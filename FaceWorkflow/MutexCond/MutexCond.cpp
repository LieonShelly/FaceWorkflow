//
//  MutexCond.cpp
//  FaceWorkflow
//
//  Created by lieon on 2021/7/26.
//

#include "MutexCond.hpp"
#include <string>
#include <SDL.h>
#include <list>
#include <thread>
#include <iostream>
#include <sstream>

using namespace std;

MutexCond::MutexCond() {
    
    TestObject objc = TestObject();
    testList.push_back(objc);
    
//    cout << objc << endl;
    cout << &(testList.front()) << endl;
    
    
    // 创建互斥锁
    mutex = SDL_CreateMutex();
    cond1 = SDL_CreateCond();
    // 创建条件变量
    cond2 = SDL_CreateCond();
    // 创建链表
    list = new std::__1::list<string>();
    list->push_back(to_string(++index));
    list->push_back(to_string(++index));
    list->push_back(to_string(++index));
    list->push_back(to_string(++index));
    
    string &str = list->front();
    string str1 = list->front();
    
    cout << str << endl;
    cout << str1 << endl;
    // 创建消费者
    consume("消费者1");
    consume("消费者2");
    consume("消费者3");
    consume("消费者4");
    
    // 创建生产者
    produce("生产者1");
    produce("生产者2");
    produce("生产者3");
    produce("生产者4");
}

MutexCond::~MutexCond() {
    SDL_DestroyMutex(mutex);
    SDL_DestroyCond(cond1);
    SDL_DestroyCond(cond2);
}

void MutexCond::consume(string name) {
    thread([this, name]() {
        // 加锁
        SDL_LockMutex(mutex);
        while (true) {
            cout << name << "开始消费" << endl; //
            while (!list->empty()) {
                cout << "消费" << list->front() << endl;
                // 删除头部
                list->pop_front();
                // 睡眠500ms
                this_thread::sleep_for(chrono::milliseconds(500));
            }
            // 唤醒生产者：赶紧开始生产
            SDL_CondSignal(cond2);
            // 等待生产者生产
            SDL_CondWait(cond1, mutex);
        }
        // 解锁
        SDL_UnlockMutex(mutex);
        cout << "消费者解锁了" << endl;
    })
    .detach();
}

void MutexCond::produce(string name) {
    thread([this, name]() {
        SDL_LockMutex(mutex);
        while (true) {
            cout << name << "开始生产" << endl;
            list->push_back(to_string(++index));
            // 睡眠500ms
            this_thread::sleep_for(chrono::milliseconds(500));
            list->push_back(to_string(++index));
            this_thread::sleep_for(chrono::milliseconds(500));
            list->push_back(to_string(++index));
            this_thread::sleep_for(chrono::milliseconds(500));
            // 唤醒消费者:赶紧消费
            SDL_CondSignal(cond1);
            // 等待消费者
            SDL_CondWait(cond2, mutex);
        }
        SDL_UnlockMutex(mutex);
        cout << "生产者解锁了" << endl;
    })
    .detach();
}
