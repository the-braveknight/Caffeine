//
//  DVC+UISearchResultsUpdating.swift
//  Caffeine
//
//  Created by Zaid Rahawi on 3/19/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import UIKit

extension DownloadsViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    var isSearching: Bool {
        return searchController.isActive
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        noDownloadsLabel.text = "No Results"
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        noDownloadsLabel.text = "No Downloads"
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredDownloads = downloader.downloads.filter { $0.name.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        tableView.reloadData()
        updateUI()
    }
}
