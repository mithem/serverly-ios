//
//  EndpointDetailsView.swift
//  serverly
//
//  Created by Miguel Themann on 02.07.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import SwiftUI

struct EndpointDetailsView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @State var endpoints =  [Endpoint]()
    @State private var showingNetworkError = false
    @State private var networkError: String? = nil
    @State private var showingAddEndpointView = false
    
    var body: some View {
        List {
            Button(action: {
                showingAddEndpointView = true
            }) {
                Text("Add")
                    .foregroundColor(.blue)
            }
            ForEach(endpoints, id: \.path) { endpoint in
                EndpointRowView(endpoint: endpoint)
            }
            .onDelete(perform: deleteEndpoints)
        }
        .animation(.easeInOut)
        .onAppear(perform: loadEndpoints)
        .actionSheet(isPresented: $showingNetworkError) {
            ActionSheet(title: Text("Networking error."), message: Text(networkError ?? "Unknown error."), buttons: [.default(Text("OK"))])
        }
        .sheet(isPresented: $showingAddEndpointView) {
            AddEndpointView()
                .onDisappear {
                    loadEndpoints()
                }
        }
        .navigationTitle("endpoints")
        .navigationBarItems(trailing: RefreshButton(callback: loadEndpoints)
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
                showingNetworkError = true
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
                    showingNetworkError = true
                }
            }
        } catch let error {
            networkError = error.localizedDescription
            showingNetworkError = true
        }
    }
}

struct EndpointDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        EndpointDetailsView(endpoints: endpointsForPreview)
    }
}
