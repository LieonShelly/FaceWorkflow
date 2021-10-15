//
//  main.cpp
//  Cxx
//
//  Created by lieon on 2021/9/15.
//

#include <iostream>
#include <string.h>
#include <stack>
#include <vector>

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
    int *array = nullptr;
    int *leftArray = nullptr;
    
    
    void mergerSort(int begin, int end) {
        if (end - begin < 2) {
            return;
        }
        int mid = (end + begin) >> 1;
        mergerSort(begin, mid);
        mergerSort(mid, end);
        mergerSortMerge(begin, mid, end);
    }
    
    void mergerSortMerge(int begin, int mid, int end) {
        int li = 0;
        int le = mid - begin;
        int ri = mid;
        int re = end;
        int ai = begin;
        //拷贝左边数组
        for (int index = 0; index < le; index++) {
            leftArray[index] = array[begin + index];
        }
        
        while (li < le) {
            if (ri < re && array[ri] < leftArray[li]) {
                array[ai] = array[ri];
                ai++;
                ri++;
            } else {
                array[ai] = leftArray[li];
                ai++;
                li++;
            }
            cout << array[ai - 1] << end;
        }
    }
    
};


void bubbleSort() {
    int a[] = {123, 23, 23, 234, 234};
    
    
}

#include <vector>

namespace Niuke {

int search(vector<int>& nums, int target) {
    // write code here
    int leftIndex = 0;
    int rightIndex = nums.size() - 1;
    int idx = -1;
    while(leftIndex <= rightIndex) {
        int midIndex = leftIndex + (rightIndex - leftIndex) / 2;
        if (target < nums.at(midIndex)) { // 左区间
            rightIndex = midIndex - 1;
        } else if (target > nums.at(midIndex)) { // 右区间
            leftIndex = midIndex + 1;
        } else { // 有可能存在几个相同的值，所以要找到索引最小的那个
            idx = midIndex;
            rightIndex = midIndex - 1;
        }
    }
    return -1;
}

/**
 NC22 合并两个有序的数组
 */

// 归并排序 - 归并排序的思想，哪个小，就往temp数组中放
void merge(int A[], int m, int B[], int n) {
    int *temp = new int[m + n];
    int i = 0;
    int j = 0;
    int index = 0;
    while (j < n && i< m) {
        if (A[i] <= B[j]) {
            temp[index] = A[i];
            index++;
            i++;
        } else {
            temp[index] = B[j];
            index++;
            j++;
        }
    }
    for (; i < m; ) {
        temp[index++] = A[i++];
    }
    for (; j < n; ) {
        temp[index++] = B[j++];
    }
    for (int k = 0; k < m + n; k++) {
        A[k] = temp[k];
    }
    
}

ListNode* reverse(ListNode *head, ListNode *endNode) {
    ListNode *node = head;
    ListNode *preNode = nullptr;
    while (node != nullptr && node != endNode) {
        ListNode *temp = node->next;
        node->next = preNode;
        preNode = node;
        node = temp;
    }
    return preNode;
}

// 链表内指定区间反转
ListNode* reverseBetween(ListNode* head, int m, int n) {
    // write code here
    int preIndex = m - 1 - 1;
    int startIndex = m - 1;
    int endIndex = n - 1;
    int index = 0;
    if (startIndex < 0) {
        return head;
    }
    ListNode *node = head;
    ListNode *preNode = nullptr;
    ListNode *endNode = nullptr;
    ListNode *endNextNode = nullptr;
    ListNode *startNode = nullptr;
    while (node != nullptr) {
        if (preIndex == index) {
            preNode = node;
        }
        if (startIndex == index) {
            startNode = node;
        }
        if (endIndex == index) {
            endNode = node;
            endNextNode = endNode->next;
        }
        node = node->next;
        index += 1;
    }
    ListNode *newhead = reverse(startNode, endNode->next);
    ListNode *temp = startNode;
    if (preNode != nullptr) {
        preNode->next = newhead;
        temp->next = endNextNode;
        return head;
    } else {
        temp->next = endNextNode;
    }
    return newhead;
}


}

class Solution1111 {
public:

    vector<int> arr;
    
    vector<int> MySort(vector<int>& arr) {
        this->arr = {11,222,3,10,52,8,0};
        int end = (int)this->arr.size();
        sort(0, end);
        return this->arr;
    }
    
    void sort(int begin, int end) {
        if (end - begin < 2) {
            return;
        }
        int mid = pivotIndex(begin, end);
        sort(begin, mid);
        sort(mid + 1, end);
        
    }
    
    int pivotIndex(int begin, int end) {
        end = end - 1;
        int randamIndex = begin + (rand() % (end - begin));
        swap(begin, randamIndex);
        int pivot = arr[begin];
        while(begin < end) {
            while(begin < end) {
                if (pivot - arr[end] < 0) {
                    end -= 1;
                } else {
                    arr[begin] = arr[end];
                    begin += 1;
                    break;
                }
            }
            while(begin < end) {
                if (pivot - arr[end] > 0) {
                    begin += 1;
                } else {
                    arr[end] = arr[begin];
                    end -= 1;
                    break;
                }
            }
        }
        arr[begin] = pivot;
        return begin;
    }
    
    void swap(int a, int b) {
        int temp = arr[b];
        arr[b] = arr[a];
        arr[a] = temp;
    }
    
};


int main(int argc, const char * argv[]) {
    vector<int> a = {884688278,387052570,77481420,537616843,659978110,215386675,604354651,64838842,830623614,544526209,292446044,570872277,946770900,411203381,445747969,480363996,31693639,303753633,261627544,884642435,978672815,427529125,111935818,109686701,714012242,691252458,230964510,340316511,917959651,544069623,193715454,631219735,219297819,151485185,986263711,805374069,915272981,493886311,970466103,819959858,733048764,393354006,631784130,70309112,513023688,17092337,698504118,937296273,54807658,353487181,82447697,177571868,830140516,536343860,453463919,998857732,280992325,13701823,728999048,764532283,693597252,433183457,157540946,427514727,768122842,782703840,965184299,586696306,256184773,984427390,695760794,738644784,784607555,433518449,440403918,281397572,546931356,995773975,738026287,861262547,119093579,521612397,306242389,84356804,42607214,462370265,294497342,241316335,158982405,970050582,740856884,784337461,885254231,633020080,641532230,421701576,298738196,918973856,472147510,169670404};
    Solution1111 *s = new Solution1111() ;
    s->MySort(a);
    return 0;
}
