//
//  RecordWAV.m
//  FaceWorkflow
//
//  Created by lieon on 2021/6/28.
//

#import "RecordWAV.h"
#include "WavHeader.hpp"
extern "C" {
#include <libavdevice/avdevice.h>
#include <libavformat/avformat.h>
#include <libavutil/avutil.h>
#include <libavcodec/avcodec.h>
}

@interface RecordWAV()

@property (nonatomic, assign) BOOL stop;


@end

@implementation RecordWAV
/**
 WAV录音的步骤
 - 获取输入格式
 - 创建格式上下文
 - 打开设备
 - 获取输入流
 - 获取音频参数
 - 根据获取的音频参数，计算sampleRate，bitsPerSample， blockAlign，byteRate
 - 写入WAV头部
 - 写入PCM数据
 - 根据PCM数据计算出dataChunkSize
 - 录音结束，写入dataChunkSize （更新）
 - 写入riffChunkDataSize（更新）
 - 释放资源
 
 采样大小的bitPerSample(位深度：单声道下的1个样本的大小)获取方式
 - 通过采样格式获取
 - 通过codec_id获取 av_get_bits_per_sample(params->codec_id);
 */



+ (void)initialize {
    avdevice_register_all();
}

- (void)record {
    self.stop = false;
    // 初始化数据包
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSString *formatName = @"avfoundation";
        NSString *deviceName = @":0";
        AVInputFormat *fmt = av_find_input_format([formatName UTF8String]);
        if (!fmt) {
            NSLog(@"获取输入格式对象失败");
            return;
        }
       AVFormatContext *ctx = nullptr;
        int ret = avformat_open_input(&ctx,
                                      deviceName.UTF8String,
                                      fmt, nullptr);
        if (ret < 0) {
            char errbuf[1024];
            av_strerror(ret, errbuf, sizeof (errbuf));
            NSLog(@"打开设备失败: %s", errbuf);
            return;
        }
        NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject;
        NSString *fileName = [filePath stringByAppendingPathComponent: @"record_out.wav"];
        // 创建一个空文件
        [[NSFileManager defaultManager]createFileAtPath:fileName contents:[NSData new] attributes:nil];
        NSFileHandle *writeHandle = [NSFileHandle fileHandleForWritingToURL:[NSURL URLWithString:fileName] error:nil];
        if (!writeHandle) {
            NSLog(@"打开文件失败");
            avformat_close_input(&ctx);
            return;
        }
     
        // 获取输入流
        AVStream *stream = ctx->streams[0];
        // 获取音频参数
        AVCodecParameters *params = stream->codecpar;
        // 写入WAV文件头
        WavHeader header;
        header.sampleRate = params->sample_rate;
        //
        header.bitPerSample = av_get_bits_per_sample(params->codec_id);
        header.numChannels = params->channels;
        if (params->codec_id >= AV_CODEC_ID_PCM_F32BE) {
            header.audioFormat = AUDION_FORMAT_FLOAT;
        }
        header.blockAlign = header.bitPerSample * header.numChannels >> 3;
        header.byteRate = header.sampleRate * header.blockAlign;
        [writeHandle seekToFileOffset:0];
        [writeHandle writeData:[NSData dataWithBytes:(void *)&header length:sizeof(WavHeader)]];
        [writeHandle seekToEndOfFile];
        AVPacket *pkt = av_packet_alloc();
        while (!self.stop) {
            ret = av_read_frame(ctx, pkt);
            if (ret == 0) {
                [writeHandle writeData:[NSData dataWithBytes:pkt->data length:pkt->size]];
                [writeHandle seekToEndOfFile];
                header.dataChunkSize += pkt->size;
                // 计算录音时长
                unsigned long long ms = 1000.0 * header.dataChunkSize / header.byteRate;
                NSLog(@"录音时长:%llu", ms);
            } else if (ret == AVERROR(EAGAIN)) {
                
            } else {
                char errbuf[1024];
                av_strerror(ret, errbuf, sizeof (errbuf));
                NSLog(@"av_read_frame: %s", errbuf);
            }
            av_packet_unref(pkt);
        }
        // 写入dataChunkSize
        [writeHandle seekToFileOffset:sizeof(WavHeader) - sizeof(header.dataChunkSize)];
        [writeHandle writeData:[NSData dataWithBytes:(void *)&header.dataChunkSize length:sizeof(header.dataChunkSize)]];
        
        // 写入riffChunkDataSize
        [writeHandle seekToEndOfFile];
        long long totalLen = [writeHandle offsetInFile];
        header.riffChunkSize = uint32_t(totalLen - sizeof(header.riffChunkId) - sizeof(header.riffChunkSize));
        [writeHandle seekToFileOffset:sizeof(header.riffChunkId)];
        [writeHandle writeData:[NSData dataWithBytes:(void *)&header.riffChunkSize length:sizeof(header.riffChunkSize)]];
        
        // 释放资源
        av_packet_free(&pkt);
        [writeHandle closeFile];
        avformat_close_input(&ctx);
        
    });
}

- (void)stopRecord {
    self.stop = true;
}
@end
