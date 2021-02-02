//
//  ShaderManager.cpp
//  FaceWorkflow
//
//  Created by lieon on 2021/1/29.
//

#include "ShaderManager.hpp"
#include "Shader.hpp"

ShaderManager* ShaderManager::ms_ShaderMager = nullptr;

ShaderManager::ShaderManager() {
    
}
ShaderManager::ShaderManager(const ShaderManager & manager) {
    
}

ShaderManager& ShaderManager::operator =(const ShaderManager &) {
    return *ms_ShaderMager;
}

ShaderManager *ShaderManager::shared() {
    if (ms_ShaderMager == nullptr) {
        ms_ShaderMager = new ShaderManager();
    }
    return ms_ShaderMager;
}

Shader * ShaderManager::loadShader(string filename) {
    return nullptr;
}
