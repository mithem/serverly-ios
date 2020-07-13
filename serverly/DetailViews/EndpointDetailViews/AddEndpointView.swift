//
//  AddEndpointView.swift
//  serverly
//
//  Created by Miguel Themann on 13.07.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import SwiftUI

struct AddEndpointView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var actionSheetTitle = "An error occured"
    @State private var actionSheetMessage: String? = nil
    @State private var showingActionSheet = false
    
    @State private var selectedMethod = 0
    @State private var path = ""
    @State private var function = ""
    
    @State private var pathColor = Color.black
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Method", selection: $selectedMethod) {
                        ForEach(0..<supportedMethods.count) { i in
                            Text(supportedMethods[i]).tag(i)
                        }
                    }
                    TextField("path", text: $path)
                        .foregroundColor(pathColor)
                        .onChange(of: path) { path in
                            pathColor = .black
                        }
                    TextField("function", text: $function)
                }
                Section {
                    Button("Add") {
                        addEndpoint()
                    }
                }
            }
            .navigationTitle("Add endpoint")
        }
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(title: Text(actionSheetTitle), message: Text(actionSheetMessage ?? "Unkown error."), buttons: [.default(Text("OK")) {
                showingActionSheet = false
            }])
        }
    }
    
    func addEndpoint() {
        do {
            if !checkEndpointPath(path) {
                pathColor = .red
                return
            }
            var request = try getRequest(for: "/console/api/endpoint.new")
            request.httpMethod = "POST"
            request.httpBody = try JSONEncoder().encode(["method": supportedMethods[selectedMethod], "path": path, "function": function])
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    let s = String(data: data, encoding: .utf8)
                    if (s?.hasPrefix("Registered ") ?? false) {
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        actionSheetTitle = "Error adding endpoint."
                        actionSheetMessage = s
                        showingActionSheet = true
                    }
                }
                if let error = error {
                    actionSheetTitle = "Networking error"
                    actionSheetMessage = error.localizedDescription
                    showingActionSheet = true
                }
            }.resume()
        } catch {
            actionSheetTitle = "Error adding endpoint."
            actionSheetMessage = error.localizedDescription
            showingActionSheet = true
        }
    }
}

struct AddEndpointView_Previews: PreviewProvider {
    static var previews: some View {
        AddEndpointView()
    }
}
