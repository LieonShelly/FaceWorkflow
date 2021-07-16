//
//  YUVPlayer.h
//  FaceWorkflow
//
//  Created by lieon on 2021/7/15.
//

#import <Foundation/Foundation.h>

@class YuvParam;
NS_ASSUME_NONNULL_BEGIN

@interface YUVPlayer : NSObject
- (void)initialize:(void *)viewId;
- (void)play;
- (void)pause;
- (void)stop;
- (BOOL)isPlaying;
- (void)setYUV:(YuvParam*)yuv;
@end

NS_ASSUME_NONNULL_END
