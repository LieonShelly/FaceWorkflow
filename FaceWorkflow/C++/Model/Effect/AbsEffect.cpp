//
//  AbsEffect.cpp
//  FaceWorkflow
//
//  Created by lieon on 2021/1/28.
//

#include "AbsEffect.hpp"


AbsEffect::AbsEffect(const char *eftName)
:m_vbh(BGFX_INVALID_HANDLE),
m_vbhScale(BGFX_INVALID_HANDLE),
m_ibh(BGFX_INVALID_HANDLE) {
    m_eftName = eftName;
}

AbsEffect::~AbsEffect() {
    if (bgfx::isValid(m_vbh)) {
        bgfx::destroy(m_vbh);
        m_vbh = BGFX_INVALID_HANDLE;
    }
    if (bgfx::isValid(m_ibh)) {
        bgfx::destroy(m_ibh);
        m_ibh = BGFX_INVALID_HANDLE;
    }
}
