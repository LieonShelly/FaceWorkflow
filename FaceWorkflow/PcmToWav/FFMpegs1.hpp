//
//  FFMpegs.hpp
//  FaceWorkflow
//
//  Created by lieon on 2021/6/22.
//

#ifndef FFMpegs1_hpp
#define FFMpegs1_hpp

#include "WavHeader.hpp"
#include <stdio.h>
#include <iostream>

class FFMpegs1 {

public:
    FFMpegs1() { };
    
    static void pcm2wav(WavHeader &header, const char *pcmFilename, const char *wavfilename);
    
    void free(const int &input) { }
};

#endif /* FFMpegs_hpp */
