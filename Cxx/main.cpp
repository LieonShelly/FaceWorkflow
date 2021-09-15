//
//  main.cpp
//  Cxx
//
//  Created by lieon on 2021/9/15.
//

#include <iostream>
#include <string.h>

using namespace std;

int myAtoi(string s) {
    const char *charArray = s.c_str();
    int index = 0;
    long int length = s.length();
    // 去掉空格"   -1"
    while (index < length && charArray[index] == ' ') {
        index++;
    }
    if (index >= length) {
        return 0;
    }
    // 获取符号位
    int sign = 1;
    if (charArray[index] == '-' || charArray[index] == '+') {
        if (charArray[index] == '-') {
            sign = -1;
        }
        index++;
    }
    int result = 0;
    int temp = result;
    while (index < length) {
        int num = charArray[index] - '0';
        if (num > 9 || num < 0) {
            break;
        }
        
        temp = result;
        result = result * 10 + num;
        if (result / 10 != temp) {
            if (sign > 0) {
                return INT32_MAX;
            } else {
                return INT32_MIN;
            }
        }
        index++;
    }
    return result * sign;
}

int main(int argc, const char * argv[]) {
    int result = myAtoi("21474836460");
    std::cout << result << endl;
    return 0;
}
