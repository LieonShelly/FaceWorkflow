//
//  H264Decode.m
//  FaceWorkflow
//
//  Created by lieon on 2021/7/21.
//

#import "H264Decode.h"

extern "C" {
#include <libavcodec/avcodec.h>
#include <libavutil/avutil.h>
#include <libavutil/imgutils.h>
}

#define ERROR_BUF(ret) \
char errbuf[1024]; \
av_strerror(ret, errbuf, sizeof (errbuf));

// 输入缓冲区的大小
#define IN_DATA_SIZE 4096

@implementation H264Decode

/**
 # H264解码步骤
 - 获取解码器 ``avcodec_find_decoder(AV_CODEC_ID_H264)``
 - 初始化解析器上下文 ``av_parser_init(codec->id);``
 - 创建上下文
 - 创建AVPacket（作为输出缓冲区）
 - 创建AVFrame (作为输入缓冲区)
 - 打开编码器
 - 读取H264文件
    - 将读取的数据送入到解析器
    - 将解析器中的pkt送入到解码器进行解码
        - 发送压缩数据解码器
        - 获取解码后的数据
    - 写入解码后的数据到文件 (YUV的采样比例不同，写入的文件长度不同，比如YUV420p，Y的平面的 大小为 width * height, u 和 v 平面的大小为  width * 0.5 * height * 0.5)
       - 写入Y平面的数据
       - 写入U平面的数据
       - 写入V平面的数据

 # 写入YUV文件时应根据YUV的采样比例计算出合适的文件长度
  - 比如YUV420p时
   ```C++
     frame->data[0] 0xd08c400 0x8c400
     frame->data[1] 0xd0d79c0 0xd79c0
     frame->data[2] 0xd0ea780 0xea780
     
     frame->data[1] - frame->data[0] = 308672 = y平面的大小
     frame->data[2] - frame->data[1] = 77248 = u平面的大小
     
     y平面的大小 640x480*1 = 307200
     u平面的大小 640x480*0.25 = 76800
     v平面的大小 640x480*0.25
   ```
 */

+ (void)h264Decode:(NSString*)infilename ouputParam:(VideoEncodeSpec*)outparam {
    int ret = 0;
    char inDataArray[IN_DATA_SIZE + AV_INPUT_BUFFER_PADDING_SIZE];
    char *inData = inDataArray;
    
    // 每次从输入文件中读取的长度（h264）
    // 输入缓冲区中，剩下的等待进行解码的有效数据长度
    int inLen;
    // 是否已经读取到了输入文件的尾部
    int inEnd = 0;
    
    NSFileHandle *infile = [NSFileHandle fileHandleForReadingAtPath:infilename];
    [[NSFileManager defaultManager]createFileAtPath:outparam.filename contents:nil attributes:nil];
    NSFileHandle *outfile = [NSFileHandle fileHandleForWritingAtPath:outparam.filename];

    // 解码器
    AVCodec *codec = nullptr;
    // 上下文
    AVCodecContext *ctx = nullptr;
    // 解析器上下文
    AVCodecParserContext *parserCtx = nullptr;
    // 存放解码前的数据h264
    AVPacket *pkt = nullptr;
    // 存放解码后的数据YUV
    AVFrame *frame = nullptr;
    NSData *inNSData = nil;
    // 获取解码器
    codec = avcodec_find_decoder(AV_CODEC_ID_H264);
    if (!codec) {
        NSLog(@"avcodec_find_decoder error");
        return;
    }
    // 初始化解析器上下文
    parserCtx = av_parser_init(codec->id);
    if (!parserCtx) {
        return;
    }
    // 创建上下文
    ctx = avcodec_alloc_context3(codec);
    if (!ctx) {
        return;
    }
    // 创建AVPacket
    pkt = av_packet_alloc();
    if (!pkt) {
        return;
    }
    // 创建Frame
    frame = av_frame_alloc();
    if (!frame) {
        goto end;
    }
    // 打开解码器
    ret = avcodec_open2(ctx, codec, nullptr);
    if (ret < 0) {
        goto end;
    }
    // 读取文件
    do {
        inNSData = [infile readDataOfLength:(NSInteger)IN_DATA_SIZE];
        inLen = (int)inNSData.length;
        inEnd = !inLen;
        inData = (char*)inNSData.bytes;
        while (inLen > 0 || inEnd) {
            // 经过解析器解析
            ret = av_parser_parse2(parserCtx, ctx,
                                   &pkt->data, &pkt->size,
                                   (uint8_t *)inData,
                                   inLen,
                                   AV_NOPTS_VALUE,
                                   AV_NOPTS_VALUE, 0);
            if (ret < 0) {
                goto end;
            }
            // 跳过已经解析过的数据
            inData += ret;
            // 减去已经解析过的数据大小
            inLen -= ret;
            // 解码
            if (pkt->size > 0 && [self decode:ctx packet:pkt frame:frame ouufile:outfile]) {
                goto  end;
            }
            // 如果到了文件尾部
            if (inEnd) {
                break;
            }
        }
    } while(!inEnd);
    
    // 刷新缓冲区
    [self decode:ctx packet:nullptr frame:frame ouufile:outfile];
    
    // 赋值输出参数
    outparam.width = ctx->width;
    outparam.height = ctx->height;
    outparam.pixFmt = ctx->pix_fmt;
    // 用framerate.num获取帧率，并不是time_base.den
    outparam.fps = ctx->framerate.num;
end:
    NSLog(@"-----end----");
    [infile closeFile];
    [outfile closeFile];
    av_packet_free(&pkt);
    av_frame_free(&frame);
    av_parser_close(parserCtx);
    avcodec_free_context(&ctx);
}

+ (int)decode:(AVCodecContext*)ctx packet:(AVPacket*)pkt frame:(AVFrame*)frame ouufile:(NSFileHandle*)outfile {
    // 发送压缩数据解码器
    int ret = avcodec_send_packet(ctx, pkt);
    if (ret < 0) {
        return ret;
    }
    while (true) {
        // 获取解码后的数据
        ret = avcodec_receive_frame(ctx, frame);
        if (ret == AVERROR(EAGAIN) || ret == AVERROR_EOF) {
            return 0;
        } else if (ret < 0) {
            ERROR_BUF(ret);
            NSLog(@"avcodec_receive_frame error: %s", errbuf);
            return ret;
        }
        static int frameIndx = 0;
        NSLog(@"解码出第: %d 帧", ++frameIndx);
        // 将解码后的数据写入文件
        // 写入Y平面
        [outfile writeData:[NSData dataWithBytes:frame->data[0] length:frame->linesize[0] * ctx->height]];
        // 写入U平面
        [outfile writeData:[NSData dataWithBytes:frame->data[1] length:frame->linesize[1] * ctx->height >> 1]];
        // 写入V平面
        [outfile writeData:[NSData dataWithBytes:frame->data[2] length:frame->linesize[2] * ctx->height >> 1]];
    }
}
@end
