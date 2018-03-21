//
//  Progress.swift
//  Caffeine
//
//  Created by Zaid Rahawi on 3/15/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import Foundation

protocol DownloadProgress {
    var totalBytes: Int64 { get set }
    var bytesReceived: Int64 { get set }
    var startDate: Date { get }
}

extension DownloadProgress {
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
}
