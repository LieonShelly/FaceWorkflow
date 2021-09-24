//
//  LinkedListAgri.swift
//  Algri
//
//  Created by lieon on 2021/9/24.
//

import Foundation


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
