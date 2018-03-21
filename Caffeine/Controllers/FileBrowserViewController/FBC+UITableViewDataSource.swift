//
//  FBC+UITableViewDataSource.swift
//  Caffeine
//
//  Created by Zaid Rahawi on 3/19/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import UIKit

extension FileBrowserViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let file = self.file(forRowAt: indexPath)
            file.delete()
            self.updateUI()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        return [delete]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FileCell
        
        configure(cell, forRowAt: indexPath)
        cell.setupViews()
        
        return cell
    }
    
    func file(forRowAt indexPath: IndexPath) -> MXFile {
        return files[indexPath.row]
    }
    
    func configure(_ cell: FileCell, forRowAt indexPath: IndexPath) {
        let file = self.file(forRowAt: indexPath)
        cell.shareButton.tag = indexPath.row
        cell.shareButton.addTarget(self, action: #selector(share), for: .touchUpInside)
        cell.textLabel?.text = file.name
        cell.imageView?.image = file.icon.withRenderingMode(.alwaysTemplate)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! FileCell
        updateCellUI(cell)
    }
}
