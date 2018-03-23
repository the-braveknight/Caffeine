//
//  MXDownload.swift
//  Caffeine
//
//  Created by Zaid Rahawi on 2/22/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import Foundation

class MXDownload: Download {
    struct Progress: DownloadProgress {
        var totalBytes: Int64
        var bytesReceived: Int64 = 0
        var startDate = Date()
        
        init(totalBytes: Int64) {
            self.totalBytes = totalBytes
        }
        
        init() {
            self.init(totalBytes: 0)
        }
    }
    
    let url: URL
    let task: URLSessionDownloadTask
    
    var state: DownloadState = .waiting {
        didSet {
            delegate?.download(self, didUpdateState: state)
        }
    }
    
    var progress: DownloadProgress = Progress() {
        // Progress must be value type (Struct) in order for this call to happen
        didSet {
            delegate?.download(self, didUpdateProgress: progress)
        }
    }
    
    // If this returns false, the URLSession delegate methods will
    // try to set the fileName to response.suggestedFilename.
    var fileNameWasSet: Bool {
        return name != url.lastPathComponent
    }
    
    var name: String {
        didSet {
            delegate?.download(self, didFetchFileName: name)
        }
    }
    
    weak var delegate: DownloadDelegate?
    
    required init(url: URL, session: URLSession, resumeData: Data) {
        self.url = url
        self.task = session.downloadTask(withResumeData: resumeData)
        self.name = url.lastPathComponent
    }
    
    required init(url: URL, session: URLSession) {
        self.url = url
        self.task = session.downloadTask(with: url)
        self.name = url.lastPathComponent
    }
    
    convenience init?(task: URLSessionDownloadTask, session: URLSession) {
        guard let url = task.response?.url, let error = task.error as NSError?, let resumeData = error.userInfo[NSURLSessionDownloadTaskResumeData] as? Data else { return nil }
        self.init(url: url, session: session, resumeData: resumeData)
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
