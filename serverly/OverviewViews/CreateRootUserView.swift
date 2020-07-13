//
//  CreateRootUserView.swift
//  serverly
//
//  Created by Miguel Themann on 12.07.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import SwiftUI

struct CreateRootUserView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var password = ""
    @State private var showingPasswordEmptyWarning = false
    @State private var showingActionSheet = false
    @State private var showingSuccessActionSheet = false
    @State private var actionSheetTitle: String? = nil
    @State private var actionSheetMessage: String? = nil
    
    var body: some View {
        Form {
            Text("Your server created a root user. You now have the option to change its password, otherwise it will remain 'root1234'.")
            SecureField("password", text: $password)
            Button("Apply") {
                guard password != "" else { showingPasswordEmptyWarning = true; return }
                do {
                    var request = try getRequest(for: "/console/api/root/create")
                    guard let token = UserDefaults().string(forKey: "create-root-user-token") else { return }
                    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                    request.httpMethod = "POST"
                    request.httpBody = try JSONEncoder().encode(["password": password])
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        if let data = data {
                            let s = String(data: data, encoding: .utf8)
                            if s == "Changed root user successfully." {
                                let ud = UserDefaults()
                                ud.set("root", forKey: "username")
                                ud.set(password, forKey: "password")
                                showingSuccessActionSheet = true
                            } else {
                                actionSheetTitle = "Invalid response"
                                actionSheetMessage = s
                                showingActionSheet = true
                            }
                        } else {
                            actionSheetTitle = "Networking error"
                            actionSheetMessage = error?.localizedDescription ?? "Unkown error."
                            showingActionSheet = true
                        }
                    }.resume()
                } catch {
                    actionSheetTitle = "Networking error"
                    actionSheetMessage = error.localizedDescription
                    showingActionSheet = true
                }
            }
            .navigationTitle("root user's setup")
        }
        .actionSheet(isPresented: $showingPasswordEmptyWarning) {
            ActionSheet(title: Text("Not all required fields are full"), message: Text("Please make sure to enter your desired password."), buttons: [.default(Text("OK"))])
        }
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(title: Text(actionSheetTitle ?? "Unkown error"), message: Text(actionSheetMessage ?? "Unkown error."), buttons: [.default(Text("OK"))])
        }
        .actionSheet(isPresented: $showingSuccessActionSheet) {
            ActionSheet(title: Text("Success!"), message: Text("Changed root user's password and saved it to your settings."), buttons: [.default(Text("OK")) {presentationMode.wrappedValue.dismiss()}])
        }
    }
}

struct CreateRootUserView_Previews: PreviewProvider {
    static var previews: some View {
        CreateRootUserView()
    }
}
