//
//  Reachability+Ex.swift
//  CoreUtil
//
//  Created by yuki on 2021/09/14.
//  Copyright © 2021 yuki. All rights reserved.
//

import Foundation
#if canImport(Combine)
import Combine

extension Reachability {
    @available(iOS 13.0, *)
    public struct Publisher: Combine.Publisher {
        public typealias Output = Reachability
        public typealias Failure = Never
        
        let subject: CurrentValueSubject<Reachability, Never>
        
        init(_ reachability: Reachability) {
            self.subject = CurrentValueSubject(reachability)
            reachability.whenReachable = {[subject] in subject.send($0) }
            reachability.whenUnreachable = {[subject] in subject.send($0) }
            try? reachability.startNotifier()
        }
        
        public func receive<S: Subscriber>(subscriber: S) where S.Failure == Self.Failure, S.Input == Self.Output {
            self.subject.receive(subscriber: subscriber)
        }
    }
}
#endif
