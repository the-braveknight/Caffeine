//
//  FileCell.swift
//  Caffeine
//
//  Created by Zaid Rahawi on 3/7/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import UIKit

class FileCell: UITableViewCell {
    let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "open").withRenderingMode(.alwaysTemplate), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupViews() {
        contentView.addSubview(shareButton)
        
        textLabel?.adjustsFontSizeToFitWidth = true
        shareButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        shareButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
    }
}
