//
//  ResampleAudioSpec.hpp
//  FaceWorkflow
//
//  Created by lieon on 2021/6/26.
//

#ifndef ResampleAudioSpec_hpp
#define ResampleAudioSpec_hpp

#include <stdio.h>
extern "C" {
#include <libavformat/avformat.h>
}

struct ResampleAudioSpec {
    const char *filename;
    int sampleRate;
    AVSampleFormat sampleFmt;
    int chLayout;
};

#endif /* ResampleAudioSpec_hpp */
