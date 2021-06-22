//
//  FFMpegs.hpp
//  FaceWorkflow
//
//  Created by lieon on 2021/6/22.
//

#ifndef FFMpegs_hpp
#define FFMpegs_hpp

#include "WavHeader.hpp"
#include <stdio.h>

class FFMpegs {

public:
    FFMpegs() {};
    
    static void pcm2wav(WavHeader &header, const char *pcmFilename, const char *wavfilename);
};

#endif /* FFMpegs_hpp */
