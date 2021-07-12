//
//  FFMpegs.m
//  FaceWorkflow
//
//  Created by lieon on 2021/6/22.
//

#import "FFMpegs.h"
extern "C" {
#include <libswresample/swresample.h>
#include <libavutil/avutil.h>
}


#define ERROR_BUF(ret) \
    char errbuf[1024]; \
    av_strerror(ret, errbuf, sizeof (errbuf));

@implementation FFMpegs

/**
 # PCM转WAV步骤
 - 计算头部一个样本的字节数
 - 计算头部字节率 byteRate
 - 读取PCM数据
 - 根据读取的PCM数据计算 ``dataChunkSize``， ``riffChunkSize``
 - 写入头部数据到wav文件
 - 写入PCM数据到wav文件
 
 */

+ (void)pcm2wav:(WavHeader *)header pcmfile:(NSString *)pcmFilename wavfile:(NSString *)wavfilename {
    // 一个样本的字节数
    header->blockAlign = header->bitPerSample * header->numChannels >> 3;
    // 字节率
    header->byteRate = header->sampleRate * header->blockAlign;
    // 打开pcm文件
    NSFileHandle *pcmhandle = [NSFileHandle fileHandleForReadingAtPath:pcmFilename];
    if (!pcmhandle) {
        NSLog(@"PCM文件打开失败");
        return;
    }
    header->dataChunkSize = (uint32_t)pcmhandle.availableData.length;
    header->riffChunkSize = header->dataChunkSize + sizeof(WavHeader) - sizeof(header->riffChunkId) - sizeof(header->riffChunkSize);
    // 打开wav文件
    NSError *error;
    [[NSFileManager defaultManager]createFileAtPath:wavfilename contents:nil attributes:nil];
    NSFileHandle *wavHandle = [NSFileHandle fileHandleForWritingToURL:[NSURL fileURLWithPath:wavfilename]  error:&error];
    if (error) {
        NSLog(@"wav文件创建失败：%@", error.description);
        [pcmhandle closeFile];
        return;
    }
    // 写入头部
    NSData *headerData = [NSData dataWithBytes:(void *)(header) length:sizeof(WavHeader)];
    [wavHandle writeData:headerData];
    
    // 写入PCM数据
    [pcmhandle seekToFileOffset:0];
    NSData *buf = [pcmhandle readDataOfLength:1024];
    NSInteger size = buf.length;
    while (size > 0) {
        if (buf) {
            [wavHandle writeData:buf];
            [wavHandle seekToEndOfFile];
        }
        buf = [pcmhandle readDataOfLength:1024];
        size = buf.length;
    }
    // 关闭文件
    [pcmhandle closeFile];
    [wavHandle closeFile];
}

/**
 # 音频重采样步骤
 - 创建采样上下文
 - 设置输入缓冲区
 - 设置输出缓冲区
 - 打开文件开始重采样
 - 检查输出缓冲区是否还有残余的样本
 - 释放资源
 ffplay -ar 44100 -ac 2 -f f32le  44100_s32.pcm
 */
