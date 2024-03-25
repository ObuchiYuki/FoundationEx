//
//  MultipartFormDataRequest.swift
//  CoreUtil
//
//  Created by yuki on 2021/08/19.
//  Copyright © 2021 yuki. All rights reserved.
//

import Foundation

public struct MultipartFormDataRequest {
    private let boundary = UUID().uuidString.replacingOccurrences(of: "-", with: "")
    private var httpBody = NSMutableData()
    
    public let url: URL
    public var bearerToken: String?

    public init(url: URL, bearerToken: String? = nil) {
        self.url = url
        self.bearerToken = bearerToken
    }

    public func addTextField(named name: String, value: String) {
        httpBody.append(textFormField(named: name, value: value))
    }
    
    public func addDataField(named name: String, data: Data, mimeType: String, filename: String) {
        httpBody.append(dataFormField(named: name, data: data, mimeType: mimeType, filename: filename))
    }
    
    public func urlRequest() -> URLRequest {
        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        httpBody.append("--\(boundary)--")
        request.httpBody = httpBody as Data
        if let bearerToken = self.bearerToken {
            request.setBearerToken(bearerToken)
        }
        return request
    }

    private func textFormField(named name: String, value: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "Content-Type: text/plain; charset=ISO-8859-1\r\n"
        fieldString += "Content-Transfer-Encoding: 8bit\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"

        return fieldString
    }

    private func dataFormField(named name: String, data: Data, mimeType: String, filename: String) -> Data {
        let fieldData = NSMutableData()

        fieldData.append("--\(boundary)\r\n")
        fieldData.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n")
        fieldData.append("Content-Type: \(mimeType)\r\n")
        fieldData.append("\r\n")
        fieldData.append(data)
        fieldData.append("\r\n")

        return fieldData as Data
    }
}

extension NSMutableData {
    func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
