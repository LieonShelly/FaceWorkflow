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
#include "AlgoResManager.hpp"

using namespace std;

class FaceProgram {
    map<string, bgfx::UniformHandle> &uniformMap = AlgoResManager::shared()->getUniformMap();
    
public:
    FaceProgram();
    
    ~FaceProgram();
    
    void createParam(string paramName, bgfx::UniformType::Enum type);
    
    void setParam(std::string paramName, float paramValue[]);
    
    void setTexture(string paramName, bgfx::TextureHandle texureHandle, int texIndex);
};
#endif /* Program_hpp */