+ (void)resample:(ResampleAudioSpec*)input outPut:(ResampleAudioSpec*)output {
    NSFileHandle *inputFile = [NSFileHandle fileHandleForReadingAtPath:[NSString stringWithCString:input->filename encoding:NSUTF8StringEncoding]];
    NSError *error;
    NSString *outfileName = [NSString stringWithCString:output->filename encoding:NSUTF8StringEncoding];
    [[NSFileManager defaultManager]createFileAtPath:outfileName contents:nil attributes:nil];
    NSFileHandle *outFile = [NSFileHandle fileHandleForWritingToURL:[NSURL fileURLWithPath:outfileName] error:&error];
    if (error) {
        NSLog(@"outfile文件创建失败：%@", error.description);
        [inputFile closeFile];
        return;
    }
    // 输入缓冲区
    // 指向缓冲区的指针
    uint8_t **inData = nullptr;
    NSData *infile;
    // 缓冲区的大小
    int inLineSize = 0;
    // 声道数
    int inChs = av_get_channel_layout_nb_channels(input->chLayout);
    // 一个样本的大小
    int inBytesPerSample = av_get_bytes_per_sample(input->sampleFmt) * inChs;
    // 缓冲区的样本数量
    int inSamples = 1024;
    // 读取文件数据的大小
    int len = 0;
    
    // 输出缓冲区
    // 指向缓冲区的指针
    uint8_t **outData = nullptr;
    // 缓冲区的大小
    int outLineSize = 0;
    // 声道数
    int outChs = av_get_channel_layout_nb_channels(output->chLayout);
    // 一个样本的大小
    int outBytesPerSample = av_get_bytes_per_sample(output->sampleFmt) * outChs;
    // 缓冲区的样本数量
    int outSamples = av_rescale_rnd((int64_t)output->sampleRate,
                                    (int64_t)inSamples,
                                    (int64_t)input->sampleRate,
                                    AV_ROUND_UP);
    /*
       inSampleRate     inSamples
       ------------- = -----------
       outSampleRate    outSamples

       outSamples = outSampleRate * inSamples / inSampleRate
       */
    NSLog(@"输入缓冲区 inSampleRate: %d - inSamples： %d", input->sampleRate, inSamples);
    NSLog(@"输出缓冲区 inSampleRate: %d - outSamples: %d", output->sampleRate, outSamples);
    int ret = 0;
    // 创建重采样上下文
    /**
     struct SwrContext *swr_alloc_set_opts(struct SwrContext *s,
                                           int64_t out_ch_layout, enum AVSampleFormat out_sample_fmt, int out_sample_rate,
                                           int64_t  in_ch_layout, enum AVSampleFormat  in_sample_fmt, int  in_sample_rate,
                                           int log_offset, void *log_ctx);
     */
    SwrContext *ctx = swr_alloc_set_opts(nullptr,
                                         output->chLayout,
                                         output->sampleFmt,
                                         output->sampleRate,
                                         input->chLayout,
                                         input->sampleFmt,
                                         input->sampleRate,
                                         0,
                                         nullptr);
    if (!ctx) {
        NSLog(@"swr_alloc_set_opts error");
        goto end;
    }
    // 初始化重采样上下文
    ret = swr_init(ctx);
    if (ret < 0) {
        ERROR_BUF(ret);
        NSLog(@"swr_init error: %s", errbuf);
        goto end;
    }
    
    //创建输入缓冲区
    ret = av_samples_alloc_array_and_samples(&inData,
                                             &inLineSize,
                                             inChs,
                                             inSamples,
                                             input->sampleFmt,
                                             1);
    if (ret < 0) {
        ERROR_BUF(ret);
        NSLog(@"av_samples_alloc_array_and_samples error: %s", errbuf);
        goto end;
    }
    
    //创建输出缓冲区
    ret = av_samples_alloc_array_and_samples(&outData,
                                             &outLineSize,
                                             outChs,
                                             outSamples,
                                             output->sampleFmt,
                                             1);
    if (ret < 0) {
        ERROR_BUF(ret);
        NSLog(@"av_samples_alloc_array_and_samples error: %s", errbuf);
        goto end;
    }
    // 读取文件数据
    [inputFile seekToFileOffset:0];
    infile = [inputFile readDataOfLength:inLineSize];
    inData[0] = (uint8_t*) [infile bytes];
    len = (int)[infile length];
    while (len > 0) {
        // 读取样本数量
        inSamples = len / inBytesPerSample;
        
        ret = swr_convert(ctx,
                          outData,
                          outSamples,
                          (const uint8_t **)inData,
                          inSamples);
        if (ret < 0) {
            ERROR_BUF(ret);
            NSLog(@"swr_convert error: %s", errbuf);
            goto end;
        }
        // 将装换后的数据写入输出文件中
        [outFile writeData:[NSData dataWithBytes:outData[0] length:ret *outBytesPerSample]];
        [outFile seekToEndOfFile];
        
        // 继续读下一段输入数据
        infile = [inputFile readDataOfLength:inLineSize];
        inData[0] = (uint8_t*) [infile bytes];
        len = (int)[infile length];
        NSLog(@"---------len: %d -- inLineSize: %d --- ret: %d", len, inLineSize, ret);
    }
    
    // 检查一下输出缓冲区是否还有残留的样本（已经重采样过的，换换过的）
    while ((ret = swr_convert(ctx, outData, outSamples, nullptr, 0)) > 0) {
        [outFile writeData:[NSData dataWithBytes:(char *)outData[0] length:ret * outBytesPerSample]];
    }
    NSLog(@"-----end----");
end:
    [inputFile closeFile];
    [outFile closeFile];
    if (inData) {
        av_freep(&inData[0]);
    }
    av_freep(&inData);
    if (outData) {
        av_freep(&outData[0]);
    }
    av_freep(&outData);
    swr_free(&ctx);
}

@end
