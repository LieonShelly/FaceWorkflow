//
//  HashMap.swift
//  FaceWorkflow
//
//  Created by lieon on 2021/8/3.
//

import Foundation

/**
 
 # Swift中（其他编程语言类似）自定义对象要自定义hashcode，则要把Equatable，Hashable实现
 - Hashable是用于计算hashcode
 - Equatable是用来判断key是否相同
 - 根据key生成hashcode，找到对应的索引，进行添加，有可能会出现hashcode相同的情况
 - 当hash冲突时，会调用equals方法比较，对应索引的存储的值的key是否相同
 
 # 哈希冲突的解决方案
 - 开放定址法：按照一定规则向其他地址探测，直到遇到空桶
 - 再哈希法：设计多个哈希函数
 - 链地址法，比如通过链表将同一个index的元素串起来
 - 默认使用单向链表将元素(key value)串起来
 - 当哈希表容量>= 64且单向链表的节点数大于8时，单向链表转换为红黑树来存储元素
 - 思考：这里为什么使用单向链表
 - 因为每次都是从头节点开始遍历
 - 单向链表比双向链表少一个指针，可以节省内存空间
 
 # 哈希函数
 - 先生成key的哈希值（必须是整数）
 - 再让key的哈希值跟数组大小进行相关运算，生成一个索引值
 
 # 如何生成key的哈希值
 - key常见的类型: 整数，浮点数，字符串，自定义对象
 - 不同种类的key，哈希值的生成方式不一样，但是目标是一样的
 - 尽量让key的所有信息参与运算
 - 尽量让每一个key的哈希值是唯一的
 
 # 如何哈希值太大，溢出怎么办？
 - 溢出就溢出，不用管
 
 # hash表的本质是数组
 - key -> hashcode -> 索引
 - 通过key生成hashcode，hashcode生成索引
 */


class HashMap {
    fileprivate(set) var size: Int = 0
    
    func clear() {
        size = 0
    }
}
