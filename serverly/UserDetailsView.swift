//
//  UserDetailsView.swift
//  serverly
//
//  Created by Miguel Themann on 30.06.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import SwiftUI

struct UserDetailsView: View {
    @State var users: [User] = []
    var body: some View {
        List(users) {user in
            UserRowView(user: user)
        }
        .onAppear {
            do{
                try getResponse(for: "/console/api/users.get?attrs=id,username", expected: [User].self) { response in
                    switch response {
                    case .success(data: let data):
                        users = data as! [User]
                    case .failure(error: let error):
                        print(error.localizedDescription)
                    }
                }
            } catch let error{
                print(error.localizedDescription)
            }
        }
        .navigationTitle("users")
    }
}

struct UserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailsView(users: usersForPreview)
    }
}
