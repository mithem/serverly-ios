//
//  UserDetailsTableViewCell.swift
//  serverly
//
//  Created by Miguel Themann on 16.06.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import UIKit

class UserDetailsTableViewCell: UITableViewCell {
    
    var lId = UILabel()
    var lUsername = UILabel()
    
    let usernameHeight = 20

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(lId)
        addSubview(lUsername)
        configureLayout()
    }
    
    func configureLayout() {
        lId.numberOfLines = 1
        lUsername.numberOfLines = 0
        
        lId.adjustsFontSizeToFitWidth = true
        lUsername.adjustsFontSizeToFitWidth = true
        
        lId.translatesAutoresizingMaskIntoConstraints = false
        lUsername.translatesAutoresizingMaskIntoConstraints = false
        
        lId.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        lId.widthAnchor.constraint(equalToConstant: 75).isActive = true
        lId.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        lId.textAlignment = .right
        
        lUsername.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        lUsername.leadingAnchor.constraint(equalTo: lId.trailingAnchor, constant: 10).isActive = true
        lUsername.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        
        lId.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    func set(id: Int, username: String){
        lId.text = String(id)
        lUsername.text = username
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }

}
