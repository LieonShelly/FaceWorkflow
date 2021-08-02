//
//  VideoService.h
//  FaceWorkflow
//
//  Created by lieon on 2021/8/1.
//

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>

@protocol PlayerServiceDelegate <NSObject>

- (void)playerDidDecodeVideoFrame:(CGImageRef _Nullable )imge imgSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_BEGIN

@interface VideoService : NSObject
@property (nonatomic, weak) id<PlayerServiceDelegate> delegate;

- (void)setFilename:(NSString*)filename;
- (void)play;
@end

NS_ASSUME_NONNULL_END
