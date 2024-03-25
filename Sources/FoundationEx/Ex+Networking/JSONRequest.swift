//
//  AxHttpJSONRequest.swift
//  AxDocument
//
//  Created by yuki on 2021/08/23.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case head = "HEAD"
    case put = "PUT"
    case connect = "CONNECT"
    case options = "OPTIONS"
    case trace = "TRACE"
    case post = "POST"
    case delete = "DELETE"
    case patch = "PATCH"
}

final public class JSONRequest {
    
    public init(_ url: URL, bearerToken: String? = nil) {
        self.url = url
        self.bearerToken = bearerToken
    }
    
    public let url: URL
    public var body = NSMutableDictionary()
    public var bearerToken: String?
    public var method: HTTPMethod = .get
    
    public func urlRequest() -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if body.count != 0 {
            let bodyData = try! JSONSerialization.data(withJSONObject: body)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = bodyData
        }
        if let bearerToken = bearerToken {
            request.setBearerToken(bearerToken)
        }
        return request
    }
}

extension JSONRequest {
    public static func get(_ url: URL, bearerToken: String? = nil) -> JSONRequest {
        let request = JSONRequest(url, bearerToken: bearerToken)
        request.method = .get
        return request
    }
    public static func post(_ url: URL, bearerToken: String? = nil) -> JSONRequest {
        let request = JSONRequest(url, bearerToken: bearerToken)
        request.method = .post
        return request
    }
    public static func delete(_ url: URL, bearerToken: String? = nil) -> JSONRequest {
        let request = JSONRequest(url, bearerToken: bearerToken)
        request.method = .delete
        return request
    }
    public static func patch(_ url: URL, bearerToken: String? = nil) -> JSONRequest {
        let request = JSONRequest(url, bearerToken: bearerToken)
        request.method = .patch
        return request
    }
}

extension URLRequest {
    public mutating func setBearerToken(_ token: String) {
        self.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
}
