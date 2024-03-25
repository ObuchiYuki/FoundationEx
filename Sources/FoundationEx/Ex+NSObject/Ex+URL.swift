//
//  Ex+URL.swift
//  CoreUtil
//
//  Created by yuki on 2020/02/06.
//  Copyright © 2020 yuki. All rights reserved.
//

import Foundation

extension URL {
    /// Access to real file object in disk. And get some metadata.
    public var fileResource: FileResource { FileResource(url: self) }
}

public struct FileResource {
    public let url: URL

    public init(url: URL) { self.url = url }
}

extension FileResource {
    
    public var exists: Bool {
        FileManager.default.fileExists(atPath: url.path)
    }
    
    public var isDirectory: Bool {
        guard let resource = try? url.resourceValues(forKeys: [.isDirectoryKey, .isPackageKey]) else { return false }

        let isDirectory = resource.isDirectory ?? false
        let isPackage = resource.isPackage ?? false

        return isDirectory && !isPackage
    }
    
    public var isPackage: Bool {
        guard let resource = try? url.resourceValues(forKeys: [.isPackageKey]) else { return false }
        
        return resource.isPackage ?? false
    }

    public var isHidden: Bool {
        guard let resource = try? url.resourceValues(forKeys: [.isHiddenKey]) else { return false }
        return resource.isHidden ?? false
    }

    

    public var localizedName: String {
        let filename = url.lastPathComponent
        guard let resource = try? url.resourceValues(forKeys: [.localizedNameKey]) else {
            return filename
        }

        return resource.localizedName ?? filename
    }

    public var creationDate: Date? {
        guard let fileCreationDateResource = try? url.resourceValues(forKeys: [.creationDateKey]) else {
            return nil
        }
        return fileCreationDateResource.creationDate
    }

    public var modificationDate: Date? {
        guard let modDateResource = try? url.resourceValues(forKeys: [.contentModificationDateKey]) else {
            return nil
        }
        return modDateResource.contentModificationDate
    }    
}

extension URL {
    public var queryParamators: [String: String?] {
        get {
            guard let component = URLComponents(url: self, resolvingAgainstBaseURL: true) else {return [:]}
            return component.paramators
        }
        set {
            guard var component = URLComponents(url: self, resolvingAgainstBaseURL: true) else {return}
            component.paramators = newValue
            self = component.url!
        }
    }
}

// MARK: - URLComponents Extensions
extension URLComponents {

    /// UrlParamators converted to Dictionary type.
    fileprivate var paramators: [String: String?] {
        get {
            return self.queryItems?.reduce(into: [String: String?]()) {$0[$1.name] = $1.value} ?? [:]
        }
        set {
            self.queryItems = newValue.map {URLQueryItem(name: $0, value: $1)}
        }
    }
}
