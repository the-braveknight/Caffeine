//
//  FBC+UISearchResultsUpdating.swift
//  Caffeine
//
//  Created by Zaid Rahawi on 3/19/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import UIKit

extension FileBrowserViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    var isSearching: Bool {
        return searchController.isActive
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredFiles = MXFile.savedFiles.filter { $0.name.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        tableView.reloadData()
        updateLabels()
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        noContentsLabel.text = "No Results"
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        noContentsLabel.text = "No Contents"
    }
}

