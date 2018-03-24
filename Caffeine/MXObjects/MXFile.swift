//
//  MXFile.swift
//  Caffeine
//
//  Created by Zaid Rahawi on 3/7/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import UIKit

struct MXFile: File {
    let url: URL
    
    static var filesDirectory: URL {
        let directory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Downloads", isDirectory: true)
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        return directory
    }
}
