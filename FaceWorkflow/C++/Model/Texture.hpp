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
