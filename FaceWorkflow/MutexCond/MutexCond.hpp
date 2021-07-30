//
//  MutexCond.hpp
//  FaceWorkflow
//
//  Created by lieon on 2021/7/26.
//

#ifndef MutexCond_hpp
#define MutexCond_hpp

#include <stdio.h>
#include <SDL.h>
#include <string>
#include <list>
#include <iostream>

using namespace std;

class TestObject {
public:
    int m_age = 0;
    TestObject() {};
    
    ~TestObject() {
        cout << "~TestObject" << endl;
    };
    
    TestObject(const TestObject &objc) {
        cout << "TestObject 拷贝构造执行了" << endl;
    }
};

class MutexCond {
private:
    SDL_mutex *mutex = nullptr;
    SDL_cond *cond1 = nullptr;
    SDL_cond *cond2 = nullptr;
    std::list<string> *list = nullptr;
    std::list<TestObject> testList;
    int index = 0;
public:
    MutexCond();
    ~ MutexCond();
    
    void consume(string name);
    
    void produce(string name);
};

#endif /* MutexCond_hpp */
