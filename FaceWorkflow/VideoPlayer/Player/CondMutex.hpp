//
//  CondMutex.hpp
//  FaceWorkflow
//
//  Created by lieon on 2021/7/30.
//

#ifndef CondMutex_hpp
#define CondMutex_hpp

#include <stdio.h>
#include <SDL.h>

class CondMutex {
private:
    SDL_mutex *mutex = nullptr;
    SDL_cond *cond = nullptr;
    
public:
    CondMutex();
    ~CondMutex();
    
    void lock();
    void unlock();
    void signal();
    void broadcast();
    void wait();
    
};


#endif /* CondMutex_hpp */
