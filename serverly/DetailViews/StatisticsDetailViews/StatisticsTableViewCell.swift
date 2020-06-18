//
//  StatisticsTableViewCell.swift
//  serverly
//
//  Created by Miguel Themann on 18.06.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import UIKit

class StatisticsTableViewCell: UITableViewCell {
    
    var lFunction = UILabel()
    var lLen = UILabel()
    var lMean = UILabel()
    var lMin = UILabel()
    var lMax = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureLayout() {
        
        lFunction.translatesAutoresizingMaskIntoConstraints = false
        lLen.translatesAutoresizingMaskIntoConstraints = false
        lMean.translatesAutoresizingMaskIntoConstraints = false
        lMin.translatesAutoresizingMaskIntoConstraints = false
        lMax.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(lFunction)
        addSubview(lLen)
        addSubview(lMean)
        addSubview(lMin)
        addSubview(lMax)
        
        lMean.font = UIFont.boldSystemFont(ofSize: 16)
        
        lLen.font = UIFont.systemFont(ofSize: 12)
        lMin.font = UIFont.systemFont(ofSize: 12)
        lMax.font = UIFont.systemFont(ofSize: 12)
        
        NSLayoutConstraint.activate([
            lMean.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            lMean.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            lFunction.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            lFunction.leadingAnchor.constraint(equalTo: lMean.trailingAnchor, constant: 10),
            lFunction.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            lMax.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            lMax.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            lMin.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            lMin.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            lLen.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            lLen.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func set(endpointStatistic: EndpointStatistic) {
        let factor = Float(100)
        func r(_ a: Float) -> Float {
            return (round(a * factor) / factor)
        }
        lFunction.text = endpointStatistic.function
        lLen.text = String(endpointStatistic.len)
        lMean.text = String(r(endpointStatistic.mean))
        lMin.text = String(r(endpointStatistic.min))
        lMax.text = String(r(endpointStatistic.max))
    }
}
