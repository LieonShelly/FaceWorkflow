//
//  FaceProgram.hpp
//  FaceWorkflow
//
//  Created by lieon on 2021/1/28.
//

#ifndef Program_hpp
#define Program_hpp
#include <string>
#include <map>
#include <bgfx/bgfx.h>
#include <stdio.h>

using namespace std;

class FaceProgram {
public:
    FaceProgram();
    
    ~FaceProgram();
    
    void createProgram(string paramName, bgfx::UniformType::Enum type);
    
    void setTexture(string paramName, bgfx::TextureHandle texureHandle, int texIndex);
};
#endif /* Program_hpp */
