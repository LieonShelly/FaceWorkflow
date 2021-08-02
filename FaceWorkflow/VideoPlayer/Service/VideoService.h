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
@end

NS_ASSUME_NONNULL_END
