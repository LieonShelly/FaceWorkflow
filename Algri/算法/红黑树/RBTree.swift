//
//  RBTree.swift
//  Algri
//
//  Created by lieon on 2021/9/14.
//

import Foundation
/**
 红黑树必须满足以下五条性质
 - 节点是RED或者Black
 - 根节点是Black
 - 叶子节点（外部节点，空节点）都是BLACK
 - RED节点的子节点都是BLACK
    - RED节点的parent都是BLACK
    - 从根节点到叶子结点的所有路径上不能有2个连续的RED节点
 - 从任一节点到叶子节点的所有路径都包含相同数据的BLACK节点
 */
