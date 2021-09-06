//
//  AVLTree.swift
//  FaceWorkflow
//
//  Created by lieon on 2021/8/6.
//

import Foundation
/**
 #
 - 二叉树在添加时，有可能退化为链表
 - 删除节点也可能会导致二叉搜索树退化为链表
 # AVL树
 - 平衡因子：某结点的左右子树的高度
 - AVL树的特定
    - 每个节点的平衡因子的绝对值 <= 1
    - 搜索，添加，删除的时间复杂度是o(logn)
 */

class AVNode<T: Comparable>: BinaryTree<T>.Node<T> {
    var height = 1
    
    override init(_ element: T, parent: BinaryTree<T>.Node<T>? = nil) {
        super.init(element, parent: parent)
    }
    
    func balanceFactor() -> Int {
        let leftH = left == nil ? 0 : (left as! AVNode<T>).height
        let rightH = right == nil ? 0 : (right as! AVNode<T>).height
        return leftH - rightH
    }
    
    func updateHeight() {
        let leftH = left == nil ? 0 : (left as! AVNode<T>).height
        let rightH = right == nil ? 0 : (right as! AVNode<T>).height
        height = 1 + max(leftH, rightH)
    }
    
    func tallerChild() -> BinaryTree<T>.Node<T>? {
        let leftH = left == nil ? 0 : (left as! AVNode<T>).height
        let rightH = right == nil ? 0 : (right as! AVNode<T>).height
        if leftH > rightH {
            return left
        }
        if leftH < rightH {
            return right
        }
        return isLeftChild ? left : right
    }
    
    
}

class AVLTree<T: Comparable>: BinarySearchTree<T> {
   
    override func afterAdd(_ node: BinaryTree<T>.Node<T>?) {
        var node = node?.parent
        repeat {
            if isBalanced(node) {
                updateHeight(node)
            } else {
                rebalance1(node)
                break
            }
            node = node?.parent
        } while node != nil

    }
    
    func isBalanced(_ node: Node<T>?) -> Bool {
        return true
    }
    
    func updateHeight(_ node: Node<T>?) {
        (node as? AVNode<T>)?.updateHeight()
    }
    
    
    /// 恢复平衡
    /// - Parameter grand: 高度最低的那个不平衡节点
    func rebalance1(_ grand: Node<T>?) {
       guard  let grand = grand,
              let parent = (grand as? AVNode<T>)?.tallerChild(),
             let node = (parent as? AVNode<T>)?.tallerChild() else {
            return
       }
        if parent.isLeftChild { // L
            if node.isLeftChild { // LL
                rotateRight(grand)
            } else { // LR
                rotateLeft(parent)
                rotateRight(grand)
            }
        } else { // R
            if node.isLeftChild { // RL
                rotateRight(parent)
                rotateLeft(grand)
            } else { // RR
                rotateLeft(grand)
            }
        }
    }
    
    func rotateLeft(_ grand: Node<T>) {
        let parent = grand.right
        let child = parent?.left
        grand.right = child
        parent?.left = grand
        afterRotate(grand, parent: parent, child: child)
    }
    
    func rotateRight(_ grand: Node<T>) {
        let parent = grand.left
        let child = parent?.right
        grand.left = child
        parent?.right = grand
        afterRotate(grand, parent: parent, child: child)
    }
    
    private func afterRotate(_ grand: Node<T>?, parent: Node<T>?, child: Node<T>?) {
        // 让parent陈伟子树的根节点
        parent?.parent = grand?.parent
        if grand?.isLeftChild ?? false {
            grand?.parent?.left = parent
        } else if grand?.isRightChild ?? false {
            grand?.parent?.right = parent
        } else {
            root = parent
        }
        // 更新child中的parent
        if child != nil {
            child?.parent = grand
        }
        // 更新grand的parent
        grand?.parent = parent
        // 更新高度
        updateHeight(grand)
        updateHeight(parent)
    }
    
}
