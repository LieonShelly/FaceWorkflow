//
//  ShaderManager.hpp
//  FaceWorkflow
//
//  Created by lieon on 2021/1/29.
//

#ifndef ShaderManager_hpp
#define ShaderManager_hpp

#include <string>
#include <stdio.h>

using namespace std;

class Shader;

class ShaderManager {
private:
    static ShaderManager* ms_ShaderMager;
    ShaderManager();
    ShaderManager(const ShaderManager & manager);
    ShaderManager& operator =(const ShaderManager &);
  
public:
    static ShaderManager *shared();
    Shader *loadShader(string filename);
};

#endif /* ShaderManager_hpp */
