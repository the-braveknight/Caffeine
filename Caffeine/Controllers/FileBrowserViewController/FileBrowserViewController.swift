//
//  FileBrowserViewController.swift
//  Caffeine
//
//  Created by Zaid Rahawi on 3/7/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import UIKit

class FileBrowserViewController: UITableViewController {
    let noContentsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No Contents"
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    let cellId = "FileCell"
    
    lazy var searchController: UISearchController = { [unowned self] in
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.delegate = self
        controller.dimsBackgroundDuringPresentation = false
        return controller
    }()
    
    var filteredFiles = [MXFile]()
    
    var files: [MXFile] {
        let files = isSearching ? filteredFiles : MXFile.savedFiles
        let existingFiles = files.filter { $0.stillExists }
        return existingFiles
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(noContentsLabel)
        noContentsLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        noContentsLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        tableView.register(FileCell.self, forCellReuseIdentifier: cellId)
        tableView.allowsSelection = false
        
        navigationItem.title = "Files"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.leftBarButtonItem = editButtonItem
        
        editButtonItem.image = #imageLiteral(resourceName: "edit")
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateColorMode), name: .colorModeChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleFileSaved), name: .fileSaved, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleFileDeleted), name: .fileDeleted, object: nil)
        
        updateColorMode()
        updateLabels()
    }
    
    @objc func updateColorMode() {
        editButtonItem.tintColor = Settings.colorMode.tintColor
        
        navigationController?.navigationBar.barStyle = Settings.colorMode.barStyle
        navigationController?.navigationBar.titleTextAttributes = Settings.colorMode.textAttributes
        navigationController?.navigationBar.largeTitleTextAttributes = Settings.colorMode.textAttributes
        
        searchController.searchBar.keyboardAppearance = Settings.colorMode.keyboardAppearance
        
        noContentsLabel.textColor = Settings.colorMode.textColor
        searchController.searchBar.tintColor = Settings.colorMode.tintColor
        
        tableView.backgroundColor = Settings.colorMode.tableViewColor
        tableView.visibleCells.compactMap { $0 as? FileCell }.forEach(updateCellUI)
        tableView.separatorColor = Settings.colorMode.tableViewSeperatorColor
    }
    
    func updateCellUI(_ cell: FileCell) {
        cell.backgroundColor = Settings.colorMode.cellColor
        cell.textLabel?.textColor = Settings.colorMode.textColor
        cell.textLabel?.textColor = Settings.colorMode.textColor
        cell.imageView?.tintColor = Settings.colorMode.textColor
        cell.shareButton.tintColor = Settings.colorMode.tintColor
    }
    
    func updateLabels() {
        noContentsLabel.isHidden = !files.isEmpty
        editButtonItem.isEnabled = !files.isEmpty
    }
    
    @objc func share(sender: UIButton) {
        let file = files[sender.tag]
        let activityController = UIActivityViewController(activityItems: [file.url], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender
        activityController.popoverPresentationController?.sourceRect = sender.bounds
        present(activityController, animated: true)
    }
    
    @objc func handleFileSaved() {
        DispatchQueue.main.async {
            self.updateLabels()
            self.tableView.reloadData()
        }
    }
    
    @objc func handleFileDeleted() {
        DispatchQueue.main.async {
            self.updateLabels()
        }
    }
}
