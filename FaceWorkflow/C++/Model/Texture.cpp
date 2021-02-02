//
//  Texture.cpp
//  FaceWorkflow
//
//  Created by lieon on 2021/1/28.
//

#include "Texture.hpp"

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
