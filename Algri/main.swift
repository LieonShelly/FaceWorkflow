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
            return true
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
    
    /**
     给定一个二叉树，检查它是否是镜像对称的。
     - 判断二叉树是否镜像
        - 左右先入队
        - 队列每次出队两个left right， 比较大小
        - left.left, right.right 入队； left.right, right.left入队

     */
    func isSymmetric(_ root: TreeNode?) -> Bool {
        guard let root = root else {
            return true
        }
        var queue: [TreeNode?] = []
        queue.append(root.left)
        queue.append(root.right)
        while !queue.isEmpty {
            let left = queue.removeFirst()
            let right = queue.removeFirst()
            if left == nil && right == nil {
                continue
            }
            if left == nil || right == nil {
                return false
            }
            if left?.val != right?.val {
                return false
            }
            queue.append(left?.left)
            queue.append(right?.right)
            queue.append(left?.right)
            queue.append(right?.left)
        }
        return true
    }
    
    // 层序遍历
    func levelOrder(_ root: TreeNode?) -> [[Int]] {
        guard let root = root else {
            return []
        }
        var queue: [TreeNode] = []
        queue.append(root)
        var levelSize = 1
        var levelVal: [Int] = []
        var all: [[Int]] = []
        while !queue.isEmpty {
            let head = queue.removeFirst()
            levelVal.append(head.val)
            levelSize -= 1
            if head.left != nil {
                queue.append(head.left!)
            }
            if head.right != nil {
                queue.append(head.right!)
            }
            if levelSize == 0 { // 一层结束
                levelSize = queue.count
                all.append(levelVal)
                levelVal.removeAll()
            }
        }
        return all
    }
    
    // 采用二分查找，中序遍历，递归的方式实现
    func sortedArrayToBST(_ nums: [Int]) -> TreeNode? {
        guard !nums.isEmpty else {
            return nil
        }
        return createBSTNode(nums.sorted(), startIdx: 0, endIdx: nums.count - 1)
    }
    
    func createBSTNode(_ nums: [Int], startIdx: Int, endIdx: Int) -> TreeNode? {
        if startIdx > endIdx {
            return nil
        }
        let mid = (startIdx + endIdx) >> 1
        let root = TreeNode(nums[mid])
        root.left = createBSTNode(nums, startIdx: startIdx, endIdx: mid - 1)
        root.right = createBSTNode(nums, startIdx: mid + 1, endIdx: endIdx)
        return root
    }
    
    // 反转字符串
    // 输入：["h","e","l","l","o"]
    // 输出：["o","l","l","e","h"]
    /*
    输入：
    ["A"," ","m","a","n",","," ","a"," ","p","l","a","n",","," ","a"," ","c","a","n","a","l",":"," ","P","a","n","a","m","a"]
    输出：
    ["a","m","a","n","a","P"," ",":","l","a","n","a","c"," "," ","a",",","n","a","l","p"," ","a"," ",",","n","a","m"," ","A"]
    预期结果：
    ["a","m","a","n","a","P"," ",":","l","a","n","a","c"," ","a"," ",",","n","a","l","p"," ","a"," ",",","n","a","m"," ","A"]
 */
    func reverseString(_ s: inout [Character]) {
        let endIndx = (s.count - 1) / 2
        for index in 0 ... endIndx {
            let temp = s [s.count - 1 - index]
            s[s.count - 1 - index] = s[index]
            s[index] = temp
        }
    }
    
    /**
     整数反转
     输入：x = 123
     输出：321
     示例 2：

     输入：x = -123
     输出：-321
     示例 3：

     输入：x = 120
     输出：21
     示例 4：

     输入：x = 0
     输出：0

     */
    func reverse(_ x: Int) -> Int {
        var x = x
        var res = 0
        while x != 0 {
            let t = x % 10
            res = res * 10 + t
            x = x / 10
        }
        if res > Int32.max || res < Int32.min {
            return 0
        }
        return res
    }
    
    /**
     给定一个字符串，找到它的第一个不重复的字符，并返回它的索引。如果不存在，则返回 -1。

     s = "leetcode"
     返回 0

     s = "loveleetcode"
     返回 2
     */
    func firstUniqChar(_ s: String) -> Int {
        var map: [String : Int] = [:]
        let strs = s.map { String($0)}
        for str in strs {
            if map.keys.contains(str) {
                let value = map[str]!
                map[str] = value + 1
            } else {
                map[str] = 1
            }
        }
        for (index, str) in strs.enumerated() {
            if map[str] == 1 {
                return index
            }
        }
        return -1
    }
    
    /**
     给定两个字符串 s 和 t ，编写一个函数来判断 t 是否是 s 的字母异位词。
     注意：若 s 和 t 中每个字符出现的次数都相同，则称 s 和 t 互为字母异位词。

     示例 1:

     输入: s = "anagram", t = "nagaram"
     输出: true
     示例 2:

     输入: s = "rat", t = "car"
     输出: false

     */
    func isAnagram(_ s: String, _ t: String) -> Bool {
        var mapS: [String : Int] = [:]
        var mapT: [String : Int] = [:]
        guard s.count == t.count else {
            return false
        }
        for str in zip(s, t) {
            if mapS.keys.contains(String(str.0)) {
                let value = mapS[String(str.0)]!
                mapS[String(str.0)] = value + 1
            } else {
                mapS[String(str.0)] = 1
            }
            if mapT.keys.contains(String(str.1)) {
                let value = mapT[String(str.1)]!
                mapT[String(str.1)] = value + 1
            } else {
                mapT[String(str.1)] = 1
            }
        }
        for str in s {
            if mapS[String(str)] != mapT[String(str)] {
                return false
            }
        }
        return true
    }
    
}

let result = Solution().isAnagram("rat", "car")
print(result)


