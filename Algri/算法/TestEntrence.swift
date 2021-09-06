//
//  TestEntrence.swift
//  FaceWorkflow
//
//  Created by lieon on 2021/8/6.
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
