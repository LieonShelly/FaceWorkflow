//
//  AlgoResManager.cpp
//  FaceWorkflow
//
//  Created by lieon on 2021/1/29.
//

#include "AlgoResManager.hpp"
#include "Shader.hpp"

AlgoResManager* AlgoResManager::ms_instace = nullptr;

AlgoResManager::AlgoResManager() {
    shaderManager = ShaderManager::shared();
}

AlgoResManager::AlgoResManager(const AlgoResManager & manager) { }

AlgoResManager& AlgoResManager::operator =(const AlgoResManager &) {
    return *ms_instace;
}

AlgoResManager *AlgoResManager::shared() {
    if (ms_instace == nullptr) {
        ms_instace = new AlgoResManager();
    }
    return ms_instace;
}

Shader *AlgoResManager::loadShader(string filename) {
    return shaderManager->loadShader(filename);
}

int AlgoResManager::getViewId() {
    return 1;
}


void AlgoResManager::bgfxFrame() {
    bgfx::frame();
}
