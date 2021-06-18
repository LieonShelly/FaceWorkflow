//
//  PermenantThread.h
//  FaceWorkflow
//
//  Created by lieon on 2021/6/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PermenantThread : NSObject
- (void)excuteTask:(void(^)(void))task;
- (void)stop;
@end

NS_ASSUME_NONNULL_END
