//
//  SummaryView.swift
//  serverly
//
//  Created by Miguel Themann on 30.06.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import SwiftUI

struct SummaryView<Content: View>: View {
    let kind: String
    @State var summary: String? = nil
    let navigateTo: Content
    @State private var navigateToChild = false
    
    init(kind: String, @ViewBuilder navigateTo: () -> Content) {
        self.navigateTo = navigateTo()
        self.kind = kind
    }
    
    init(kind: String, navigateTo: Content) {
        self.navigateTo = navigateTo
        self.kind = kind
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                NavigationLink(destination: navigateTo, isActive: $navigateToChild) {
                    Text(kind)
                        .font(.headline)
                        .padding(.leading)
                }
                if let summary = summary {
                    Text(summary)
                        .lineLimit(3)
                        .padding(.top, 8)
                        .padding(.leading)
                        .onTapGesture(perform: refresh)
                        .onLongPressGesture {
                            navigateToChild = true
                        }
                } else {
                    ProgressView()
                        .padding(.horizontal)
                }
            }
            .foregroundColor(.black)
            .onAppear(perform: refresh)
            Spacer()
        }
    }
    
    func refresh() {
        summary = nil
        getSummary(for: kind) { summary in
            self.summary = summary
        }
    }
}
