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
        sort(0, array.count)
    }
    
    
    func sort(_ start: Int, _ end: Int) {
        if end - start < 2 {
            return
        }
        let midIndex = pivotIndex(start,end)
        sort(start, midIndex)
        sort(midIndex + 1, end)
    }
    
    func pivotIndex(_ begin: Int, _ end: Int) -> Int {
        
        var begin = begin
        var end = end
        end -= 1
        let randamIndex = Int.random(in: ClosedRange<Int>.init(uncheckedBounds: (begin, end)))
        /// 随机选择一个元素跟begin的位置交换
        swap(begin, randamIndex)
        // 备份轴点元素
        let pivot = array[begin]
        while begin < end {
            // 从右往左扫描
            while begin < end {
                if pivot - array[end] < 0 { // 右边元素大于轴点元素
                    end -= 1
                } else {
                    array[begin] = array[end]
                    begin += 1
                    break
                }
            }
            // 从左往右扫描
            while begin < end {
                if pivot - array[begin] > 0 { // 左边元素小于轴点元素
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
    
    func swap(_ a: Int, _ b: Int) {
        let temp = array[b]
        array[b] = array[a]
        array[a] = temp
    }
    
    
    
//    /// 对区间[begin, end)进行快速排序
//    func sort(begin: Int, end: Int) {
//        if end - begin < 2  {
//            return
//        }
//        let midIndex = pivotIndex(begin: begin, end: end)
//        sort(begin: begin, end: midIndex)
//        sort(begin: midIndex + 1, end: end)
//    }
//
//
//    /// 获取轴点元素的索引
//
//    fileprivate func pivotIndex(begin: Int, end: Int) -> Int {
//        // 随机选择一个元素跟begin的位置交换
//        swap(begin, Int.random(in: Range<Int>(uncheckedBounds: (begin, end))))
//        var begin = begin
//        var end = end;
//        end -= 1
//        // 备份轴点元素
//        let pivot = array[begin]
//        while begin < end {
//            // 从右往左扫描
//            while begin < end {
//                if pivot - array[end] < 0 {
//                    end -= 1
//                } else {
//                    array[begin] = array[end]
//                    begin += 1
//                    break
//                }
//            }
//            // 从左往右扫描
//            while begin < end {
//                if pivot - array[begin] > 0 {
//                    begin += 1
//                } else {
//                    array[end] = array[begin]
//                    end -= 1
//                    break
//                }
//            }
//        }
//        array[begin] = pivot
//        return begin
//    }
    
//    fileprivate func swap(_ currentIndex: Int, _ destIndex: Int) {
//        let temp = array[currentIndex]
//        array[currentIndex] = array[destIndex]
//        array[destIndex] = temp
//    }
}



class Sorting {
    
    func bubbleSort(_ array: inout [Int]) {
        let count = array.count
        for end in (1 ... count - 1).reversed()  {
            for begin in 1 ... end {
                if array[begin] < array[begin - 1] {
                    let temp = array[begin]
                    array[begin] = array[begin - 1]
                    array[begin - 1] = temp
                }
            }
        }
    }
    
    func bubbleSort1(_ array: inout [Int]) {
        let count = array.count
        for end in (1 ... count - 1).reversed()  {
            var sorted = false
            for begin in 1 ... end {
                if array[begin] < array[begin - 1] {
                    let temp = array[begin]
                    array[begin] = array[begin - 1]
                    array[begin - 1] = temp
                    sorted = false
                }
            }
            if sorted {
                break
            }
        }
    }
    
    func bubbleSort3(_ array: inout [Int]) {
        var startIndex = 0
        for end in (startIndex ... array.count - 1).reversed() {
            var sortedIndex = 1
            for begin in 1 ... end {
                if array[begin] < array[begin - 1] {
                    let temp = array[begin]
                    array[begin] = array[begin - 1]
                    array[begin - 1] = temp
                    sortedIndex = begin
                }
            }
            startIndex = sortedIndex
        }
    }
    
    func search(_ nums: [Int], _ target: Int) -> Int {
        var leftIndex = 0
        var rightIndex = nums.count - 1
        while leftIndex <= rightIndex {
            let midIndex = leftIndex + (rightIndex - leftIndex) / 2
            if nums[midIndex] > target { // 左区间 [leftIndex, mid - 1]
                rightIndex = midIndex - 1
            } else if nums[midIndex] < target { // 右区间
                leftIndex = midIndex + 1
            } else {
                return midIndex
            }
        }
        return -1
    }
    
    func selectedSort(_ array: inout [Int]) {
        for end in 1 ... array.count - 1 {
            var maxIndex = 0
            for begin in 1 ... end {
                if array[maxIndex] <= array[begin] {
                    maxIndex = begin
                }
            }
            let temp = array[maxIndex]
            array[maxIndex] = array[end]
            array[end] = temp
        }
    }
}

/// 计数排序
class CountingSort {
    var array: [Int]
    
    init(_ array: [Int]) {
        self.array = array
    }
    
    func sort() {
        var max = array[0]
        /// 找出最大值
        for value in array {
            if value > max {
                max = value
            }
        }
        // 统计每个整数出现的次数
        var counts: [Int] = [Int](repeating: 0, count: max + 1)
        for value in array {
            counts[value] += 1
        }
        // 根据整数出现次数，对整数进行排序
        var index = 0
        for countIndex in 0 ..< counts.count {
            while counts[countIndex] > 0 {
                array[index] = countIndex
                index += 1
                counts[countIndex] -= 1
            }
        }
    }
}
