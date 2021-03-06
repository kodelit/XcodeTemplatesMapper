//
//  InfoPlistDetails.swift
//  PlistMapper
//
//  Created by Grzegorz Maciak on 22/03/2019.
//  Copyright © 2019 kodelit. All rights reserved.
//

import Foundation

protocol PlistDataProtocol {
    var title:String { get }
    var path:String { get }
    var plist:[String:Any] { get set }

    init?(path:String, plist:[String:Any])

    // MARK: - With default implementations
    func sourceFileNameWithExtension() -> String?
    func sourceFileName() -> String?

    func outputFileName() -> String?
}

extension PlistDataProtocol {
    func sourceFileNameWithExtension() -> String? {
        let components = path.components(separatedBy: "/")
        guard let fileName = components.last, !fileName.isEmpty else {
            return nil
        }
        return fileName
    }

    func sourceDir() -> String {
        return (path as NSString).deletingLastPathComponent as String
    }

    func sourceFileName() -> String? {
        return sourceFileNameWithExtension()?.replacingOccurrences(of: ".\(Plist.fileExtension)", with: "")
    }

    func outputFileName() -> String? {
        return self.title
    }
}
