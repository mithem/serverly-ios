//
//  SummaryView.swift
//  serverly
//
//  Created by Miguel Themann on 30.06.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import SwiftUI

struct SummaryView<Content: View>: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    let kind: String
    let navigateTo: Content
    
    @State var summary: String? = nil
    @State private var navigateToChild = false
    @State private var error: String? = nil
    @State private var showingCreateUserScreen = false
    
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
                if let error = error {
                    Text("Error getting root permission: \(error)")
                }
            }
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .onAppear(perform: refresh)
            Spacer()
            NavigationLink(destination: CreateRootUserView(), isActive: $showingCreateUserScreen) {}
        }
    }
    
    func refresh() {
        summary = nil
        getSummary(for: kind) { summary in
            self.summary = summary
            let last: Substring = summary.prefix(5)
            if kind == "users" && String(last) == "User " { // just initiate once and check if user is not found
                requestRootUserPermissions { response in
                    switch response {
                    case .success:
                        showingCreateUserScreen = true
                    case .denied:
                        break
                    case .failure(error: let error):
                        self.summary = error.localizedDescription
                    }
                }
            }
        }
    }
}
