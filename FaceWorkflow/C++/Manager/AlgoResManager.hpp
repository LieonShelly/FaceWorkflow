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

using namespace std;

class Shader;

class AlgoResManager {
private:
    static AlgoResManager* ms_instace;
    AlgoResManager();
    AlgoResManager(const AlgoResManager & manager);
    AlgoResManager& operator =(const AlgoResManager &);
    ShaderManager *shaderManager { nullptr };
    
public:
    static AlgoResManager *shared();
    Shader *loadShader(string filename);
};


#endif /* AlgoResManager_hpp */
