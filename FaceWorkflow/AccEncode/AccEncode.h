//
//  AccEncode.h
//  FaceWorkflow
//
//  Created by lieon on 2021/7/1.
//

#import <Foundation/Foundation.h>
extern "C" {
#include <libavformat/avformat.h>
}


NS_ASSUME_NONNULL_BEGIN

typedef struct {
    const char *filename;
    int sampleRate;
    AVSampleFormat sampleFmt;
    int chLayout;
} AudioEncodeSpec;

@interface AccEncode : NSObject


+ (void)aacEncodeWithSpec:(AudioEncodeSpec*)input outfile: (NSString*)outfile;
@end

NS_ASSUME_NONNULL_END
