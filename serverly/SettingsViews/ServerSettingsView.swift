//
//  ServerSettingsView.swift
//  serverly
//
//  Created by Miguel Themann on 30.06.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import SwiftUI

struct ServerSettingsView: View {
    @AppStorage("serverURL") var serverURL = ""
    @AppStorage("username") var username = ""
    @AppStorage("password") var password = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("server url")
                .bold()
                .padding(.leading)
            TextField("url", text: $serverURL)
                .padding([.leading, .trailing])
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("This URL is used to receive information about the server. Make sure that you have registered all console.summary endpoints of the serverly standard API.")
                .padding(.leading)
                .foregroundColor(.secondary)
            Text("username")
                .bold()
                .padding([.leading, .top])
            TextField("username", text: $username)
                .padding([.leading, .trailing])
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("Your username used to authenticate on the server.")
                .padding([.leading, .trailing])
                .foregroundColor(.secondary)
            Text("password")
                .bold()
                .padding([.leading, .top])
            SecureField("password", text: $password)
                .padding([.leading, .trailing])
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("Your password used to authenticate on the server.")
                .padding([.leading, .trailing])
                .foregroundColor(.secondary)
            Spacer()
                
        }
        .navigationTitle("server settings")
    }
}

struct ServerSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ServerSettingsView()
    }
}
