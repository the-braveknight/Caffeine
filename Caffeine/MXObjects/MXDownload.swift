//
//  MXDownload.swift
//  Caffeine
//
//  Created by Zaid Rahawi on 2/22/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import Foundation

class MXDownload: Download {
    let url: URL
    let task: URLSessionDownloadTask
    
    var state: State = .waiting {
        didSet {
            downloader.delegate?.downloader(downloader, download: self, didUpdateState: state)
        }
    }
    
    var progress = Progress() {
        // Progress must be value type (Struct) in order for this call to happen
        didSet {
            downloader.delegate?.downloader(downloader, download: self, didUpdateProgress: progress)
        }
    }
    
    var name: String {
        didSet {
            downloader.delegate?.downloader(downloader, download: self, didUpdateFileName: name)
        }
    }
    
    unowned var downloader: Downloader
    
    init(url: URL, downloader: Downloader, resumeData: Data? = nil, fileName: String? = nil) {
        self.url = url
        self.downloader = downloader
        self.name = fileName ?? url.lastPathComponent
        if let resumeData = resumeData {
            self.task = downloader.session.downloadTask(withResumeData: resumeData)
        } else {
            self.task = downloader.session.downloadTask(with: url)
        }
    }
    
    convenience init?(task: URLSessionDownloadTask, downloader: Downloader, fileName: String? = nil) {
        guard let url = task.response?.url, let error = task.error as NSError?, let resumeData = error.userInfo[NSURLSessionDownloadTaskResumeData] as? Data else { return nil }
        self.init(url: url, downloader: downloader, resumeData: resumeData, fileName: fileName)
    }
    
    func pause() {
        state = .suspended
        task.suspend()
    }
    
    func resume() {
        state = .running
        task.resume()
    }
    
    func cancel() {
        state = .canceling
        task.cancel()
    }
}
