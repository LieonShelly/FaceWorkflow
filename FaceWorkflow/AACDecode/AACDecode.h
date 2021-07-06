//
//  AACDecode.h
//  FaceWorkflow
//
//  Created by lieon on 2021/7/6.
//

#import <Foundation/Foundation.h>
extern "C" {
#include <libavformat/avformat.h>
}

typedef struct {
    const char *filename;
    int sampleRate;
    AVSampleFormat sampleFmt;
    int chLayout;
} AudioDecodeSpec;

NS_ASSUME_NONNULL_BEGIN

@interface AACDecode : NSObject

+ (void)aacDecode:(NSString*)filename output:(AudioDecodeSpec*)output;
@end

NS_ASSUME_NONNULL_END
