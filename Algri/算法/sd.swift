//
//  sd.swift
//  Algri
//
//  Created by lieon on 2021/11/4.
//

import Foundation


class StringAgri {
    
    // 无重复最长子串的长度
    func lengthOfLongestSubstring(_ str: String) -> Int {
        var set = Set<String.Element>.init()
        let str = str.map { $0 }
        let n = str.count
        var result = 0
        var i = 0
        var j = 0
        while i < n, j < n {
            if !set.contains(str[j]) {
                set.insert(str[j])
                j += 1
                result = max(result, j - i)
            } else {
                set.remove(str[i])
                i += 1
            }
        }
        return result
    }
    
    //NC137 表达式求值
    /**
     输入：
     "(2*(3-4))*5"
     返回值：

     */
    func solve ( _ s: String) -> Int {
         // write code here
        return 0
     }
    
    
    //最长回文子串
    // “回文串”是一个正读和反读都一样的字符串，比如“level”或者“noon”等等就是回文串。
    func getLongestPalindrome ( _ A: String,  _ n: Int) -> Int {
        var index = 0
        let strArr = Array(A)
        var len = 1
        while index < n {
            var right = index
            var left = index
            //过滤掉重复的
            while right + 1 < n, strArr[right] == strArr[right + 1] {
                right += 1
            }
            index = right + 1
            // 中心扩散
            while left > 0, right + 1 < n, strArr[left - 1] == strArr[right + 1]  {
                left -= 1
                right += 1
            }
            if right - left + 1 > len {
                len = right - left + 1
            }
        }
        return len
     }
    
    // 最长回文子串暴力法
    func getLongestPalindrome1 ( _ A: String,  _ n: Int) -> Int {
        var maxLen = 0
        for index in 0 ..< n {
            for j in index ..< n {
                let subStr = subStr(A, range: .init(uncheckedBounds: (lower: index, upper: j)))
                if subStr.count > maxLen {
                    var left: Int = 0
                    var right: Int = subStr.count - 1
                    let strArray = subStr.map { String($0) }
                    var isPair = true
                    for _ in 0 ..< strArray.count - 1 {
                        let leftStr = strArray[left]
                        let rightStr = strArray[right]
                        if leftStr.lowercased() != rightStr.lowercased() {
                            isPair = false
                        }
                        left += 1
                        right -= 1
                    }
                    if isPair {
                        maxLen = subStr.count
                    }
                }
            }
        }
        return maxLen
     }
    
    
    // 反转字符串
    func solve ( _ str: String) -> String {
          // write code here
        var strArray = Array(str)
        var leftIndex = 0
        var endIndex = str.count - 1
        while leftIndex < endIndex {
            let temp = strArray[leftIndex]
            strArray[leftIndex] = strArray[endIndex]
            strArray[endIndex] = temp
            leftIndex += 1
            endIndex -= 1
        }
        return String(strArray)
      }
    
    func reverseWords(_ chars: inout [String.Element], left: Int, right: Int) {
        var left = left
        var right = right
        while left < right {
            let temp = chars[left]
            chars[left] = chars[right]
            chars[right] = temp
            left += 1
            right -= 1
        }
    }
    
