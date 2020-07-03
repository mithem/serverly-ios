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
    
    @State private var summaryUsers: String? = nil
    @GestureState private var isDetectingLongPress = false
    @State private var completedLongPress =  false
    
    @State private var showUsersView = false
    
    var body: some View {
        NavigationView {
            Group {
                VStack {
                    SummaryView<UserDetailsView>(kind: "users", navigateTo: UserDetailsView())
                        .padding([.top, .bottom])
                    SummaryView<EndpointDetailsView>(kind: "endpoints", navigateTo: EndpointDetailsView())
                    .padding(.bottom)
                    SummaryView<StatisticsDetailsView>(kind: "statistics", navigateTo: StatisticsDetailsView())
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
