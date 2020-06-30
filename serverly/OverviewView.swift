//
//  OverviewView.swift
//  serverly
//
//  Created by Miguel Themann on 30.06.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import SwiftUI

@main
struct Serverly: App {
    var body: some Scene {
        WindowGroup {
            OverviewView()
        }
    }
}

struct OverviewView: View {
    @State var summaryUsers: String? = nil
    let summaryUsersView = SummaryView(kind: "users")
    let summaryEndpointsView = SummaryView(kind: "endpoints")
    let summaryStatisticsView = SummaryView(kind: "statistics")
    var body: some View {
        NavigationView {
            Group {
                VStack {
                    NavigationLink(destination: UserDetailsView()) {
                        summaryUsersView
                    }
                    .padding([.top, .bottom])
                    NavigationLink(destination: Text("hello world 2")) {
                        summaryEndpointsView
                    }
                    .padding(.bottom)
                    NavigationLink(destination: Text("hello world 3")) {
                        summaryStatisticsView
                    }
                    Spacer()
                }
            }
            .navigationTitle("serverly")
            .navigationBarItems(trailing: NavigationLink("settings", destination: SettingsView())).foregroundColor(.black).font(.system(size: 16, weight: .medium, design: .default))
        }
    }
}

struct OverviewView_Previews: PreviewProvider {
    static var previews: some View {
        OverviewView()
    }
}
