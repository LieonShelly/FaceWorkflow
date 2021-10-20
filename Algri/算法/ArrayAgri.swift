//
//  ArrayAgri.swift
//  Algri
//
//  Created by lieon on 2021/9/24.
//

import Foundation

class ArrayAgri {
    
    //给定一个长度为 n 的数组 arr ，返回其中任意子数组的最大累加和
    func maxsumofSubarray ( _ arr: [Int]) -> Int {
        var sum = 0
        var ans = arr[0]
        for num in arr {
            if sum > 0 {
                sum += num
            } else {
                sum = num
            }
            ans = max(ans, sum)
        }
        return ans
     }
    
    //找出一个数组中的所有K数。（ K 数定义：前面的数都比它小，后面的数都比它大。） 举例：1 3 2 4 7 5 9 其中K数有：1 4 9
    func finKNum(_ a: [Int]) -> [Int] {
        var results: [Int] = []
        for (index, num) in a.enumerated() {
            // 找到比Num小的数
            var isFindMin: Bool = true
            for subIndex in 0 ..< index {
                if a[subIndex] >= num {
                    isFindMin = false
                    break
                }
            }
            //  // 找到比Num大的数
            var isFindMax: Bool = true
            if isFindMin {
                for subIndex in index + 1 ..< a.count {
                    if a[subIndex] <= num {
                        isFindMax = false
                        break
                    }
                }
            }
            if isFindMax, isFindMin {
                results.append(num)
            }
           
        }
        return results
    }
    
    var array: [Int] = []
    //FIXME:重点 NC88 寻找第K大 （ === 找出数组中第 n - K的索引的值，快排）
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
    
    func maxSubArray1(_ nums: [Int]) -> Int {
        if nums.isEmpty { return 0 }
        var dp = Array<Int>.init(repeating: 0, count: nums.count)
        var maxValue = dp[0]
        for index in 1 ..< nums.count {
            if dp[index - 1] < 0 {
                dp[index] = nums[index]
            } else {
                dp[index] = dp[index - 1] + nums[index]
            }
            maxValue = max(dp[index], maxValue)
        }
        return maxValue
    }
    
    /// 最长上升子序列
    func lengthOfLIS(_ nums: [Int]) -> Int {
        if nums.isEmpty { return 0 }
        var dp = Array<Int>.init(repeating: 1, count: nums.count)
        var maxValue = dp[0]
        for index in 1 ..< dp.count {
            for j in 0 ..< index {
                if nums[index] <= nums[j] { continue }
                dp[index] = max(dp[index], dp[j] + 1)
            }
            maxValue = max(dp[index], maxValue)
        }
        return maxValue
    }
    
    ///最长公共子序列
    func lcs(_ nums1: [Int], _ nums2: [Int]) -> Int {
        if nums1.isEmpty { return 0 }
        if nums2.isEmpty { return 0 }
        var dp: [[Int]] = Array<Array<Int>>.init(repeating: Array<Int>.init(repeating: 0, count: nums2.count), count: nums1.count)
        for i in 1 ... nums1.count {
            for j in 1 ... nums2.count {
                if nums1[i - 1] == nums2[j - 1] {
                    dp[i][j] = dp[i - 1][j - 1] + 1
                } else {
                    dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])
                }
            }
        }
        return dp[nums1.count][nums2.count]
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
