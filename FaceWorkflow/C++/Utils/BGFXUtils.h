//
//  BGFXUtils.hpp
//  EditSDK
//
//  Created by lieon on 2020/7/21.
//

#ifndef BGFXUtils_hpp
#define BGFXUtils_hpp
#include <stdio.h>
#include "bgfx/bgfx.h"
#include "bx/readerwriter.h"
#include "bimg/bimg.h"
#include "bimg/decode.h"
#include <tuple>

struct TextureFormat {
    enum Enum {
        Unknowm = 0,
        BGFXSupported,
        Webp
    };
};

bgfx::ShaderHandle loadShader(const char* _name, const char* shaderFullPath);

bgfx::ProgramHandle loadProgram(const char* _vsName, const char * vsFullPath, const char * _fsName, const char * fsFullPath);

bgfx::TextureHandle loadTexture(const char* _name, uint64_t _flags = BGFX_TEXTURE_NONE|BGFX_SAMPLER_NONE, uint8_t _skip = 0, bgfx::TextureInfo* _info = NULL, bimg::Orientation::Enum* _orientation = NULL);

std::tuple<const bgfx::Memory *, TextureFormat::Enum> loadTexture(const char *_filePath,
                                                                 uint8_t _skip,
                                                                 bgfx::TextureInfo *_info,
                                                                  bimg::Orientation::Enum *_orientation);

#endif /* BGFXUtils_hpp */
