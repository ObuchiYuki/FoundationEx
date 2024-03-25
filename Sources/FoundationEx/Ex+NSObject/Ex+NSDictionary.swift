//
//  Ex+NSDictionary.swift
//  CoreUtil
//
//  Created by yuki on 2021/09/14.
//  Copyright © 2021 yuki. All rights reserved.
//

import Foundation

extension NSDictionary {
    @inlinable public func castMutableOrMutableCopy() -> NSMutableDictionary {
        if let mutable = self as? NSMutableDictionary { return mutable }
        return self.mutableCopy() as! NSMutableDictionary
    }
}
