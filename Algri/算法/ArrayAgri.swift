//
//  ArrayAgri.swift
//  Algri
//
//  Created by lieon on 2021/9/24.
//

import Foundation

class ArrayAgri {
    
    var array: [Int] = []
    // NC88 寻找第K大 （ === 找出数组中第 n - K的索引的值，快排）
    func findKth ( _ a: [Int],  _ n: Int,  _ K: Int) -> Int {
        // write code here
        array = a
        sort()
        return array[K - 1]
    }
    
    
    func sort() {
        sort(0, array.count)
    }
    
    func sort(_ begin: Int, _ end: Int) {
        if end - begin < 2 {
            return
        }
        let index = pivotIndex(begin, end)
        sort(begin, index)
        sort(index + 1, end)
    }
    
    // 获取轴点的索引
    func pivotIndex(_ begin: Int, _ end: Int) -> Int {
        // 随机获取一个轴点元素的位置
        self.swap(begin, Int.random(in: Range<Int>.init(uncheckedBounds: (begin, end))))
        var begin = begin
        var end = end - 1
        let pivot = array[begin]
        while(begin < end) {
            // 从右往左扫描, 此时锚点在左边
            while(begin < end) {
                if pivot < array[end] {
                    end -= 1
                } else {
                    array[begin] = array[end]
                    begin += 1
                    break
                }
            }
            // 从左往右扫描, 此时锚点在右边
            while(begin < end) {
                if pivot > array[begin] {
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
    
    // 交换
    
    func swap(_ index: Int, _ dest: Int) {
        let temp = array[index]
        array[index] = array[dest]
        array[dest] = temp
    }
    
    
    func merge(_ nums1: inout [Int], _ m: Int, _ nums2: [Int], _ n: Int) {
        if m == 0, n != 0 {
            nums1 = nums2
            return
        }
        if m == 0, n == 0 {
            return
        }
        if m != 0, n == 0 {
            return
        }
        var i = m - 1
        var j = n - 1
        var end = m + n - 1
        while j >= 0 {
            if i >= 0, nums1[i] > nums2[j] {
                nums1[end] = nums1[i]
                i -= 1
            } else {
                nums1[end] = nums2[j]
                j -= 1
            }
            end -= 1
            
        }
    }
    
    /**
     移动零
     给定一个数组 nums，编写一个函数将所有 0 移动到数组的末尾，同时保持非零元素的相对顺序。
     
     示例:
     
     输入: [0,1,0,3,12]
     输出: [1,3,12,0,0]
     []
     */
    func moveZeroes(_ nums: inout [Int]) {
        var numsArray: [Int] = []
        var zeronArray: [Int] = []
        for num in nums {
            if num == 0 {
                zeronArray.append(num)
            } else {
                numsArray.append(num)
            }
        }
        numsArray.append(contentsOf: zeronArray)
        nums = numsArray
        
    }
    
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        var map: [Int: Int?] = [:]
        for (currentIndex, num) in nums.enumerated() {
            let other = target - num
            if map[other] != nil {
                return [map[other]!!, currentIndex]
            } else {
                map[num] = currentIndex
            }
            
        }
        return []
    }
        
    func rotate(_ matrix: inout [[Int]]) {
        var newMatrix = matrix
        for (i, rowArray) in matrix.enumerated() {
            for (j, num) in rowArray.enumerated() {
                let newJ = rowArray.count - 1 - i
                let newI = i
                newMatrix[newI][newJ] = num
            }
        }
        matrix = newMatrix
    }
    
    /**
     给定两个数组，编写一个函数来计算它们的交集。
     
      
     
     示例 1：
     
     输入：nums1 = [1,2,2,1], nums2 = [2,2]
     输出：[2,2]
     示例 2:
     
     输入：nums1 = [4,9,5], nums2 = [9,4,9,8,4]
     输出：[4,9]
     */
    func intersect(_ nums1: [Int], _ nums2: [Int]) -> [Int] {
        var map: [Int: Int?] = [:]
        // 将一个数组的元素存入hashMap表中，key为num，value为num出现的次数
        for num in nums1 {
            if map[num] != nil {
                map[num]!! += 1
            } else {
                map[num] = 1
            }
        }
        var result: [Int] = []
        // 在另一个数组中遍历，如果hashMap表中存在这个key，那么hasMap对应的值减一，同时将这个num放入到新的数组中，如果还存在这个key但是，value已经为0了，则说明之前已经把这个num放入到新的数组中了
        for num in nums2 {
            if map[num] != nil, map[num]! != 0 {
                result.append(num)
                map[num]!! -= 1
            }
        }
        return result
    }
    /**
     给定一个非空整数数组，除了某个元素只出现一次以外，其余每个元素均出现两次。找出那个只出现了一次的元素。
     
     说明：
     
     你的算法应该具有线性时间复杂度。 你可以不使用额外空间来实现吗？
     
     示例 1:
     
     输入: [2,2,1]
     输出: 1
     示例 2:
     
     输入: [4,1,2,1,2]
     输出: 4
     
     使用异或实现：相同为0，不同为1
     a ^ a = 0
     a ^ 0 = a
     a ^ b ^ a = a ^ a ^ b = 0 ^ b = b
     这样就可以把相同的值过滤掉，不重复的值保留下来
     */
    func singleNumber(_ nums: [Int]) -> Int {
        var reduce = 0
        for num in nums {
            reduce = reduce ^ num
        }
        return reduce
        //        var set: Set<Int> = .init()
        //        for num in nums {
        //            if set.insert(num).0 == false { // 如果集合中存在改元素，则移除这个元素，相当于把重复的元素，从集合中移除，保留不重复的
        //                set.remove(num)
        //            }
        //        }
        //        return set.isEmpty ? 0 : set.first!
    }
    
    /**给定一个数组，将数组中的元素向右移动 k 个位置，其中 k 是非负数。
     进阶：
     
     尽可能想出更多的解决方案，至少有三种不同的方法可以解决这个问题。
     你可以使用空间复杂度为 O(1) 的 原地 算法解决这个问题吗？
      
     
     示例 1:
     
     输入: nums = [1,2,3,4,5,6,7], k = 3
     输出: [5,6,7,1,2,3,4]
     解释:
     向右旋转 1 步: [7,1,2,3,4,5,6]
     向右旋转 2 步: [6,7,1,2,3,4,5]
     向右旋转 3 步: [5,6,7,1,2,3,4]
     示例 2:
     
     输入：nums = [-1,-100,3,99], k = 2
     输出：[3,99,-1,-100]
     解释:
     向右旋转 1 步: [99,-1,-100,3]
     向右旋转 2 步: [3,99,-1,-100]
     */
    func rotate(_ nums: inout [Int], _ k: Int) {
        let maxIndex = nums.count - 1
        var newnums = nums
        for (index, num) in nums.enumerated() {
            var newIndex = index + k
            while newIndex > maxIndex {
                newIndex = newIndex - maxIndex - 1
                print(newIndex)
            }
            newnums[newIndex] = num
        }
        nums = newnums
    }
    
    
    /**
     给定一个由 整数 组成的 非空 数组所表示的非负整数，在该数的基础上加一。
     最高位数字存放在数组的首位， 数组中每个元素只存储单个数字。
     你可以假设除了整数 0 之外，这个整数不会以零开头。
     示例 1：
     
     输入：digits = [1,2,3]
     输出：[1,2,4]
     解释：输入数组表示数字 123。
     示例 2：
     
     输入：digits = [4,3,2,1]
     输出：[4,3,2,2]
     解释：输入数组表示数字 4321。
     示例 3：
     
     输入：digits = [0]
     输出：[1]
     */
    func plusOne(_ digits: [Int]) -> [Int] {
        var newDigits: [Int] = digits
        for current in 0 ..< digits.count {
            let index = digits.count - 1 - current
            // 如果当前遍历位不为9，则直接加1，然后放回
            if newDigits[index] != 9 {
                newDigits[index] += 1
                return newDigits
            } else {
                /// 如果当前遍历位为9，则直接置为0, 然后进行下一位的遍历
                newDigits[index] = 0
            }
        }
        // 来到这里说明数组全为9，那么加1后，数组要插入一，其他为位全为0
        newDigits.insert(1, at: 0)
        return newDigits
    }
    
    /**
     NC41 最长无重复子数组
     描述
     给定一个数组arr，返回arr的最长无重复元素子数组的长度，无重复指的是所有数字都不相同。
     子数组是连续的，比如[1,3,5,7,9]的子数组有[1,3]，[3,5,7]等等，但是[1,3,7]不是子数组
     示例1
     输入：
     [2,3,4,5]
     复制
     返回值：
     4
     复制
     说明：
     [2,3,4,5]是最长子数组
     示例2
     输入：
     [2,2,3,4,3]
     复制
     返回值：
     3
     复制
     说明：
     [2,3,4]是最长子数组
     示例3
     输入：
     [9]
     复制
     返回值：
     1
     复制
     示例4
     * 代码中的类名、方法名、参数名已经指定，请勿修改，直接返回方法规定的值即可
     *
     * @param arr int整型一维数组 the array
     * @return int整型
     */
    func maxLength ( _ arr: [Int]) -> Int {
        // write code here
        if arr.count < 2 {
            return arr.count
        }
        var setDict: Set<Int> = .init()
        var res = 0
        var left = 0
        var right = 0
        while(right < arr.count) {
            let element = arr[right]
            if !setDict.contains(element) {
                setDict.insert(element)
                right += 1
            } else {
                _ = setDict.remove(arr[left])
                left += 1
            }
            res = max(res, setDict.count)
        }
        return res
    }
    
    /**
     给定一个整数数组 nums ，找到一个具有最大和的连续子数组（子数组最少包含一个元素），返回其最大和。
     
     */
    func maxSubArray(_ nums: [Int]) -> Int {
        var sum = 0
        var ans = nums[0]
        for num in nums {
            if sum > 0 {
                sum += num
            } else {
                sum = num
            }
            ans = max(ans, sum)
        }
        return ans
    }
    // 数组去重
    static  func removeDuplicates(_ nums: inout [Int]) -> Int {
        var leftIndex = 0
        var rightIndex = 1
        if leftIndex >= nums.count {
            return 0
        }
        if rightIndex >= nums.count {
            return 1
        }
        var left = nums[leftIndex]
        var right = nums[rightIndex]
        
        let sortedNums = nums
        for (index, _) in sortedNums.enumerated() {
            rightIndex = index + 1
            if rightIndex >= sortedNums.count {
                break
            }
            right = sortedNums[rightIndex]
            if left != right {
                // 保存之前left的值
                nums[leftIndex] = left
                // 移动left
                leftIndex += 1
                left = right
                nums[leftIndex] = left
            }
        }
        return leftIndex + 1
    }
    
    /// 给定一个整数数组，判断是否存在重复元素。
    /// 哈希表法，根据key的唯一性别
    /// set法
    func containsDuplicate(_ nums: [Int]) -> Bool {
        var set = Set<Int>()
        for num in nums {
            set.insert(num)
        }
        if set.count == nums.count {
            return false
        }
        return true
    }
}
