//
//  BinaryTreeAgri.swift
//  Algri
//
//  Created by lieon on 2021/9/24.
//

import Foundation

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
