//
//  BinaryTree.swift
//  FaceWorkflow
//
//  Created by lieon on 2021/8/6.
//

import Foundation

class BinaryTree<T: Comparable> {
    var size: Int = 0
    var root: Node<T>?
    
    class Node<T: Comparable>: NSObject {
        var element: T
        var left: Node?
        var right: Node?
        var parent: Node?
        
        init(_ element: T, parent: Node? = nil) {
            self.element = element
            self.parent = parent
        }
        
        var isLeaf: Bool {
            return left != nil && right == nil
        }
        
        var hasTwoChildren: Bool {
            return left != nil && right != nil
        }
    }
    
    func clear() {
        size = 0
        root = nil
    }
    
    // 1: element1> element2
    func compare(_ element1: T, element2: T) -> Int {
        if element1 > element2 {
            return 1
        } else if element1 < element2 {
            return -1
        }
        return 0
    }
    
    /// 前序遍历： 根节点，左节点， 右节点
    func preorderTraserval(_ visitor: Visitor<T>) {
        preoOrder(root, visitor: visitor)
    }
    
    func preoOrder(_ node: Node<T>?, visitor: Visitor<T>) {
        guard let node = node else {
            return
        }
        if visitor.stop {
            return
        }
        visitor.stop = visitor.visitor(node.element)
        preoOrder(node.left, visitor: visitor)
        preoOrder(node.right, visitor: visitor)
    }
    
    /// 中序遍历: 左节点，根节点，右节点
    func inorderTraserval(_ visitor: Visitor<T>) {
        inorder(root, visitor: visitor)
    }
    
    func inorder(_ node: Node<T>?, visitor: Visitor<T>) {
        guard let node = node else {
            return
        }
        if visitor.stop {
            return
        }
        inorder(node.left, visitor: visitor)
        if visitor.stop {
            return
        }
        visitor.stop = visitor.visitor(node.element)
        inorder(node.right, visitor: visitor)
    }
    
    /// 后序遍历： 左节点，右节点 根节点
    func postTraversal(_ visitor: Visitor<T>) {
        postorder(root, visitor: visitor)
    }
    
    func postorder(_ node: Node<T>?, visitor: Visitor<T>) {
        guard let node = node else {
            return
        }
        if visitor.stop {
            return
        }
        postorder(node.left, visitor: visitor)
        postorder(node.right, visitor: visitor)
        if visitor.stop {
            return
        }
        visitor.stop = visitor.visitor(node.element)
    }
    
    /// 层序遍历
    func levelTravseral(_ visitor: Visitor<T>) {
        guard let root = root else {
            return
        }
        var queue: [Node<T>] = []
        queue.append(root)
        while !queue.isEmpty {
            let head = queue.removeFirst()
            visitor.stop = visitor.visitor(head.element)
            let stop = visitor.stop
            if stop {
                return
            }
            if head.left != nil {
                queue.append(head.left!)
            }
            if head.right != nil {
                queue.append(head.right!)
            }
        }
    }
    
    
    /**获取前驱节点: 中序遍历的前一个节点，一定是它的左子树的最大节点
     - 如果 node.left != nil， 则 predecessor = node.left.right.right,终止条件为 right 为 nil
     - 如果 node.left == nil && node.parent != nil， 则predecessor = node.parent.parent 终止条件为 node在parent的右子树中
     - node.left == nil && node.parent == nil, 则没有前驱节点
     */
    
    func predecessor(_ node: Node<T>?) -> Node<T>? {
        guard var node = node else {
            return nil
        }
        if node.left != nil {
            // node.left != nil， 则 predecessor = node.left.right.right,终止条件为 right 为 nil
            var p = node.left!
            while p.right != nil {
                p = p.right!
            }
            return p;
        }
        // 从父节点，祖父节点中寻找前驱节点
        while node.parent != nil, node == node.parent!.left {
            node = node.parent!
        }
        
        // node.parent == nil
        // node = node.parent.right
        
        return node.parent
    }
    
    /**
     后继节点：中序遍历的后一个节点, 与前驱节点对称的
     */
    func successor(_ node: Node<T>?) -> Node<T>? {
        guard var node = node else {
            return nil
        }
        if node.right != nil {
            var p = node.right!
            while p.left != nil {
                p = p.left!
            }
            return p;
        }
        // 从父节点，祖父节点中寻找前驱节点
        while node.parent != nil, node == node.parent!.right {
            node = node.parent!
        }
        
        return node.parent
    }
    
    // 翻转二叉树
    func revert(_ node: Node<T>?) {
        guard let node = node else {
            return
        }
        let temp = node.left
        node.left = node.right
        node.right  = temp
        
        revert(node.left)
        revert(node.right)
    }
    
    func toString() -> String {
        toString(root, str: "", prefix: "")
        return ""
    }
    
    fileprivate  func toString(_ node: Node<T>?, str: String, prefix: String) {
        guard let node = node else {
            return
        }
        var str = str
        str.append(prefix)
        str.append("\(node.element)")
        str.append("\n")
        print(str)
        toString(node.left, str: str, prefix: "--L--")
        toString(node.right, str: str, prefix: "--R--")
    }
    
    /// 二叉树的高度 递归的方式
    func height1() -> Int {
        return height1(root)
    }
    
    fileprivate func height1(_ node: Node<T>?) -> Int {
        guard let node = node else {
            return 0
        }
        return  1 + max(height1(node.left), height1(node.right))
    }
    
    /// 二叉树的高度：迭代的方式
    func height() -> Int {
        guard let root = root else {
            return 0
        }
        var height = 0
        var levelSize = 1
        var queue: [Node<T>] = []
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
     判断是否是完全二叉树
     - 如果树不为空，开始层序遍历二叉树
     - 如果node.left != null && node.right != null. 将node.left, node.right 按顺序入队
     - 如果node.left == null && node.right != null, 返回false
     - node.left != null && node.right != null
     - node.left != null && nodel.right == null 或者 node.left == null && node.right == null，那么后面遍历的节点都应该为叶子节点，才是完全二叉树，否则返回false
     */
    
    func isComplete() -> Bool {
        guard let root = root else {
            return false
        }
        var queue: [Node<T>] = []
        queue.append(root)
        var leaf = false
        while !queue.isEmpty {
            let head = queue.removeFirst()
            if leaf && !head.isLeaf { // 要求是叶子节点，但是这个节点不是叶子节点
                return false
            }
            if head.left != nil {
                queue.append(head.left!)
            } else if head.right != nil {
                // head.left == nil && head.right != ni
                return false
            }
            if head.right != nil {
                queue.append(head.right!)
            } else {
                leaf = true
            }
        }
        return true
    }
    
    func node(_ element: T) -> Node<T>? {
        var node = root
        while node != nil {
            let cmp = compare(element, element2: node!.element)
            if cmp == 0 {
                return node
            } else if cmp > 1 {
                node = node?.right
            } else {
                node = node?.left
            }
        }
        return nil
    }
}

class Visitor<T: Comparable> {
    var stop: Bool = false
    fileprivate var ireatorHandler: ((T) -> Bool)
    
    init(_ handler: @escaping ((T) -> Bool)) {
        self.ireatorHandler = handler
    }
    
    func visitor(_ element: T) -> Bool {
        return ireatorHandler(element)
    }
}
