//
//  FFMpegs.h
//  FaceWorkflow
//
//  Created by lieon on 2021/6/22.
//

#import <Foundation/Foundation.h>
#include "WavHeader.hpp"
NS_ASSUME_NONNULL_BEGIN

@interface FFMpegs : NSObject
// PCM 转 WAV
+ (void)pcm2wav:(WavHeader*)header
        pcmfile:(NSString*)pcmFilename
        wavfile:(NSString*)wavfilename;
@end

NS_ASSUME_NONNULL_END
