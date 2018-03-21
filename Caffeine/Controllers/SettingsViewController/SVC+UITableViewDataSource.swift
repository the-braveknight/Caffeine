//
//  SVC+UITableViewDataSource.swift
//  Caffeine
//
//  Created by Zaid Rahawi on 3/19/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import UIKit

extension SettingsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        updateCellUI(cell)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "Dark Mode"
                let darkModeSwitch = UISwitch()
                darkModeSwitch.translatesAutoresizingMaskIntoConstraints = false
                darkModeSwitch.isOn = Settings.colorMode == .dark
                darkModeSwitch.addTarget(self, action: #selector(handleDarkModeSwitch), for: .valueChanged)
                cell.contentView.addSubview(darkModeSwitch)
                darkModeSwitch.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -12).isActive = true
                darkModeSwitch.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
            }
        }
        
        return cell
    }
}
