//
//  CondMutex.cpp
//  FaceWorkflow
//
//  Created by lieon on 2021/7/30.
//

#include "CondMutex.hpp"

CondMutex::CondMutex() {
    mutex = SDL_CreateMutex();
    cond = SDL_CreateCond();
}

CondMutex::~CondMutex() {
    SDL_DestroyCond(cond);
    cond = nullptr;
    SDL_DestroyMutex(mutex);
    mutex = nullptr;
}

void CondMutex::lock() {
    SDL_LockMutex(mutex);
}

void CondMutex::unlock() {
    SDL_UnlockMutex(mutex);
}

void CondMutex::signal() {
    SDL_CondSignal(cond);
}

void CondMutex::broadcast() {
    SDL_CondBroadcast(cond);
}

void CondMutex::wait() {
    SDL_CondWait(cond, mutex);
}
