//
//  MXDownloader.swift
//  Caffeine
//
//  Created by Zaid Rahawi on 2/22/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import UIKit

class MXDownloader: NSObject, Downloader, URLSessionDownloadDelegate {
    enum Error: Swift.Error {
        case invalidUrl
        case unsupportedUrl
        case alreadyInProgress
    }
    
    static let shared = MXDownloader(sessionIdentifier: "com.zrahawi.mx-downloader")
    
    private(set) var downloads = [Download]()
    
    weak var delegate: DownloaderDelegate?
    
    let sessionIdentifier: String
    
    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: sessionIdentifier)
        configuration.shouldUseExtendedBackgroundIdleMode = true
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    init(sessionIdentifier: String) {
        self.sessionIdentifier = sessionIdentifier
    }
    
    func downloadFile(at url: URL, as fileName: String? = nil) {
        guard downloads[url] == nil else {
            delegate?.downloader(self, didFailToDownloadFileAt: url, withError: Error.alreadyInProgress)
            return
        }
        
        guard UIApplication.shared.canOpenURL(url) else {
            delegate?.downloader(self, didFailToDownloadFileAt: url, withError: Error.unsupportedUrl)
            return
        }
        
        let download = MXDownload(url: url, downloader: self, fileName: fileName)
        downloads.append(download)
        download.resume()
        delegate?.downloader(self, didStartDownloading: download)
    }
    
    func loadUnfinishedDownloads() {
        backgroundDownloads { (downloads) in
            self.downloads.append(contentsOf: downloads)
        }
    }
    
    private func backgroundDownloads(handler: @escaping ([MXDownload]) -> Void) {
        session.getTasksWithCompletionHandler { [unowned self] (dataTasks, uploadTasks, downloadTasks) in
            let downloads = downloadTasks.compactMap { MXDownload(task: $0, downloader: self) }
            handler(downloads)
        }
    }
    
    // MARK: - URLSessionDownloadDelegate
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Swift.Error?) {
        guard let error = error as NSError? else { return }
        guard let download = downloads[task] else { return }
        
        if download.state == .running {
            // Notify delegate if an active download (state == .running) encounters an unexpected error
            delegate?.downloader(self, download: download, didFailWithError: error)
            try? downloads.remove(download)
        } else if download.state == .canceling {
            try? downloads.remove(download)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let download = downloads[downloadTask] as? MXDownload else { return }
        if let suggestedFilename = downloadTask.response?.suggestedFilename, download.shouldSetFileName, download.name != suggestedFilename {
            download.name = suggestedFilename
        }
        
        if download.progress.isInitial {
            download.progress.totalBytes = totalBytesExpectedToWrite
        }
        download.progress.bytesReceived = totalBytesWritten
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let download = downloads[downloadTask] as? MXDownload else { return }
        
        download.state = .completed
        
        try? downloads.remove(download)
        
        MXFile.saveItem(at: location, fileName: download.name) { (file, error) in
            if let file = file {
                self.delegate?.downloader(self, didFinishDownloading: download, asFile: file)
            } else if let error = error {
                self.delegate?.downloader(self, download: download, didFailWithError: error)
            }
        }
    }
}

extension MXDownloader.Error {
    var localizedDescription: String {
        switch self {
        case .invalidUrl: return "Invalid URL address. Please make sure you're typing the address correctly."
        case .unsupportedUrl: return "Unsupported URL address. Your device cannot open this type of URLs."
        case .alreadyInProgress: return "Download already in progress."
        }
    }
}

extension Array where Element == Download {
    enum Error: Swift.Error {
        case invalidIndex
    }
    
    func index(of element: Element) -> Index? {
        return index { $0.url == element.url }
    }
    
    mutating func remove(_ item: Element) throws {
        guard let index = index(where: { item === $0 }) else { throw Error.invalidIndex }
        remove(at: index)
    }
    
    subscript (_ task: URLSessionTask) -> Element? {
        return first { $0.task == task }
    }
    
    subscript (_ url: URL) -> Element? {
        return first { $0.url == url }
    }
}
