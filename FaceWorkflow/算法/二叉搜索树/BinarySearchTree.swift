//
//  BinarySearchTree.swift
//  FaceWorkflow
//
//  Created by lieon on 2021/8/4.
//

import Foundation

class TestTree {
    func test() {
        let best = BinarySearchTree()
        [1, 2, 3, 4, 5, 6, 7, 8, 3].forEach { element in
            best.addElement(element)
        }
    }
}

class BinarySearchTree {
    class Node {
        var element: Int
        var left: Node?
        var right: Node?
        var parent: Node?
        
        init(_ element: Int, parent: Node? = nil) {
            self.element = element
            self.parent = parent
        }
    }
    fileprivate var size: Int = 0
    fileprivate var root: Node?
    
    func addElement(_ element: Int) {
        // 添加第一个节点
        if root == nil {
            root = Node(element, parent: nil)
            size += 1
        }
        // 添加的不是根节点
        //找到父节点
        var node = root
        var parent: Node? = nil
        var cmp = 0
        while node != nil {
             cmp = compare(element, element2: node!.element)
            parent = node
            if cmp > 0 {
                node = node!.right
            } else if cmp < 0 {
                node = node!.left
            } else {
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
    
    // 大于0：element1 > element2
    private func compare(_ element1: Int, element2: Int) -> Int {
        return 0
    }
    
}
