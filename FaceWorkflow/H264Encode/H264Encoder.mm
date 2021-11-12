//
//  H264Encoder.m
//  FaceWorkflow
//
//  Created by lieon on 2021/11/8.
//

#import "H264Encoder.h"
#import "VideoEncodeSpec.h"

extern "C" {
#include <libavcodec/avcodec.h>
#include <libavutil/avutil.h>
#include <libavutil/imgutils.h>
#include <libavutil/opt.h>
}

#define ERROR_BUF(ret) \
char errbuf[1024]; \
av_strerror(ret, errbuf, sizeof (errbuf));


@interface H264Encoder()

@end

@implementation H264Encoder

// 检查像素格式
static int checktPixFmt(const AVCodec *codec, enum AVPixelFormat pixFmt) {
    const enum AVPixelFormat *p = codec->pix_fmts;
    while (*p != AV_PIX_FMT_NONE) {
        if (*p == pixFmt) return 1;
        p++;
    }
    return 0;
}

- (void)encode:(VideoEncodeSpec*)input output:(NSString*)output {
    NSFileHandle *infile = [NSFileHandle fileHandleForReadingAtPath:input.filename];
    [[NSFileManager defaultManager]createFileAtPath:output contents:nil attributes:nil];
    NSFileHandle *outfile = [NSFileHandle fileHandleForWritingAtPath:output];
    // 一帧图片图片大小
    int imageSize = av_image_get_buffer_size((AVPixelFormat)input.pixFmt, input.width, input.height, 1);
    int ret = 0;
    // 编码器
    AVCodec *codec = nullptr;
    // 编码上下文
    AVCodecContext *ctx = nullptr;
    AVFrame *frame = nullptr;
    AVPacket *pkt = nullptr;
    NSData *indata = nil;
    
    // 获取编码器
    codec = avcodec_find_encoder_by_name("libx264");
    if (!codec) {
        return;
    }
    // 检查输入格式
    if (checktPixFmt(codec, (AVPixelFormat)input.pixFmt)) {
        return;
    }
    // 创建编码器上下文
    ctx = avcodec_alloc_context3(codec);
    if (!ctx) {
        return;
    }
    // 设置YUV参数
    ctx->width = input.width;
    ctx->height = input.height;
    ctx->pix_fmt = (AVPixelFormat)input.pixFmt;
    // 设置帧率
    ctx->time_base = {1, input.fps};
    // 打开编码器
    ret = avcodec_open2(ctx, codec, nullptr);
    if (ret < 0) {
        goto end;
    }
    // 创建frame
    frame = av_frame_alloc();
    if (!frame) {
        goto end;
    }
    frame->width = ctx->width;
    frame->height = ctx->height;
    frame->format = ctx->pix_fmt;
    frame->pts = 0;
    // 填充数据
    av_image_alloc(frame->data,
                   frame->linesize,
                   input.width,
                   input.height,
                   AV_PIX_FMT_YUV420P,
                   1);
    if (ret < 0) {
        goto end;
    }
    // 创建AVPacket
    pkt = av_packet_alloc();
    if (!pkt) {
        goto end;
    }
    // ffmpeg -i in.MP4 -s 512x512 -pixel_format yuv420p in.yuv
    // 打开文件
    indata = [infile readDataOfLength:imageSize];
    if (indata.length > 0) {
        // 进行编码
        frame->data[0] = (uint8_t*)indata.bytes;
        if ([self encode:ctx inputFrame:frame outputPkt:pkt file:outfile] < 0) {
            goto end;
        }
        // 设置帧序号
        frame->pts++;
        indata = [infile readDataOfLength:imageSize];
    }
    [self encode:ctx inputFrame:nullptr outputPkt:pkt file:outfile];
end:
    [infile closeFile];
    [outfile closeFile];
    if (frame) {
        av_frame_free(&frame);
    }
    av_packet_free(&pkt);
    avcodec_free_context(&ctx);
    
}

- (int)encode:(AVCodecContext*)ctx inputFrame:(AVFrame*)frame outputPkt:(AVPacket*)pkt file:(NSFileHandle*)file {
    // 发送数据到编码器
    int ret = avcodec_send_frame(ctx, frame);
    if (ret < 0) {
        return ret;
    }
    // 不断从编码器中取出编码后的数据
    while (true) {
        ret = avcodec_receive_packet(ctx, pkt);
        if (ret == AVERROR(EAGAIN) || ret == AVERROR_EOF) {
            return 0;
        } else if (ret < 0) {
            return  ret;
        }
        // 将编码后的数据写入文件
        [file writeData:[NSData dataWithBytes:pkt->data length:pkt->size]];
        [file seekToEndOfFile];
        // 释放pkt内部的资源
        av_packet_unref(pkt);
    }
}
@end
