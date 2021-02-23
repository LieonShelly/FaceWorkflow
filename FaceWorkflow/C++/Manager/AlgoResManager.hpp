//
//  AlgoResManager.hpp
//  FaceWorkflow
//
//  Created by lieon on 2021/1/29.
//

#ifndef AlgoResManager_hpp
#define AlgoResManager_hpp
#include <string>
#include <stdio.h>
#include "ShaderManager.hpp"
#include <map>
#include "bgfx/bgfx.h"

using namespace std;

class Shader;

class AlgoResManager {
private:
    static AlgoResManager* ms_instace;
    AlgoResManager();
    AlgoResManager(const AlgoResManager & manager);
    AlgoResManager& operator =(const AlgoResManager &);
    ShaderManager *shaderManager { nullptr };
    map<string, bgfx::UniformHandle> m_uniformMap;
    
public:
    static AlgoResManager *shared();
    Shader *loadShader(string filename);
    int getViewId();
    void bgfxFrame();
    map<string, bgfx::UniformHandle> & getUniformMap();
};


#endif /* AlgoResManager_hpp */
