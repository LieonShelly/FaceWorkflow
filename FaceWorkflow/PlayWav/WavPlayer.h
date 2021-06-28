//
//  WavPlayer.h
//  FaceWorkflow
//
//  Created by lieon on 2021/6/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WavPlayer : NSObject
- (void)playWithFile:(NSString*)wavFile;
@end

NS_ASSUME_NONNULL_END
