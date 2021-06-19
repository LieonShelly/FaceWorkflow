//
//  AudioViewController.m
//  FaceWorkflow
//
//  Created by lieon on 2021/6/18.
//

#import "AudioViewController.h"
#import "PermenantThread.h"
#include "Test.hpp"
extern "C" {
// 设备
#include <libavdevice/avdevice.h>
// 格式
#include <libavformat/avformat.h>
// 工具
#include <libavutil/avutil.h>
#include "SDL.h"
}
#include "SDL_main.h"

@interface AudioViewController ()
@property (nonatomic, assign) BOOL isInterruptionRequested;
@property (nonatomic, strong) UIButton *recordBtn;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) PermenantThread *thread;
@property (nonatomic, copy) NSString *fileName;

@end

@implementation AudioViewController

- (UIButton *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_recordBtn setTitle:@"开始录音" forState:UIControlStateNormal];
        [_recordBtn setTitle:@"停止录音" forState:UIControlStateSelected];
        [_recordBtn addTarget:self action:@selector(recordBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordBtn;
}


- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_playBtn setTitle:@"播放" forState:UIControlStateNormal];
        [_playBtn setTitle:@"暂停" forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(playBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (void)loadView {
    [super loadView];
    avdevice_register_all();
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.recordBtn.frame = CGRectMake(100, 100, 100, 59);
    self.playBtn.frame = CGRectMake(100, CGRectGetMaxY(self.recordBtn.frame) + 50, 100, 59);
    [self.view addSubview:self.recordBtn];
    [self.view addSubview:self.playBtn];
    SDL_version v;
    SDL_VERSION(&v);
    SDL_SetMainReady();
}

- (void)recordBtnTap:(UIButton*)btn {
    [self.recordBtn setSelected:!btn.isSelected];
    if (self.recordBtn.isSelected) {
        self.isInterruptionRequested = false;
        [self record];
    } else {
        self.isInterruptionRequested = true;
    }
    
}

- (void)playBtnTap:(UIButton*)btn {
    [self.playBtn setSelected:!btn.isSelected];
    if (self.playBtn.isSelected) {
        self.isInterruptionRequested = false;
        [self playPCM:self.fileName];
    } else {
        self.isInterruptionRequested = true;
    }
}

- (PermenantThread *)thread {
    if (!_thread) {
        _thread = [PermenantThread new];
    }
    return _thread;
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
    self.fileName = [filePath stringByAppendingPathComponent:@"out.pcm"];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSString *fileName = self.fileName;
        NSMutableData *pcmData = [NSMutableData new];
        AVPacket pkt = AVPacket();
        NSInteger bufferSize = 1024 * 10;
        while (!self.isInterruptionRequested) {
           int ret = av_read_frame(ctx, &pkt);
            if (ret == 0) {
                if (pcmData.length >= bufferSize) {
                    dispatch_barrier_async(queue, ^{
                        NSFileManager *fileManager = [NSFileManager defaultManager];
                        NSRange writeRange = NSMakeRange(0, pcmData.length);
                        NSData *writeData = [pcmData subdataWithRange:writeRange];
                        if (![fileManager fileExistsAtPath:fileName]) {
                            [writeData writeToFile:fileName atomically:true];
                            [pcmData resetBytesInRange:writeRange];
                            [pcmData setLength:0];
                            NSLog(@"写入文件成功：%lu", (unsigned long)writeData.length);
                        } else {
                            NSFileHandle *filehandle = [NSFileHandle fileHandleForWritingAtPath:fileName];
                            [filehandle seekToEndOfFile];
                            [filehandle writeData:writeData];
                            [filehandle closeFile];
                            [pcmData resetBytesInRange:writeRange];
                            [pcmData setLength:0];
                            NSLog(@"写入文件成功：%lu", (unsigned long)writeData.length);
                        }
                    });
                }
                NSLog(@"---record---pkt: %d - pcmData: %lu", pkt.size, (unsigned long)pcmData.length);
                [pcmData appendBytes:pkt.data length:pkt.size];
            } else if (ret == AVERROR(EAGAIN) ) {
                
            } else {
                char errbuf[1024];
                av_strerror(ret, errbuf, sizeof(errbuf));
                NSLog(@"打开设备失败:%@", [NSString stringWithUTF8String:errbuf]);
            }
        }
        NSFileHandle *filehandle = [NSFileHandle fileHandleForWritingAtPath:fileName];
        [filehandle seekToEndOfFile];
        [filehandle writeData:pcmData];
        [filehandle closeFile];
        NSLog(@"写入文件成功：%lu", (unsigned long)pkt.size);
        [pcmData resetBytesInRange:NSMakeRange(0, pcmData.length)];
        [pcmData setLength:0];
        pcmData = nil;
    });
}

- (void)recordWithPermantThread {
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
        NSLog(@"打开设备失败");
        return;
    }
    self.fileName = [filePath stringByAppendingPathComponent:@"out.pcm"];
    [self.thread excuteTask:^{
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
       BOOL result = [[NSFileManager defaultManager]createFileAtPath:self.fileName contents:pcmData attributes:nil];
        if (result) {
            NSLog(@"写入文件成功：%lu", (unsigned long)pcmData.length);
        } else {
            NSLog(@"写入文件失败");
        }
    }];
}


int bufferLen;
char *bufferData;

void pulAudioData(void *userData, Uint8 *stream, int len) {
    SDL_memset(stream, 0, len);
    if (bufferLen <= 0) {
        return;
    }
    int realLen = len > bufferLen ? bufferLen : len;
    SDL_MixAudio(stream, (UInt8 *)bufferData, realLen, SDL_MIX_MAXVOLUME);
    bufferData += realLen;
    bufferLen -= len;
    
}

- (void)playPCM:(NSString*)filename {
    if (SDL_Init(SDL_INIT_AUDIO)) {
        NSLog(@"SDL_INIT Error: %s", SDL_GetError());
        return;
    }
    int SAMPLES = 1024;
    int CHANNELS = 2;
    int SAMPLE_FORMAT = AUDIO_S16LSB;
    int SAMPLE_SIZE = SDL_AUDIO_BITSIZE(SAMPLE_FORMAT);
    int BYTES_PER_SAMPLE = (SAMPLE_SIZE * CHANNELS) >> 3;
    int BUFFER_SIZE = SAMPLES * BYTES_PER_SAMPLE;
    SDL_AudioSpec spec;
    spec.freq = 44100;
    spec.format = AUDIO_S16LSB;
    spec.channels = 2;
    spec.samples = 1024;
    spec.userdata = (void*)100;
    spec.callback = pulAudioData;
    if (SDL_OpenAudio(&spec, nullptr)) {
        SDL_Quit();
        NSLog(@"SDL_OpenAudio Error: %s", SDL_GetError());
        return;
    }
    SDL_PauseAudio(0);
    NSFileHandle *filehandle = [NSFileHandle fileHandleForReadingAtPath:filename];
    [self.thread excuteTask:^{
        while (!self.isInterruptionRequested) {
            if (bufferLen > 0) continue;
            NSData *data = [filehandle readDataOfLength:BUFFER_SIZE];
            bufferLen = data.length;
            if (bufferLen <= 0) {
                break;
            }
            bufferData =  (char *)[data bytes];
        }
        [filehandle closeFile];
        SDL_CloseAudio();
        SDL_Quit();
    }];
}
@end
