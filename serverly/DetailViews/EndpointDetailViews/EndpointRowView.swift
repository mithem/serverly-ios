//
//  EndpointRowView.swift
//  serverly
//
//  Created by Miguel Themann on 02.07.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import SwiftUI

struct EndpointRowView: View {
    let endpoint: Endpoint
    var body: some View {
        HStack {
            Text(endpoint.method.prefix(3).uppercased())
            Text(endpoint.path)
                .lineLimit(2)
                .padding(.horizontal)
            Spacer()
            Text(endpoint.name)
                .lineLimit(2)
                .padding(.trailing)
        }
    }
}

struct EndpointRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EndpointRowView(endpoint: endpointsForPreview[0])
                .previewLayout(.fixed(width: 350, height: 80))
            EndpointRowView(endpoint: endpointsForPreview[1])
                .previewLayout(.fixed(width: 350, height: 80))
            EndpointRowView(endpoint: endpointsForPreview[2])
                .previewLayout(.fixed(width: 350, height: 80))
        }
    }
}
