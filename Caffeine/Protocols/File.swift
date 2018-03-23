//
//  File.swift
//  Caffeine
//
//  Created by Zaid Rahawi on 3/15/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import UIKit

enum FileType {
    case archive
    case photo
    case music
    case video
    case document
    case unknown
    
    var icon: UIImage {
        switch self {
        case .photo: return #imageLiteral(resourceName: "picture")
        case .music: return #imageLiteral(resourceName: "musical")
        case .video: return #imageLiteral(resourceName: "movie")
        case .document: return #imageLiteral(resourceName: "document")
        case .archive: return #imageLiteral(resourceName: "archive")
        case .unknown: return #imageLiteral(resourceName: "file")
        }
    }
    
    init(fileExtension: String) {
        switch fileExtension {
        case "zip", "rar", "zipx", "7z": self = .archive
        case "mp4", "mkv", "mov", "avi", "wmv": self = .video
        case "mp3", "m4a", "wav", "aac", "flac": self = .music
        case "png", "jpg", "tiff", "bmp": self = .photo
        case "pdf", "doc", "docx", "ppt", "pptx": self = .document
        default: self = .unknown
        }
    }
}

protocol File {
    var url: URL { get }
    var name: String { get }
}

extension File {
    var type: FileType {
        return FileType(fileExtension: name.fileExtension)
    }
    
    var icon: UIImage {
        return type.icon
    }
}
