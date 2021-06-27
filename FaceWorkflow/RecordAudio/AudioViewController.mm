//
//  AudioViewController.m
//  FaceWorkflow
//
//  Created by lieon on 2021/6/18.
//

#import "AudioViewController.h"
#import "PermenantThread.h"
#include "AudioBuffer.hpp"
#import "FFMpegs.h"
#import <objc/runtime.h>

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
@property (nonatomic, strong) UIButton *wavConvertBtn;
@property (nonatomic, strong) dispatch_queue_t moneyQueue;

@end


// 采样率
#define SAMPLE_RATE 48000 // 44100 //  //
// 采样格式
#define SAMPLE_FORMAT AUDIO_S16LSB
// 采样大小
#define SAMPLE_SIZE SDL_AUDIO_BITSIZE(SAMPLE_FORMAT)
// 声道数
#define CHANNELS 1 // 2
// 音频缓冲区的样本数量
#define SAMPLES 1024
// 每个样本占用多少个字节
#define BYTES_PER_SAMPLE ((SAMPLE_SIZE * CHANNELS) >> 3)
// 文件缓冲区的大小
#define BUFFER_SIZE (SAMPLES * BYTES_PER_SAMPLE)


@implementation AudioViewController

- (UIButton *)wavConvertBtn {
    if (!_wavConvertBtn) {
        _wavConvertBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_wavConvertBtn setTitle:@"开始转换" forState:UIControlStateNormal];
        [_wavConvertBtn addTarget:self action:@selector(wavConvertBtnTap) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wavConvertBtn;
}

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
    self.wavConvertBtn.frame = CGRectMake(100, CGRectGetMaxY(self.playBtn.frame) + 50, 100, 59);
    [self.view addSubview:self.recordBtn];
    [self.view addSubview:self.playBtn];
    [self.view addSubview:self.wavConvertBtn];
    SDL_version v;
    SDL_VERSION(&v);
    SDL_SetMainReady();
    self.moneyQueue = dispatch_queue_create("moneyQueue", DISPATCH_QUEUE_SERIAL);
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

- (void)__drawMoney {
   dispatch_sync(self.moneyQueue, ^{
       NSLog(@"__drawMoney: %@", [NSThread currentThread]);
   });
}

- (void)__saveMoney {
   dispatch_sync(self.moneyQueue, ^{
       NSLog(@"__saveMoney: %@", [NSThread currentThread]);
   });
}

- (void)playBtnTap:(UIButton*)btn {
    [self.playBtn setSelected:!btn.isSelected];
    if (self.playBtn.isSelected) {
        self.isInterruptionRequested = false;
        NSString *inpcm = [[NSBundle mainBundle]pathForResource:@"in.pcm" ofType:nil];
        [self playPCM:self.fileName == nil ? inpcm : self.fileName];
    } else {
        self.isInterruptionRequested = true;
    }
}

- (void)wavConvertBtnTap {
    NSLog(@"[super superclass] = %@", [super superclass]);
    NSLog(@"[super class] = %@", [super class]);
//    WavHeader header = WavHeader();
//    header.sampleRate = SAMPLE_RATE;
//    header.bitPerSample = SDL_AUDIO_BITSIZE(SAMPLE_FORMAT);
//    header.numChannels = CHANNELS;
//    NSString *pcmfile = [[NSBundle mainBundle]pathForResource:@"in.pcm" ofType:nil];
//    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject;
//    NSString *wavFile = [filePath stringByAppendingPathComponent:@"in.wav"];
//    [FFMpegs pcm2wav:&header pcmfile:pcmfile wavfile:wavFile];
    
    ResampleAudioSpec input;
    const char *inputfile =  [self.fileName UTF8String];
    input.filename = (char *)inputfile;
    input.sampleRate = SAMPLE_RATE;
    input.sampleFmt = AV_SAMPLE_FMT_S16;
    input.chLayout = AV_CH_LAYOUT_MONO;
    
    ResampleAudioSpec output;
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject;
    NSString *outFilename = [filePath stringByAppendingPathComponent:@"44100_s32.pcm"];
    output.filename = [outFilename UTF8String];
    output.sampleRate = 44100;
    output.sampleFmt = AV_SAMPLE_FMT_FLT;
    output.chLayout = AV_CH_LAYOUT_STEREO;
    
    [FFMpegs resample:&input outPut:&output];
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
    // 通过codec_id也可以知道采样格式
    NSLog(@"codec_id: %d", params->codec_id);
    // 每个样本的位数 >> 3 得到字节数
    NSLog(@"av_get_bits_per_sample: %d", av_get_bits_per_sample(params->codec_id));

}

- (void)record {
    NSString *formatName = @"avfoundation";
    NSString *deviceName = @":0";
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject;
    self.fileName = [filePath stringByAppendingPathComponent: @"record_out.pcm"];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
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
        NSString *fileName = self.fileName;
        NSMutableData *pcmData = [NSMutableData new];
        AVPacket *pkt = av_packet_alloc();
        NSInteger bufferSize = 1024 * 10;
        while (!self.isInterruptionRequested) {
           int ret = av_read_frame(ctx, pkt);
            if (ret == 0) {
                if (pcmData.length >= bufferSize) {
                    showSpec(ctx);
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
                NSLog(@"---record---pkt: %d - pcmData: %lu", pkt->size, (unsigned long)pcmData.length);
                [pcmData appendBytes:pkt->data length:pkt->size];
            } else if (ret == AVERROR(EAGAIN) ) {
                
            } else {
                char errbuf[1024];
                av_strerror(ret, errbuf, sizeof(errbuf));
                NSLog(@"打开设备失败:%@", [NSString stringWithUTF8String:errbuf]);
            }
            av_packet_unref(pkt);
        }
        NSFileHandle *filehandle = [NSFileHandle fileHandleForWritingAtPath:fileName];
        [filehandle seekToEndOfFile];
        [filehandle writeData:pcmData];
        [filehandle closeFile];
        NSLog(@"写入文件成功：%lu", (unsigned long)pkt->size);
        [pcmData resetBytesInRange:NSMakeRange(0, pcmData.length)];
        [pcmData setLength:0];
        pcmData = nil;
        av_packet_free(&pkt);
        avformat_close_input(&ctx);
    });
}

