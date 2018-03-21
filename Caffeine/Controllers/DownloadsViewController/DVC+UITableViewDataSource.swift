//
//  DVC+UITableViewDataSource.swift
//  Caffeine
//
//  Created by Zaid Rahawi on 3/19/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import UIKit

extension DownloadsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloads.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DownloadCell
        
        configure(cell, forRowAt: indexPath)
        cell.setupViews()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let download = self.download(forRowAt: indexPath)
        
        let cancel = UITableViewRowAction(style: .destructive, title: "Cancel") { (action, indexPath) in
            download.cancel()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        return [cancel]
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! DownloadCell
        updateCellUI(cell)
    }
    
    func download(forRowAt indexPath: IndexPath) -> MXDownload {
        return downloads[indexPath.row]
    }
    
    func configure(_ cell: DownloadCell, forRowAt indexPath: IndexPath) {
        let download = self.download(forRowAt: indexPath)
        cell.download = download
        cell.button.tag = indexPath.row
        cell.button.addTarget(self, action: #selector(handleButtonPress), for: .touchUpInside)
        download.delegate = self
        cell.imageView?.image = download.icon.withRenderingMode(.alwaysTemplate)
        cell.nameLabel.text = download.name
        cell.button.isSelected = download.state == .running
        
        cell.progressBar.progress = download.progress.fractionCompleted
        cell.progressLabel.text = download.progress.description
    }
}
