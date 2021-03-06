//
//  Download.swift
//  Caffeine
//
//  Created by Zaid Rahawi on 3/15/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import UIKit

enum DownloadState {
    case waiting, running, suspended, canceling, completed
}

struct DownloadProgress {
    var totalBytes: Int64
    var bytesReceived: Int64 = 0
    let startDate = Date()
    
    var speed: Int64 {
        let timeInterval = Date().timeIntervalSince(startDate)
        return timeInterval >= 1 ? Int64(bytesReceived) / Int64(timeInterval) : 0
    }
    
    var fractionCompleted: Float {
        return isInitial ? 0 : Float(bytesReceived) / Float(totalBytes)
    }
    
    var isInitial: Bool {
        return totalBytes == 0 && bytesReceived == 0
    }
    
    init(totalBytes: Int64) {
        self.totalBytes = totalBytes
    }
    
    init() {
        self.init(totalBytes: 0)
    }
}

protocol Download: class {
    var url: URL { get }
    var name: String { get }
    var downloader: Downloader { get }
    var progress: Progress { get }
    var state: DownloadState { get }
    var task: URLSessionDownloadTask { get }
    var shouldSetFileName: Bool { get }
    func resume()
    func pause()
    func cancel()
}

extension Download {
    typealias Progress = DownloadProgress
    typealias State = DownloadState
}

// Default implementation
extension Download {
    var shouldSetFileName: Bool {
        return url.lastPathComponent == name
    }
}

extension Download {
    var fileType: FileType {
        return FileType(fileExtension: name.fileExtension)
    }
    
    var icon: UIImage {
        return fileType.icon
    }
}
