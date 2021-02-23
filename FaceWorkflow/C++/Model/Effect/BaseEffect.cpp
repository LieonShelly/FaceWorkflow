//
//  BaseEffect.cpp
//  FaceWorkflow
//
//  Created by lieon on 2021/1/28.
//

#include "BaseEffect.hpp"
#include "FaceProgram.hpp"
#include "Texture.hpp"
#include "Shader.hpp"
#include "AlgoResManager.hpp"

const static char *PARAM_ORI_TEXTURE = "s_ori_texture";
BaseEffect::BaseEffect(const char *eftName) {
    m_program = new FaceProgram();
    m_shader = nullptr;
    m_program->createParam(PARAM_ORI_TEXTURE, bgfx::UniformType::Sampler);
    m_eftName = eftName;
    ms_decl
        .begin()
        .add(bgfx::Attrib::Position, 3, bgfx::AttribType::Float)
        .add(bgfx::Attrib::TexCoord0, 3, bgfx::AttribType::Float)
        .end();
    setVertexDecl(ms_decl);
    setCubeVertice();
    setCubeTriOrder();
}

BaseEffect::BaseEffect(const char *eftName, bool isLayerEffect) {
    m_eftName = eftName;
    m_isLayerEft = isLayerEffect;
    m_program = new FaceProgram();
    m_program->createParam(PARAM_ORI_TEXTURE, bgfx::UniformType::Sampler);
    ms_decl
        .begin()
        .add(bgfx::Attrib::Position, 3, bgfx::AttribType::Float)
        .add(bgfx::Attrib::TexCoord0, 3, bgfx::AttribType::Float)
        .end();
    setVertexDecl(ms_decl);
    setCubeVertice();
    setCubeTriOrder();
}

BaseEffect::~BaseEffect() {
    if (m_program == nullptr) {
        delete m_program;
        m_program = nullptr;
    }
    if (m_inputImageData != nullptr) {
        delete m_inputImageData;
        m_inputImageData = nullptr;
    }
}

// 渲染到FBO
void BaseEffect::render() {
    setAndSubmitCommonParams();
}


// 提前准备数据
void BaseEffect::prepareEffectDataInAdvanced(Texture *inputTexture) {
    
}


// 重置效果数据
void BaseEffect::resetEffectData() {
    
}


// 设置效果输入纹理
void BaseEffect::setInputTexture(Texture *texture) {
    m_inputTexture = texture;
}


// 设置效果输出纹理
void BaseEffect::setOutputTexture(Texture *texture) {
    m_outputTexture = texture;
}

void BaseEffect::setIsLayerEffect(bool isLayerEffect) {
    m_isLayerEft = isLayerEffect;
}

void BaseEffect::initAllShaderMap(std::string effectName) {
    
}

Texture *BaseEffect::getInputTexture() {
    return m_inputTexture;
}

    
Texture *BaseEffect::getOutputTexture() {
    return m_outputTexture;
}


// 设置蒙层
void BaseEffect::setMaskTexture(Texture *maskTexture) {
    m_maskTexture = maskTexture;
}


bool BaseEffect::maskTextureIsValid() {
    return false;
}


void BaseEffect::setViewRect(PGRect rect) {
    m_viewRect[0] = rect.x1;
    m_viewRect[1] = rect.y1;
    m_viewRect[2] = rect.x2;
    m_viewRect[3] = rect.y2;
}


void BaseEffect::setLayerRect(PGRect rect) {
    m_layerRect[0] = rect.x1;
    m_layerRect[1] = rect.y1;
    m_layerRect[2] = rect.x2;
    m_layerRect[3] = rect.y2;
}


void BaseEffect::setCanvasRect(PGRect rect) {
    m_canvasRect[0] = rect.x1;
    m_canvasRect[1] = rect.y1;
    m_canvasRect[2] = rect.x2;
    m_canvasRect[3] = rect.y2;
}


void BaseEffect::setLayerAngle(float angle) {
    m_angle[0] = angle;
    m_angle[1] = 0;
    m_angle[2] = 0;
    m_angle[3] = 0;
}


void BaseEffect::setLayerBlendMode(LayerBlendMode::Enum mode) {
    m_curBlendMode = mode;
}


void BaseEffect::setLayerOpacity(float opacity) {
    m_effectOpacity = opacity;
}

void BaseEffect::initCurEffectShader() {
    map<LayerBlendMode::Enum, string>::iterator iter; m_blendShaderNameMap.find(m_curBlendMode);
    if (iter != m_blendShaderNameMap.end()) {
        m_shader = AlgoResManager::shared()->loadShader(iter->second);
    } else {
        m_shader =  AlgoResManager::shared()->loadShader(m_basicEffectShaderPath);
    }
}

void BaseEffect::setAndSubmitCommonParams() {
    initCurEffectShader();
    bgfx::ViewId viewId = 1;
    m_program->setTexture(PARAM_ORI_TEXTURE, m_inputTexture->getTextureHandle(), 0);
    bgfx::setVertexBuffer(0, m_vbh);
    bgfx::setIndexBuffer(m_ibh);
    bgfx::setViewRect(viewId, 0, 0, uint16_t(m_outputTexture->getWidth()), uint16_t(m_outputTexture->getHeight()));
    m_outputTexture->createFrameBuffer();
    bgfx::setViewFrameBuffer(viewId, m_outputTexture->getFrameBufferHandle());
    bgfx::setState(BGFX_STATE_WRITE_RGB | BGFX_STATE_WRITE_A);
    bgfx::submit(viewId, m_shader->getProgram());
    m_outputTexture->releaseFrameBuffer();
}

void BaseEffect::setCubeVertice(PosColorVertex vertices[]) {
    m_RectangleVertices = vertices;
    m_vbh = bgfx::createVertexBuffer(bgfx::makeRef(vertices, sizeof(vertices)), ms_decl);
}

// 设置顶点渲染顺序
void BaseEffect::setCubeTriOrder(uint16_t order[]) {
    m_RectangleTriOrder = order;
    m_ibh = bgfx::createIndexBuffer(bgfx::makeRef(order, sizeof(order)));
}

// 设置顶点读取顺序对象描述器
void BaseEffect::setVertexDecl(bgfx::VertexLayout decl) {
    ms_decl = decl;
}

void BaseEffect::renderToFBO(const char *shaderName) {
    
}
