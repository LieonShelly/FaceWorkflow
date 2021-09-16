//
//  main.cpp
//  Cxx
//
//  Created by lieon on 2021/9/15.
//

#include <iostream>
#include <string.h>
#include <stack>

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


struct ListNode {
    int val;
    struct ListNode *next;
    
    ListNode(int val) {
        this->val = val;
        this->next = nullptr;
    }
};


class Solution
{
public:
    void push(int node) {
        stack1.push(node);
    }

    int pop() {
        if (stack2.size() == 0) {
            while(stack1.size() != 0) {
                int element = stack1.top();
                stack1.pop();
                stack2.push(element);
            }
        }
        int top = stack2.top();
        stack2.pop();
        return  top;
    }

private:
    stack<int> stack1;
    stack<int> stack2;
    
public:
    
    /**
        *
        * @param head ListNode类
        * @param k int整型
        * @return ListNode类
        */
       ListNode* reverseKGroup(ListNode* head, int k) {
           // write code here
           ListNode *dummy = new ListNode(0);
           dummy->next = head;
           ListNode *pre = dummy;
           ListNode *end = dummy;
           while(end != nullptr) {
               // 每k个反转
               for(int i = 0; i < k && end != nullptr; i++) {
                   end = end->next;
               }
               if (end == nullptr) {
                   break;
               }
               // 反转开始的节点
               ListNode *start = pre->next;
               // next是下一次反转的头结点
               ListNode *next = end->next;
               end->next = nullptr;
               pre->next = reverse(start);
               start->next = next;
               pre = start;
               end = start;
           }
           return dummy->next;
           
       }
       
       
       ListNode* reverse(ListNode *head) {
           ListNode *node = head;
           ListNode *pre = nullptr;
           while(node != nullptr) {
               ListNode *temp = node->next;
               node->next = pre;
               pre = node;
               node = temp;
           }
           return pre;
       }
};

int main(int argc, const char * argv[]) {
    Solution queue = Solution();
    ListNode *head = new ListNode(1);
    ListNode *node2 = new ListNode(2);
    ListNode *node3 = new ListNode(3);
    ListNode *node4 = new ListNode(4);
    ListNode *node5 = new ListNode(5);
    ListNode *node6 = new ListNode(6);
    ListNode *node7 = new ListNode(7);
    ListNode *node8 = new ListNode(8);
    ListNode *node9 = new ListNode(9);
    head->next = node2;
    node2->next = node3;
    node3->next = node4;
    node4->next = node5;
    node5->next = node6;
    node6->next = node7;
    node7->next = node8;
    node8->next = node9;
    ListNode *newhead = queue.reverseKGroup(head, 3);
    while (newhead != nullptr) {
        cout << newhead->val << endl;
        newhead = newhead->next;
    }
    return 0;
}
