//
//  Sort.swift
//  Algri
//
//  Created by lieon on 2021/9/21.
//

import Foundation

/**
 # 归并排序
 -不断地将当前序列平均分割成2个子序列，直到不能分割
 - 不断地将2个子序列合并成一个有序序列，知道最终只剩下一个有序序列
 */

class MergerSort {
    var array: [Int] = []
    var leftArray: [Int] = []
    
    func sort() {
        leftArray.append(contentsOf: array)
        sort(begin: 0, end: array.count)
    }
    
    // [begin, end)
    func sort(begin: Int, end: Int) {
        if end - begin < 2 {
            return
        }
        let mid = (end + begin) >> 1
        sort(begin: begin, end: mid)
        sort(begin: mid, end: end)
        merge(begin: begin, mid: mid, end: end)
    }
    
    func merge(begin: Int, mid: Int, end: Int) {
        var li = 0
        let le = mid - begin
        var ri = mid
        var ai = begin
        let re = end
        // 拷贝左边数组
        for index in 0 ..< le {
            leftArray[index] = array[begin + index]
        }
        while li < le {
            if ri < re && array[ri] < leftArray[li] {
                array[ai] = array[ri]
                ai += 1
                ri += 1
            } else {
                array[ai] = leftArray[li]
                ai += 1
                li += 1
            }
        }
    }
}


/**
 # 快速排序
 - 从序列中选择一个轴点元素，假设每次选择0位置的元素为轴点元素
 - 利用轴点元素将序列分割成2个子序列
 - 将小于轴点的元素放在左侧
 - 将大于轴点的元素放在右侧
 - 等于轴点的元素放在哪边都可以
 - 对子序列进行1,2操作, 直到不能再分割
 - 快速排序的本质
 - 逐渐将每一个元素都转换成轴点元素
 
 时间复杂度最坏为O(n^2), 为了避免这种情况：
 采用随机选择轴点元素
 */

class QuickSort {
    var array: [Int] = []
    
    func sort() {
        sort(begin: 0, end: array.count)
    }
    
    
    /// 对区间[begin, end)进行快速排序
    func sort(begin: Int, end: Int) {
        if end - begin < 2  {
            return
        }
        let midIndex = pivotIndex(begin: begin, end: end)
        sort(begin: begin, end: midIndex)
        sort(begin: midIndex + 1, end: end)
    }
    
    
    /// 获取轴点元素的索引
    
    fileprivate func pivotIndex(begin: Int, end: Int) -> Int {
        // 随机选择一个元素跟begin的位置交换
        swap(begin, Int.random(in: Range<Int>(uncheckedBounds: (begin, end))))
        var begin = begin
        var end = end;
        end -= 1
        // 备份轴点元素
        let pivot = array[begin]
        while begin < end {
            // 从右往左扫描
            while begin < end {
                if pivot - array[end] < 0 {
                    end -= 1
                } else {
                    array[begin] = array[end]
                    begin += 1
                    break
                }
            }
            // 从左往右扫描
            while begin < end {
                if pivot - array[begin] > 0 {
                    begin += 1
                } else {
                    array[end] = array[begin]
                    end -= 1
                    break
                }
            }
        }
        array[begin] = pivot
        return begin
    }
    
    fileprivate func swap(_ currentIndex: Int, _ destIndex: Int) {
        let temp = array[currentIndex]
        array[currentIndex] = array[destIndex]
        array[destIndex] = temp
    }
}

