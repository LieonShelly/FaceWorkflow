//
//  VideoService.h
//  FaceWorkflow
//
//  Created by lieon on 2021/8/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoService : NSObject
- (void)setFilename:(NSString*)filename;
- (void)play;
@end

NS_ASSUME_NONNULL_END
