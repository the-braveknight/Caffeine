//
//  MXDownloaderDelegate.swift
//  Caffeine
//
//  Created by Zaid Rahawi on 2/22/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import Foundation

protocol DownloaderDelegate: class {
    func downloader(_ downloader: Downloader, didStartDownloading download: Download)
    func downloader(_ downloader: Downloader, didFinishDownloading download: Download, asFile savedFile: File)
    func downloader(_ downloader: Downloader, download: Download, didUpdateState newState: Download.State)
    func downloader(_ downloader: Downloader, download: Download, didUpdateProgress progress: Download.Progress)
    func downloader(_ downloader: Downloader, download: Download, didUpdateFileName fileName: String)
    func downloader(_ downloader: Downloader, didFailToDownloadFileAt url: URL?, withError error: Error)
    func downloader(_ downloader: Downloader, download: Download, didFailWithError error: Error)
}
