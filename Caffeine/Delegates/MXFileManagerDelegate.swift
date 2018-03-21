//
//  MXFileManagerDelegate.swift
//  mx-downloader
//
//  Created by Zaid Rahawi on 2/23/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import Foundation

protocol MXFileManagerDelegate: class {
    func fileManager(_ fileManager: MXFileManager, didSaveFileWithName fileName: String, as file: MXFile)
    func fileManager(_ fileManager: MXFileManager, didFailToSaveFileWithName fileName: String, withError error: Error)
    func fileManager(_ fileManager: MXFileManager, didDeleteCacheFor url: URL)
    func fileManager(_ fileManager: MXFileManager, didDeleteFileWithName fileName: String)
}

// Optional methods
extension MXFileManagerDelegate {
    func fileManager(_ fileManager: MXFileManager, didDeleteCacheFor url: URL) {}
    func fileManager(_ fileManager: MXFileManager, didFailToSaveFileWithName fileName: String, withError error: Error) {}
}
