//
//  MXDownloadDelegate.swift
//  Caffeine
//
//  Created by Zaid Rahawi on 2/22/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import Foundation

protocol DownloadDelegate: class {
    func download(_ download: Download, didFetchFileName fileName: String)
    func download(_ download: Download, didUpdateProgress progress: DownloadProgress)
    func download(_ download: Download, didUpdateState state: DownloadState)
}
