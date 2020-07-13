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
    @State private var showingUsersWarning = false
    @State private var showingNetworkError = false
    @State private var networkError: String? = nil
    @State private var offsets: IndexSet = IndexSet()
    @State private var showingCreateRootUserView = false
    
    var body: some View {
        VStack {
            List{
                ForEach(users) {user in
                    UserRowView(user: user)
                }
                .onDelete(perform: deleteUsers)
                .alert(isPresented: $showingUsersWarning) {
                    Alert(title: Text("Delete user?"), message: Text("This action cannot be undone."), primaryButton: .destructive(Text("Delete"), action: deleteUsersForReal), secondaryButton: .cancel())
                }
            }
            .onAppear(perform: refresh)
            NavigationLink(destination: CreateRootUserView(), isActive: $showingCreateRootUserView) {}
        }
        .actionSheet(isPresented: $showingNetworkError) {
            ActionSheet(title: Text("Network error"), message: Text(self.networkError ?? "unkown error"), buttons: [.default(Text("OK"))])
        }
        .navigationTitle("users")
        .navigationBarItems(trailing: Button(action: refresh, label: {Image(systemName: "arrow.clockwise").foregroundColor(.black).padding()}))
    }
    
    func refresh() {
        do {
            try getParsedJSONResponse(for: "/console/api/users.get?attrs=id,username", expected: [User].self) { response in
                switch response {
                case .success(data: let data):
                    users = data as! [User]
                    checkUserCount()
                case .failure(error: let error):
                    networkError = "Error getting root permissions: \(error.localizedDescription)"
                    showingNetworkError = true
                }
            }
        } catch let error{
            networkError = error.localizedDescription
            showingNetworkError = true
        }
    }
    
    /// Check whether it there are no users left in which case a request for root permissions to create/change root user is appropriate
    func checkUserCount() {
        if users.count == 0 {
            requestRootUserPermissions { response in
                switch response {
                case .success:
                    showingCreateRootUserView = true
                case .denied:
                    break
                case .failure(error: let error):
                    networkError = error.localizedDescription
                }
            }
        }
    }
    
    func deleteUsers(offsets: IndexSet) {
        if UserDefaults().bool(forKey: "showedDeleteUsersWarning") {
            self.offsets = offsets
            deleteUsersForReal()
        } else {
            showingUsersWarning = true
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
                checkUserCount()
            case .failure(error: let error):
                networkError = error.localizedDescription
                showingNetworkError = true
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
