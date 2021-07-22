//
//  H264Decode.h
//  FaceWorkflow
//
//  Created by lieon on 2021/7/21.
//

#import <Foundation/Foundation.h>
#import "VideoEncodeSpec.h"


NS_ASSUME_NONNULL_BEGIN

@interface H264Decode : NSObject

+ (void)h264Decode:(NSString*)infilename ouputParam:(VideoEncodeSpec*)outparam;
@end

NS_ASSUME_NONNULL_END
