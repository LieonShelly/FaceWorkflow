//
//  BGFXUtils.cpp
//  EditSDK
//
//  Created by lieon on 2020/7/21.
//  仿写bgfx_utils

#include "BGFXUtils.h"
#include "PgEntry.hpp"
#include "dbg.h"

void* load(bx::FileReaderI* _reader, bx::AllocatorI* _allocator, const char* _filePath, uint32_t* _size)
{
    if (bx::open(_reader, _filePath) )
    {
        uint32_t size = (uint32_t)bx::getSize(_reader);
        void* data = BX_ALLOC(_allocator, size);
        bx::read(_reader, data, size);
        bx::close(_reader);
        if (NULL != _size)
        {
            *_size = size;
        }
        return data;
    }
    else
    {
        DBG("Failed to open: %s.", _filePath);
    }

    if (NULL != _size)
    {
        *_size = 0;
    }

    return NULL;
}

void unload(void* _ptr)
{
    BX_FREE(entry::getAllocator(), _ptr);
}

static const bgfx::Memory* loadMem(bx::FileReaderI* _reader, const char* _filePath) {
    if (bx::open(_reader, _filePath)) {
        uint32_t size = (uint32_t)bx::getSize(_reader);
        const bgfx::Memory *mem = bgfx::alloc(size + 1);
        bx::read(_reader, mem->data, size);
        bx::close(_reader);
        mem->data[mem->size-1] = '\0';
        return mem;
    }
    return NULL;
}

static bgfx::ShaderHandle loadShader(bx::FileReaderI* _reader, const char* _name, const char* shaderFullPath) {
    bgfx::ShaderHandle handle = bgfx::createShader(loadMem(_reader, shaderFullPath));
    bgfx::setName(handle, _name);
    return handle;
}


bgfx::ShaderHandle loadShader(const char* _name, const char* shaderFullPath) {
    return loadShader(entry::getFileReader(), _name, shaderFullPath);
}

bgfx::ProgramHandle loadProgram(bx::FileReaderI* _reader, const char* _vsName, const char * vsFullPath, const char* _fsName, const char* fsFullPath) {
    bgfx::ShaderHandle vsh = loadShader(_reader, _vsName, vsFullPath);
    bgfx::ShaderHandle fsh = BGFX_INVALID_HANDLE;
    if (NULL != _fsName) {
        fsh = loadShader(_reader, _fsName, fsFullPath);
    }
    return bgfx::createProgram(vsh, fsh);
}

bgfx::ProgramHandle loadProgram(const char* _vsName, const char * vsFullPath, const char * _fsName, const char * fsFullPath) {
    return loadProgram(entry::getFileReader(), _vsName, vsFullPath, _fsName, fsFullPath);
}


static void imageReleaseCb(void* _ptr, void* _userData) {
    BX_UNUSED(_ptr);
    bimg::ImageContainer* imageContainer = (bimg::ImageContainer*)_userData;
    bimg::imageFree(imageContainer);
}

bgfx::TextureHandle loadTexture(bx::FileReaderI* _reader, const char* _filePath, uint64_t _flags, uint8_t _skip, bgfx::TextureInfo* _info, bimg::Orientation::Enum* _orientation)
{
    BX_UNUSED(_skip);
    bgfx::TextureHandle handle = BGFX_INVALID_HANDLE;

    uint32_t size;
    void* data = load(_reader, entry::getAllocator(), _filePath, &size);
    if (NULL != data)
    {
        bimg::ImageContainer* imageContainer = bimg::imageParse(entry::getAllocator(), data, size);

        if (NULL != imageContainer)
        {
            if (NULL != _orientation)
            {
                *_orientation = imageContainer->m_orientation;
            }

            const bgfx::Memory* mem = bgfx::makeRef(
                      imageContainer->m_data
                    , imageContainer->m_size
                    , imageReleaseCb
                    , imageContainer
                    );
            unload(data);

            if (imageContainer->m_cubeMap)
            {
                handle = bgfx::createTextureCube(
                      uint16_t(imageContainer->m_width)
                    , 1 < imageContainer->m_numMips
                    , imageContainer->m_numLayers
                    , bgfx::TextureFormat::Enum(imageContainer->m_format)
                    , _flags
                    , mem
                    );
            }
            else if (1 < imageContainer->m_depth)
            {
                handle = bgfx::createTexture3D(
                      uint16_t(imageContainer->m_width)
                    , uint16_t(imageContainer->m_height)
                    , uint16_t(imageContainer->m_depth)
                    , 1 < imageContainer->m_numMips
                    , bgfx::TextureFormat::Enum(imageContainer->m_format)
                    , _flags
                    , mem
                    );
            }
            else if (bgfx::isTextureValid(0, false, imageContainer->m_numLayers, bgfx::TextureFormat::Enum(imageContainer->m_format), _flags) )
            {
                handle = bgfx::createTexture2D(
                      uint16_t(imageContainer->m_width)
                    , uint16_t(imageContainer->m_height)
                    , 1 < imageContainer->m_numMips
                    , imageContainer->m_numLayers
                    , bgfx::TextureFormat::Enum(imageContainer->m_format)
                    , _flags
                    , mem
                    );
            }

            if (bgfx::isValid(handle) )
            {
                bgfx::setName(handle, _filePath);
            }

            if (NULL != _info)
            {
                bgfx::calcTextureSize(
                      *_info
                    , uint16_t(imageContainer->m_width)
                    , uint16_t(imageContainer->m_height)
                    , uint16_t(imageContainer->m_depth)
                    , imageContainer->m_cubeMap
                    , 1 < imageContainer->m_numMips
                    , imageContainer->m_numLayers
                    , bgfx::TextureFormat::Enum(imageContainer->m_format)
                    );
            }
        }
    }

    return handle;
}

