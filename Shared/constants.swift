//
//  constants.swift
//  serverly
//
//  Created by Miguel Themann on 30.06.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import Foundation
import SwiftUI

let HTTPMethodMap = [
    "get": "GET",
    "post": "POS",
    "put": "PUT",
    "delete": "DEL"
]

let supportedMethods = ["GET", "POST", "PUT", "DELETE"]

let summaryURLMap = [
    "users": "/console/api/summary.users",
    "endpoints": "/console/api/summary.endpoints",
    "statistics": "/console/api/summary.statistics"
]

let requestTimeout: TimeInterval = 5

let usersForPreview = [User(id: 1, username: "mithem"), User(id: 2, username: "miguel"), User(id: 3, username: "yooo")]

let endpointsForPreview = [Endpoint(method: "get", name: "_console_hello_world", path: "/console/hello-world"), Endpoint(method: "get", name: "_api_user_get", path: "/api/user"), Endpoint(method: "post", name: "create_a_new_product_and_store_it_in_the_database_for_later_access", path: "/product/categories/software/a/0/create/new/sure/go")]

let statisticsForPreview = [EndpointStatistic(function: "my_function", len: 17, mean: 6.8, min: 4.23, max: 11.78), EndpointStatistic(function: "get_users", len: 42, mean: 18.89, min: 14.21, max: 22.817), EndpointStatistic(function: "_api_endpoints-get", len: 113212, mean: 8.4492932348398983, min: 6.583957357208, max: 10.8572972073580824097)]
