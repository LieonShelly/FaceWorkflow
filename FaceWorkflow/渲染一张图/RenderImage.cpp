//
//  RenderImage.cpp
//  FaceWorkflow
//
//  Created by lieon on 2021/6/15.
//

#include "RenderImage.hpp"
#include "BGFXUtils.h"

void RenderImage::initPlatform(BgfxInitInfo &info) {
    m_width = info.width;
    m_height = info.height;
    bgfx::PlatformData pd;
    pd.ndt      = NULL;
    pd.nwh          = (void*)info.nativeWindowHandle;
    pd.context      = NULL;
    pd.backBuffer   = NULL;
    pd.backBufferDS = NULL;
    bgfx::Init init;
    init.platformData = pd;
    init.type = bgfx::RendererType::Count;
    init.vendorId = 0;
    init.resolution.width = m_width;
    init.resolution.height = m_height;
    init.resolution.reset = 1;
    bgfx::init(init);
    bgfx::setDebug(1);
    bgfx::setViewClear(0, BGFX_CLEAR_COLOR | BGFX_CLEAR_DEPTH, 0x303030ff); //(0, BGFX_CLEAR_COLOR | BGFX_CLEAR_DEPTH, 0x303030ff, 1.0, 0);
}

void RenderImage::helloworld() {
    // 这句话的意思是位置数据里面，前三个 Float 类型是作为顶点坐标，后两个 Int16 类的值作为纹理的坐标
    ms_layout.begin()
    .add(bgfx::Attrib::Position, 3, bgfx::AttribType::Float)
    .add(bgfx::Attrib::TexCoord0, 2, bgfx::AttribType::Int16, true)
    .end();
    
    // 设置顶点缓冲区
    m_vbh = bgfx::createVertexBuffer(bgfx::makeRef(s_rectangleVertices, sizeof(s_rectangleVertices)), ms_layout);
    // 设置顶点绘制绘制顺序缓冲
    m_ibh = bgfx::createIndexBuffer(bgfx::makeRef(s_rectangleOrderList, sizeof(s_rectangleOrderList)));

    // 从shader创建program
    m_program = loadProgram(m_param->vsName.c_str(), m_param->vsFullPath.c_str(), m_param->fsName.c_str(), m_param->fsFullPath.c_str());
    // shader的uniform
    s_textureHandle = bgfx::createUniform("s_texColor", bgfx::UniformType::Sampler);
    // 创建纹理
    m_texture = loadTexture(m_param->texturePath.c_str());
    
    // 创建显示的 program
    m_display_program = loadProgram(m_param->vsName.c_str(), m_param->vsFullPath.c_str(), m_param->fsName.c_str(), m_param->fsFullPath.c_str());
    
    // 显示 program 中待传入的纹理
    s_display_tex_Handle = bgfx::createUniform("display_texColor", bgfx::UniformType::Sampler);

    // 创建FBO
    bgfx::FrameBufferHandle m_fbh = BGFX_INVALID_HANDLE;
    if (!bgfx::isValid(m_fbh)) {
        m_fbh = bgfx::createFrameBuffer(uint16_t(m_width), uint16_t(m_height), bgfx::TextureFormat::RGBA8);
    }
    // 渲染FBO
    // 设置渲染窗口大小
    bgfx::setViewRect(0, 0, 0, uint16_t(m_width), uint16_t(m_height));
    // 绑定 FBO 到 View_Id 为0的这个 View 上，开始渲染，渲染开始是 submit 方法调用后。
    bgfx::setViewFrameBuffer(0, m_fbh);
    bgfx::setState(BGFX_STATE_WRITE_RGB|BGFX_STATE_WRITE_A);
    // 设置 FBO 需要的输入纹理
    bgfx::setTexture(0, s_textureHandle, m_texture);
    bgfx::submit(0, m_program);


    // 渲染FBO结果到屏幕
    // 渲染到屏幕的view需要祖东将将view的FBo设置invalid，然后从FBO中拿出
    // 渲染到屏幕的 view 需要主动将该 view 的 FBO 设置为 invalid，然后从 FBO 中拿出 attach 的纹理，设置到这次渲染需要的输入参数中,然后显示
    bgfx::setVertexBuffer(0, m_vbh);
    bgfx::setIndexBuffer(m_ibh);
    bgfx::setViewRect(1, 0, 0, uint16_t(m_width), uint16_t(m_height) );
    bgfx::setViewFrameBuffer(1, BGFX_INVALID_HANDLE);
    bgfx::setState(BGFX_STATE_WRITE_RGB|BGFX_STATE_WRITE_A);
    bgfx::setTexture(1, s_display_tex_Handle, bgfx::getTexture(m_fbh));
    bgfx::submit(1, m_display_program);
    // 显示到屏幕
    bgfx::frame();
}

void RenderImage::setParam(Param *param) {
    this->m_param = param;
}


RenderImage::RenderImage() {
 
    
}
