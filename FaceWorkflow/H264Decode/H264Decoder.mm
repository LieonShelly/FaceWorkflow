//
//  H264Decoder.m
//  FaceWorkflow
//
//  Created by lieon on 2021/11/10.
//

#import "H264Decoder.h"
#import "VideoEncodeSpec.h"
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


@implementation H264Decoder
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
    // 存放解码前的数据
    AVPacket *pkt = nullptr;
    // 存放解码后的数据YUV
    AVFrame *frame = nullptr;
    NSData *inNSData = nil;
    // 获取解码器
    codec = avcodec_find_decoder(AV_CODEC_ID_H264);
    if (!codec) {
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
    // 创建frame
    frame = av_frame_alloc();
    if (!frame) {
        return;
    }
    //打开解码器
    ret = avcodec_open2(ctx, codec, nullptr);
    if (ret < 0) {
        goto end;
        return;
    }
    //读取文件
    do {
        inNSData = [infile readDataOfLength:(NSInteger)IN_DATA_SIZE];
        inLen = (int)inNSData.length;
        inEnd = !inLen;
        inData = (char*)inNSData.bytes;
        while (inLen > 0 || inEnd) {
            // 经过解析器解析，进行分段
            ret = av_parser_parse2(parserCtx, ctx,
                                   &pkt->data, &pkt->size,
                                   (uint8_t*)inData,
                                   inLen,
                                   AV_NOPTS_VALUE ,
                                   AV_NOPTS_VALUE,
                                   0);
            if (ret < 0) {
                goto end;
            }
            // 跳过已经解析过的数据
            inData += ret;
            // 减去已经解析过的数据大小
            inLen -= ret;
            // 解码
            if (pkt->size > 0 && [self decode:ctx packet:pkt frame:frame ouufile: outfile]) {
                goto end;
            }
            // 如果到了文件尾部
            if (inEnd) {
                break;
            }
        }
        
    } while(!inEnd);
    // 刷新缓冲区
    [self decode:ctx packet:nullptr frame:frame ouufile:outfile];
    // 赋值数组参数
    outparam.width = ctx->width;
    outparam.height = ctx->height;
    outparam.pixFmt = ctx->pix_fmt;
    // 用framerate.num获取帧率，并不是time_base.den
    outparam.fps = ctx->framerate.num;
    
end:
    [infile closeFile];
    [outfile closeFile];
    av_packet_free(&pkt);
    av_frame_free(&frame);
    av_parser_close(parserCtx);
    avcodec_free_context(&ctx);

}

+ (int)decode:(AVCodecContext*)ctx packet:(AVPacket*)pkt frame:(AVFrame*)frame ouufile:(NSFileHandle*)outfile  {
    return 0;
}
@end
