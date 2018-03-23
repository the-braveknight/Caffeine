//
//  LocalFile.swift
//  Caffeine
//
//  Created by Zaid Rahawi on 3/15/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import Foundation

protocol LocalFile: File {
    static var filesDirectory: URL { get }
    
    init(url: URL)
}

extension LocalFile {
    var name: String {
        return url.lastPathComponent
    }
}

extension LocalFile {
    var stillExists: Bool {
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    static var savedFiles: [Self] {
        let urls = try? FileManager.default.contentsOfDirectory(at: filesDirectory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        let savedFiles = urls?.map { Self(url: $0) }
        return savedFiles ?? []
    }
    
    func delete() {
        try? FileManager.default.removeItem(at: url)
        NotificationCenter.default.post(name: .fileDeleted, object: self)
    }
    
    static func saveItem(at tempPath: URL, fileName: String, handler: ((Self?, Error?) -> Void)? = nil) {
        let newPath = localPath(forFileWithName: fileName)
        do {
            try FileManager.default.moveItem(at: tempPath, to: newPath)
            let file = Self(url: newPath)
            handler?(file, nil)
            NotificationCenter.default.post(name: .fileSaved, object: file)
        } catch {
            handler?(nil, error)
        }
    }
    
    private static func localPath(forFileWithName fileName: String) -> URL {
        let itemsWithTheSameName = savedFiles.map { $0.url }.filter { $0.lastPathComponent.deletingFileExtension.contains(fileName.deletingFileExtension) }
        if itemsWithTheSameName.count > 0 {
            return filesDirectory.appendingPathComponent("\(fileName.deletingFileExtension)-\(itemsWithTheSameName.count).\(fileName.fileExtension)")
        }
        return filesDirectory.appendingPathComponent(fileName)
    }
}

extension String {
    var deletingFileExtension: String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }
    
    var fileExtension: String {
        return URL(fileURLWithPath: self).pathExtension
    }
}

extension Notification.Name {
    static let fileDeleted = Notification.Name(rawValue: "FileDeleted")
    static let fileSaved = Notification.Name(rawValue: "FileSaved")
}
