//
//  YUVPlayer.m
//  FaceWorkflow
//
//  Created by lieon on 2021/7/15.
//

#import "YUVPlayer.h"
#import "YuvParam.h"
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
    YuvParam *_yuv;
    
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
 - 获取一帧的大小 ``av_image_get_buffer_size``
 
 # 播放YUV视频步骤
 - 初始化SDL
 - 创建窗口
 - 创建渲染上下文
 - 创建渲染纹理
 - 通过fps计算出每帧渲染的时间，定时渲染一帧
    - 将YUV的像素数据填充到纹理
    - 设置绘制颜色
    - 用绘制的颜色清除渲染目标
    - 拷贝纹理数据到渲染目标
    -更新所有的渲染操作到屏幕上
 
 */

- (void)dealloc {
    [self.file closeFile];
    SDL_DestroyTexture(texture);
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
}

+ (void)load {

    SDL_SetMainReady();
}

- (void)initialize:(void *)viewId  {
    if(SDL_Init(SDL_INIT_VIDEO)) {
        NSLog(@"SDL_Init error");
    }
    // 创建窗口
    window = SDL_CreateWindow("YUV",
                                SDL_WINDOWPOS_UNDEFINED,
                                SDL_WINDOWPOS_UNDEFINED,
                                512, 512, SDL_WINDOW_SHOWN); //SDL_CreateWindowFrom(viewId);
    RET(!window, SDL_CreateWindowFrom);
    // 创建渲染上下文
    renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
    if (!renderer) {
        renderer = SDL_CreateRenderer(window, -1, 0);
        RET(!renderer, SDL_CreateRenderer);
    }
}

- (void)play {
    //
    NSTimeInterval interval = 1.0 / _yuv.fps * 1.0;
    __weak typeof(self)weakSelf = self;
    self.timer = [NSTimer timerWithTimeInterval:interval repeats:true block:^(NSTimer * _Nonnull timer) {
        [weakSelf timerAction];
        NSLog(@"-----");
    }];
    [self.timer fire];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)pause {
    
}

- (void)stop {
    
}

- (BOOL)isPlaying {
    return true;
}

- (void)setYUV:(YuvParam*)yuv {
    _yuv = yuv;
    NSInteger format = [(NSNumber*)self.pixelFormatMap[[NSNumber numberWithInteger:yuv.pixelFomat]] integerValue];
    texture = SDL_CreateTexture(renderer,
                                (int)format,
                                SDL_TEXTUREACCESS_STREAMING, (int)yuv.width, (int)yuv.height);
    self.file = [NSFileHandle fileHandleForReadingAtPath: _yuv.filename];
}

- (void)timerAction {
    // 获取图片的大小 ``av_image_get_buffer_size``
    int imageSize = av_image_get_buffer_size((AVPixelFormat)_yuv.pixelFomat, (int)_yuv.width, (int)_yuv.height, 1);
    NSData *imageData = [self.file readDataOfLength:imageSize];
    if (imageData.length > 0) {
        // 将YUV的像素数据填充到纹理
        SDL_UpdateTexture(texture, nullptr, imageData.bytes, (int)_yuv.width);
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
