//
//  WavPlayer.m
//  FaceWorkflow
//
//  Created by lieon on 2021/6/27.
//

#import "WavPlayer.h"
#include "SDL.h"
#include "AudioBuffer.hpp"


@interface WavPlayer()
@property (nonatomic, assign, getter=isInterruptionRequested) BOOL interruptionRequested;
@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation WavPlayer

- (dispatch_queue_t)queue {
    if (!_queue) {
        _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    return _queue;
}

// 等待音频设备回调(会回调多次)
void pull_audio_data(void *userdata,
                     // 需要往stream中填充PCM数据
                     Uint8 *stream,
                     // 希望填充的大小(samples * format * channels / 8)
                     int len
                     ) {
    AudioBuffer *buffer = (AudioBuffer*)userdata;
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

+ (void)initialize {
    SDL_SetMainReady();
}

/**
 # 播放PCM步骤
 - 初始化SDL ``SDL_Init(SDL_INIT_AUDIO)``
 - 设置SDL音频参数 ``SDL_AudioSpec``
 - 直接加载WAV文件 ``SDL_LoadWAV``
 - 设置拉取回调
 - SDL打开音频 ``SDL_OpenAudio``
 - 开始拉取 ``SDL_PauseAudio(0);``
 - 回调监听
    - 设置音频流内存大小，播放器的内存数据在这个 ``stream`` 中
    - 传入PCM数据进行混音
    - 移动缓存指针，进行下轮的拉取
- 释放资源
 */

- (void)playWithFile:(NSString*)wavFile {
    dispatch_async(self.queue, ^{
        if (SDL_Init(SDL_INIT_AUDIO)) {
            return;
        }
        self.interruptionRequested = false;
        SDL_AudioSpec spec;
        Uint8 *data = nullptr;
        UInt32 len = 0;
        if (!SDL_LoadWAV([wavFile UTF8String], &spec, &data, &len)) {
            NSLog(@"SDL_LoadWAV Error: %s", SDL_GetError());
            SDL_Quit();
            return;
        }
        spec.samples = 1024;
        spec.callback = pull_audio_data;
        
        AudioBuffer buffer;
        buffer.data = data;
        buffer.len = len;
        spec.userdata = &buffer;
        if (SDL_OpenAudio(&spec, nullptr)) {
            NSLog(@"SDL_OpenAudio Error: %s", SDL_GetError());
            SDL_Quit();
            return;
        }
        
        int sampleSize = SDL_AUDIO_BITSIZE(spec.format);
        int bytesPerSample = (sampleSize * spec.channels) >> 3;
        SDL_PauseAudio(0);
        while (!self.interruptionRequested) {
            if (buffer.len > 0) {
                continue;
            }
            if (buffer.len <= 0) {
                int samples = buffer.pullLen / bytesPerSample;
                int ms = samples * 1000 / spec.freq;
                SDL_Delay(ms);
                break;
            }
        }
        SDL_FreeWAV(data);
        SDL_CloseAudio();
        SDL_Quit();
    });
    
}

- (void)stop {
    self.interruptionRequested = true;
}
@end
