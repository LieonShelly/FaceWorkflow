//
//  VideoService.m
//  FaceWorkflow
//
//  Created by lieon on 2021/8/1.
//

#import "VideoService.h"
#include "VideoPlayer.hpp"

@interface VideoService()
{
    VideoPlayer *player;
    uint8_t *preFramedata;
    CGImageRef preFrame;
}
@end

@implementation VideoService

- (instancetype)init
{
    self = [super init];
    if (self) {
        player = new VideoPlayer();
        player->setUserData((__bridge void *)self);
        [self setPlayerCallback];
    }
    return self;
}

- (void)setFilename:(NSString *)filename {
    player->setFilename(filename.UTF8String);
}

- (void)play {
    player->play();
}

- (void)releasePreFrame {
    VideoService * service = self;
    if (service->preFrame) {
        delete service->preFramedata;
        service->preFramedata = nullptr;
    }
    if (service->preFrame) {
        CGImageRelease(service->preFrame);
        service->preFrame = nil;
    }
}

void didStateChanged(void * userData, VideoPlayer *player) {
    VideoService *service = (__bridge VideoService*)userData;
    if ([service.delegate respondsToSelector:@selector(playerStateDidChanged:)]) {
        PlayerState state = PlayerStateStopped;
        switch (player->getState()) {
            case VideoPlayer::Paused:
                state = PlayerStatePaused;
                break;
            case VideoPlayer::Playing:
                state = PlayerStatePlaying;
                break;
            case VideoPlayer::Stopped:
                state = PlayerStateStopped;
                break;
        }
        [service.delegate playerStateDidChanged:state];
    }
}

void didTimeChanged(void * userData, VideoPlayer *player) {
    VideoService *service = (__bridge VideoService*)userData;
    if ([service.delegate respondsToSelector:@selector(playerTimeDidChanged:)]) {
        [service.delegate playerTimeDidChanged:player->getTime()];
    }
}

void didDecodeVideoFrame(void * userData, VideoPlayer *player, uint8_t *data, VideoPlayer::VideoSwsSpec spec) {
    VideoService *service = (__bridge VideoService*)userData;
    if ([service.delegate respondsToSelector:@selector(playerDidDecodeVideoFrame:imgSize:)]) {
        CGImageRef cIImage = [service generateImage:spec data:data];
        [service releasePreFrame];
        service->preFrame = cIImage;
        service->preFramedata = data;
        [service.delegate playerDidDecodeVideoFrame:cIImage imgSize:CGSizeMake(spec.width, spec.height)];
   
    }
}

- (void)setPlayerCallback {
    player->setDecodeVideoFrameCallback(didDecodeVideoFrame);
    player->setTimeChangedCallback(didTimeChanged);
    player->setStateCallback(didStateChanged);
}


- (CGImageRef)generateImage:(const VideoPlayer::VideoSwsSpec &)output data:(void*)buffer {
    int width = output.width;
    int height = output.height;
    size_t bufferLength = width * height * 3;
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, bufferLength, NULL);
    size_t bitsPerComponent = 8;
    size_t bitsPerPixel = 24;
    size_t bytesPerRow = 3 * width;
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    if(colorSpaceRef == NULL) {
        CGDataProviderRelease(provider);
    }
    
    CGBitmapInfo bitmapInfo = kCGImageAlphaNone;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    CGImageRef iref = CGImageCreate(width,
                                    height,
                                    bitsPerComponent,
                                    bitsPerPixel,
                                    bytesPerRow,
                                    colorSpaceRef,
                                    bitmapInfo,
                                    provider,   // data provider
                                    NULL,      // decode
                                    NO,          // should interpolate
                                    renderingIntent);
    return iref;
}
@end
