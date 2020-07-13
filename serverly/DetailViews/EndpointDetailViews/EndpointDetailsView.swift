//
//  EndpointDetailsView.swift
//  serverly
//
//  Created by Miguel Themann on 02.07.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import SwiftUI

struct EndpointDetailsView: View {
    
    @State var endpoints =  [Endpoint]()
    @State private var showNetworkError = false
    @State private var networkError: String? = nil
    
    var body: some View {
        List {
            ForEach(endpoints, id: \.path) { endpoint in
                EndpointRowView(endpoint: endpoint)
            }
            .onDelete(perform: deleteEndpoints)
        }
        .onAppear(perform: loadEndpoints)
        .actionSheet(isPresented: $showNetworkError) {
            ActionSheet(title: Text("Networking error."), message: Text(networkError ?? "Unknown error."), buttons: [.default(Text("OK"))])
        }
        .navigationTitle("endpoints")
        .navigationBarItems(trailing: Button(action: loadEndpoints, label: {Image(systemName: "arrow.clockwise").foregroundColor(.black).padding()})
        )
    }
    
    func deleteEndpoints(offsets: IndexSet) {
        var endpointsToDelete = [Endpoint]()
        for idx in offsets {
            endpointsToDelete.append(endpoints[idx])
        }
        serverly.deleteEndpoints(endpoints: endpointsToDelete) { response in
            switch response {
            case .success:
                endpoints.remove(atOffsets: offsets)
            case .failure(error: let error):
                networkError = error.localizedDescription
                showNetworkError = true
            }
        }
    }
    
    func loadEndpoints() {
        do {
            try getParsedJSONResponse(for: "/console/api/endpoints?list=true", expected: [Endpoint].self) { response in
                switch response {
                case .success(data: let data):
                    var myEndpoints = data as! [Endpoint]
                    myEndpoints.sort(by: { e1, e2 in
                        return e2.path > e1.path
                    })
                    endpoints = myEndpoints
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

struct EndpointDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        EndpointDetailsView(endpoints: endpointsForPreview)
    }
}
