//
//  RawVideoFrame.hpp
//  FaceWorkflow
//
//  Created by lieon on 2021/7/16.
//

#ifndef RawVideoFrame_hpp
#define RawVideoFrame_hpp

#include <stdio.h>
extern "C" {
#include <libavutil/avutil.h>
}

struct RawVideoFrame {
    char *pixels = nullptr;
    int width = 0;
    int height = 0;
    AVPixelFormat format;
    int frameSize = 0;
};

#endif /* RawVideoFrame_hpp */
