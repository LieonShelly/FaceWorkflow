//
//  AccEncode.m
//  FaceWorkflow
//
//  Created by lieon on 2021/7/1.
//

#import "AccEncode.h"

extern "C" {
#include <libavcodec/mediacodec.h>
#include <libavutil/avutil.h>
}

#define ERROR_BUF(ret) \
char errbuf[1024]; \
av_strerror(ret, errbuf, sizeof (errbuf));

@implementation AccEncode

// 包含static关键字的函数只在他所在的文件中是可见的，在其他文件中不可见，会导致找不到定义
static int checkSampleFmt(const AVCodec *codec, enum AVSampleFormat sampleFmt) {
    const enum AVSampleFormat *p = codec->sample_fmts;
    while (*p != AV_SAMPLE_FMT_NONE) {
        if (*p == sampleFmt) {
            return 1;
        }
        p++;
    }
    return 0;
}


static int encode(AVCodecContext *ctx, AVFrame *frame, AVPacket *pkt, NSFileHandle *outFile) {
    // 发送数据到编码器
    int ret = avcodec_send_frame(ctx, frame);
    if (ret < 0) {
        ERROR_BUF(ret);
        NSLog(@"avcodec_send_frame error: %s", errbuf);
        return ret;
    }

    // 不断从编码器中取出编码后的数据
    while (true) {
        ret = avcodec_receive_packet(ctx, pkt);
        if (ret == AVERROR(EAGAIN) || ret == AVERROR_EOF) {
            // 继续读取数据到frame，然后送到编码器
            return 0;
        } else if (ret < 0) { // 其他错误
            return ret;
        }
        // 成功从编码器拿到编码后的数据
        // 将编码后的数据写入文件
        NSData *data = [NSData dataWithBytes:pkt->data length:pkt->size];
        [outFile writeData:data];
        [outFile seekToEndOfFile];
        // 释放pkt内部的资源
        av_packet_unref(pkt);
    }
    return 0;
}
/**
 AAC编码步骤
 - 获取编码器 ``avcodec_find_encoder_by_name``
 - 创建编码上下文 ``avcodec_alloc_context3``
 - 设置上下文PCM参数：采样格式，采样率，通道布局，比特率，规格
 - 打开编码器
 - 初始化输入AVFrame存放PCM
 - 设置输入缓冲区参数：样本帧数量，格式，通道布局
 - 利用nb_samples, format, channel_layout创建缓冲区 ``av_frame_get_buffer``
 - 创建输出缓冲区AVPacket ``av_packet_alloc``
 - 读取PCM到创建好的AVFrame中
 - 将填满AVFrame的frame进行AAC编码
    - 发送数据到编码器
    - 不断从编码器中取出编码后的数据, 将编码后的数据写入文件
    - 释放输出缓冲区pkt内部的资源 ``av_packet_unref``
 
 */
+ (void)aacEncodeWithSpec:(AudioEncodeSpec*)input outfile: (NSString*)outfileName {
    NSFileHandle *infile = [NSFileHandle fileHandleForReadingAtPath:[NSString stringWithCString:input->filename encoding:NSUTF8StringEncoding]];
    [[NSFileManager defaultManager]createFileAtPath: outfileName contents:[NSData new] attributes:nil];
    NSFileHandle *outFile = [NSFileHandle fileHandleForWritingAtPath:outfileName];
    [outFile seekToFileOffset:0];
    int offset = 0;
    int ret = 0;
    // 编码器
    AVCodec *codec = nullptr;
    // 编码上下文
    AVCodecContext *ctx = nullptr;
    // 存放编码前的PCM
    AVFrame *frame = nullptr;
    // 存放编码后的数据 aac
    AVPacket *pkt = nullptr;
    NSData *inputDataBuffer = nullptr;
    // 获取编码器
    codec = avcodec_find_encoder_by_name("libfdk_aac");
    if (!codec) {
        NSLog(@"libfdk_acc encoder not found");
        return;
    }
    // libfdk_aac对输入数据的要求：采样格式必须是16位整数
    if(!checkSampleFmt(codec, input->sampleFmt)) {
        NSLog(@"unsupported sample format: %s", av_get_sample_fmt_name(input->sampleFmt));
        return;
    }
    // 创建编码上下文
    ctx = avcodec_alloc_context3(codec);
    if (!ctx) {
        NSLog(@"avcodec_alloc_context3 error");
        return;
    }
    // 设置PCM参数
    ctx->sample_fmt = input->sampleFmt;
    ctx->sample_rate = input->sampleRate;
    ctx->channel_layout = input->chLayout;
    // 比特率
    ctx->bit_rate = 32000; // av_get_bytes_per_sample(input->sampleFmt) << 3;
    //规格
    ctx->profile = FF_PROFILE_AAC_HE_V2;
    // 打开编码器
    ret = avcodec_open2(ctx, codec, nullptr);
    if (ret < 0) {
        goto end;
    }
    frame = av_frame_alloc();
    if (!frame) {
        NSLog(@"av_frame_alloc error");
        goto end;
    }
    // frame缓冲区中的样本帧数量
    frame->nb_samples = ctx->frame_size;
    frame->format = ctx->sample_fmt;
    frame->channel_layout = ctx->channel_layout;
    
    // 利用nb_samples, format, channel_layout创建缓冲区
    ret = av_frame_get_buffer(frame, 0);
    if (ret < 0) {
        ERROR_BUF(ret);
        NSLog(@"av_frame_get_buffer error: %s", errbuf);
        goto end;
    }
    // 创建AVPacket
    pkt = av_packet_alloc();
    if (!pkt) {
        NSLog(@"av_packet_alloc erro");
        goto end;
    }
    // 读取数据到frame
    [infile seekToFileOffset:offset];
    inputDataBuffer = [infile readDataOfLength:frame->linesize[0]];
    frame->data[0] = (uint8_t *)inputDataBuffer.bytes;
    offset += frame->linesize[0];
    NSLog(@"inputDataBuffer-length: %ld - frame->linesize[0]: %d - offset: %d", inputDataBuffer.length, frame->linesize[0], offset);
    while (inputDataBuffer.length > 0) {
        // 从文件中读取的数据，不足以填满farme缓冲区
        if (inputDataBuffer.length < frame->linesize[0]) {
            int bytes = av_get_bytes_per_sample((AVSampleFormat)frame->format);
            int ch = av_get_channel_layout_nb_channels(frame->channel_layout);
            // 设置真正有效的样本帧数量
            // 防止编码器编码了一些冗余数据
            frame->nb_samples = (int)inputDataBuffer.length / (bytes * ch);
            NSLog(@"文件中读取的数据，不足以填满farme缓冲区: %d", frame->linesize[0]);
        }
        
        if (encode(ctx, frame, pkt, outFile)) {
            goto end;
        }
        [infile seekToFileOffset:offset];
        inputDataBuffer = [infile readDataOfLength:frame->linesize[0]];
        frame->data[0] = (uint8_t *)inputDataBuffer.bytes;
        offset += frame->linesize[0];
        NSLog(@"inputDataBuffer-length: %ld - frame->linesize[0]: %d - offset: %d", inputDataBuffer.length, frame->linesize[0], offset);
    }
    encode(ctx, nullptr, pkt, outFile);
end:
    [infile closeFile];
    av_frame_free(&frame);
    av_packet_free(&pkt);
    avcodec_free_context(&ctx);
    NSLog(@"End");
}
@end
