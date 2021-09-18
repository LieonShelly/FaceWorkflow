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
    
    func isPalindrome(_ s: String) -> Bool {
        var left: Int = 0
        var right: Int = s.count - 1
        let strArray = s.map { String($0) }
        for _ in 0 ..< strArray.count - 1 {
            let leftStr = strArray[left]
            let rightStr = strArray[right]
            // 因为题中说了，只考虑字母和数字，所以不是字母和数字的先过滤掉
            while left < right, !isLetterOrDigest(leftStr) {
                left += 1
            }
            while left < right, !isLetterOrDigest(rightStr) {
                right -= 1
            }
            //后把两个字符变为小写，在判断是否一样，如果不一样，直接返回false
            if leftStr.lowercased() != rightStr.lowercased() {
                return false
            }
            left += 1
            right -= 1
        }
        return true
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
    
    func isLetterOrDigest(_ str: String) -> Bool {
        let reg = "^[a-zA-Z0-9]+$"
        let pre = NSPredicate(format: "SELF MATCHES %@", reg)
        if pre.evaluate(with: str) {
            return true
        } else{
            return false
        }
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
}


class SolutionLinkList {
    var head: ListNode?
    
    func deleteNode(_ node: ListNode?) {
        // 当前节点的值等于下一个节点的值
        node?.val = (node?.next!.val)!
        // 当前节点的next指向下一个节点下一个节点，相当于删除node的next节点
        node?.next = node?.next?.next
    }
    
    public class ListNode: Equatable {
        public var val: Int
        public var next: ListNode?
        public init(_ val: Int) {
            self.val = val
            self.next = nil
        }
        
        static func == (lhs: ListNode, rhs: ListNode) -> Bool {
            let lhspoint = Unmanaged<AnyObject>.passUnretained(lhs as AnyObject).toOpaque()
            let lhshashValue = lhspoint.hashValue
            
            let rhspoint = Unmanaged<AnyObject>.passUnretained(rhs as AnyObject).toOpaque()
            let rhshashValue = rhspoint.hashValue
            return lhshashValue == rhshashValue
        }
    }
   // [1,2,3,4,5]  n = 2 删除链表的倒数第n个结点
    func removeNthFromEnd(_ head: ListNode?, _ n: Int) -> ListNode? {
        var length = 0
        var node = head
        while node != nil {
            length += 1
            node = node?.next
        }
        let index = length - n
        if index == 0 {
            return head?.next
        }
        var preNode = head
        for _ in 0 ..< index - 1 {
            preNode = preNode?.next
        }
        preNode?.next = preNode?.next?.next
        return head
    }
    
    // 反转一个链表
    func reverseList(_ head: ListNode?) -> ListNode? {
        var current = head
        var pre: ListNode? = nil
        while current != nil {
            let temp = current?.next
            current?.next = pre
            pre = current
            current = temp
        }
        return pre
    }
    
    /// 合并两个有序链表
    func mergeTwoLists(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        if l1 == nil {
            return l2
        }
        if l2 == nil {
            return l1
        }
        var node1 = l1
        var node2 = l2
        let dummy = ListNode(0)
        var current: ListNode? = dummy
        while node1 != nil && node2 != nil {
            // 两个链表小的那个头放到新的链表的尾部，然后继续下一轮的遍历
            if node1!.val >= node2!.val {
                current?.next = node2
                node2 = node2?.next
            } else {
                current?.next = node1
                node1 = node1?.next
            }
            current = current?.next
        }
        // 把剩余的链表合并到新链表之后
        current?.next = node2 == nil ? node1 : node2
        return dummy.next
    }
    
    // 判断链表是回文链表 == 是否对称
    func isPalindrome(_ head: ListNode?) -> Bool {
        var index = 0
        var map: [Int: ListNode] = [:]
        var node = head
        while node != nil {
            map[index] = node
            node = node?.next
            index += 1
        }
        for (_, key) in map.keys.enumerated() {
            let firstIndex = key
            let secondIndex = map.keys.count - 1 - firstIndex
            if map[firstIndex]!.val != map[secondIndex]!.val {
                return false
            }
        }
        return true
    }
    
    func isPalindrome1(_ head: ListNode?) -> Bool {
        var fast = head
        var slow = head
        while fast != nil, fast?.next != nil {
            fast = fast?.next?.next
            slow = slow?.next
        }
        // 如果fast不为nil。表明链表的长度为奇数个
        if fast != nil {
            slow = slow?.next
        }
        fast = head
        slow = reverseList(slow)
        while slow != nil {
            if fast?.val != slow?.val {
                return false
            }
            fast = fast?.next
            slow = slow?.next
        }
        return true
    }
    
    func hasCycle(_ head: ListNode?) -> Bool {
        guard let head = head else {
            return false
        }
        // 快指针
        var fast: ListNode? = head
        // 慢指针
        var slow: ListNode? = head
        while fast != nil, fast?.next != nil {
            // 快指针每次走两步
            fast = fast?.next?.next
            // 慢指针每次走一步
            slow = slow?.next
            // 如果他们相遇，则有环
            if fast?.val == slow?.val {
                return true
            }
        }
        return false
    }
}

let head = SolutionLinkList.ListNode(1)
let node1 = SolutionLinkList.ListNode(2)
let node2 = SolutionLinkList.ListNode(2)
let node3 = SolutionLinkList.ListNode(1)
let node4 = SolutionLinkList.ListNode(5)
head.next = node1
node1.next = node2
node2.next = node3
//node3.next = node4

let head2 = SolutionLinkList.ListNode(1)
let node21 = SolutionLinkList.ListNode(2)
let node22 = SolutionLinkList.ListNode(3)
let node23 = SolutionLinkList.ListNode(4)
let node24 = SolutionLinkList.ListNode(5)
head2.next = node21
node21.next = node22
node22.next = node23
node23.next = node24


class SolutionSorted {
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
     字符串转数字
     - 去掉空格
     - 越界判断
     - 获取符号位
     - 获取数字部分
        - &* 溢出乘法 &+ 溢出加法
     */
    func myAtoi(_ s: String) -> Int {
        let chars = Array(s)
        // 去掉空格
        var index = 0
        let length = s.count
        while index < length, chars[index] == " " {
            index += 1
        }
        if index >= length {
            return 0
        }
        // 获取符号位
        var sign: Int32 = 1
        if chars[index] == "+" || chars[index] == "-" {
            if chars[index] == "-" {
                sign = -1
            }
            index += 1
        }
        // 获取数字部分
        var result: Int32 = 0
        var temp: Int32 = 0
        while index < length {
            if let num = Int32(String(chars[index])), num <= 9, num >= 0 {
                temp = result
                result = result &* 10  &+ num
                if result / 10 != temp {
                    if sign > 0 {
                        return Int(Int32.max)
                    } else {
                        return Int(Int32.min)
                    }
                }
                index += 1
            } else {
                break
            }
           
        }
        return Int(result * sign)
    }
    
    /**
     实现 strStr() 函数。

     给你两个字符串 haystack 和 needle ，请你在 haystack 字符串中找出 needle 字符串出现的第一个位置（下标从 0 开始）。如果不存在，则返回  -1 。

     - 滑动窗口 subStr[left ..< right] == str
     - 双指针 当两个字符不相等时，i = i - j + 1, j = 0, 重新开始比较
     
     */
    func strStr(_ haystack: String, _ needle: String) -> Int {
        if needle.isEmpty {
            return 0
        }
        var i = 0
        var j = 0
        let haystackArray = Array(haystack)
        let needleArray = Array(needle)
        while i < haystack.count, j < needle.count {
            if haystackArray[i] == needleArray[j] {
                i += 1;
                j += 1;
            } else {
                i = i - j + 1
                j = 0
            }
        }
        if j == needle.count {
            return i - j
        }
        return -1
    }
    
    func subStr(_ str: String, range: Range<Int>) -> String {
        let beginIndex = str.index(str.startIndex, offsetBy: range.lowerBound)
        let endIndex = str.index(str.startIndex, offsetBy: range.upperBound)
        return String(str[beginIndex ..< endIndex])
    }
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

var array: [CGFloat] = [11.0, 12.0, 13.0, 14.0, 33333.0].map { CGFloat($0)}



extension Array where Self.Element == CGFloat {
    /// 获取一个数字数组中的最小区间
    func findRange(_ num: CGFloat) -> [Int] {
        guard let maxValue = filter({ $0 >= num }).first else { return [] }
        guard let minValue = filter({ $0 <= num}).last else { return [] }
        guard let minIndex = firstIndex(of: minValue) else { return [] }
        guard let maxIndex = firstIndex(of: maxValue) else { return [] }
        return [minIndex, maxIndex]
    }
}

print(array.findRange(13.4))


