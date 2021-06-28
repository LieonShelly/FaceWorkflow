//
//  RecordWAV.h
//  FaceWorkflow
//
//  Created by lieon on 2021/6/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecordWAV : NSObject
- (void)record;
- (void)stopRecord;
- (NSString*)filename;
@end

NS_ASSUME_NONNULL_END
