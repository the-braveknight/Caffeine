//
//  File.swift
//  Caffeine
//
//  Created by Zaid Rahawi on 3/15/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import UIKit

enum FileType {
    case archive
    case photo
    case music
    case video
    case document
    case unknown
    
    var icon: UIImage {
        switch self {
        case .photo: return #imageLiteral(resourceName: "picture")
        case .music: return #imageLiteral(resourceName: "musical")
        case .video: return #imageLiteral(resourceName: "movie")
        case .document: return #imageLiteral(resourceName: "document")
        case .archive: return #imageLiteral(resourceName: "archive")
        case .unknown: return #imageLiteral(resourceName: "file")
        }
    }
    
    init(fileExtension: String) {
        switch fileExtension {
        case "zip", "rar", "zipx", "7z": self = .archive
        case "mp4", "mkv", "mov", "avi", "wmv": self = .video
        case "mp3", "m4a", "wav", "aac", "flac": self = .music
        case "png", "jpg", "tiff", "bmp": self = .photo
        case "pdf", "doc", "docx", "ppt", "pptx": self = .document
        default: self = .unknown
        }
    }
}

protocol File {
    static var filesDirectory: URL { get }
    
    var url: URL { get }
    var name: String { get }
    init(url: URL)
}

extension File {
    var name: String {
        return url.lastPathComponent
    }
    
    var type: FileType {
        return FileType(fileExtension: name.fileExtension)
    }
    
    var icon: UIImage {
        return type.icon
    }
}

extension File {
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
