//
//  YUVPlayer.m
//  FaceWorkflow
//
//  Created by lieon on 2021/7/15.
//

#import "YUVPlayer.h"
#include "Yuv.hpp"
extern "C" {
#include <libavutil/avutil.h>
#include <libavutil/imgutils.h>
#include <SDL.h>
}

#define RET(judge, func) \
    if (judge) { \
        NSLog(@"%s error %s", #func, SDL_GetError()); \
        return; \
    }


@interface YUVPlayer()
{
    SDL_Window *window;
    SDL_Renderer *renderer;
    SDL_Texture *texture;
    Yuv *_yuv;
    
}

@property (nonatomic, strong) NSFileHandle *file;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSDictionary *pixelFormatMap;


@end

@implementation YUVPlayer
- (NSDictionary *)pixelFormatMap {
    if (!_pixelFormatMap) {
        _pixelFormatMap = @{[NSNumber numberWithInt:AV_PIX_FMT_YUV420P]: [NSNumber numberWithInt:SDL_PIXELFORMAT_IYUV],
                            [NSNumber numberWithInt:AV_PIX_FMT_YUYV422] : [NSNumber numberWithInt:SDL_PIXELFORMAT_YUY2],
                            [NSNumber numberWithInt:AV_PIX_FMT_NONE] : [NSNumber numberWithInt:SDL_PIXELFORMAT_UNKNOWN]
        };
    }
    return _pixelFormatMap;
}
/**
 # 播放的原理
 - 通过fps计算出每帧渲染的时间，定时渲染一帧
 
 # 播放YUV视频步骤
 - 创建窗口
 - 创建渲染上下文
 
 */

- (void)dealloc {
    [self.file closeFile];
    SDL_DestroyTexture(texture);
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
}

- (void)initialize:(void *)viewId  {
    // 创建窗口
    window = SDL_CreateWindowFrom(viewId);
    RET(window, SDL_CreateWindowFrom);
    // 创建渲染上下文
    renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
    if (!renderer) {
        renderer = SDL_CreateRenderer(window, -1, 0);
        RET(!renderer, SDL_CreateRenderer);
    }
}

- (void)play {
    //
    NSTimeInterval interval = 1.0 / _yuv->fps * 1.0;
    __weak typeof(self)weakSelf = self;
    self.timer = [NSTimer timerWithTimeInterval:interval repeats:true block:^(NSTimer * _Nonnull timer) {
        [weakSelf timerAction];
    }];
}

- (void)pause {
    
}

- (void)stop {
    
}

- (BOOL)isPlaying {
    return true;
}

- (void)setYUV:(Yuv*)yuv {
    _yuv = yuv;
    NSInteger format = [(NSNumber*)self.pixelFormatMap[[NSNumber numberWithInt:yuv->pixelFomat]] integerValue];
    texture = SDL_CreateTexture(renderer,
                                (int)format,
                                SDL_TEXTUREACCESS_STREAMING, yuv->width, yuv->height);
    self.file = [NSFileHandle fileHandleForReadingAtPath:[NSString stringWithUTF8String:yuv->filename]];
}

- (void)timerAction {
    // 获取图片的大小
    int imageSize = av_image_get_buffer_size(_yuv->pixelFomat, _yuv->width, _yuv->height, 1);
    NSData *imageData = [self.file readDataOfLength:imageSize];
    if (imageData.length > 0) {
        // 将YUV的像素数据填充dao纹理
        SDL_UpdateTexture(texture, nullptr, imageData.bytes, _yuv->width);
        // 设置绘制颜色
        SDL_SetRenderDrawColor(renderer, 0, 0, 0, SDL_ALPHA_OPAQUE);
        // 用绘制的颜色清除渲染目标
        SDL_RenderClear(renderer);
        // 拷贝纹理数据到渲染目标
        SDL_RenderCopy(renderer, texture, nullptr, nullptr);
        // 更新所有的渲染操作到屏幕上
        SDL_RenderPresent(renderer);
    } else {
        [self.timer invalidate];
        self.timer = nil;
    }
    
}

@end
