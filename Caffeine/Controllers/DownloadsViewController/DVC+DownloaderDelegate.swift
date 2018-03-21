//
//  DVC+DownloaderDelegate.swift
//  Caffeine
//
//  Created by Zaid Rahawi on 3/19/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import UIKit

extension DownloadsViewController: DownloaderDelegate {
    func downloader(_ downloader: MXDownloader, didFinishDownloading download: Download, as file: LocalFile) {
        print("Finished downloading \(download.name) to \(file.url)")
        DispatchQueue.main.async {
            self.showAlert(title: "Downlad Complete", message: "\(download.name) was downloaded successfully.")
            self.tableView.reloadData()
            self.updateLabels()
        }
    }
    
    func downloader(_ downloader: MXDownloader, failedToDownload download: Download, withError error: Error) {
        print("Failed to download \(download.name) with error: \(error.localizedDescription)")
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.updateLabels()
            self.handle(error: error)
        }
    }
    
    func downloader(_ downloader: MXDownloader, didStartDownloading download: Download) {
        print("DownloaderDelegate: Starting \(download.name).")
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.updateLabels()
        }
    }
}
