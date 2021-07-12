//
//  RecordVideo.m
//  FaceWorkflow
//
//  Created by lieon on 2021/7/12.
//

#import "RecordVideo.h"
extern "C" {
#include <libavdevice/avdevice.h>
#include <libavformat/avformat.h>
#include <libavutil/avutil.h>
#include <libavutil/imgutils.h>
#include <libavcodec/avcodec.h>
}

#define ERROR_BUF(ret) \
    char errbuf[1024]; \
    av_strerror(ret, errbuf, sizeof (errbuf));


@interface RecordVideo()
@property (nonatomic, assign, getter=isStop) BOOL stop;

@end

@implementation RecordVideo

+ (void)initialize {
    avdevice_register_all();
}

- (void)recordVideo {
    self.stop = false;
    dispatch_queue_t queue = dispatch_queue_create("record", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [self record];
    });
}

/**
# 视频录制步骤
- 获取输入格式对象
- 设置设备参数: video_size, pixel_format, framerate
- 打开设备
- 创建数据包
- while循环读取帧数据 ``av_read_frame``
- 将读取到的数据存入文件
- 关闭设备
- 关闭文件
 
 */
- (void)record {
    NSString *fmtname = @"avfoundation";
    NSString *deviceName = @"0";
    // 获取输入格式对象
    AVInputFormat *fmt = av_find_input_format(fmtname.UTF8String);
    if (!fmt) {
        NSLog(@"av_find_input_format error: %@",  fmtname);
        return;
    }
    // 格式上下文
    AVFormatContext *ctx = nullptr;
    // 设备参数
    AVDictionary *options = nullptr;
    av_dict_set(&options, "video_size", "640x480", 0);
    av_dict_set(&options, "pixel_format", "nv12", 0);
    av_dict_set(&options, "framerate", "30", 0);
    // 打开设备
    int ret = avformat_open_input(&ctx, deviceName.UTF8String, fmt, &options);
    if (ret < 0) {
        ERROR_BUF(ret);
        NSLog(@"avformat_open_input error :%s", errbuf);
        return;
    }
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject;
    NSString *fileName = [filePath stringByAppendingPathComponent:@"out.yuv"];
    [[NSFileManager defaultManager]createFileAtPath:fileName contents:[NSData new] attributes:nil];
    NSFileHandle *file = [NSFileHandle fileHandleForWritingAtPath:fileName];
    if (!file) {
        avformat_close_input(&ctx);
        return;
    }
    // 计算一帧的大小
    AVCodecParameters *params = ctx->streams[0]->codecpar;
    AVPixelFormat pixFmt = (AVPixelFormat)params->format;
    int imgeSize = av_image_get_buffer_size(pixFmt,
                                            params->width,
                                            params->height,
                                            1);
    // 数据包
    AVPacket *pkt = av_packet_alloc();
    while (!self.isStop) {
        ret = av_read_frame(ctx, pkt);
        if (ret == 0) { // 读取成功
            NSData *data = [NSData dataWithBytes:pkt->data length:imgeSize];
            [file writeData:data];
            [file seekToEndOfFile];
            av_packet_unref(pkt);
        } else if (ret == AVERROR(EAGAIN)) {
            continue;
        } else {
            break;
        }
    }
    av_packet_free(&pkt);
    [file closeFile];
    avformat_close_input(&ctx);
}

- (void)stop {
    self.stop = true;
}
@end

