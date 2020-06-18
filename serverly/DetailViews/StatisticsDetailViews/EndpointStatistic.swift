//
//  Endpoint.swift
//  serverly
//
//  Created by Miguel Themann on 18.06.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import Foundation

struct EndpointStatistic: Decodable {
    let function: String
    let len: Int
    let mean: Float
    let min: Float
    let max: Float
}
