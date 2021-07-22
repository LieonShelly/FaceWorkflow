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
        inLen = inNSData.length;
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
    // 发送压缩数据打破解码器
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
