//
//  Download.swift
//  Caffeine
//
//  Created by Zaid Rahawi on 3/15/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import Foundation

enum DownloadState {
    case waiting, running, suspended, canceling, completed
}

protocol Download: class, File {
    var delegate: DownloadDelegate? { get set }
    var progress: DownloadProgress { get set }
    var state: DownloadState { get set }
    var task: URLSessionDownloadTask { get }
    
    init(url: URL, session: URLSession, resumeData: Data)
    init(url: URL, session: URLSession)
}
