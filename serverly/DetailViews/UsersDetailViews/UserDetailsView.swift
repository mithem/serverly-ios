//
//  UserDetailsView.swift
//  serverly
//
//  Created by Miguel Themann on 30.06.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import SwiftUI

struct UserDetailsView: View {
    @State private var users = [User]()
    @State private var showUsersWarning = false
    @State private var showNetworkError = false
    @State private var networkError: String? = nil
    @State private var offsets: IndexSet = IndexSet()
    
    var body: some View {
        List{
            ForEach(users) {user in
                UserRowView(user: user)
            }
            .onDelete(perform: deleteUsers)
            .alert(isPresented: $showUsersWarning) {
                Alert(title: Text("Delete user?"), message: Text("This action cannot be undone."), primaryButton: .destructive(Text("Delete"), action: deleteUsersForReal), secondaryButton: .cancel())
            }
        }
        .onAppear(perform: refresh)
        .alert(isPresented: $showNetworkError) {
            Alert(title: Text("Network error"), message: Text(self.networkError ?? "unkown error"), dismissButton: .default(Text("OK")))
        }
        .navigationTitle("users")
        .navigationBarItems(trailing: Button(action: refresh, label: {Image(systemName: "arrow.clockwise").foregroundColor(.black)}))
    }
    
    func refresh() {
        do {
            try getParsedJSONResponse(for: "/console/api/users.get?attrs=id,username", expected: [User].self) { response in
                switch response {
                case .success(data: let data):
                    users = data as! [User]
                case .failure(error: let error):
                    networkError = error.localizedDescription
                    showNetworkError = true
                }
            }
        } catch let error{
            networkError = error.localizedDescription
            showNetworkError = true
        }
    }
    
    func deleteUsers(offsets: IndexSet) {
        if UserDefaults().bool(forKey: "showedDeleteUsersWarning") {
            self.offsets = offsets
            deleteUsersForReal()
        } else {
            showUsersWarning = true
            UserDefaults().set(true, forKey: "showedDeleteUsersWarning")
        }
    }
        
    func deleteUsersForReal() {
        var ids = [Int]()
        for idx in offsets {
            ids.append(users[idx].id)
        }
        serverly.deleteUsers(withIds: ids) { response in
            switch response {
            case .success:
                users.remove(atOffsets: offsets)
            case .failure(error: let error):
                networkError = error.localizedDescription
                showNetworkError = true
            }
        }
    }
}

struct UserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailsView()
            .preferredColorScheme(.dark)
    }
}
