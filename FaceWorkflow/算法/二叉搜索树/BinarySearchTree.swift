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
        [63, 96, 93, 32, 46, 57, 40, 53, 8, 98].forEach { element in
            best.addElement(element)
        }
        best.postTraversal(Visitor { element in
            print(element)
            return element == 8
        })
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
    func preorderTraserval(_ visitor: Visitor<T>) {
        preoOrder(root, visitor: visitor)
    }
    
    private func preoOrder(_ node: Node<T>?, visitor: Visitor<T>) {
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
    
    
    fileprivate func inorder(_ node: Node<T>?, visitor: Visitor<T>) {
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
