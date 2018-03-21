//
//  DVC+DownloadDelegate.swift
//  Caffeine
//
//  Created by Zaid Rahawi on 3/19/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import UIKit

extension DownloadsViewController: DownloadDelegate {
    func indexPath(for download: Download) -> IndexPath? {
        if let download = download as? MXDownload, let index = downloads.index(of: download) {
            return IndexPath(row: index, section: 0)
        }
        return nil
    }
    
    func cell(for download: Download) -> DownloadCell? {
        if let indexPath = indexPath(for: download), let cell = tableView.cellForRow(at: indexPath) as? DownloadCell {
            return cell
        }
        return nil
    }
    
    func download(_ download: Download, didUpdateState state: DownloadState) {
        DispatchQueue.main.async {
            let cell = self.cell(for: download)
            cell?.button.isSelected = state == .running
            cell?.progressBar.progressTintColor = Settings.colorMode.progressTintColor(forState: state)
            
            self.updateUI()
        }
    }
    
    func download(_ download: Download, didFetchFileName fileName: String) {
        DispatchQueue.main.async {
            let cell = self.cell(for: download)
            cell?.nameLabel.text = fileName
        }
    }
    
    func download(_ download: Download, didUpdateProgress progress: DownloadProgress) {
        DispatchQueue.main.async {
            let cell = self.cell(for: download)
            cell?.progressBar.progress = progress.fractionCompleted
            cell?.progressLabel.text = progress.description
        }
    }
}

extension DownloadProgress {
    var description: String {
        if isInitial {
            return "In Queue"
        }
        
        let recieved = ByteCountFormatter.string(fromByteCount: bytesReceived, countStyle: .file)
        let total = ByteCountFormatter.string(fromByteCount: totalBytes, countStyle: .file)
        let speed = ByteCountFormatter.string(fromByteCount: self.speed, countStyle: .file)
        return "Progress: \(recieved) of \(total)\nSpeed: \(speed)/s"
    }
}
