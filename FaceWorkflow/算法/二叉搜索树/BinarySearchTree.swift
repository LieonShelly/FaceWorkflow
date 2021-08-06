//
//  BinarySearchTree.swift
//  FaceWorkflow
//
//  Created by lieon on 2021/8/4.
//

import Foundation

class BinarySearchTree<T: Comparable>: BinaryTree<T> {
    
    func remove(_ element: T) {
        let node = node(element)
        remove(node)
    }
    
    func contains(_ element: T) -> Bool {
       return node(element) != nil
    }
    
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
      /**
     # 删除节点 - 叶子节点(度为0，即子树数目为0)
     - 直接删除
        node = node.parent.left => node.parent.left = nil
        node == node.parent.right => node.parent.right = nil
        node.parent == nil -> root = nil
     # 删除节点 - 度为1的节点(即子树数目为1)
     - 用子节点替代原节点的位置
        - child 是 node.left 或者 child 是 node.right
     - 用child替代node的位置
        - 如果node是左子节点
          child.parent = node.parent
          node.parent.left = child
        - 如果node是右子节点
          child.parent = node.parent
          node.parent.right = child
     - 如果node是根节点
        root = child
        child.parent = nil
     # 删除节点 - 度为2的节点(即子树数目为2)
      - 先用前驱或者后继节点的值覆盖原节点的值
      - 然后删除相应的前驱或者后继节点
      - 如果一个节点的度为2，那么它的前驱，后继节点的度只可能为1和0
     */
    
    fileprivate func remove(_ node: Node<T>?) {
        guard var node = node else {
            return
        }
        size -= 1;
        if node.hasTwoChildren { // 度为2
           let preNode = predecessor(node)
            node.element = preNode!.element
            node = preNode!
        }
        // 删除Node节点（node的度必为1或者0）
        let replace = node.left != nil ? node.left : node.right
        
        if replace != nil { // node是度为1的节点
            // 更改parent
            replace?.parent = node.parent
            // 更改replace的left，right的指向
            if node.parent == nil { // node是度为1的节点，并且是根节点
               root = replace
            } else if node == node.parent?.left {
                node.parent?.left = replace
            } else { // if node == node.parent?.right
                node.parent?.right = replace
            }
        } else if node.parent == nil { // node是叶子结点且是根节点
            root = nil
        } else { // node是叶子节点，但不是根节点
            if node == node.parent?.right {
                node.parent?.right = nil
            } else { // node == node.parent?.left
                node.parent?.left = nil
            }
        }
    }
    
}
