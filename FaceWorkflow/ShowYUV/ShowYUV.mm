//
//  ShowYUV.m
//  FaceWorkflow
//
//  Created by lieon on 2021/7/14.
//

#import "ShowYUV.h"
#import <SDL.h>


#define END(judge, func) \
    if (judge) { \
        NSLog(@"%s error %s", #func, SDL_GetError()); \
        goto end; \
    }

#define IMG_W 512
#define IMG_H 512

@implementation ShowYUV
// ffplay -video_size 512x512 -pixel_format yuvj420p in.yuv


+ (void)initialize {
    SDL_SetMainReady();
}

/**
 # SDL显示YUV步骤
 - 初始化SDL子系统 ``SDL_Init(SDL_INIT_VIDEO)``
 - 创建窗口 ``SDL_CreateWindow``
 - 创建渲染上下文 ``SDL_CreateRenderer``
 - 创建纹理 ``SDL_CreateTexture``
 - 将YUV的像素数据填充到texture ``SDL_UpdateTexture``
 - 设置绘制颜色 ``SDL_SetRenderDrawColor``
 - 用绘制颜色清除渲染目标 ``SDL_RenderClear``
 - 拷贝纹理数据到渲染目标 ``SDL_RenderCopy``
 - 更新所有的渲染操作到屏幕上 ``SDL_RenderPresent``
 - 命令行显示YUV
    ```
    ffplay -video_size 512x512 -pixel_format yuvj420p in.yuv
    ```
 */

- (void)show {
    // 渲染窗口
    SDL_Window *window = nullptr;
    // 渲染上下文
    SDL_Renderer *renderer = nullptr;
    // 纹理
    SDL_Texture *texture = nullptr;
    NSString *fileName = [[NSBundle mainBundle]pathForResource:@"in.yuv" ofType:nil];
    NSData *yuv = [NSData dataWithContentsOfFile:fileName];
    // 初始化子系统
    END(SDL_Init(SDL_INIT_VIDEO), SDL_Init);
    // 创建窗口
    window = SDL_CreateWindow("YUV",
                              SDL_WINDOWPOS_UNDEFINED,
                              SDL_WINDOWPOS_UNDEFINED,
                              IMG_W, IMG_H, SDL_WINDOW_SHOWN);
    END(!window, SDL_CreateWindow);
    // 创建渲染上下文
    renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
    if (!renderer) {
        renderer = SDL_CreateRenderer(window, -1, 0);
        END(!renderer, SDL_CreateRenderer);
    }
    // 创建纹理
    texture = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_IYUV, SDL_TEXTUREACCESS_STREAMING, IMG_W, IMG_H);
    END(!texture, SDL_CreateTexture);
    // 将YUV的像素数据填充到texture
    END(SDL_UpdateTexture(texture, nullptr, yuv.bytes, IMG_W), SDL_UpdateTexture);
    // 设置绘制颜色
    END(SDL_SetRenderDrawColor(renderer, 0, 0, 0, SDL_ALPHA_OPAQUE), SDL_SetRenderDrawColor);
    // 用绘制颜色清除渲染目标
    END(SDL_RenderClear(renderer), SDL_RenderClear);
    // 拷贝纹理数据到渲染目标
    END(SDL_RenderCopy(renderer, texture, nullptr, nullptr), SDL_RenderCopy);
    // 更新所有的渲染操作到屏幕上
    SDL_RenderPresent(renderer);
    while (1) {
        SDL_Event event;
        SDL_WaitEvent(&event);
        switch (event.type) {
            case SDL_QUIT:
                goto end;
        }
    }
end:
    NSLog(@"endl");
    SDL_DestroyTexture(texture);
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
}
@end
