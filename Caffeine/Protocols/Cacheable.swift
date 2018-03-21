//
//  Cacheable.swift
//  Caffeine
//
//  Created by Zaid Rahawi on 3/13/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import Foundation

// Experimental caching mechanism

// Not in use anymore...

protocol Cacheable: Codable {
    static var cachesDirectory: URL { get }
    var cacheKey: String { get }
}

extension Cacheable {
    static var allCached: [Self] {
        let decoder = JSONDecoder()
        let contents = try? FileManager.default.contentsOfDirectory(at: cachesDirectory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        return contents?.compactMap { try? Data(contentsOf: $0) }.compactMap { try? decoder.decode(Self.self, from: $0) } ?? []
    }
    
    static func cached(withKey cacheKey: String) -> Self? {
        let decoder = JSONDecoder()
        let cachePath = cachesDirectory.appendingPathComponent(cacheKey)
        if let data = try? Data(contentsOf: cachePath) {
            return try? decoder.decode(Self.self, from: data)
        }
        return nil
    }
    
    func deleteCaches() {
        let cachePath = Self.cachesDirectory.appendingPathComponent(cacheKey)
        try? FileManager.default.removeItem(at: cachePath)
    }
    
    func cache() throws {
        let encoder = JSONEncoder()
        let encodedData = try encoder.encode(self)
        let cachePath = Self.cachesDirectory.appendingPathComponent(cacheKey)
        try encodedData.write(to: cachePath)
    }
}
