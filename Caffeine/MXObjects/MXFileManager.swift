//
//  MXFileManager.swift
//  mx-downloader
//
//  Created by Zaid Rahawi on 2/22/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import Foundation

class MXFileManager {
    static let shared = MXFileManager()
    
    weak var delegate: MXFileManagerDelegate?
    
    private let fileManager = FileManager.default
    
    var downloadsDirectory: URL {
        let directory = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Downloads", isDirectory: true)
        try? fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
        return directory
    }
    
    typealias FileCompletionHandler = (MXFile?, Error?) -> Void
    
    func saveFile(at tempPath: URL, as fileName: String, completion: FileCompletionHandler? = nil) {
        do {
            let filePath = newDownloadPath(forFileName: fileName)
            try fileManager.copyItem(at: tempPath, to: filePath)
            try? fileManager.removeItem(at: tempPath)
            let file = MXFile(url: filePath)
            completion?(file, nil)
            delegate?.fileManager(self, didSaveFileWithName: fileName, as: file)
        } catch {
            completion?(nil, error)
            delegate?.fileManager(self, didFailToSaveFileWithName: fileName, withError: error)
        }
    }
    
    var savedFiles: [MXFile] {
        let savedFiles = try? fileManager.contentsOfDirectory(at: downloadsDirectory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        return savedFiles?.map { MXFile(url: $0) } ?? []
    }
    
    typealias CacheCompletionHandler = (URL?, Error?) -> Void
    
    func delete(_ file: MXFile) {
        try? fileManager.removeItem(at: file.url)
        delegate?.fileManager(self, didDeleteFileWithName: file.fileName)
    }
    
    private func newDownloadPath(forFileName fileName: String) -> URL {
        let itemsWithTheSameName = savedFiles.map { $0.url }.filter { $0.lastPathComponent.deletingFileExtension.contains(fileName.deletingFileExtension) }
        if itemsWithTheSameName.count > 0 {
            return downloadsDirectory.appendingPathComponent("\(fileName.deletingFileExtension)-\(itemsWithTheSameName.count).\(fileName.fileExtension)")
        }
        return downloadsDirectory.appendingPathComponent(fileName)
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
