//
//  BinarySearchTree.swift
//  FaceWorkflow
//
//  Created by lieon on 2021/8/4.
//

import Foundation

class TestTree {
    static func test() {
        let best = BinarySearchTree<Int>()
        [1, 2, 3, 4, 5, 6, 7, 8, 3].forEach { element in
            best.addElement(element)
        }
        best.inorderTraserval()
        
    }
}

class BinarySearchTree<T: Comparable> {
    class Node<T: Comparable> {
        var element: T
        var left: Node?
        var right: Node?
        var parent: Node?
        
        init(_ element: T, parent: Node? = nil) {
            self.element = element
            self.parent = parent
        }
    }
    fileprivate var size: Int = 0
    fileprivate var root: Node<T>?
    
    func addElement(_ element: T) {
        // 添加第一个节点
        if root == nil {
            root = Node(element, parent: nil)
            size += 1
        }
        // 添加的不是根节点
        //找到父节点
        var node = root
        var parent: Node<T>? = root
        var cmp = 0
        while node != nil {
            cmp = compare(element, element2: node!.element)
            parent = node
            if cmp > 0 {
                node = node!.right
            } else if cmp < 0 {
                node = node!.left
            } else {
                node?.element = element
                return
            }
        }
        guard let parent = parent else {
            return
        }
        let newNode = Node(element, parent: parent)
        // 看看插入到父节点那个位置
        if cmp > 0 {
            parent.right = newNode
        } else {
            parent.left = newNode
        }
    }
    
    // 1: element1> element2
    private func compare(_ element1: T, element2: T) -> Int {
        if element1 > element2 {
            return 1
        } else if element1 < element2 {
            return -1
        }
        return 0
    }
    
    /// 前序遍历： 根节点，左节点， 右节点
    func preorderTraserval() {
        preoOrder(root)
    }
    
    private func preoOrder(_ node: Node<T>?) {
        guard let node = node else {
            return
        }
        print(node.element)
        preoOrder(node.left)
        preoOrder(node.right)
    }
    
    /// 中序遍历: 左节点，根节点，右节点
    func inorderTraserval() {
        inorder(root)
    }
    
    /// 后序遍历： 左节点，右节点 根节点
    func postTraversal() {
        postorder(root)
    }
    
    func postorder(_ node: Node<T>?) {
        guard let node = node else {
            return
        }
        preoOrder(node.left)
        preoOrder(node.right)
        print(node.element)
    }
    
    /// 层序遍历
    func levelTravseral() {
        guard let root = root else {
            return
        }
        var queue: [Node<T>] = []
        queue.append(root)
        while !queue.isEmpty {
            let head = queue.removeFirst()
            print(head.element)
            if head.left != nil {
                queue.append(head.left!)
            }
            if head.right != nil {
                queue.append(head.right!)
            }
        }
    }
    
    
    fileprivate func inorder(_ node: Node<T>?) {
        guard let node = node else {
            return
        }
        inorder(node.left)
        print(node.element)
        inorder(node.right)
    }
}
