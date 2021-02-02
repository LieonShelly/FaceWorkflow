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
#include <map>

using namespace std;

class Shader;

class ShaderManager {
    map<string, Shader*> shaderCache;
    string shaderRootPth;
    
private:
    static ShaderManager* ms_ShaderMager;
    ShaderManager();
    ~ShaderManager();
    ShaderManager(const ShaderManager & manager);
    ShaderManager& operator =(const ShaderManager &);
  
   
    
public:
    static ShaderManager *shared();
    Shader *loadShader(string filename);
    void setShaderRootPth(string pth);
    void removeCachedShader(string key);
    void clearAllShader();
};

#endif /* ShaderManager_hpp */
