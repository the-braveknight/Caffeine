//
//  SettingsViewController.swift
//  Caffeine
//
//  Created by Zaid Rahawi on 3/7/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    let cellId = "SettingCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Settings"
        tableView.allowsSelection = false
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateColorMode), name: .colorModeChanged, object: nil)
        
        updateColorMode()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleDarkModeSwitch(sender: UISwitch) {
        Settings.colorMode = sender.isOn ? .dark : .normal
    }
    
    @objc func updateColorMode() {
        navigationController?.navigationBar.barStyle = Settings.colorMode.barStyle
        navigationController?.navigationBar.titleTextAttributes = Settings.colorMode.textAttributes
        navigationController?.navigationBar.largeTitleTextAttributes = Settings.colorMode.textAttributes
        
        tableView.backgroundColor = Settings.colorMode.tableViewColor
        tableView.separatorColor = Settings.colorMode.tableViewSeperatorColor
        tableView.visibleCells.forEach(updateCellUI)
    }
    
    func updateCellUI(_ cell: UITableViewCell) {
        cell.backgroundColor = Settings.colorMode.cellColor
        cell.textLabel?.textColor = Settings.colorMode.textColor
    }
}
