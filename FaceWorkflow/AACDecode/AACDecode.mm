//
//  AACDecode.m
//  FaceWorkflow
//
//  Created by lieon on 2021/7/6.
//

#import "AACDecode.h"
extern "C" {
#include <libavcodec/avcodec.h>
#include <libavutil/avutil.h>
}

#define ERROR_BUF(ret) \
    char errbuf[1024]; \
    av_strerror(ret, errbuf, sizeof (errbuf));

// 输入缓冲区的大小
#define IN_DATA_SIZE 20480
// 需要再次读取输入文件数据的阈值
#define REFILL_THRESH 4096

@implementation AACDecode


static int decode(AVCodecContext *ctx, AVPacket *pkt, AVFrame *frame, NSFileHandle *outFile) {
    int ret = avcodec_send_packet(ctx, pkt);
    if (ret < 0) {
        return ret;
    }
    while (true) {
        ret = avcodec_receive_frame(ctx, frame);
        if (ret == AVERROR(EAGAIN) || ret == AVERROR_EOF) {
            return 0;
        } else if (ret < 0) {
            ERROR_BUF(ret);
            NSLog(@"avcodec_receive_frame error: %s", errbuf);
            return  ret;
        }
        // 将编码后的数据写入文件
        [outFile writeData:[NSData dataWithBytes:frame->data[0] length:frame->linesize[0]]];
        [outFile seekToEndOfFile];
        
    }
    return 0;
}

/**
 AAC解码步骤
 - 获取解码器 ``avcodec_find_decoder_by_name``
 - 初始化解码器上下文 ``av_parser_init``
 - 创建上下文 ``avcodec_alloc_context3``
 - 创建输入缓冲区AVPacket ``av_packet_alloc``
 - 创建输出缓冲区AVFrame ``av_frame_alloc``
 - 打开解码器 ``avcodec_open2``
 - 读取数据到输入缓冲区，将输入缓冲区的数据送入  解码解析器，读取数据的方式采用分段（IN_DATA_SIZE）读取，当剩余数据小于REFILL_THRESH时，继续读取剩余的数据
  当读取到的数据长度为0时，直接跳出
 - 将解析器的数据送入解码器进行解码
    - 发送压缩数据到解码器 ``avcodec_send_packet``
    - 获取解码后的数据 ``avcodec_receive_frame``
    - 将解码后的数据写入文件
 
 */

+ (void)aacDecode:(NSString*)filename output:(AudioDecodeSpec*)output {
    int ret = 0;
    // 用来存放读取的输入文件数据
    // 加上AV_INPUT_BUFFER_PADDING_SIZE是为了防止某些优化的reader一次读取过多导致越界
    NSData *inDataArrayNS = nullptr;
    char inDataArray[IN_DATA_SIZE + AV_INPUT_BUFFER_PADDING_SIZE];
    char *inData = inDataArray;
    // 每次输入文件中读取的长度（aac）
    int inLen = 0;
    // 是否读取到了输入文件的尾部
    int inEnd = 0;
    
    NSFileHandle *inFile = [NSFileHandle fileHandleForReadingAtPath:filename];
    [[NSFileManager defaultManager]createFileAtPath:[NSString stringWithUTF8String:output->filename] contents:[NSData new] attributes:nil];
    NSFileHandle *outFile = [NSFileHandle fileHandleForWritingAtPath:[NSString stringWithUTF8String:output->filename]];
    // 解码器
    AVCodec *codec = nullptr;
    // 上下文
    AVCodecContext *ctx = nullptr;
    // 解析器上下文
    AVCodecParserContext *parserCtx = nullptr;
    // 存放解码前的数据
    AVPacket *pkt = nullptr;
    // 存放编码后的数据(PCM)
    AVFrame *frame = nullptr;
    // 获取解码器
    codec = avcodec_find_decoder_by_name("libfdk_aac");
    if (!codec) {
        NSLog(@"decode not found");
        return;
    }
    // 初始化解析器上下文
    parserCtx = av_parser_init(codec->id);
    if (!parserCtx) {
        NSLog(@"av_parser_init error");
        return;
    }
    // 创建上下文
    ctx = avcodec_alloc_context3(codec);
    if (!ctx) {
        goto end;
    }
    // 创建AVPacket
    pkt = av_packet_alloc();
    if (!pkt) {
        NSLog(@"av_packet_alloc error");
        goto end;
    }
    frame = av_frame_alloc();
    if (!frame) {
        NSLog(@"av_frame_alloc error");
        goto end;
    }
    // 打开编码器
    ret = avcodec_open2(ctx, codec, nullptr);
    if (ret < 0) {
        ERROR_BUF(ret);
        NSLog(@"avcodec_open2 error: %s", errbuf);
        goto end;
    }
    inDataArrayNS = [inFile readDataOfLength:IN_DATA_SIZE];
    inData = (char*)inDataArrayNS.bytes;
    inLen = (int)inDataArrayNS.length;
    while (inLen > 0) {
        ret = av_parser_parse2(parserCtx,
                               ctx,
                               &pkt->data,
                               &pkt->size,
                               (uint8_t *)inData,
                               inLen,
                               AV_NOPTS_VALUE,
                               AV_NOPTS_VALUE, 0);
        if (ret < 0) {
            ERROR_BUF(ret);
            NSLog(@"av_parser_parse2 error: %s", errbuf);
            goto end;
        }
        // 跳过已经解析过的数据
        inData += ret;
        // 减去已经解析过的数据大小
        inLen -= ret;
        // 解码
        if (pkt->size > 0 && decode(ctx, pkt, frame, outFile) < 0) {
            goto end;
        }
        NSLog(@"inLen:%d", inLen);
        // 检查是否需要读取新的文件数据
        if (inLen < REFILL_THRESH && !inEnd) {
            NSMutableData *data = [NSMutableData data];
            [data appendData:[NSData dataWithBytes:inData length:inLen]];
            NSData *padderData = [inFile readDataOfLength:IN_DATA_SIZE - inLen];
            [data appendData:padderData];
            
            inData = (char*)data.bytes;
            int len = (int)padderData.length;
            if (len > 0) {
                inLen = (int)data.length;
            } else {
                inEnd = 1;
            }
        }
    }
    // 刷新缓冲区
    decode(ctx, nullptr, frame, outFile);
    // 赋值输出参数
    output->sampleRate = ctx->sample_rate;
    output->sampleFmt = ctx->sample_fmt;
    output->chLayout = (int)ctx->channel_layout;
    
end:
    [inFile closeFile];
    [outFile closeFile];
    av_packet_free(&pkt);
    av_frame_free(&frame);
    av_parser_close(parserCtx);
    avcodec_free_context(&ctx);
    NSLog(@"End");
}
@end
