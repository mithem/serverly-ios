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
    var lMethod = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(lMethod)
        addSubview(lPath)
        addSubview(lName)
        configure()
    }
    
    func set(path: String, name: String, method: String) {
        lMethod.text = HTTPMethodMap[method] ?? "N/A"
        lPath.text = path
        lName.text = name
    }
    
    func configure() {
        lMethod.numberOfLines = 1
        lPath.numberOfLines = 0
        lName.numberOfLines = 0
        
        lMethod.adjustsFontSizeToFitWidth = true
        lPath.adjustsFontSizeToFitWidth = true
        lName.adjustsFontSizeToFitWidth = true
        
        lMethod.translatesAutoresizingMaskIntoConstraints = false
        lMethod.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        lMethod.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        lPath.translatesAutoresizingMaskIntoConstraints = false
        lPath.leadingAnchor.constraint(equalTo: lMethod.trailingAnchor, constant: 10).isActive = true
        lPath.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        lPath.widthAnchor.constraint(equalToConstant: self.frame.size.width / 2).isActive = true
        
        lName.translatesAutoresizingMaskIntoConstraints = false
        lName.leadingAnchor.constraint(equalTo: lPath.trailingAnchor, constant: 10).isActive = true
        lName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        lName.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
