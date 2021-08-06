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
        [64, 78, 44, 34, 53, 24, 85, 69, 38, 56, 49, 29, 11].forEach { element in
            best.addElement(element)
        }
        best.postTraversal(Visitor { element in
            print(element)
            return false
        })
        best.remove(64)
        best.postTraversal(Visitor { element in
            print(element)
            return false
        })
    }
}

class BinarySearchTree<T: Comparable> {
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
    
    /**获取前驱节点: 中序遍历的前一个节点，一定是它的左子树的最大节点
     - 如果 node.left != nil， 则 predecessor = node.left.right.right,终止条件为 right 为 nil
     - 如果 node.left == nil && node.parent != nil， 则predecessor = node.parent.parent 终止条件为 node在parent的右子树中
     - node.left == nil && node.parent == nil, 则没有前驱节点
     */
    
    fileprivate func predecessor(_ node: Node<T>?) -> Node<T>? {
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
    fileprivate func successor(_ node: Node<T>?) -> Node<T>? {
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
    
    func remove(_ element: T) {
        let node = node(element)
        remove(node)
    }
    
    fileprivate func node(_ element: T) -> Node<T>? {
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
    
    func clear() {
        size = 0
        root = nil
    }
    
    func contains(_ element: T) -> Bool {
       return node(element) != nil
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