bgfx::TextureHandle loadTexture(const char* _name, uint64_t _flags, uint8_t _skip, bgfx::TextureInfo* _info, bimg::Orientation::Enum* _orientation)
{
    return loadTexture(entry::getFileReader(), _name, _flags, _skip, _info, _orientation);
}


std::tuple<const bgfx::Memory *, TextureFormat::Enum> loadTexture(const char *_filePath,
                                                                 uint8_t _skip,
                                                                 bgfx::TextureInfo *_info,
                                                                 bimg::Orientation::Enum *_orientation) {
    bx::FileReaderI *_reader = entry::getFileReader();
    
    BX_UNUSED(_skip);
    
    uint32_t size;
    void *data = load(_reader, entry::getAllocator(), _filePath, &size);
    
    if (NULL != data)
    {
        bimg::ImageContainer *imageContainer = bimg::imageParse(entry::getAllocator(), data, size);
        
        // 如果是BGFX支持的图片格式(譬如jpg、png等等)，可以创建出bimg::ImageContainer对象
        if (NULL != imageContainer)
        {
            unload(data);
            if (NULL != _orientation)
            {
                *_orientation = imageContainer->m_orientation;
            }
            
            const bgfx::Memory *mem = bgfx::makeRef(imageContainer->m_data, imageContainer->m_size, imageReleaseCb, imageContainer);

            if (NULL != _info)
            {
                bgfx::calcTextureSize(*_info, uint16_t(imageContainer->m_width),
                                      uint16_t(imageContainer->m_height), uint16_t(imageContainer->m_depth),
                                      imageContainer->m_cubeMap, 1 < imageContainer->m_numMips,
                                      imageContainer->m_numLayers,
                                      bgfx::TextureFormat::Enum(imageContainer->m_format));
            }
            return std::make_tuple(mem, TextureFormat::BGFXSupported);
        }
        // 如果无法创建出bimg::ImageContainer对象，那么考虑可能是webp数据，尝试使用libWebp解析，看能否解析出来。
        /* else if (WebPGetInfo((const uint8_t *)data, (size_t)size, NULL, NULL))
        {
            WebPDecoderConfig * config = new WebPDecoderConfig();
            if (!WebPInitDecoderConfig(config))
            {
                WebPFreeDecBuffer(&(config->output));
                delete config;
                return std::make_tuple(nullptr, emTextureMemFormatWebp);
            }
            config->options.no_fancy_upsampling = 1;
            config->options.bypass_filtering = 1;
            config->options.use_threads = 1;
            // 如果这里指定了输出的色彩空间，那么libwebp会解析为指定的色彩空间
            // 如果没有指定，那么就会按文件本身的色彩空间来。
            config->output.colorspace = MODE_RGBA;
            VP8StatusCode code = WebPDecode((const uint8_t *)data, size, config);
            unload(data);
            if (code == VP8_STATUS_OK)
            {
                _info->width = config->output.width;
                _info->height = config->output.height;
                _info->format = bgfx::TextureFormat::RGBA8;
                _info->storageSize = (uint32_t)config->output.u.RGBA.size;
                const bgfx::Memory *mem = bgfx::makeRef(config->output.u.RGBA.rgba,
                                                        (uint32_t)config->output.u.RGBA.size, imageReleaseWebp, config);
                if (NULL != mem)
                {
                    return std::make_tuple(mem, emTextureMemFormatWebp);
                }
                else
                {
                    WebPFreeDecBuffer(&(config->output));
                    delete config;
                }
            }
            else
            {
                WebPFreeDecBuffer(&(config->output));
                delete config;
            }
        }*/
    }
    
    return std::make_tuple(nullptr, TextureFormat::Unknowm);
}
