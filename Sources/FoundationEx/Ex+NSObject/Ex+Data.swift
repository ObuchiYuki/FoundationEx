//
//  Ex+Data.swift
//  CoreUtil
//
//  Created by yuki on 2021/09/10.
//  Copyright © 2021 yuki. All rights reserved.
//

import Foundation

extension Data {
    @inlinable public init?(hexString: String) {
        let len = hexString.count / 2
        var data = Data(capacity: len)
        var i = hexString.startIndex
        for _ in 0..<len {
            let j = hexString.index(i, offsetBy: 2)
            let bytes = hexString[i..<j]
            if var num = UInt8(bytes, radix: 16) {
                data.append(&num, count: 1)
            } else {
                return nil
            }
            i = j
        }
        self = data
    }
}
