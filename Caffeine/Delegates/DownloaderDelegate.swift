//
//  MXDownloaderDelegate.swift
//  Caffeine
//
//  Created by Zaid Rahawi on 2/22/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import Foundation

protocol DownloaderDelegate: class {
    func downloader(_ downloader: MXDownloader, didStartDownloading download: Download)
    func downloader(_ downloader: MXDownloader, didFinishDownloading download: Download, as file: LocalFile)
    func downloader(_ downloader: MXDownloader, failedToDownload download: Download, withError error: Error)
    func downloader(_ downloader: MXDownloader, failedToDownloadFileAt url: URL?, withError error: Error)
}
