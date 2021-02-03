//
//  Texture.hpp
//  FaceWorkflow
//
//  Created by lieon on 2021/1/28.
//

#ifndef Texture_hpp
#define Texture_hpp

#include <stdio.h>
#include <bgfx/bgfx.h>

#define PGTEXTURE_APP_FLAG_NONE         (0x00000000)
#define PGTEXTURE_APP_FLAG_IMMUTABLE    (0x00000001)
typedef enum{
    AUTO,
    FLIP,
    NOFLIP
}PGTEXTURE_CVT_PGMAT_FLAG;

class Texture_ {
public:
    bgfx::TextureHandle m_texure = BGFX_INVALID_HANDLE;
    bgfx::FrameBufferHandle m_frameBufferHandle = BGFX_INVALID_HANDLE;
    int m_texureWidth = 0, m_textureHeight = 0;
    bgfx::TextureFormat::Enum m_TextureFromat =  bgfx::TextureFormat::RGBA8;
    uint64_t m_textureFlags = BGFX_SAMPLER_NONE;
    uint32_t m_textureAppFlags = PGTEXTURE_APP_FLAG_NONE;
    
public:
    Texture_();
    ~Texture_();
    Texture_(int width, int height, bgfx::TextureFormat::Enum formmat, uint64_t _flags, uint32_t appFlags = PGTEXTURE_APP_FLAG_NONE, const bgfx::Memory *mem = nullptr);
};

class Texture {
public:
    Texture();
    ~Texture();
    
    bgfx::TextureHandle getTextureHandle();
    
    int getWidth() const;
    int getHeight() const;
    bool createFrameBuffer();
    bgfx::FrameBufferHandle getFrameBufferHandle();
    bool releaseFrameBuffer();
};

#endif /* Texture_hpp */
