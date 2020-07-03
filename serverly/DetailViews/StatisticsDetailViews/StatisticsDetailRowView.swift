//
//  StatisticsDetailRowView.swift
//  serverly
//
//  Created by Miguel Themann on 03.07.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import SwiftUI

struct StatisticsDetailRowView: View {
    
    let statistic: EndpointStatistic
    
    func r(_ a: Float) -> String {
        return String(round(a * 1000) / 1000)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(r(statistic.mean))
                    .bold()
                    .padding(.trailing)
                Spacer()
                Text(statistic.function)
            }
            HStack {
                Text(r(statistic.max))
                Spacer()
                Text(String(statistic.len))
                    .padding(.horizontal)
                Spacer()
                Text(r(statistic.min))
            }
        }
    }
}

struct StatisticsDetailRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatisticsDetailRowView(statistic: statisticsForPreview[0])
            StatisticsDetailRowView(statistic: statisticsForPreview[1])
            StatisticsDetailRowView(statistic: statisticsForPreview[2])
        }
        .previewLayout(.fixed(width: 400, height: 80))
    }
}
