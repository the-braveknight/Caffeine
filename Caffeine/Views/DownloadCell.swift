//
//  DownloadCell.swift
//  Caffeine
//
//  Created by Zaid Rahawi on 2/22/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import UIKit

class DownloadCell: UITableViewCell {
    var download: Download?
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 15)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let progressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 11)
        return label
    }()
    
    let progressBar: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .bar)
        view.progressTintColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "resume").withRenderingMode(.alwaysTemplate), for: .normal)
        button.setImage(#imageLiteral(resourceName: "pause").withRenderingMode(.alwaysTemplate), for: .selected)
        return button
    }()
    
    func setupViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(progressBar)
        contentView.addSubview(progressLabel)
        contentView.addSubview(button)
        
        button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -44).isActive = true
        
        progressBar.leadingAnchor.constraint(equalTo: imageView!.leadingAnchor).isActive = true
        progressBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14).isActive = true
        progressBar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: imageView!.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -14).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        progressLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        progressLabel.leadingAnchor.constraint(equalTo: imageView!.trailingAnchor, constant: 14).isActive = true
        progressLabel.bottomAnchor.constraint(equalTo: progressBar.topAnchor, constant: -2).isActive = true
        progressLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
    }
}
