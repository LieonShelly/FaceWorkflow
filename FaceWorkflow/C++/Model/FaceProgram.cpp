//
//  Program.cpp
//  FaceWorkflow
//
//  Created by lieon on 2021/1/28.
//

#include "FaceProgram.hpp"


using namespace std;

FaceProgram:: FaceProgram() {
    
}

FaceProgram:: ~FaceProgram() {
    
}

void FaceProgram::createParam(string paramName, bgfx::UniformType::Enum type) {
    if (uniformMap.count(paramName) == 0) {
        uniformMap[paramName] = bgfx::createUniform(paramName.c_str(), type);
    }
}

void FaceProgram::setParam(std::string paramName, float paramValue[]) {
    bgfx::setUniform(uniformMap[paramName], paramValue);
}

void FaceProgram::setTexture(string paramName, bgfx::TextureHandle texureHandle, int texIndex) {
    bgfx::setTexture(texIndex, uniformMap[paramName], texureHandle);
}
