//
//  StatisticsDetailsView.swift
//  serverly
//
//  Created by Miguel Themann on 02.07.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import SwiftUI

struct StatisticsDetailsView: View {
    
    @State var statistics = [EndpointStatistic]()
    
    @State private var networkError: String? = nil
    @State private var showNetworkError = false
    
    var body: some View {
        List {
            ForEach(statistics, id: \.function) {statistic in
                StatisticsDetailRowView(statistic: statistic)
            }
            Button("reset", action: resetStatistics)
                .foregroundColor(.red)
        }
        .onAppear(perform: refresh)
        .alert(isPresented: $showNetworkError) {
            Alert(title: Text("Networking error."), message: Text(networkError ?? "Unknown error."), dismissButton: .default(Text("OK")))
        }
        .navigationTitle("statistics")
        .navigationBarItems(trailing: Button(action: refresh, label: {Image(systemName: "arrow.clockwise").foregroundColor(.black)}))
    }
    
    func resetStatistics() {
        do {
            var request = try getRequest(for: "/console/api/statistics")
            request.httpMethod = "DELETE"
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    networkError = error.localizedDescription
                    showNetworkError = true
                } else {
                    refresh()
                }
            }.resume()
        } catch let error {
            networkError = error.localizedDescription
            showNetworkError = true
        }
    }
    
    func refresh() {
        do {
            try getParsedJSONResponse(for: "/console/api/statistics?list=true", expected: [EndpointStatistic].self) { response in
                switch response {
                case .success(data: let stats):
                    statistics = (stats as! [EndpointStatistic]).sorted(by: {e1, e2 in
                        return e2.function > e1.function
                    })
                case .failure(error: let error):
                    networkError = error.localizedDescription
                    showNetworkError = true
                }
            }
        } catch let error {
            networkError = error.localizedDescription
            showNetworkError = true
        }
    }
}

struct StatisticsDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsDetailsView(statistics: statisticsForPreview)
    }
}