void pulAudioData(void *userData, Uint8 *stream, int len) {
    AudioBuffer *buffer = (AudioBuffer*)userData;
    SDL_memset(stream, 0, len);
    if (buffer->len <= 0) {
        return;
    }
    buffer->pullLen = len > buffer->len ? buffer->len : len;
    NSLog(@"before-buffer->len: %d, buffer->pullLen %d, len: %d", buffer->len, buffer->pullLen, len);
    SDL_MixAudio(stream, (UInt8 *)buffer->data, buffer->pullLen, SDL_MIX_MAXVOLUME);
    buffer->data += buffer->pullLen;
    buffer->len -= buffer->pullLen;
    NSLog(@"buffer->len: %d, buffer->pullLen %d", buffer->len, buffer->pullLen);
}

- (void)playPCM:(NSString*)filename {
    if (SDL_Init(SDL_INIT_AUDIO)) {
        NSLog(@"SDL_INIT Error: %s", SDL_GetError());
        return;
    }
    SDL_AudioSpec spec;
    spec.freq = SAMPLE_RATE;
    spec.format = SAMPLE_FORMAT;
    spec.channels = CHANNELS;
    spec.samples = SAMPLES;
    spec.callback = pulAudioData;
    AudioBuffer *buffer = new AudioBuffer();
    spec.userdata = buffer;
    if (SDL_OpenAudio(&spec, nullptr)) {
        SDL_Quit();
        NSLog(@"SDL_OpenAudio Error: %s", SDL_GetError());
        return;
    }
    SDL_PauseAudio(0);
    NSFileHandle *filehandle = [NSFileHandle fileHandleForReadingAtPath:filename];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (!self.isInterruptionRequested) {
            if (buffer->len > 0) continue;
            NSData *data = [filehandle readDataOfLength:BUFFER_SIZE];
            buffer->len = (int)data.length;
            if (buffer->len <= 0) {
                // 剩余样本数量
                // BYTES_PER_SAMPLE 每个样本的大小 = 采样率 * 通道数 >> 3
                // 这样做的目的是推迟线程结束的时间，让剩余的音频播放完毕
                int samples = buffer->pullLen / BYTES_PER_SAMPLE;
                int ms = samples * 1000 / SAMPLE_RATE;
                SDL_Delay(ms);
                break;
            }
            buffer->data =  (Uint8 *)[data bytes];
        }
        [filehandle closeFile];
        SDL_CloseAudio();
        SDL_Quit();
        dispatch_async(dispatch_get_main_queue(), ^{
            [self playEnd];
        });
    });
    
}

- (void)playEnd {
    
    [self.playBtn setSelected:false];
}
@end


/**
 LSB\MSB
 - LSB（Least Sigificant Bit\Byte）最低有效位/字节 小端 (最低有效字节先被读取到)
 - MSB (Most Significant Bit\Byte) 最高有效位/字节 大端 （最高有字节先被读取到）
 AV_CODEC_ID_PCM_S32LE,
 AV_CODEC_ID_PCM_S32BE,
 AV_CODEC_ID_PCM_U32LE,
 采样格式包含：
 1.位深度（样本占多少位）
 2.有符号，无符号，浮点数
 3.大端(Big-Endian), 小端(Little-Endian)
 */

