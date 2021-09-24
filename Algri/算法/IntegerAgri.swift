//
//  IntegerAgri.swift
//  Algri
//
//  Created by lieon on 2021/9/24.
//

import Foundation

class IntegerAgri {
    /**
     整数反转
     输入：x = 123
     输出：321
     示例 2：
     
     输入：x = -123
     输出：-321
     示例 3：
     
     输入：x = 120
     输出：21
     示例 4：
     
     输入：x = 0
     输出：0
     
     */
    func reverse(_ x: Int) -> Int {
        var x = x
        var res = 0
        while x != 0 {
            let t = x % 10
            res = res * 10 + t
            x = x / 10
        }
        if res > Int32.max || res < Int32.min {
            return 0
        }
        return res
    }
    
}
