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

typedef struct {
    float x;
    float y;
    float z;
    
    float u;
    float v;
} vertex_struct;

static vertex_struct simple_vertex_data[] =
{
    {-1.0f, 1.0f, 0.0f, 0, 0},
    {1.0f, 1.0f, 0.0f, 1, 0},
    {-1.0f, -1.0f, 0.0f, 0, 1},
    {1.0f, -1.0f, 0.0f, 1, 1},
};

static uint16_t simple_triangle_list[] =
{
    0, 2, 1,
    1, 2, 3
};

Texture::Texture() {
    
}

Texture::~Texture() {
    
}

Texture::Texture(const Texture &tex) {
    
}

Texture::Texture(Texture &input, unsigned int x, unsigned int y, unsigned int width, unsigned
                 int height) {
    
}

Texture::Texture(int width, int height, const bgfx::Memory *mem, bgfx::TextureFormat::Enum format, uint64_t _flags) {
    
}

Texture::Texture(int width, int height, bgfx::TextureFormat::Enum eFormat, uint64_t _flags) {
    
}

// PGMat 还没有引入
//    Texture(const PGMat &m,uint64_t _flags = BGFX_TEXTURE_RT| BGFX_SAMPLER_U_CLAMP | BGFX_SAMPLER_V_CLAMP);
Texture::Texture &operator = (const unsigned char value) {
    
}

//    Texture &operator = (const PGMat &m);

long Texture::getSpCount() {
    return 1;
}

unsigned long long Texture::getPtr() {
    return 1;
}
int Texture::channels() const {
    return 1;
}
int Texture::type() const {
    
}
bool Texture::empty() const {
    
}

bgfx::TextureHandle Texture::getTextureHandle() {
    
}
int Texture::getWidth() const {
    
}
int Texture::getHeight() const{
    
}
uint64_t Texture::getFlags() const {
    
}
uint32_t Texture::getAppFlags() const {
    
}
bool Texture::immutable() const {
    
}
bgfx::TextureFormat::Enum Texture::getTextureFormat() const {
    
}
bool Texture::isValid() {
    
}

#pragma mark - 接口函数
#pragma mark 填充纹理数据接口
bool Texture::create(const char *name) {
    
}

bool Texture::create(int width, int height,
            bgfx::TextureFormat::Enum eFormat = bgfx::TextureFormat::Enum::RGBA8,
                     uint64_t _flags = BGFX_TEXTURE_RT | BGFX_SAMPLER_U_CLAMP | BGFX_SAMPLER_V_CLAMP) {
    
}

bool Texture::create(int width, int height, const bgfx::Memory *mem,
            bgfx::TextureFormat::Enum eFormat = bgfx::TextureFormat::Enum::RGBA8,
                     uint64_t _flags = BGFX_TEXTURE_RT | BGFX_SAMPLER_U_CLAMP | BGFX_SAMPLER_V_CLAMP) {
    
}

bool Texture::create(int width, int height,unsigned char r,unsigned char g,unsigned char b,unsigned char a,
            bgfx::TextureFormat::Enum eFormat = bgfx::TextureFormat::Enum::RGBA8,
                     uint64_t _flags = BGFX_TEXTURE_RT | BGFX_SAMPLER_U_CLAMP | BGFX_SAMPLER_V_CLAMP) {
    
}

#pragma mark 其他接口
void Texture::release() {
    
}

Texture Texture::clone() {
    
}

void Texture::update(int dstx, int dsty, Texture &src, int srcx = 0, int srcy = 0, int width = 0, int height = 0) {
    
}

//    void update(unsigned int dstx. unsigned int dsty, PGMat &src);
void Texture::setTo(const unsigned char r, const unsigned char g, const unsigned char b, const unsigned char a) {
    
}

void Texture::setTo(int component_idx, const unsigned char value) {
    
}

//    PGMat toCpu(PGTEXTURE_CVT_PGMAT_FLAG flag = PGTEXTURE_CVT_PGMAT_FLAG::NOFLIP,bool bBlocking = true);
//
//    void operator >>(PGMat &m);
bool Texture::createFrameBuffer() {
    
}

bool Texture::createFrameBuffer(Texture &depth) {
    
}

bool Texture::releaseFrameBuffer() {
    
}

bgfx::FrameBufferHandle Texture::getFrameBufferHandle() {
    
}

void Texture::trans2gray(Texture &output) {
    
}

// 倒置
void Texture::invert(Texture &output) {
    
}

void Texture::getSingleChannel(Texture &output, int channelnum = 1) {
    
}

void Texture::gtSingelChannelInvert(Texture &output,int channelnum = 1) {
    
}

void Texture::edgeblack() {
    
}
void Texture::getTextureData(int viewId, unsigned char *data) {
    
}
