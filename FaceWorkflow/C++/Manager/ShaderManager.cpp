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

ShaderManager::~ShaderManager() {
    clearAllShader();
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
    Shader *shader = shaderCache.at(filename);
    if (shader == nullptr) {
        shader = new Shader();
        bool result = shader->compileShader(shaderRootPth, filename);
        if (result) {
            shaderCache[filename] = shader;
        } else {
            delete shader;
            shader = nullptr;
        }
    }
    return shader;
}

void ShaderManager::setShaderRootPth(string pth) {
    shaderRootPth = pth;
}

void ShaderManager::removeCachedShader(string key) {
    Shader *shader = shaderCache[key];
    if(shader) {
        delete shader;
        shader = nullptr;
        shaderCache.erase(key);
    }
}

void ShaderManager::clearAllShader() {
    map<string, Shader*>::iterator iter;
    for(iter = shaderCache.begin(); iter != shaderCache.end(); iter++) {
        Shader *shader = iter->second;
        delete shader;
        shader = nullptr;
    }
    shaderCache.clear();
}
