//
//  EndpointDetailsTableViewCell.swift
//  serverly
//
//  Created by Miguel Themann on 14.06.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import UIKit

class EndpointDetailsTableViewCell: UITableViewCell {
    
    var lPath = UILabel()
    var lName = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(lPath)
        addSubview(lName)
        configure()
    }
    
    func set(path: String, name: String) {
        lPath.text = path
        lName.text = name
    }
    
    func configure() {
        lPath.numberOfLines = 0
        lName.numberOfLines = 0
        
        lPath.adjustsFontSizeToFitWidth = true
        lName.adjustsFontSizeToFitWidth = true
        
        lPath.translatesAutoresizingMaskIntoConstraints = false
        lPath.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        lPath.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        lName.translatesAutoresizingMaskIntoConstraints = false
        lName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10).isActive = true
        lName.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
