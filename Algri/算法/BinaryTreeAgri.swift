//
//  BinaryTreeAgri.swift
//  Algri
//
//  Created by lieon on 2021/9/24.
//

import Foundation

class BinaryTreeAgri {
    
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
    func lowestCommonAncestor ( _ root: TreeNode?,  _ o1: Int,  _ o2: Int) -> Int {
        return compareNodeForeCommonAncestor(root, o1, o2)?.val ?? -1
    }
    
    func compareNodeForeCommonAncestor( _ root: TreeNode?,  _ o1: Int,  _ o2: Int) -> TreeNode? {
        // 如果root为空，或者root为o1、o2中的一个，则它们的最近公共祖先就为root
        guard let root1 = root else {
            return root
        }
        if root1.val == o1 || root1.val == o2 {
            return root1
        }
        // 递归遍历左子树，只要在左子树中找到了o1或o2，则先找到谁就返回谁
        let leftNode = compareNodeForeCommonAncestor(root1.left, o1, o2)
        // 递归遍历右子树，只要在右子树中找到了o1或o2，则先找到谁就返回谁
        let rightNode = compareNodeForeCommonAncestor(root1.right, o1, o2)
        // 如果在左子树中o1和o2都找不到，则o1和o2一定都在右子树中，右子树中先遍历到的那个就是最近公共祖先（一个节点也可以是它自己的祖先）
        if leftNode == nil {
            return rightNode
        } else if rightNode == nil { // 否则，如果left不为空，在左子树中有找到节点（o1或o2），这时候要再判断一下右子树中的情况，
            // 如果在右子树中，o1和o2都找不到，则 o1和o2一定都在左子树中，左子树中先遍历到的那个就是最近公共祖先（一个节点也可以是它自己的祖先）
            return leftNode
        } else {
            return root1
        }
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
}
