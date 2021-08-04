//
//  H264Encode.m
//  FaceWorkflow
//
//  Created by lieon on 2021/7/19.
//

#import "H264Encode.h"
extern "C" {
#include <libavcodec/avcodec.h>
#include <libavutil/avutil.h>
#include <libavutil/imgutils.h>
#include <libavutil/opt.h>
}

#define ERROR_BUF(ret) \
char errbuf[1024]; \
av_strerror(ret, errbuf, sizeof (errbuf));

@implementation H264Encode

// 检查像素格式
static int checktPixFmt(const AVCodec *codec, enum AVPixelFormat pixFmt) {
    const enum AVPixelFormat *p = codec->pix_fmts;
    while (*p != AV_PIX_FMT_NONE) {
        if (*p == pixFmt) return 1;
        p++;
    }
    return 0;
}

/**
 # H264编码实现步骤
 - 获取编码器 ``avcodec_find_encoder_by_name``
 - 检查输入格式
 - 创建编码器上下文 ``avcodec_alloc_context3``
 - 设置编码上下文参数 `` width height pix_fmt time_base``
 - 创建frame
 - 设置frame参数 ``width height format pts``
 - 利用frame创建输入缓冲区，相当于是为frme->data 设置其内存布局，设置好之后，直接网data指针数组中填入数据
 - 创建AVPacket, 作为输出缓冲区
 - 逐帧读取YUV数据到frame中，将frame数据送入到编码器
    - 从编码器中获取编码后的数据
    - 将编码后的书写入文件
    - 释放packet
 - 释放资源
    - frame
    - context
    - 编码器
    - packet
    - 关闭文件
 
 # 输入缓冲区的内存申请方式
    - 方式一
    ```C++
     // 创建frame
     frame = av_frame_alloc();
     frame->width = ctx->width;
     frame->height = ctx->height;
     frame->format = ctx->pix_fmt;
     frame->pts = 0;

     ret = av_image_alloc(frame->data, frame->linesize,
                              input.width, input.height,
                              AV_PIX_FMT_YUV420P, 1);
    ```
    
    - 方式二
    ```C++
     frame = av_frame_alloc();
     frame->width = ctx->width;
     frame->height = ctx->height;
     frame->format = ctx->pix_fmt;
     frame->pts = 0;
     // 一帧图片的大小
     int imgSize = av_image_get_buffer_size(in.pixFmt, in.width, in.height, 1);
     buf = (uint8_t *) av_malloc(imgSize);
     ret = av_image_fill_arrays(frame->data, frame->linesize,
                                buf,
                                in.pixFmt, in.width, in.height, 1);
    ```
    - 方式三
    ```C++
     frame = av_frame_alloc();
     frame->width = ctx->width;
     frame->height = ctx->height;
     frame->format = ctx->pix_fmt;
     frame->pts = 0;
     ret = av_frame_get_buffer(frame, 0);
    ```
 */

+ (void)h264Encode:(VideoEncodeSpec*)input output:(NSString*)output {
    NSFileHandle *infile = [NSFileHandle fileHandleForReadingAtPath:input.filename];
    [[NSFileManager defaultManager]createFileAtPath:output contents:nil attributes:nil];
    NSFileHandle *outfile = [NSFileHandle fileHandleForWritingAtPath:output];
    // 一帧图片的大小
    int imageSize = av_image_get_buffer_size((AVPixelFormat)input.pixFmt, input.width, input.height, 1);
    int ret = 0;
    // 编码器
    AVCodec *codec = nullptr;
    // 编码上下文
    AVCodecContext *ctx = nullptr;
    AVFrame *frame = nullptr;
    AVPacket *pkt = nullptr;
    NSData *inData = nil;
    
      
    
//    uint8_t *buf = nullptr;
    // 获取编码器
    codec = avcodec_find_encoder_by_name("libx264") ;
    if (!codec) {
        NSLog(@"codec not found");
        return;
    }
    // 检查输入格式
    if (!checktPixFmt(codec, (AVPixelFormat)input.pixFmt)) {
        return;
    }
    // 创建编码器上下文
    ctx = avcodec_alloc_context3(codec);
    if (!ctx) {
        NSLog(@"avcodec_alloc_context3 error");
        return;
    }
    //设置YUV参数
    ctx->width = input.width;
    ctx->height = input.height;
    ctx->pix_fmt = (AVPixelFormat)input.pixFmt;
    // 设置帧率
    ctx->time_base = {1, input.fps };
    // 打开编码器
    ret = avcodec_open2(ctx, codec, nullptr);
    if (ret < 0) {
        ERROR_BUF(ret);
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
    
    // 利用width，height ,format创建缓冲区, 相当于把每一帧内部布局设置好，然后直接填充数据
    ret = av_image_alloc(frame->data, frame->linesize,
                             input.width, input.height,
                             AV_PIX_FMT_YUV420P, 1);
    
//    buf = (uint8_t *) av_malloc(imageSize);
//    ret = av_image_fill_arrays(frame->data, frame->linesize,
//                               buf,
//                               AV_PIX_FMT_YUV420P, input.width, input.height, 1);
    if (ret < 0) {
        ERROR_BUF(ret);
        goto end;
    }
    NSLog(@"%s", frame->data[0]);
    
    if (ret < 0) {
        ERROR_BUF(ret);
        goto end;
    }
    // 创建AVPacket
    pkt = av_packet_alloc();
    if (!pkt) {
        goto end;
    }
    // ffmpeg -i in.MP4 -s 512x512 -pixel_format yuv420p in.yuv
    // 打开文件
    inData = [infile readDataOfLength:imageSize];
    while (inData.length > 0) {
        // 进行编码
        frame->data[0] = (uint8_t*)inData.bytes;
        if ([self encode:ctx inputFrame:frame outputPkt:pkt file:outfile] < 0) {
            goto end;
        }
        // 设置帧序号
        frame->pts++;
        inData = [infile readDataOfLength:imageSize];
    }
    
    // 刷新缓冲区
    [self encode:ctx inputFrame:nullptr outputPkt:pkt file:outfile];
end:
    NSLog(@"----：%lld", frame->pts);
    [infile closeFile];
    [outfile closeFile];
    if (frame) {
//        av_freep(&frame->data[0]);
        av_frame_free(&frame);
    }
    av_packet_free(&pkt);
    avcodec_free_context(&ctx);
}

+ (int)encode:(AVCodecContext*)ctx inputFrame:(AVFrame*)frame outputPkt:(AVPacket*)pkt file:(NSFileHandle*)file {
    // 发送数据到编码器
    int ret = avcodec_send_frame(ctx, frame);
    if (ret < 0) {
        return ret;
    }
    // 不断从编码器中取出编码后的数据
    static int total = 0;
    while (true) {
        ret = avcodec_receive_packet(ctx, pkt);
        if (ret == AVERROR(EAGAIN) || ret == AVERROR_EOF) {
            return 0;
        } else if (ret < 0) {
            return ret;
        }
        // 将编码后的数据写入文件
        total += pkt->size;
        NSLog(@"写入H264文件：%d - %llu - 总长度：%d", pkt->size, file.offsetInFile, total);
        [file writeData:[NSData dataWithBytes:pkt->data length:pkt->size]];
        [file seekToEndOfFile];
        // 释放pkt内部的资源
        av_packet_unref(pkt);
    }
}

@end
