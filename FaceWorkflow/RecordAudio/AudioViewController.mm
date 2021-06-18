//
//  AudioViewController.m
//  FaceWorkflow
//
//  Created by lieon on 2021/6/18.
//

#import "AudioViewController.h"

#include "Test.hpp"

extern "C" {
// 设备
#include <libavdevice/avdevice.h>
// 格式
#include <libavformat/avformat.h>
// 工具
#include <libavutil/avutil.h>
}

@interface AudioViewController ()
@property (nonatomic, assign) BOOL isInterruptionRequested;
@property (nonatomic, strong) UIButton *btn;

@end

@implementation AudioViewController

- (void)loadView {
    [super loadView];
    avdevice_register_all();
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.btn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.btn.frame = CGRectMake(100, 100, 100, 59);
    [self.btn setTitle:@"开始录音" forState:UIControlStateNormal];
    [self.btn setTitle:@"停止录音" forState:UIControlStateSelected];
    [self.btn addTarget:self action:@selector(btnTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];
}


- (void)btnTap:(UIButton*)btn {
    [self.btn setSelected:!btn.isSelected];
    if (self.btn.isSelected) {
        self.isInterruptionRequested = false;
        [self record];
    } else {
        self.isInterruptionRequested = true;
    }
    
}


void showSpec(AVFormatContext *ctx) {
    AVStream *stream = ctx->streams[0];
    AVCodecParameters * params = stream->codecpar;
    NSLog(@"channels: %d", params->channels);
    NSLog(@"sample_rate:%d", params->sample_rate);
    NSLog(@"channel_layout: %llu", params->channel_layout);
    NSLog(@"format: %d", params->format);
    NSLog(@"av_get_bytes_per_sample: %d", av_get_bytes_per_sample((AVSampleFormat)params->format));
    NSLog(@"codec_id: %d", params->codec_id);
    NSLog(@"av_get_bits_per_sample: %d", av_get_bits_per_sample(params->codec_id));

}



- (void)record {
    NSString *formatName = @"avfoundation";
    NSString *deviceName = @":0";
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject;
    AVInputFormat *fmt = av_find_input_format([formatName UTF8String]);
    if (!fmt) {
        NSLog(@"获取输入格式对象失败");
        return;
    }
    AVFormatContext *ctx = nullptr;
    AVDictionary *option = nullptr;
    int ret = avformat_open_input(&ctx, deviceName.UTF8String, fmt, &option);
    if (ret < 0) {
        char errbuf[1024];
        av_strerror(ret, errbuf, sizeof(errbuf));
        NSLog(@"打开设备失败:%@", [NSString stringWithUTF8String:errbuf]);
        return;
    }
   
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSString *fileName = [filePath stringByAppendingPathComponent:@"out.pcm"];
        NSMutableData *pcmData = [NSMutableData new];
        AVPacket pkt = AVPacket();
        while (!self.isInterruptionRequested) {
           int ret = av_read_frame(ctx, &pkt);
            if (ret == 0) {
                NSLog(@"---record---: %d", pkt.size);
                [pcmData appendBytes:pkt.data length:pkt.size];
            } else if (ret == AVERROR(EAGAIN) ) {
                
            } else {
                char errbuf[1024];
                av_strerror(ret, errbuf, sizeof(errbuf));
                NSLog(@"打开设备失败:%@", [NSString stringWithUTF8String:errbuf]);
            }
        }
       BOOL result = [[NSFileManager defaultManager]createFileAtPath:fileName contents:pcmData attributes:nil];
        if (result) {
            NSLog(@"写入文件成功：%lu", (unsigned long)pcmData.length);
        } else {
            NSLog(@"写入文件失败");
        }
    });
  
   
}
@end
