//
//  constants.swift
//  serverly
//
//  Created by Miguel Themann on 30.06.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import Foundation

let HTTPMethodMap = [
    "get": "GET",
    "post": "POS",
    "put": "PUT",
    "delete": "DEL"
]

let summaryURLMap = [
    "users": "/console/api/summary.users",
    "endpoints": "/console/api/summary.endpoints",
    "statistics": "/console/api/summary.statistics"
]

let requestTimeout: TimeInterval = 5

let usersForPreview = [User(id: 1, username: "mithem"), User(id: 2, username: "miguel"), User(id: 3, username: "yooo")]
