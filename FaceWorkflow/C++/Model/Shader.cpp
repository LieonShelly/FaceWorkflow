//
//  Shader.cpp
//  FaceWorkflow
//
//  Created by lieon on 2021/1/28.
//

#include "Shader.hpp"
#include "BGFXUtils.h"

Shader::Shader() {
    
}

Shader:: ~Shader() {
    destoryProgram();
}

bgfx::ProgramHandle Shader::getProgram() {
    return m_program;
}


bool Shader::destoryProgram() {
    if (bgfx::isValid(m_program)) {
        bgfx::destroy(m_program);
        return true;
    }
    return false;
}

bool Shader::compileShader(string shaderPth, string name) {
    string vsname = name + "_vs";
    string fsname = name + "_fs";
    string vShaderFullPth = shaderPth + name + ".vs";
    string fsShaderFullPth = shaderPth + name + ".fs";
    shaderFileRootPth = shaderPth;
    shaderName = name;
    m_program = loadProgram(vsname.c_str(), vShaderFullPth.c_str(), fsname.c_str(), fsShaderFullPth.c_str());
    return bgfx::isValid(m_program);
}

bool Shader::compileSahderData(unsigned char *vsShader, uint32_t vsDataSize, unsigned char *fsShaderData, uint32_t fsDataSize) {
    const bgfx::Memory *vsMem = bgfx::makeRef(vsShader, vsDataSize);
    const bgfx::Memory *fsMem = bgfx::makeRef(fsShaderData, fsDataSize);
    bgfx::ShaderHandle vsHandle = bgfx::createShader(vsMem);
    bgfx::ShaderHandle fsHandle = bgfx::createShader(fsMem);
    m_program = bgfx::createProgram(vsHandle, fsHandle);
    return bgfx::isValid(m_program);
}
