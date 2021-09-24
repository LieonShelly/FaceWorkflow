//
//  StringAgri.swift
//  Algri
//
//  Created by lieon on 2021/9/24.
//

import Foundation


class StringAgri {
    
    func isLetterOrDigest(_ str: String) -> Bool {
        let reg = "^[a-zA-Z0-9]+$"
        let pre = NSPredicate(format: "SELF MATCHES %@", reg)
        if pre.evaluate(with: str) {
            return true
        } else{
            return false
        }
    }
    
    
    
    /**
     给定一个字符串，找到它的第一个不重复的字符，并返回它的索引。如果不存在，则返回 -1。
     
     s = "leetcode"
     返回 0
     
     s = "loveleetcode"
     返回 2
     */
    func firstUniqChar(_ s: String) -> Int {
        var map: [String : Int] = [:]
        let strs = s.map { String($0)}
        for str in strs {
            if map.keys.contains(str) {
                let value = map[str]!
                map[str] = value + 1
            } else {
                map[str] = 1
            }
        }
        for (index, str) in strs.enumerated() {
            if map[str] == 1 {
                return index
            }
        }
        return -1
    }
    
    /**
     给定两个字符串 s 和 t ，编写一个函数来判断 t 是否是 s 的字母异位词。
     注意：若 s 和 t 中每个字符出现的次数都相同，则称 s 和 t 互为字母异位词。
     
     示例 1:
     
     输入: s = "anagram", t = "nagaram"
     输出: true
     示例 2:
     
     输入: s = "rat", t = "car"
     输出: false
     
     */
    func isAnagram(_ s: String, _ t: String) -> Bool {
        var mapS: [String : Int] = [:]
        var mapT: [String : Int] = [:]
        guard s.count == t.count else {
            return false
        }
        for str in zip(s, t) {
            if mapS.keys.contains(String(str.0)) {
                let value = mapS[String(str.0)]!
                mapS[String(str.0)] = value + 1
            } else {
                mapS[String(str.0)] = 1
            }
            if mapT.keys.contains(String(str.1)) {
                let value = mapT[String(str.1)]!
                mapT[String(str.1)] = value + 1
            } else {
                mapT[String(str.1)] = 1
            }
        }
        for str in s {
            if mapS[String(str)] != mapT[String(str)] {
                return false
            }
        }
        return true
    }
    
    func isPalindrome(_ s: String) -> Bool {
        var left: Int = 0
        var right: Int = s.count - 1
        let strArray = s.map { String($0) }
        for _ in 0 ..< strArray.count - 1 {
            let leftStr = strArray[left]
            let rightStr = strArray[right]
            // 因为题中说了，只考虑字母和数字，所以不是字母和数字的先过滤掉
            while left < right, !isLetterOrDigest(leftStr) {
                left += 1
            }
            while left < right, !isLetterOrDigest(rightStr) {
                right -= 1
            }
            //后把两个字符变为小写，在判断是否一样，如果不一样，直接返回false
            if leftStr.lowercased() != rightStr.lowercased() {
                return false
            }
            left += 1
            right -= 1
        }
        return true
    }
    // 反转字符串
    // 输入：["h","e","l","l","o"]
    // 输出：["o","l","l","e","h"]
    /*
     输入：
     ["A"," ","m","a","n",","," ","a"," ","p","l","a","n",","," ","a"," ","c","a","n","a","l",":"," ","P","a","n","a","m","a"]
     输出：
     ["a","m","a","n","a","P"," ",":","l","a","n","a","c"," "," ","a",",","n","a","l","p"," ","a"," ",",","n","a","m"," ","A"]
     预期结果：
     ["a","m","a","n","a","P"," ",":","l","a","n","a","c"," ","a"," ",",","n","a","l","p"," ","a"," ",",","n","a","m"," ","A"]
     */
    func reverseString(_ s: inout [Character]) {
        let endIndx = (s.count - 1) / 2
        for index in 0 ... endIndx {
            let temp = s [s.count - 1 - index]
            s[s.count - 1 - index] = s[index]
            s[index] = temp
        }
    }
    /**
     字符串转数字
     - 去掉空格
     - 越界判断
     - 获取符号位
     - 获取数字部分
     - &* 溢出乘法 &+ 溢出加法
     */
    func myAtoi(_ s: String) -> Int {
        let chars = Array(s)
        // 去掉空格
        var index = 0
        let length = s.count
        while index < length, chars[index] == " " {
            index += 1
        }
        if index >= length {
            return 0
        }
        // 获取符号位
        var sign: Int32 = 1
        if chars[index] == "+" || chars[index] == "-" {
            if chars[index] == "-" {
                sign = -1
            }
            index += 1
        }
        // 获取数字部分
        var result: Int32 = 0
        var temp: Int32 = 0
        while index < length {
            if let num = Int32(String(chars[index])), num <= 9, num >= 0 {
                temp = result
                result = result &* 10  &+ num
                if result / 10 != temp {
                    if sign > 0 {
                        return Int(Int32.max)
                    } else {
                        return Int(Int32.min)
                    }
                }
                index += 1
            } else {
                break
            }
            
        }
        return Int(result * sign)
    }
    
    /**
     实现 strStr() 函数。
     
     给你两个字符串 haystack 和 needle ，请你在 haystack 字符串中找出 needle 字符串出现的第一个位置（下标从 0 开始）。如果不存在，则返回  -1 。
     
     - 滑动窗口 subStr[left ..< right] == str
     - 双指针 当两个字符不相等时，i = i - j + 1, j = 0, 重新开始比较
     
     */
    func strStr(_ haystack: String, _ needle: String) -> Int {
        if needle.isEmpty {
            return 0
        }
        var i = 0
        var j = 0
        let haystackArray = Array(haystack)
        let needleArray = Array(needle)
        while i < haystack.count, j < needle.count {
            if haystackArray[i] == needleArray[j] {
                i += 1;
                j += 1;
            } else {
                i = i - j + 1
                j = 0
            }
        }
        if j == needle.count {
            return i - j
        }
        return -1
    }
    
    func subStr(_ str: String, range: Range<Int>) -> String {
        let beginIndex = str.index(str.startIndex, offsetBy: range.lowerBound)
        let endIndex = str.index(str.startIndex, offsetBy: range.upperBound)
        return String(str[beginIndex ..< endIndex])
    }
}
