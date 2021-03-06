//
//  DownloadsViewController.swift
//  Caffeine
//
//  Created by Zaid Rahawi on 2/22/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import UIKit

extension Download {
    var isActive: Bool {
        return [.waiting, .running, .suspended].contains(state)
    }
}

class DownloadsViewController: UITableViewController {
    let downloader: Downloader
    
    var filteredDownloads = [Download]()
    
    var downloads: [Download] {
        let downloads = isSearching ? filteredDownloads : downloader.downloads
        let activeDownloads = downloads.filter { $0.isActive }
        return activeDownloads
    }
    
    lazy var searchController: UISearchController = { [unowned self] in
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.delegate = self
        controller.dimsBackgroundDuringPresentation = false
        return controller
    }()
    
    let noDownloadsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No Downloads"
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    lazy var addButton = UIBarButtonItem(image: #imageLiteral(resourceName: "add"), style: .plain, target: self, action: #selector(addDownload))
    
    let cellId = "DownloadCell"
    
    init(downloader: Downloader) {
        self.downloader = downloader
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        downloader.delegate = self
        
        view.addSubview(noDownloadsLabel)
        noDownloadsLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        noDownloadsLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        tableView.register(DownloadCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.rowHeight = 80
        tableView.allowsSelection = false
        
        definesPresentationContext = false
        navigationItem.searchController = searchController
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = addButton
        navigationItem.title = "Downloads"
        navigationItem.leftBarButtonItem = editButtonItem
        editButtonItem.image = #imageLiteral(resourceName: "edit")
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateColorMode), name: .colorModeChanged, object: nil)
        
        updateColorMode()
        updateLabels()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func updateColorMode() {
        navigationController?.navigationBar.barStyle = Settings.colorMode.barStyle
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = Settings.colorMode.searchBarTextAttributes
        tabBarController?.tabBar.tintColor = Settings.colorMode.tintColor
        tabBarController?.tabBar.barTintColor = Settings.colorMode.barTintColor
        
        editButtonItem.tintColor = Settings.colorMode.tintColor
        addButton.tintColor = Settings.colorMode.tintColor
        
        navigationController?.navigationBar.titleTextAttributes = Settings.colorMode.textAttributes
        navigationController?.navigationBar.largeTitleTextAttributes = Settings.colorMode.textAttributes
        
        searchController.searchBar.keyboardAppearance = Settings.colorMode.keyboardAppearance
        searchController.searchBar.tintColor = Settings.colorMode.tintColor
        
        noDownloadsLabel.textColor = Settings.colorMode.textColor

        tableView.backgroundColor = Settings.colorMode.tableViewColor
        tableView.visibleCells.compactMap { $0 as? DownloadCell }.forEach(updateCellUI)
        
        tableView.separatorColor = Settings.colorMode.tableViewSeperatorColor
    }
    
    func updateCellUI(_ cell: DownloadCell) {
        cell.backgroundColor = Settings.colorMode.cellColor
        cell.textLabel?.textColor = Settings.colorMode.textColor
        cell.nameLabel.textColor = Settings.colorMode.textColor
        cell.progressLabel.textColor = Settings.colorMode.textColor
        cell.imageView?.tintColor = Settings.colorMode.textColor
        cell.button.tintColor = Settings.colorMode.tintColor
        cell.progressBar.progressTintColor = Settings.colorMode.progressTintColor(forState: cell.download!.state)
    }
    
    @objc func addDownload() {
        let alertController = UIAlertController(title: "Add Download", message: "Enter the URL address of the file that you want to download.", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.keyboardAppearance = Settings.colorMode.keyboardAppearance
            textField.placeholder = "https://example.com/myfile.zip"
            textField.keyboardType = .URL
            textField.returnKeyType = .done
        }
        
        let addDownload = UIAlertAction(title: "Add", style: .default) { (action) in
            let urlString = alertController.textFields!.first!.text!.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics.union(.urlPathAllowed).union(.urlHostAllowed))!
            self.downloader.downloadFile(at: urlString)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(addDownload)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    @objc func handleButtonPress(button: UIButton) {
        let download = downloads[button.tag]
        if download.state == .running {
            download.pause()
        } else {
            download.resume()
        }
    }
    
    func handle(error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func updateLabels() {
        editButtonItem.isEnabled = !downloads.isEmpty
        noDownloadsLabel.isHidden = !downloads.isEmpty
    }
}

extension Downloader {
    func downloadFile(at urlString: String, as fileName: String? = nil) {
        guard let url = URL(string: urlString) else {
            delegate?.downloader(self, didFailToDownloadFileAt: nil, withError: Error.invalidUrl)
            return
        }
        downloadFile(at: url, as: fileName)
    }
}

extension DownloaderError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidUrl: return "Invalid URL address. Please make sure you're typing the address correctly."
        case .unsupportedUrl: return "Unsupported URL address. Your device cannot open this type of URLs."
        case .alreadyInProgress: return "Download already in progress."
        }
    }
}
