//
//  models.swift
//  serverly
//
//  Created by Miguel Themann on 30.06.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import Foundation

struct User: Decodable, Identifiable {
    let id: Int
    let username: String
}
