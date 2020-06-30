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
    var body: some View {
        NavigationView {
            NavigationLink(destination: Text("hello world")){
                SummaryView(kind: "users")
            }
        }
    }
}

struct OverviewView_Previews: PreviewProvider {
    static var previews: some View {
        OverviewView()
    }
}
