//
//  main.cpp
//  Cxx
//
//  Created by lieon on 2021/9/15.
//

/// clang++ -cc1 -emit-llvm -fdump-record-layouts -fdump-vtable-layouts  main.cpp
/// gcc --fdump-class-hierarchy main.cpp
/// clang -Xclang -fdump-record-layouts main.cpp
 struct A
{
    int ax;
    virtual void f0() {}
    virtual void bar() {}
};

struct B : virtual public A           /****************************/
{                                     /*                          */
    int bx;                           /*             A            */
    void f0() override {}             /*           v/ \v          */
};                                    /*           /   \          */
                                      /*          B     C         */
struct C : virtual public A           /*           \   /          */
{                                     /*            \ /           */
    int cx;                           /*             D            */
    virtual void f1() {}              /*                          */
};                                    /****************************/


struct D : public B, public C
{
    int dx;
    void f0() override {}
};

int main(int argc, const char * argv[]) {
    return 0;
}
