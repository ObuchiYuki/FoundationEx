//
//  Ex+UUID.swift
//  CoreUtil
//
//  Created by yuki on 2020/10/08.
//  Copyright © 2020 yuki. All rights reserved.
//

import Foundation

extension UUID {
    public var base64String: String {
        var base64 = self.data.base64EncodedString()
        base64.removeLast(2)
        return base64
    }

    public var data: Data {
        withUnsafeBytes(of: self.uuid) { Data($0) }
    }
    
    public init?(data: Data) {
        guard data.count == 16 else { return nil }
        self.init(uuid: data.withUnsafeBytes { $0.load(as: uuid_t.self) })
    }
}
