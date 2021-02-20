//
//  Texture.hpp
//  FaceWorkflow
//
//  Created by lieon on 2021/1/28.
//

#ifndef Texture_hpp
#define Texture_hpp
#include <memory>
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
    bgfx::TextureHandle m_texture = BGFX_INVALID_HANDLE;
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
private:
    std::shared_ptr<Texture_> m_bgfxtTexture = nullptr;
    void setValueRun(uint64_t state_flag,uint16_t clear_color_flag,int clear_component_idx,const unsigned char r,const unsigned char g,const unsigned char b,const unsigned char a);
public:
    Texture();
    ~Texture();
    
    Texture(const Texture &tex);
    Texture(Texture &input, unsigned int x, unsigned int y, unsigned int width, unsigned
            int height);
    Texture(int width, int height, const bgfx::Memory *mem, bgfx::TextureFormat::Enum format = bgfx::TextureFormat::Enum::RGBA8, uint64_t _flags =  BGFX_TEXTURE_RT | BGFX_SAMPLER_U_CLAMP | BGFX_SAMPLER_V_CLAMP);
    Texture(int width, int height,
              bgfx::TextureFormat::Enum eFormat = bgfx::TextureFormat::Enum::RGBA8,
              uint64_t _flags =  BGFX_TEXTURE_RT | BGFX_SAMPLER_U_CLAMP | BGFX_SAMPLER_V_CLAMP);
    // PGMat 还没有引入
//    Texture(const PGMat &m,uint64_t _flags = BGFX_TEXTURE_RT| BGFX_SAMPLER_U_CLAMP | BGFX_SAMPLER_V_CLAMP);
    Texture &operator = (const unsigned char value);
    
//    Texture &operator = (const PGMat &m);
    
    long getSpCount();
    unsigned long long getPtr();
    int channels() const;
    int type() const;
    bool empty() const;
    bgfx::TextureHandle getTextureHandle();
    int getWidth() const;
    int getHeight() const;
    uint64_t getFlags() const;
    uint32_t getAppFlags() const;
    bool immutable() const;
    bgfx::TextureFormat::Enum getTextureFormat() const;
    bool isValid();
    
#pragma mark - 接口函数
#pragma mark 填充纹理数据接口
    bool create(const char *name);
    
    bool create(int width, int height,
                bgfx::TextureFormat::Enum eFormat = bgfx::TextureFormat::Enum::RGBA8,
                uint64_t _flags = BGFX_TEXTURE_RT | BGFX_SAMPLER_U_CLAMP | BGFX_SAMPLER_V_CLAMP);
    bool create(int width, int height, const bgfx::Memory *mem,
                bgfx::TextureFormat::Enum eFormat = bgfx::TextureFormat::Enum::RGBA8,
                uint64_t _flags = BGFX_TEXTURE_RT | BGFX_SAMPLER_U_CLAMP | BGFX_SAMPLER_V_CLAMP);
    bool create(int width, int height,unsigned char r,unsigned char g,unsigned char b,unsigned char a,
                bgfx::TextureFormat::Enum eFormat = bgfx::TextureFormat::Enum::RGBA8,
                uint64_t _flags = BGFX_TEXTURE_RT | BGFX_SAMPLER_U_CLAMP | BGFX_SAMPLER_V_CLAMP);
#pragma mark 其他接口
    void release();
    Texture clone();
    void update(int dstx, int dsty, Texture &src, int srcx = 0, int srcy = 0, int width = 0, int height = 0);
//    void update(unsigned int dstx. unsigned int dsty, PGMat &src);
    void setTo(const unsigned char r, const unsigned char g, const unsigned char b, const unsigned char a);
    void setTo(int component_idx, const unsigned char value);
//    PGMat toCpu(PGTEXTURE_CVT_PGMAT_FLAG flag = PGTEXTURE_CVT_PGMAT_FLAG::NOFLIP,bool bBlocking = true);
//
//    void operator >>(PGMat &m);
    bool createFrameBuffer();
    bool createFrameBuffer(Texture &depth);
    bool releaseFrameBuffer();
    bgfx::FrameBufferHandle getFrameBufferHandle();
    void trans2gray(Texture &output);
    // 倒置
    void invert(Texture &output);
    void getSingleChannel(Texture &output, int channelnum = 1);
    void gtSingelChannelInvert(Texture &output,int channelnum = 1);
    void edgeblack();
    void getTextureData(int viewId, unsigned char *data);
};

#endif /* Texture_hpp */
