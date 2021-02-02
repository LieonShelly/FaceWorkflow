//
//  Shader.cpp
//  FaceWorkflow
//
//  Created by lieon on 2021/1/28.
//

#include "Shader.hpp"

Shader::Shader() {
    
}

Shader:: ~Shader() {
    
}

bgfx::ProgramHandle Shader::getProgram() {
    return m_program;
}

void Shader::generateIntactShdaerFilePth() {
    
}

bgfx::ShaderHandle Shader:: generateShaderHandle(string shaderFilePath, bool &generateSuccess) {
    return BGFX_INVALID_HANDLE;
}

bool Shader::compileShader() {
    return false;
}

bool Shader::destoryProgram() {
    return false;
}

void Shader::cleanShaderInfo() {
    
}

bool Shader::compileShader(string shaderPth, string name) {
    return false;
}

bool Shader::compileSahderData(unsigned char *vsShader, uint32_t vsDataSize, unsigned char *fsShaderData, uint32_t fsDataSize) {
    return false;
}
