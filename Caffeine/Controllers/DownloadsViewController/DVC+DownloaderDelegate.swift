//
//  DVC+DownloaderDelegate.swift
//  Caffeine
//
//  Created by Zaid Rahawi on 3/19/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import UIKit

extension DownloadsViewController: DownloaderDelegate {
    func indexPath(for download: Download) -> IndexPath? {
        if let index = downloads.index(of: download) {
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
    
    func downloader(_ downloader: Downloader, didStartDownloading download: Download) {
        print("DownloaderDelegate: Starting \(download.name).")
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.updateLabels()
        }
    }
    
    func downloader(_ downloader: Downloader, download: Download, didFailWithError error: Error) {
        print("Failed to download \(download.name) with error: \(error.localizedDescription)")
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.updateLabels()
            self.handle(error: error)
        }
    }
    
    func downloader(_ downloader: Downloader, download: Download, didUpdateFileName fileName: String) {
        DispatchQueue.main.async {
            let cell = self.cell(for: download)
            cell?.nameLabel.text = fileName
        }
    }
    
    func downloader(_ downloader: Downloader, didFailToDownloadFileAt url: URL?, withError error: Error) {
        DispatchQueue.main.async {
            self.handle(error: error)
        }
    }
    
    func downloader(_ downloader: Downloader, download: Download, didUpdateProgress progress: Download.Progress) {
        DispatchQueue.main.async {
            let cell = self.cell(for: download)
            cell?.progressBar.progress = progress.fractionCompleted
            cell?.progressLabel.text = progress.description
        }
    }
    
    func downloader(_ downloader: Downloader, download: Download, didUpdateState newState: Download.State) {
        DispatchQueue.main.async {
            let cell = self.cell(for: download)
            cell?.button.isSelected = newState == .running
            cell?.progressBar.progressTintColor = Settings.colorMode.progressTintColor(forState: newState)
            
            self.updateLabels()
        }
    }
    
    func downloader(_ downloader: Downloader, didFinishDownloading download: Download, asFile savedFile: File) {
        print("Finished downloading \(download.name) to \(savedFile.url)")
        DispatchQueue.main.async {
            self.showAlert(title: "Downlad Complete", message: "\(download.name) was downloaded successfully.")
            self.tableView.reloadData()
            self.updateLabels()
        }
    }
}

extension Download.Progress: CustomStringConvertible {
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
