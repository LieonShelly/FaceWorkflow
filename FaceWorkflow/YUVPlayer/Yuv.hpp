//
//  Yuv.hpp
//  FaceWorkflow
//
//  Created by lieon on 2021/7/15.
//

#ifndef Yuv_hpp
#define Yuv_hpp

#include <stdio.h>

extern "C" {
#include <libavutil/avutil.h>
}

struct Yuv {
    const char *filename;
    int width = 0;
    int height = 0;
    AVPixelFormat pixelFomat;
    int fps = 24;
};

#endif /* Yuv_hpp */
