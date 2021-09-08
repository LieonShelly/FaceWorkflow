//
//  main.swift
//  Algri
//
//  Created by lieon on 2021/9/6.
//

import Foundation

print("Hello, World!")

/**
 给定一个整数数组，判断是否存在重复元素。
 
 如果存在一值在数组中出现至少两次，函数返回 true 。如果数组中每个元素都不相同，则返回 false 。
 示例 1:
 
 输入: [1,2,3,1]
 输出: true
 示例 2:
 
 输入: [1,2,3,4]
 输出: false
 示例 3:
 
 输入: [1,1,1,3,3,4,3,2,4,2]
 输出: true
 
 */


class Solution0 {
    /// 哈希表法，根据key的唯一性别
    //    func containsDuplicate(_ nums: [Int]) -> Bool {
    //        var dict = [Int: Int]()
    //        for num in nums {
    //            if dict.keys.contains(where: { num == $0}) {
    //                return true
    //            } else {
    //                dict[num] = num
    //            }
    //        }
    //        return false
    //    }
    
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
/**
 给定一个整数数组 nums ，找到一个具有最大和的连续子数组（子数组最少包含一个元素），返回其最大和。
 
 动态规划的是首先对数组进行遍历，当前最大连续子序列和为 sum，结果为 ans
 如果 sum > 0，则说明 sum 对结果有增益效果，则 sum 保留并加上当前遍历数字
 如果 sum <= 0，则说明 sum 对结果无增益效果，需要舍弃，则 sum 直接更新为当前遍历数字
 每次比较 sum 和 ans的大小，将最大值置为ans，遍历结束返回结果
 时间复杂度：O(n)O(n)
 
 */
class Solution2 {
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
}


// 数组去重
class Solution3 {
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
}
var array = [0,0,1,1,1,2,2,3,3,4]
let count =  Solution3.removeDuplicates(&array)
print(count)
print(array)

// 二叉树的最大深度
/**
 - 采用层序遍历
 - root先入队， levelSize = 1
 - while 循环 队列不为空
    - 取出队列的头 head
    - levelSize -= 1
    - 如果head的left不为空， head的left入队
    - 如果head的right不为空，head的right入队
    - 如果 levelSize = 0， 说明一层遍历完成， height += 1
 */
class Solution {
    public class TreeNode {
        public var val: Int
        public var left: TreeNode?
        public var right: TreeNode?
        public init() { self.val = 0; self.left = nil; self.right = nil; }
        public init(_ val: Int) { self.val = val; self.left = nil; self.right = nil; }
        public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
            self.val = val
            self.left = left
            self.right = right
        }
    }
    func maxDepth(_ root: TreeNode?) -> Int {
        guard let root = root else {
            return 0
        }
        var height = 0
        var levelSize = 1
        var queue: [TreeNode] = []
        queue.append(root)
        while !queue.isEmpty {
            let head = queue.removeFirst()
            levelSize -= 1
            if head.left != nil {
                queue.append(head.left!)
            }
            if head.right != nil {
                queue.append(head.right!)
            }
            if levelSize == 0 { //
                levelSize = queue.count
                height += 1
            }
        }
        return height
    }
    
    
    /**
     给你一个二叉树的根节点 root ，判断其是否是一个有效的二叉搜索树。

     有效 二叉搜索树定义如下：

     节点的左子树只包含 小于 当前节点的数。
     节点的右子树只包含 大于 当前节点的数。
     所有左子树和右子树自身必须也是二叉搜索树
     
     
     - 采用中序遍历：左节点 根节点 右节点 ,中序遍历的作用是排序，如果是搜索二叉树的话，中序遍历的结果是一个升序
     - 所以要如果中序遍历的结果不是升序，那么就不是搜索二叉树
     */
    var pre: Int = .min
    func isValidBST(_ root: TreeNode?) -> Bool {
        guard let root = root else {
            return false
        }
        if !isValidBST(root.left) {
            return false
        }
        if root.val <= pre {
            return false
        }
        pre = root.val
        return isValidBST(root.right)
    }
    
}

