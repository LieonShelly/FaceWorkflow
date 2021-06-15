//
//  RenderImage.hpp
//  FaceWorkflow
//
//  Created by lieon on 2021/6/15.
//

#ifndef RenderImage_hpp
#define RenderImage_hpp
#include "bgfx/bgfx.h"
#include <stdio.h>
#include <string>

using namespace std;

typedef struct BgfxInitInfo
{
    int type; // 0:Windows 1:Linux 2:Mac 3:Android 4:iOS
    void* nativeWindowHandle; // Surface/Layer/Window
    int width;
    int height;
} BgfxInitInfo;


struct Param {
    string vsName;
    string vsFullPath;
    string fsName;
    string fsFullPath;
    string texturePath;
};

class RenderImage {
    uint32_t m_width = 0;
    uint32_t m_height = 0;
    // 通用顶点数组引用
    bgfx::VertexBufferHandle m_vbh;
    // 顶点渲染顺序对象的引用
    bgfx::IndexBufferHandle m_ibh;
    // 顶点描述对象，用于描述如何从顶点数组读取数据
    bgfx::VertexLayout ms_layout;
    bgfx::ProgramHandle m_display_program;
    bgfx::UniformHandle s_display_tex_Handle;
    bgfx::FrameBufferHandle m_fbh = BGFX_INVALID_HANDLE;
    
    bgfx::ProgramHandle m_program;
    bgfx::TextureHandle m_texture;
    bgfx::UniformHandle s_textureHandle;
    Param *m_param = nullptr;
    
public:
    RenderImage();
    ~RenderImage();
    void initPlatform(BgfxInitInfo &info);
    
    void helloworld();
    
    void setParam(Param *param);
};

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


#endif /* RenderImage_hpp */

