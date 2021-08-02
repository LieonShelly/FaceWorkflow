//
//  VideoService.h
//  FaceWorkflow
//
//  Created by lieon on 2021/8/1.
//

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>

typedef enum : NSUInteger {
    PlayerStateStopped = 0,
    PlayerStatePlaying,
    PlayerStatePaused
} PlayerState;

@protocol PlayerServiceDelegate <NSObject>
@required
- (void)playerDidDecodeVideoFrame:(CGImageRef _Nullable )imge imgSize:(CGSize)size;
@optional
- (void)playerTimeDidChanged:(double)time;
- (void)playerStateDidChanged:(PlayerState)state;
@end;

NS_ASSUME_NONNULL_BEGIN

@interface VideoService : NSObject
@property (nonatomic, weak) id<PlayerServiceDelegate> delegate;
- (void)releasePreFrame;
- (void)setFilename:(NSString*)filename;
- (void)play;
// 暂停
- (void)pause;
// 停止
- (void)stop;
// 是否在播放中
- (BOOL)isPlaying;
// 获取当前播放状态
- (PlayerState)getState;
// 获取总时长（秒）
- (int)getDuration;
// 当前的播放时刻
- (int)getTime;
// 设置当前的播放时刻
- (void)setTime:(float)seekTime;
// 设置音量
- (void)setVolumn:(float)volumn;
- (int)getVolumn;
// 设置静音
- (void)setMute:(bool)mute;
- (bool)isMute;

@end

NS_ASSUME_NONNULL_END
