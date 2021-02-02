//
//  AbsEffect.hpp
//  FaceWorkflow
//
//  Created by lieon on 2021/1/28.
//

#ifndef AbsEffect_hpp
#define AbsEffect_hpp
#include <bgfx/bgfx.h>
#include <stdio.h>

/**
 * 顶点描述对象
 */
struct PosColorVertex {
    float m_x;// 顶点x坐标
    float m_y; // 顶点y坐标
    float m_z; // 顶点z坐标
    float m_u; // 纹理U坐标
    float m_v; // 纹理V坐标
};


/**
 * 顶点数据
 */
static PosColorVertex s_rectangleVertices[] =
{
#if (defined __ANDROID__) || (defined __linux__)
    {-1.0f, 1.0f, 0.0f, 0.0f, 1.0f},
    {1.0f, 1.0f, 0.0f, 1.0f, 1.0f},
    {-1.0f, -1.0f, 0.0f, 0.0f, 0.0f},
    {1.0f, -1.0f, 0.0f, 1.0f, 0.0f},
#else
    {-1.0f, 1.0f,  0.0f, 0.0f,      0.0f},
    {1.0f,  1.0f,  0.0f, 1.0f, 0.0f},
    {-1.0f, -1.0f, 0.0f, 0.0f,      1.0f},
    {1.0f,  -1.0f, 0.0f, 1.0f, 1.0f},
#endif
};

/**
 * android 顶点渲染数据
 */
static PosColorVertex s_rectangleVertices_adr_render[] =
{
    {-1.0f, 1.0f,  0.0f, 0.0f, 0.0f},
    {1.0f,  1.0f,  0.0f, 1.0f, 0.0f},
    {-1.0f, -1.0f, 0.0f, 0.0f, 1.0f},
    {1.0f,  -1.0f, 0.0f, 1.0f, 1.0f},
};

/**
 * 顶点渲染顺序
 */
static uint16_t s_rectangleOrderList[] =
{
    0, 2, 1,
    1, 2, 3,
};


class AbsEffect {
protected:
    const char *m_eftName { nullptr };
    // 顶点数组
    bgfx::VertexBufferHandle m_vbh;
    bgfx::VertexBufferHandle m_vbhScale;
    // 顶点渲染顺序
    bgfx::IndexBufferHandle m_ibh;
    // 顶点描述对象
    bgfx::VertexLayout ms_decl;
    PosColorVertex *m_RectangleVertices {nullptr};
    uint16_t *m_RectangleTriOrder {nullptr};
    
public:
    AbsEffect(const char *eftName = (const char*)"undefine");
    
    virtual ~AbsEffect();
    
    // 设置顶点数组对象数组
    virtual void setCubeVertice(PosColorVertex vertices[] = s_rectangleVertices) = 0;
    
    // 设置顶点渲染顺序
    virtual void setCubeTriOrder(uint16_t order[] = s_rectangleOrderList) = 0;
    
    // 设置顶点读取顺序对象描述器
    virtual void setVertexDecl(bgfx::VertexLayout decl) = 0;
};

#endif /* AbsEffect_hpp */
