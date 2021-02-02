//
//  Shader.hpp
//  FaceWorkflow
//
//  Created by lieon on 2021/1/28.
//

#ifndef Shader_hpp
#define Shader_hpp
#include <bgfx/bgfx.h>
#include <stdio.h>
#include <string>

using namespace std;

class Shader {
    bgfx::ProgramHandle m_program;
    string shaderFileRootPth;
    string shaderName;
    
    bool destoryProgram();
    
public:
    Shader();
    Shader(string shaderPth, string name);
    ~Shader();
    
    bgfx::ProgramHandle getProgram();
    
    bool compileShader(string shaderPth, string name);
    
    bool compileSahderData(unsigned char *vsShader, uint32_t vsDataSize, unsigned char *fsShaderData, uint32_t fsDataSize);
};

#endif /* Shader_hpp */
