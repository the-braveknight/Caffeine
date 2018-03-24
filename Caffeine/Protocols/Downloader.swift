//
//  Downloader.swift
//  Caffeine
//
//  Created by Zaid Rahawi on 3/24/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import Foundation

enum DownloaderError: Error {
    case invalidUrl
    case unsupportedUrl
    case alreadyInProgress
}

protocol Downloader: class {
    typealias Error = DownloaderError
    var session: URLSession { get }
    var downloads: [Download] { get }
    var delegate: DownloaderDelegate? { get set }
    func downloadFile(at url: URL, as fileName: String?)
}
