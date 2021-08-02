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
}
@end

@implementation VideoService

- (instancetype)init
{
    self = [super init];
    if (self) {
        player = new VideoPlayer();
    }
    return self;
}

- (void)setFilename:(NSString *)filename {
    player->setFilename(filename.UTF8String);
}

- (void)play {
    player->play();
}

void didDecodeVideoFrame(void * userData, VideoPlayer *player, uint8_t *data, VideoPlayer::VideoSwsSpec spec) {
    VideoService *service = (__bridge VideoService*)userData;
    if ([service.delegate respondsToSelector:@selector(playerDidDecodeVideoFrame:imgSize:)]) {
        
    }
}

- (void)setPlayerCallback {
    player->setDecodeVideoFrameCallback(didDecodeVideoFrame);
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
