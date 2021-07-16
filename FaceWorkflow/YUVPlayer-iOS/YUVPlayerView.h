//
//  YUVPlayerView.h
//  FaceWorkflow
//
//  Created by lieon on 2021/7/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YuvParam;
@interface YUVPlayerView : UIView
- (void)play;
- (void)pause;
- (void)stop;
- (BOOL)isPlaying;
- (void)setYUV:(YuvParam*)yuv;
@end

NS_ASSUME_NONNULL_END
