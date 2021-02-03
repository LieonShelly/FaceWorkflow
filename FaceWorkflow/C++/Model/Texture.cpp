//
//  Texture.cpp
//  FaceWorkflow
//
//  Created by lieon on 2021/1/28.
//

#include "Texture.hpp"

Texture_::Texture_() {
    
}

Texture_::~Texture_() {
    if (bgfx::isValid(m_frameBufferHandle)) {
        bgfx::destroy(m_frameBufferHandle);
    }
    if (bgfx::isValid(m_texure)) {
        bgfx::destroy(m_texure);
    }
}

Texture_::Texture_(int width, int height, bgfx::TextureFormat::Enum formmat, uint64_t _flags, uint32_t appFlags, const bgfx::Memory *mem) {
    if (width == 0) {
        width = 1;
    }
    if (height == 0) {
        height = 1;
    }
    m_texureWidth = width;
    m_textureHeight = height;
    m_TextureFromat = formmat;
    m_textureAppFlags = appFlags | (mem == nullptr ? PGTEXTURE_APP_FLAG_NONE : PGTEXTURE_APP_FLAG_IMMUTABLE);
    // 创建2D纹理
    m_texure = bgfx::createTexture2D(width, height, false, 1, formmat, _flags, mem);
}

Texture:: Texture() {
    
}

Texture:: ~Texture() {
    
}


bgfx::TextureHandle Texture::getTextureHandle() {
    return BGFX_INVALID_HANDLE;
}

int Texture::getWidth() const {
    return 0;
}

int Texture::getHeight() const {
    return 0;
}

bool Texture::createFrameBuffer() {
    return  false;
}

bgfx::FrameBufferHandle Texture::getFrameBufferHandle() {
    return BGFX_INVALID_HANDLE;
}

bool Texture::releaseFrameBuffer() {
    return false;
}
