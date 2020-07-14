//
//  AddUserView.swift
//  serverly
//
//  Created by Miguel Themann on 14.07.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import SwiftUI

struct AddUserView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var username = ""
    @State private var password = ""
    
    @State private var actionSheetTitle = "Error"
    @State private var actionSheetMessage = "Unkown error."
    @State private var showingActionSheet = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("username", text: $username)
                    SecureField("password", text: $password)
                }
                Section {
                    Button("Create") {
                        createUser()
                    }
                }
            }
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text(actionSheetTitle), message: Text(actionSheetMessage), buttons: [.default(Text("OK"))])
            }
            .navigationTitle("New user")
        }
    }
    
    func createUser() {
        var request: URLRequest
        guard let url = try? getServerURL() else { return }
        guard let myurl = URL(string: url + "/api/user") else { return }
        do {
            request = URLRequest(url: myurl)
            request.httpMethod = "POST"
            request.httpBody = try JSONEncoder().encode(["username": username, "password": password])
        } catch {
            actionSheetTitle = "Error preparing request."
            actionSheetMessage = error.localizedDescription
            showingActionSheet = true
            return
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let s = String(data: data, encoding: .utf8) {
                    if s.isEmpty {
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        actionSheetTitle = "Error registering user"
                        actionSheetMessage = s
                        showingActionSheet = true
                    }
                }
            }
            else if let error = error {
                actionSheetTitle = "Networking error"
                actionSheetMessage = error.localizedDescription
                showingActionSheet = true
            }
        }.resume()
    }
}

struct AddUserView_Previews: PreviewProvider {
    static var previews: some View {
        AddUserView()
    }
}
