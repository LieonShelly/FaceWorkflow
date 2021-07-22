//
//  Demux.h
//  FaceWorkflow
//
//  Created by lieon on 2021/7/22.
//

#import <Foundation/Foundation.h>
#import "VideoDecodeSpec.h"
#import "AudioDecodeSpec.h"

NS_ASSUME_NONNULL_BEGIN

@interface Demux : NSObject

- (void)demux:(NSString*)infileName outAudioParam:(AudioDecodeSpec*)aOut outVideooParam:(VideoDecodeSpec*)vOut;
@end

NS_ASSUME_NONNULL_END
