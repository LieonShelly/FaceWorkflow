//
//  Texture.cpp
//  FaceWorkflow
//
//  Created by lieon on 2021/1/28.
//

#include "Texture.hpp"
#include "AlgoResManager.hpp"
#include "BGFXUtils.h"
#include "BaseEffect.hpp"
#include "AlgoResManager.hpp"
#include "FaceProgram.hpp"
#include "Shader.hpp"

Texture_::Texture_() {
    
}

Texture_::~Texture_() {
    if (bgfx::isValid(m_frameBufferHandle)) {
        bgfx::destroy(m_frameBufferHandle);
    }
    if (bgfx::isValid(m_texture)) {
        bgfx::destroy(m_texture);
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
    m_texture = bgfx::createTexture2D(width, height, false, 1, formmat, _flags, mem);
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
    if (input.empty()) {
        return;
    }
    if (width == 0) width = 1;
    if (height == 0) height = 1;
    auto ex = x + width;
    auto ey = y + height;
    if (ex > input.m_bgfxtTexture->m_texureWidth || ey > m_bgfxtTexture->m_textureHeight || width == 0 || height == 0) {
        return;
    }
    AlgoResManager *manager = AlgoResManager::shared();
    if (BGFX_CAPS_TEXTURE_BLIT == (bgfx::getCaps()->supported & BGFX_CAPS_TEXTURE_BLIT)) {
        m_bgfxtTexture = std::make_shared<Texture_>(width, height, input.getTextureFormat(), input.getFlags() | BGFX_TEXTURE_BLIT_DST);
        auto viewid = manager->getViewId();
        bgfx::blit(viewid, m_bgfxtTexture->m_texture, 0, 0, input.m_bgfxtTexture->m_texture, x, y, width, height);
    } else {
        m_bgfxtTexture = std::make_shared<Texture_>(width, height, input.getTextureFormat(), input.getFlags() | BGFX_TEXTURE_RT);
        update(0, 0, input, x, y, width, height);
    }
}

Texture::Texture(int width, int height, const bgfx::Memory *mem, bgfx::TextureFormat::Enum format, uint64_t _flags) {
    create(width, width, mem, format, _flags);
}

Texture::Texture(int width, int height, bgfx::TextureFormat::Enum eFormat, uint64_t _flags) {
    create(width, height, eFormat, _flags);
}

// PGMat 还没有引入
//    Texture(const PGMat &m,uint64_t _flags = BGFX_TEXTURE_RT| BGFX_SAMPLER_U_CLAMP | BGFX_SAMPLER_V_CLAMP);

static inline int channels(bgfx::TextureFormat::Enum format) {
    if (format == bgfx::TextureFormat::Enum::RGBA8 || format == bgfx::TextureFormat::Enum::BGRA8) {
        return 4;
    }
    if (format == bgfx::TextureFormat::Enum::R8 || format == bgfx::TextureFormat::A8) {
        return 1;
    }
    return -1;
}

void Texture::setValueRun(uint64_t state_flag,uint16_t clear_color_flag,int clear_component_idx,const unsigned char r,const unsigned char g,const unsigned char b,const unsigned char a) {
    assert(this->isValid());
    // 对于默认的蒙版纹理创建，直接采用cpu创建数据的方式，避免分配fbo和加载shader
    if (m_bgfxtTexture->m_TextureFromat == bgfx::TextureFormat::R8 || m_bgfxtTexture->m_TextureFromat == bgfx::TextureFormat::A8) {
        if (m_bgfxtTexture->m_texureWidth == 1 && m_bgfxtTexture->m_textureHeight == 1) {
            const bgfx::Memory *mem = bgfx::alloc(1);
            mem->data[0] = r;
            this->create(1, 1, mem, m_bgfxtTexture->m_TextureFromat, m_bgfxtTexture->m_textureFlags);
            return;
        }
    }
    AlgoResManager *manager = AlgoResManager::shared();
    auto viewId = manager->getViewId();
    createFrameBuffer();
    
    bgfx::setViewRect(viewId, 0, 0, m_bgfxtTexture->m_texureWidth, m_bgfxtTexture->m_textureHeight);
    bgfx::setViewFrameBuffer(viewId, m_bgfxtTexture->m_frameBufferHandle);
    auto clearColor = (r << 24) | (g << 16) | (b << 8) | a;
    bgfx::setViewClear(viewId, clear_color_flag, clearColor);
    bgfx::setState(state_flag);
    if (clear_color_flag == BGFX_CLEAR_NONE) {
        FaceProgram program;
        auto shadername = string("algo_core/normal/set_value");
        Shader *shader = manager->loadShader(shadername);
        program.createProgram("idx", bgfx::UniformType::Vec4);
        
        float cleat_component_idx_f32[4] = {
            static_cast<float>(clear_component_idx), 0, 0, 0
        };
        program.setParam("idx", cleat_component_idx_f32);
        
        float vec4Arr[4] = { r / 255.f, g / 255.f, b / 255.f, a / 255.f};
        bgfx::UniformHandle unhandle = bgfx::createUniform("value", bgfx::UniformType::Vec4);
        bgfx::setUniform(unhandle, "value");
        program.createProgram("value", bgfx::UniformType::Vec4);
        program.setParam("value", vec4Arr);
        
        bgfx::VertexLayout ms_decl;
        ms_decl.begin()
        .add(bgfx::Attrib::Position, 3, bgfx::AttribType::Float)
        .add(bgfx::Attrib::TexCoord0, 2, bgfx::AttribType::Float, true)
        .end();
        
        bgfx::VertexBufferHandle m_vbh = bgfx::createVertexBuffer(bgfx::makeRef(simple_vertex_data, sizeof(simple_vertex_data)), ms_decl);
        
        bgfx::IndexBufferHandle m_ibh = bgfx::createIndexBuffer(bgfx::makeRef(simple_triangle_list, sizeof(simple_triangle_list)));
        bgfx::setVertexBuffer(0, m_vbh);
        bgfx::setIndexBuffer(m_ibh);
        bgfx::submit(viewId, shader->getProgram());
        
        bgfx::destroy(m_vbh);
        bgfx::destroy(m_ibh);
    } else {
        bgfx::touch(viewId);
    }
    releaseFrameBuffer();
}

Texture &Texture::operator = (const unsigned char value) {
    if(empty()) {
        return *this;
    }
    uint64_t state;
    if (m_bgfxtTexture->m_TextureFromat == bgfx::TextureFormat::Enum::R8) {
        state = BGFX_STATE_WRITE_R;
    } else if (m_bgfxtTexture->m_TextureFromat == bgfx::TextureFormat::Enum::A8) {
        state = BGFX_STATE_WRITE_A;
    } else if (m_bgfxtTexture->m_TextureFromat == bgfx::TextureFormat::Enum::RGBA8) {
        state = BGFX_STATE_WRITE_RGB | BGFX_STATE_WRITE_A;
    } else {
        return *this;
    }

    setValueRun(state, BGFX_CLEAR_COLOR, 0, value, value, value, value);

    return *this;
}

//    Texture &operator = (const PGMat &m);

long Texture::getSpCount() {
    return 1;
}

unsigned long long Texture::getPtr() {
    return 1;
}
int Texture::channels() const {
    return m_bgfxtTexture != nullptr ? ::channels(m_bgfxtTexture->m_TextureFromat) : -1;
}
int Texture::type() const {
    return 1;
}
bool Texture::empty() const {
    return m_bgfxtTexture == nullptr || !bgfx::isValid(m_bgfxtTexture->m_texture) || getWidth() == 0 || getHeight() == 0;
}

bgfx::TextureHandle Texture::getTextureHandle() {
    return m_bgfxtTexture->m_texture;
}

int Texture::getWidth() const {
    return m_bgfxtTexture != nullptr ? m_bgfxtTexture->m_texureWidth : 0;
}

int Texture::getHeight() const{
    return m_bgfxtTexture != nullptr ? m_bgfxtTexture->m_textureHeight : 0;
}

uint64_t Texture::getFlags() const {
    return m_bgfxtTexture != nullptr ? m_bgfxtTexture->m_textureFlags : 0;
}

uint32_t Texture::getAppFlags() const {
    return m_bgfxtTexture != nullptr ? m_bgfxtTexture->m_textureAppFlags : 0;
}
bool Texture::immutable() const {
    return m_bgfxtTexture != nullptr ? ((m_bgfxtTexture->m_textureAppFlags & PGTEXTURE_APP_FLAG_IMMUTABLE) ==
                                       PGTEXTURE_APP_FLAG_IMMUTABLE) : true;
}

bgfx::TextureFormat::Enum Texture::getTextureFormat() const {
    return m_bgfxtTexture != nullptr ? m_bgfxtTexture->m_TextureFromat : bgfx::TextureFormat::A8;
}

bool Texture::isValid() {
    return  m_bgfxtTexture != nullptr && bgfx::isValid(m_bgfxtTexture->m_texture);
}

#pragma mark - 接口函数
#pragma mark 填充纹理数据接口
bool Texture::create(const char *name) {
    bool result = false;
    bgfx::TextureInfo texInfo;
    std::tuple<const bgfx::Memory *, TextureFormat::Enum> textureInfo = loadTexture(name, 0, &texInfo, nullptr);
    if(get<0>(textureInfo) != nullptr) {
        create(texInfo.width, texInfo.height, get<0>(textureInfo), texInfo.format, BGFX_SAMPLER_NONE);
        if(texInfo.format == bgfx::TextureFormat::RGB8) {
            Texture texture(getWidth(), getHeight(), nullptr, bgfx::TextureFormat::RGBA8,
                            BGFX_SAMPLER_U_CLAMP | BGFX_SAMPLER_V_CLAMP | BGFX_TEXTURE_RT);
            BaseEffect effect;
            effect.setInputTexture(this);
            effect.setOutputTexture(&texture);
            effect.setIsLayerEffect(false);
            effect.initAllShaderMap("rgbToRgba/rgbToRgba_blendNormal_eft");
            effect.setAndSubmitCommonParams();
            AlgoResManager::shared()->bgfxFrame();
            *this = texture;
        }
        result = isValid();
    }
    return result;
}

bool Texture::create(int width, int height, bgfx::TextureFormat::Enum eFormat, uint64_t _flags) {
    if (width == 0) width = 1;
    if (height == 0) height = 1;
    return create(width, height, nullptr, eFormat, _flags);
    
}

bool Texture::create(int width, int height, const bgfx::Memory *mem, bgfx::TextureFormat::Enum eFormat, uint64_t _flags) {
    if ((m_bgfxtTexture != nullptr) &&
        (width == m_bgfxtTexture->m_texureWidth) &&
        (height == m_bgfxtTexture->m_textureHeight) &&
        (_flags == m_bgfxtTexture->m_textureFlags) &&
        (!immutable())) {
        if (mem != nullptr) {
            bgfx::updateTexture2D(m_bgfxtTexture->m_texture, 0, 0, 0, 0, m_bgfxtTexture->m_texureWidth, m_bgfxtTexture->m_textureHeight, mem);
        }
        return true;
    } else {
        m_bgfxtTexture = make_shared<Texture_>(width, height, eFormat, _flags, PGTEXTURE_APP_FLAG_NONE, mem);
    }
    return true;
}

bool Texture::create(int width, int height, unsigned char r, unsigned char g, unsigned char b, unsigned char a, bgfx::TextureFormat::Enum eFormat, uint64_t _flags) {
    if (!(m_bgfxtTexture != nullptr) &&
        (width == m_bgfxtTexture->m_texureWidth) &&
        (height == m_bgfxtTexture->m_textureHeight) &&
        (eFormat == m_bgfxtTexture->m_TextureFromat) &&
        (_flags == m_bgfxtTexture->m_textureFlags)) {
        m_bgfxtTexture = make_shared<Texture_>(width, height, eFormat, _flags);
    }
    auto chs = ::channels(m_bgfxtTexture->m_TextureFromat);
    if (chs == 4) {
        this->setTo(r, g, b, a);
    } else if (chs == 1) {
        this->setTo(0, r);
    }
    return true;
}

#pragma mark 其他接口
void Texture::release() {
    m_bgfxtTexture = nullptr;
}

Texture Texture::clone() {
    return  Texture(*this, 0, 0, this->getWidth(), this->getHeight());
}

void Texture::update(int dstx, int dsty, Texture &src, int srcx, int srcy, int width, int height) {
    if (empty() || src.empty() || src.channels() != channels()) {
        return;
    }
    srcx = max(srcx, 0);
    srcy = max(srcy, 0);
    
    const auto dstW = getWidth();
    const auto dsth = getHeight();
    const auto srcW = src.getWidth();
    const auto srcH = src.getHeight();
    if (width == 0 || height == 0) {
        width = srcW;
        height = srcH;
    }
    if(width > srcW || height > srcH) {
        return;
    }
    width = dstx + width > dstW ? (int)dstW - dstx : width;
    height = dsty + height > dsth ? (int)dsth - dsty : height;
    
    width = dstx < 0 ? width + dstx : width;
    height = dsty < 0 ? height + dsty : height;
    
    AlgoResManager *manager = AlgoResManager::shared();
    auto viewid = manager->getViewId();
    if ((BGFX_CAPS_TEXTURE_BLIT == (bgfx::getCaps()->supported & BGFX_CAPS_TEXTURE_BLIT)) &&
        ((m_bgfxtTexture->m_textureFlags & BGFX_TEXTURE_BLIT_DST) == BGFX_TEXTURE_BLIT_DST)) {
        bgfx::blit(viewid, m_bgfxtTexture->m_texture, dstx, dsty, src.getTextureHandle(), srcx, srcy, width, height);
    } else {
        createFrameBuffer();
        bgfx::setViewRect(viewid, 0, 0, m_bgfxtTexture->m_texureWidth, m_bgfxtTexture->m_textureHeight);
        bgfx::setViewFrameBuffer(viewid, m_bgfxtTexture->m_frameBufferHandle);
        bgfx::setViewClear(viewid, BGFX_CLEAR_NONE, 0);
        bgfx::setState(BGFX_STATE_WRITE_RGB | BGFX_STATE_WRITE_A);
        
        FaceProgram program;
        auto shaderName = string("algo_core/copyTexture/copyTexture");
        Shader *shader = manager->loadShader(shaderName);
        
        program.createProgram("offsetXYWH", bgfx::UniformType::Vec4);
        float offsetXYWH[4] = {
            (float)srcx / srcW, (float)srcy / srcH, (float)width / srcW, (float)height / srcH
        };
        program.setParam("offsetXYWH", offsetXYWH);
        
        program.createProgram("textureUnit0", bgfx::UniformType::Sampler);
        program.setTexture("textureUnit0", src.m_bgfxtTexture->m_texture, 0);
        
        bgfx::VertexLayout ms_decl;
        ms_decl.begin()
        .add(bgfx::Attrib::Position, 3, bgfx::AttribType::Float)
        .add(bgfx::Attrib::TexCoord0, 2, bgfx::AttribType::Float, true)
        .end();
        
        float destX_normed = 2 * (float)dstx / dstW - 1;
        float destY_normed = - 2 * (float)dsty / dsth + 1;
        float desX1_normed = 2 * (float)(dstx + width) / dstW - 1;
        float desY1_normed = -2 * (float)(dsty + height) / dsth + 1;
        vertex_struct simple_vertext_data_tmp[] =
        {
            {destX_normed, -destY_normed, 0.0f, 0.0f, 0.0f},
            {desX1_normed, -destY_normed, 0.0f, 1.0f, 0.0f},
            {destX_normed, -desX1_normed, 0.0f, 0.0f, 1.0f},
            {desX1_normed, -desY1_normed, 0.0f, 0.0f, 1},
        };
        
        bgfx::VertexBufferHandle m_vbh = bgfx::createVertexBuffer(bgfx::copy(simple_vertext_data_tmp, sizeof(simple_vertext_data_tmp)), ms_decl);
        
        bgfx::IndexBufferHandle m_ibh = bgfx::createIndexBuffer(bgfx::makeRef(simple_triangle_list, sizeof(simple_triangle_list)));
        bgfx::setVertexBuffer(0, m_vbh);
        bgfx::setIndexBuffer(m_ibh);
        
        bgfx::submit(viewid, shader->getProgram());
        bgfx::destroy(m_vbh);
        bgfx::destroy(m_ibh);
        releaseFrameBuffer();
    }
    
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
    if (m_bgfxtTexture == nullptr) {
        return false;
    }
    bool flag = false;
    if (bgfx::isValid(m_bgfxtTexture->m_frameBufferHandle)) {
        flag = true;
    } else {
        if (bgfx::isValid(m_bgfxtTexture->m_texture)) {
            bgfx::TextureHandle tmpTextures[1];
            tmpTextures[0] = m_bgfxtTexture->m_texture;
            m_bgfxtTexture->m_frameBufferHandle = bgfx::createFrameBuffer(BX_COUNTOF(tmpTextures), tmpTextures, false);
            flag = bgfx::isValid(m_bgfxtTexture->m_frameBufferHandle);
        } else {
            m_bgfxtTexture->m_frameBufferHandle = BGFX_INVALID_HANDLE;
            flag = false;
        }
    }
    return flag;
}

bool Texture::createFrameBuffer(Texture &depth) {
    if (m_bgfxtTexture == nullptr) {
        return false;
    }
    bool flag = false;
    if (bgfx::isValid(m_bgfxtTexture->m_frameBufferHandle)) {
        flag = true;
    } else {
        if (bgfx::isValid(m_bgfxtTexture->m_texture)) {
            bgfx::TextureHandle tempTextures[2];
            tempTextures[0] = m_bgfxtTexture->m_texture;
            tempTextures[1] = depth.getTextureHandle();
            m_bgfxtTexture->m_frameBufferHandle = bgfx::createFrameBuffer(BX_COUNTOF(tempTextures), tempTextures, false);
            flag = bgfx::isValid(m_bgfxtTexture->m_frameBufferHandle);
        } else {
            m_bgfxtTexture->m_frameBufferHandle = BGFX_INVALID_HANDLE;
            flag = false;
        }
    }
    return flag;
}

bool Texture::releaseFrameBuffer() {
    if (m_bgfxtTexture == nullptr) {
        return false;
    }
    if (bgfx::isValid(m_bgfxtTexture->m_frameBufferHandle)) {
        bgfx::destroy(m_bgfxtTexture->m_frameBufferHandle);
        m_bgfxtTexture->m_frameBufferHandle = BGFX_INVALID_HANDLE;
        return true;
    }
    return false;
}

bgfx::FrameBufferHandle Texture::getFrameBufferHandle() {
    if (m_bgfxtTexture != nullptr) {
        return m_bgfxtTexture->m_frameBufferHandle;
    }
    return BGFX_INVALID_HANDLE;
}

void Texture::trans2gray(Texture &output) {
    if (channels() != 4) {
        return;
    }
    AlgoResManager *manager = AlgoResManager::shared();
    auto viewId = manager->getViewId();
    
    output.create(getWidth(), getHeight(), bgfx::TextureFormat::R8, BGFX_SAMPLER_U_CLAMP | BGFX_SAMPLER_V_CLAMP | BGFX_TEXTURE_RT);
    bgfx::setViewRect(viewId, 0, 0, output.getWidth(), output.getHeight());
    output.createFrameBuffer();
    bgfx::setViewFrameBuffer(viewId, output.getFrameBufferHandle());
    bgfx::setViewClear(viewId, BGFX_CLEAR_NONE, 0);
    bgfx::setState(BGFX_STATE_WRITE_R);
    
    FaceProgram program;
    auto shaderName = string("algo_core/normal/to_gray");
    Shader *shader = manager->loadShader(shaderName);
    
    program.createProgram("textureUnit0", bgfx::UniformType::Sampler);
    program.setTexture("textureUnit0", m_bgfxtTexture->m_texture, 0);
    
    bgfx::VertexLayout mDescVextext0;
    mDescVextext0
    .begin()
    .add(bgfx::Attrib::Position, 3, bgfx::AttribType::Float)
    .add(bgfx::Attrib::TexCoord0, 3, bgfx::AttribType::Float, true)
    .end();
    
    bgfx::VertexBufferHandle m_vbh =
    bgfx::createVertexBuffer(bgfx::makeRef(simple_vertex_data, sizeof(simple_vertex_data)), mDescVextext0);
    bgfx::IndexBufferHandle m_ibh = bgfx::createIndexBuffer(bgfx::makeRef(simple_triangle_list, sizeof(simple_triangle_list)));
    bgfx::setVertexBuffer(0, m_vbh);
    bgfx::setIndexBuffer(m_ibh);
    
    bgfx::submit(viewId, shader->getProgram());
    bgfx::destroy(m_vbh);
    bgfx::destroy(m_ibh);
    releaseFrameBuffer();
}

// 倒置
void Texture::invert(Texture &output) {
    
}

void Texture::getSingleChannel(Texture &output, int channelnum) {
    
}

void Texture::gtSingelChannelInvert(Texture &output,int channelnum) {
    
}

void Texture::edgeblack() {
    
}
void Texture::getTextureData(int viewId, unsigned char *data) {
    
}
