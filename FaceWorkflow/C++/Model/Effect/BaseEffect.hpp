//
//  BaseEffect.hpp
//  FaceWorkflow
//
//  Created by lieon on 2021/1/28.
//

#ifndef BaseEffect_hpp
#define BaseEffect_hpp
#include "AbsEffect.hpp"
#include <stdio.h>
#include <map>
#include <string>
#include <iostream>
#include "BlendMode.hpp"
#include "CommonDefine.hpp"

class Shader;
class Texture;
class FaceProgram;

using namespace std;

class BaseEffect: public AbsEffect {
protected:
    unsigned char* m_inputImageData { nullptr };
    Texture *m_inputTexture { nullptr };
    Texture *m_outputTexture { nullptr };
    Texture *m_maskTexture { nullptr };
    FaceProgram * m_program { nullptr };
    
    float m_viewRect[4];
    float m_layerRect[4];
    float m_canvasRect[4];
    float m_angle[4] = { 0.0, 0.0, 0.5, 0.0 };
    float m_effectOpacity = 0.0;
    Shader *m_shader { nullptr };
    
    map<LayerBlendMode::Enum, string>m_blendShaderNameMap;
    LayerBlendMode::Enum m_curBlendMode;
    bool m_isLayerEft = true;
    bool m_isNotBasePath = false;
    string m_basicEffectShaderPath = "";
    
public:
    BaseEffect(const char *eftName = (const char *) "undefine");

    BaseEffect(const char *eftName, bool isLayerEffect);
    
    virtual ~BaseEffect();
    
    virtual void setIsLayerEffect(bool isLayerEffect);
    
    // 渲染到FBO
    virtual void render();
    
    // 提前准备数据
    virtual void prepareEffectDataInAdvanced(Texture *inputTexture);
    
    // 重置效果数据
    virtual void resetEffectData();
    
    // 渲染到屏幕
    void renderToScreen();
    
    // 设置效果输入纹理
    virtual void setInputTexture(Texture *texture);
    
    // 设置效果输出纹理
    virtual void setOutputTexture(Texture *texture);
    
    Texture *getInputTexture();
        
    Texture *getOutputTexture();
    
    // 设置蒙层
    virtual void setMaskTexture(Texture *maskTexture);
    
    virtual bool maskTextureIsValid();
    
    virtual void setViewRect(PGRect rect);
    
    virtual void setLayerRect(PGRect rect);
    
    virtual void setCanvasRect(PGRect rect);
    
    virtual void setLayerAngle(float angle);
    
    virtual void setLayerBlendMode(LayerBlendMode::Enum mode);
    
    virtual void setLayerOpacity(float opacity);
    
    void initAllShaderMap(std::string effectName);
    
    virtual void setAndSubmitCommonParams();
protected:
    // 设置顶点数组对象数组
    virtual void setCubeVertice(PosColorVertex vertices[] = s_rectangleVertices);
    
    // 设置顶点渲染顺序
    virtual void setCubeTriOrder(uint16_t order[] = s_rectangleOrderList);
    
    // 设置顶点读取顺序对象描述器
    virtual void setVertexDecl(bgfx::VertexLayout decl);
    
    void initCurEffectShader();
    
    void renderToFBO(const char *shaderName);
    
};
#endif /* BaseEffect_hpp */
