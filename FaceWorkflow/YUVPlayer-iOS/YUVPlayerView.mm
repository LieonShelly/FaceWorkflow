//
//  YUVPlayerView.m
//  FaceWorkflow
//
//  Created by lieon on 2021/7/16.
//
#import <CoreImage/CoreImage.h>
#import "YUVPlayerView.h"
#import "YuvParam.h"
#import "FFMpegs.h"
#include "RawVideoFrame.hpp"
extern "C" {
#include <libavutil/imgutils.h>
}
/**
 - 定时读取YUV的视频帧
 - 将YUV转换为RGB数据
 - 用RGB数据生成CGimage
 - 在view上绘制CGImage
 */

@interface YUVPlayerView()
{
    YuvParam *_yuv;
    int imageSize;
    CGRect playerRect;
    
}
@property (nonatomic, strong) CAShapeLayer *playLayer;
@property (nonatomic, strong) NSFileHandle *file;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSDictionary *pixelFormatMap;
@end

@implementation YUVPlayerView

- (CAShapeLayer *)playLayer {
    if (!_playLayer) {
        _playLayer = [CAShapeLayer layer];
        _playLayer.fillColor = UIColor.redColor.CGColor;
        _playLayer.backgroundColor = UIColor.yellowColor.CGColor;
    }
    return _playLayer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.layer addSublayer:self.playLayer];
    }
    return self;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
//    self.playLayer.frame = layer.bounds;
}

- (void)play {
    //
    NSTimeInterval interval = 1.0 / _yuv.fps * 1.0;
    __weak typeof(self)weakSelf = self;
    self.timer = [NSTimer timerWithTimeInterval:interval repeats:true block:^(NSTimer * _Nonnull timer) {
        [weakSelf timerAction];
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
    NSInteger format = yuv.pixelFomat;
    self.file = [NSFileHandle fileHandleForReadingAtPath: _yuv.filename];
    // 一帧图片的大小
    imageSize = av_image_get_buffer_size((AVPixelFormat)_yuv.pixelFomat, _yuv.width, _yuv.height, 1);
    // 当前控件的大小
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    // 计算Rect
    CGFloat dx = 0;
    CGFloat dy = 0;
    CGFloat dw = _yuv.width;
    CGFloat dh = _yuv.height;
    // 计算目标尺寸
    if (dw > width || dh > height) {
        if (dw * height > width * dh) { // 视频的宽高比 > 播放器的宽高比
            dh = width * dh / dw;
            dw = width;
        } else {
            dw = height * dw / dh;
            dh = height;
        }
    }
    dx = (width - dw) * 0.5;
    dy = (height - dh) * 0.5;
    playerRect = CGRectMake(dx, dy, dw, dh);
}

- (CGImageRef)generateImage:(const RawVideoFrame &)output {
    int width = output.width;
    int height = output.height;
    size_t bufferLength = width * height * 3;
    char * buffer = output.pixels;
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

- (void)timerAction {
    NSData *imageData = [self.file readDataOfLength:imageSize];
    if (imageData.length > 0) {
        RawVideoFrame input = {
            (char*)imageData.bytes,
            static_cast<int>(_yuv.width),
            static_cast<int>(_yuv.height),
            (AVPixelFormat)_yuv.pixelFomat,
        };
        RawVideoFrame output = {
            nullptr,
            static_cast<int>(_yuv.width >> 4 << 4),
            static_cast<int>(_yuv.height >> 4 << 4), // 16的倍数。提高编码效率
            AV_PIX_FMT_RGB24
        };
        [FFMpegs convertRawVideo:&input output:&output];
        CGImageRef iref = [self generateImage:output];
        self.playLayer.contents = (__bridge id)iref;
        self.playLayer.frame = playerRect;
    } else {
        [self.timer invalidate];
        self.timer = nil;
    }
    
}

@end
