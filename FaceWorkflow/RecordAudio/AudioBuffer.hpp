//
//  AudioBuffer.hpp
//  FaceWorkflow
//
//  Created by lieon on 2021/6/20.
//

#ifndef AudioBuffer_hpp
#define AudioBuffer_hpp

#include <stdio.h>
#include <iostream>
#include "SDL.h"

struct AudioBuffer {
public:
    int len = 0;
    // 每次往音频缓冲区的大小
    int pullLen = 0;
    Uint8 *data = nullptr;
    
    AudioBuffer() {}
};

#endif /* AudioBuffer_hpp */
