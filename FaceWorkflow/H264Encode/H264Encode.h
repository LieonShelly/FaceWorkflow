//
//  H264Encode.h
//  FaceWorkflow
//
//  Created by lieon on 2021/7/19.
//

#import <Foundation/Foundation.h>
#import "VideoEncodeSpec.h"

NS_ASSUME_NONNULL_BEGIN

@interface H264Encode : NSObject

+ (void)h264Encode:(VideoEncodeSpec*)input output:(NSString*)output;
@end

NS_ASSUME_NONNULL_END
