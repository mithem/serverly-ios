//
//  SettingsView.swift
//  serverly
//
//  Created by Miguel Themann on 30.06.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        List {
            NavigationLink("authentication", destination: ServerSettingsView())
            NavigationLink("notifications", destination: NotificationSettings())
            NavigationLink("customization", destination: CustomizationSettings())
        }
        .navigationTitle("settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