    // 翻转字符串 hello world => world hello
    func revertWords(_ str: String) -> String {
        guard !str.isEmpty else {
            return str
        }
        //消除多余的空格
        var newStr = Array(str)
        // 字符串的有效长度
        var length = 0
        // 用来存当前字符的位置
        var cur = 0
        // 前一个字符是否空格字符
        var space = true
        for (_, char) in str.enumerated() {
            if char != " " { // 非空字符
                newStr[cur] = char
                cur += 1
                space = false
            } else if space == false { // str[i]为空个字符。 str[i - 1]为非空字符
                newStr[cur] = " "
                cur += 1
                space = true
            }
        }
        length = space ? cur - 1: cur
        guard length > 0 else { return "" }
        //先将整个字符串反转
        var allChars = newStr.map { $0 }
        reverseWords(&allChars, left: 0, right: length - 1)
        let allRevertStr = String(allChars)
        var single = allRevertStr.map { $0 }
        //再反转每个单词
        var preIndex = -1
        for (index, strElement) in allRevertStr.enumerated() {
            guard String(strElement) == " " else { continue }
            reverseWords(&single, left: preIndex + 1, right: index - 1)
            preIndex = index
        }
        // 反转最后一个单词
        reverseWords(&single, left: preIndex + 1, right: length - 1)
        return String(single[single.startIndex ..< single.index(0, offsetBy: length)])
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


// LRU 缓存机制
class LRUCache {
    class DLinkedNode {
        var key: Int
        var value: Int
        var prev: DLinkedNode?
        var next: DLinkedNode?
        
        init(key: Int, value: Int) {
            self.key = key
            self.value = value
        }
    }
    var head: DLinkedNode?
    var tail: DLinkedNode?
    var size: Int = 0
    var capacity: Int = 0
    var cache: [Int: DLinkedNode] = [:]
    
    init(capacity: Int) {
        self.capacity = capacity
        head = DLinkedNode(key: -100, value: -100)
        tail = DLinkedNode(key: -100, value: -100)
        head?.next = tail
        tail?.prev = head
    }
    
    func addToHead(_ node: DLinkedNode?) {
        node?.prev = head
        node?.next = head?.next
        head?.next?.prev = node
        head?.next  = node
    }
    
    func moveToHead(_ node: DLinkedNode?) {
        removeNode(node)
        addToHead(node)
    }
    
    func removeNode(_ node: DLinkedNode?) {
        node?.prev?.next = node?.next
        node?.next?.prev = node?.prev
    }
    
    
    func removeTail() -> DLinkedNode? {
        let node = tail?.prev
        removeNode(node)
        return node
    }
    
    func get(_ key: Int) -> Int? {
        if !cache.keys.contains(key) {
            return -1
        }
        let node = cache[key]
        moveToHead(node)
        return node?.value
    }
    
    func put(key: Int, value: Int) {
        if !cache.keys.contains(key) {
            let node = DLinkedNode(key: key, value: value)
            cache[key] = node
            addToHead(node)
            size += 1
            if size > capacity {
                var removed = removeTail()
                if let index = cache.index(forKey: key) {
                    cache.remove(at: index)
                }
                size -= 1
                removed = nil
            }
        } else {
            let node = cache[key]
            node?.value = value
            moveToHead(node)
        }
    }
}

class ArrayAgri {
    
    func sortMerge(_ array: inout [Int]) {
        mergeSort(&array, 0, array.count - 1)
    }
    
    func mergeSort(_ array: inout [Int], _ begin: Int, _ end: Int) {
        if end == begin {
            return
        }
        let mid = (end + begin) >> 1
        mergeSort(&array, begin, mid)
        mergeSort(&array, mid + 1, end)
        mergeSortImp(&array, begin, mid, end)
    }
    
    func mergeSortImp(_ array: inout [Int], _ left: Int, _ center: Int, _ right: Int) {
        let length = right - left + 1
        var temp = (0 ..< length).map { _ in 0 }
        var _left = left
        var _right = center + 1
        var tempIndex = 0
        while _left <= center, _right <= right {
            if array[_left] <= array[_right] {
                temp[tempIndex] = array[_left]
                _left += 1
                tempIndex += 1
            } else {
                temp[tempIndex] = array[_right]
                _right += 1
                tempIndex += 1
            }
        }
        
        while _left <= center {
            temp[tempIndex] = array[_left]
            _left += 1
            tempIndex += 1
        }
        while _right <= right {
            temp[tempIndex] = array[_right]
            _right += 1
            tempIndex += 1
        }
        
        tempIndex = 0
        while tempIndex < length {
            array[tempIndex + left] = temp[tempIndex]
            tempIndex += 1
        }
    }
    
    func quickSort(_ array: inout [Int]) {
        quickSort(&array, 0, array.count - 1)
    }
    
    func quickSort(_ array: inout [Int], _ start: Int, _ end: Int) {
        // 获取轴点元素
        if start < end {
            let key = array[start]
            var i = start // 轴点元素的索引
            for j in start + 1 ... end {
                // 大于轴点元素放在右边，小于轴点元素放左边
                if key > array[j] {
                    i += 1 // 轴点元素的右边
                    swap(&array, j, i)
                }
            }
            // 先挪动
            array[start] = array[i]
            // 再办轴点元素放到指定位置
            array[i] = key
            // 对轴点元素左边进行排序
            quickSort(&array, start, i - 1)
            // 对轴点元素右边进行排序
            quickSort(&array, i + 1, end)
        }
    }
    
    func swap(_ array: inout [Int], _ start: Int, _ end: Int) {
        let temp = array[start]
        array[start] = array[end]
        array[end] = temp
    }
    // 插入排序
    func insertSort(_ array: inout [Int]) {
        for begin in 1 ..< array.count {
            var cur = begin
            while cur > 0,  array[cur] - (array[cur - 1] - 1) < 0 {
                let temp = array[cur]
                array[cur] = array[cur - 1]
                array[cur - 1] = temp
                cur -= 1
            }
        }
    }
    
    //给定数组和k，求数组中k个连续元素和的最大值
    func maxValueInArray(_ array: [Int], _ k: Int) -> Int {
        guard !array.isEmpty else { return 0}
        var arrs: [[Int]] = []
        var arr: [Int] = []
        var ans = 0
        for index in (0 ..< array.count ) {
            let num = array[index]
            arr.append(num)
            if arr.count >= k {
                arrs.append(arr)
                ans = max(ans, arr.reduce(0, +))
                arr.removeAll()
                arr.append(num)
            }
        }
        arrs.append(arr)
        ans = max(ans, arr.reduce(0, +))
        return ans
    }
    
    // 冒泡排序
    func bubbleSort1(_ array: inout [Int]) {
        guard array.count > 1 else {
            return
        }
        for end in (1 ... array.count - 1).reversed() {
            for begin in 1 ... end{
                if array[begin] - array[begin - 1] < 0 {
                    let temp = array[begin]
                    array[begin] = array[begin - 1]
                    array[begin - 1] = temp
                }
            }
        }
    }
    
    // 冒泡排序优化版本
    func bubbleSort2(_ array: inout [Int]) {
        var startIndex = 0
        for end in (startIndex ... array.count - 1).reversed() {
            var sortedIndex = 1
            for begin in 1 ... end {
                if array[begin] - array[begin - 1] < 0 {
                    let temp = array[begin]
                    array[begin] = array[begin - 1]
                    array[begin - 1] = temp
                    sortedIndex = begin
                }
            }
            startIndex = sortedIndex
        }
    }
    
    /**二分查找**/
    // 第一个错误版本
    func isBadVersion(_ n: Int) -> Bool { true }
    
    func firstBadVersion(_ n: Int) -> Int {
        var res = -1
        var left = 0
        var right = n
        while left <= right {
            let mid = left + (right - left) >> 1
            if isBadVersion(mid) {
                res = mid
                right = mid - 1
            } else {
                left = mid + 1
            }
        }
        return res
    }
    
    // x的平方根
    func mySqrt(_ x: Int) -> Int {
        var l = 0
        var r = x
        var ans = -1
        while l <= r {
            let mid = l + (r - l) >> 1
            if mid * mid <= x {
                ans = mid
                l = mid + 1
            } else {
                r = mid - 1
            }
        }
        return ans
    }
    /**动态规划相关*/
    // 爬楼梯
    func climbStairs(_ n: Int) -> Int {
        var dp: [Int] = Array<Int>.init(repeating: 0, count: n+1)
        if n <= 2{
            return n
        }
        dp[1] = 1
        dp[2] = 2
        for index in 3 ... n {
            dp[index] = dp[index - 1] + dp[index - 2]
        }
        return dp[n]
        
    }
    
    // 最大连续子序列和
    func maxSubArray(_ nums: [Int]) -> Int {
        var result = Int(-1e9)
        var sum = 0
        for num in nums {
            sum = max(sum + num, num)
            result = max(sum, result)
        }
        return result
    }
    
    // 最长上升子序列
    func lengthOfLIS(_ nums: [Int]) -> Int {
        var dp: [Int] = Array<Int>.init(repeating: 0, count: nums.count)
        var result = 1
        for i in 0 ..< nums.count {
            dp[i] = 1
            for j in 0 ..< i {
                if nums[j] < nums[i] {
                    dp[i] = max(dp[j] + 1, dp[i])
                }
            }
            result = max(result, dp[i])
        }
        return result
    }
    
    // 三角形最小路径和
    func minimumTotal(_ triangle:[[Int]]) -> Int {
        guard !triangle.isEmpty else { return 0 }
        if triangle.count == 1 {
            return triangle[0][0]
        }
        var dp = triangle.map { $0 }
        var res = Int(1e9)
        // 控制三角形层数, 从第二层开始
        for i in 1 ..< dp.count {
            // 控制每层元素
            for j in 0 ..< triangle[i].count {
                //元素为三角形每层最左元素时，上一步只能是其上层最左元素
                if j == 0 {
                    dp[i][j] = dp[i - 1][j] + triangle[i][j]
                    //元素为三角形每层最右元素时，上一步只能是其上层最右元素
                } else if j == i {
                    dp[i][j] = dp[i - 1][j - 1] + triangle[i][j]
                } else { //上一步可以是其上层坐标为j或j-1元素
                    dp[i][j] = min(dp[i - 1][j - 1], dp[i - 1][j]) + triangle[i][j]
                }
                if i == triangle.count - 1 {
                    res = min(res, dp[i][j])
                }
            }
        }
        return res
    }
    // 最小路径和
    func minPathSum(_ grid: [[Int]]) -> Int {
        var dp = grid
        for i in 0 ..< grid.count {
            for j in 0 ..< grid[i].count {
                if i == 0, j == 0 {
                    continue
                } else if i == 0 {
                    dp[i][j] = dp[i][j - 1] + grid[i][j]
                } else if j == 0 {
                    dp[i][j] = dp[i - 1][j] + grid[i][j]
                } else {
                    dp[i][j] = min(dp[i - 1][j], dp[i][j - 1]) + grid[i][j]
                }
            }
        }
        let len = dp.count
        return dp[len - 1][dp[0].count - 1]
    }
    
    // 两数和
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        var map: [Int: Int] = [:]
        var index = 0
        for num in nums {
            map[num] = index
            index += 1
        }
        for num in nums {
            let key = target - num
            if map[key] != nil {
                guard let num1 = map[num] else { continue }
                guard let num2 = map[key] else { continue }
                guard num1 != num2 else { continue }
                return num1 < num2 ? [num1, num2] : [num2, num1]
            }
        }
        return []
    }
    
    // 数组加1
    func plusOne(_ digits: [Int]) -> [Int] {
        var digits = digits
        let count = digits.count
        // 末位不为9直接加1
        if digits.last != 9 {
            digits[count - 1] += 1
            return digits
        }
        // 判断末位有几个9
        var index = count - 1
        var numCount = 0
        while(index >= 0) {
            if digits[index] == 9 {
                numCount += 1
            } else {
                break
            }
            index -= 1
        }
        // 全是9
        if numCount == count {
            return [1] + digits.map {_ in  0 }
        }
        // 部分为9, 清除9的位为0
        index = count - 1
        while (numCount > 0) {
            digits[index] = 0
            numCount -= 1
            index -= 1
        }
        digits[index] = digits[index] + 1
        return digits
    }
    
    // 原地删除
    func removeElement(_ nums: inout [Int], val: Int) -> Int {
        var left = 0
        var right = nums.count
        while left < right {
            if nums[left] == val {
                nums[left] = nums[right - 1]
                right -= 1
            } else {
                left += 1
            }
        }
        return left
    }
    
    // 买卖股票的最佳时机
    func maxProfit(_ prices: [Int]) -> Int {
        var minPrice = Int(1e9)
        var maxProfit = 0
        for price in prices {
            maxProfit = max(maxProfit, price - minPrice)
            minPrice = min(price, minPrice)
        }
        return maxProfit
    }
    
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
    
    func twoSum1(_ nums: [Int], _ target: Int) -> [Int] {
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
    func rotate1(_ nums: inout [Int], _ k: Int) {
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
    
    func rotate(_ nums: inout [Int], _ k: Int) {
        reverse(&nums, left: 0, right: nums.count - 1)
        reverse(&nums, left: 0, right: k % nums.count)
        reverse(&nums, left: k % nums.count + 1, right: nums.count - 1)
    }
    
    func reverse(_ nums: inout [Int], left: Int, right: Int) {
        var left = left
        var right = right
        while left < right {
            let temp = nums[left]
            nums[left] = nums[right]
            nums[right] = temp
            left += 1
            right -= 1
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
    func plusOne1(_ digits: [Int]) -> [Int] {
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
    // 最大和的连续子数组
    func maxSubArray2(_ nums: [Int]) -> Int {
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
    func lengthOfLIS1(_ nums: [Int]) -> Int {
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
        guard nums.count > 1 else { return nums.count }
        var left = nums[0]
        var leftIndex = 0
        for index in (0 ... nums.count - 1) {
            let num = nums[index]
            if num != left {
                nums[leftIndex] = left
                leftIndex += 1
                nums[leftIndex] = num
                left = num
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
    
    // 大数相乘
    func bigNumMulity(_ nums1: [Int], _ nums2: [Int]) -> [Int] {
        var result = Array.init(repeating: 0, count: nums1.count + nums2.count)
        // 先不考虑进位问题，根据竖式的乘法运算，num1额第位与num2中的第j位相乘，结果应该存放在结果的第i+j位上
        for i in 0 ..< nums1.count {
            for j in 0 ..< nums2.count {
                // 因为进位的问题，最终结果放置到第i+j+1位上
                result[i+j+1] += nums1[i] * nums2[j]
            }
        }
        // 单独处理进位问题
        var k = result.count - 1
        while k > 0 {
            if result[k] > 10 {
                result[k - 1] += result[k] / 10
                result[k] %= 10
            }
            k -= 1
        }
        return result
    }
    
}


class BinaryTreeAgri {
    // 二叉树的倒置
    func invert(_ node: TreeNode?) {
        guard let node = node else { return }
        let temp = node.left
        node.left = node.right
        node.right = temp
        invert(node.left)
        invert(node.right)
    }
    
    // 二叉树中的最大路径和
    func maxPathSum(_ root: TreeNode?) -> Int {
        var val = Int(-1e9)
        maxPathSum(root, &val)
        return val
    }
    
    func maxPathSum(_ node: TreeNode?, _ val: inout Int) -> Int {
        guard let node = node else {
            return 0
        }
        let left = maxPathSum(node.left, &val)
        let right = maxPathSum(node.right, &val)
        let lmr = node.val + max(0, left) + max(0, right)
        let ret = node.val + max(0, max(left, right))
        val = max(val, max(lmr, ret))
        return ret

    }
    
    
    // 二叉树根节点到叶子节点和为指定值的路径
    func pathSum ( _ root: TreeNode?,  _ sum: Int) -> [[Int]] {
          // write code here
        var rest: [[Int]] = []
        let path: [Int] = []
        prepathSum(root, sum, 0, &rest, path)
        return rest
      }
    
    
    func prepathSum( _ root: TreeNode?,  _ sum: Int, _ current: Int, _ res: inout [[Int]], _ path: [Int]) {
        guard let root = root else {
            return
        }
        var path: [Int] = path
        var current = current
        path.append(root.val)
        current = current + root.val
        if current == sum, root.left == nil, root.right == nil {
            res.append(path)
        }
        if root.left != nil {
            prepathSum(root.left!, sum, current, &res, path)
        }
        if root.right != nil {
            prepathSum(root.right!, sum, current, &res, path)
        }
       
    }
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
    //FIXME: 重点
    /* 找出二叉树的最近的公共祖先节点
     - 若root是是p1 和 q1的公共祖先节点，那么满足符合下面特性任意一条
     - 若 root 不等于 p1, q1,那么p1 ,q1在root的左右
     - 若root == p1 ==> q1在root的左或者右
     - 若 root == q1 ==> p1在root的左或者右
     */
    func lowestCommonAncestor(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
        if root == nil || root?.val == p?.val || root?.val == q?.val {
            return root
        }
        let left = lowestCommonAncestor(root?.left, p, q)
        let right = lowestCommonAncestor(root?.right, p, q)
        if left == nil, right == nil {
            return nil
        }
        if left == nil { return right }
        if right == nil { return left }
        return root
      }
    
    /// 找到最近的公共祖先
    func commonGrand(_ root: TreeNode?,  _ o1: Int,  _ o2: Int) -> TreeNode? {
        guard let root = root else {
            return root
        }
        if root.val == o1 || root.val == o2 {
            return root
        }
        let leftNode = commonGrand(root.left, o1, o2) // 从左子树中找到与o1或者o2相等的节点
        let rightNode = commonGrand(root.right, o1, o2)// 从右子树中找到与o1或者o2相等的节点
        if leftNode == nil, rightNode != nil { // 如果左子树中不存在与o1或者o2相等的节点，那么必然在右子树中
            return rightNode
        } else if rightNode == nil { // leftNode != NIL, 如果右子树为空，那么左子树为公共祖父节点
            return leftNode
        } else { /// 否则为root节点
            return root
        }
    }
    
    /// 实现二叉树的前中后遍历
    func threeOrders ( _ root: TreeNode?) -> [[Int]] {
        var preResults: [Int] = []
        preOrder(root) { val in
            preResults.append(val)
        }
        var inOrderResults: [Int] = []
        inOrder(root) { val in
            inOrderResults.append(val)
        }
        var postOrderResults: [Int] = []
        postOrder(root) { val in
            postOrderResults.append(val)
        }
        return [preResults, inOrderResults, postOrderResults]
    }
    
    func preOrder(_ root: TreeNode?, callback: ((Int) -> Void)) {
        guard let root = root else {
            return
        }
        let val = root.val
        callback(val)
        preOrder(root.left, callback: callback)
        preOrder(root.right, callback: callback)
    }
    
    func inOrder(_ root: TreeNode?, callback: ((Int) -> Void)) {
        guard let root = root else {
            return
        }
        inOrder(root.left, callback: callback)
        let val = root.val
        callback(val)
        inOrder(root.right, callback: callback)
    }
    
    
    func postOrder(_ root: TreeNode?, callback: ((Int) -> Void)) {
        guard let root = root else {
            return
        }
        postOrder(root.left, callback: callback)
        postOrder(root.right, callback: callback)
        let val = root.val
        callback(val)
    }
    
    // 二叉树的最大深度
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
    func levelOrder1(_ root: TreeNode?) -> [[Int]] {
        var queue: [TreeNode?] = []
        guard let root = root else {
            return []
        }
        var res: [[Int]] = []
        var level: [Int] = []
        queue.append(root)
        var levelSize = queue.count
        while !queue.isEmpty {
            let node = queue.removeFirst()
            levelSize = levelSize - 1
            if node?.left != nil {
                level.append(node!.left!.val)
                queue.append(node?.left)
            }
            if node?.right != nil {
                level.append(node!.right!.val)
                queue.append(node?.right)
            }
            if levelSize == 0 {
                levelSize = queue.count
                res.append(level)
                level.removeAll()
            }
        }
        return res
    }
    
    
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
    
    //生成一个搜索二叉树 采用二分查找，中序遍历，递归的方式实现
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
}


class IntegerAgri {
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
    
}


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
        /// 随机选择一个元素跟begin的位置交换 - 降低出现最坏时间复杂度的情况
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
