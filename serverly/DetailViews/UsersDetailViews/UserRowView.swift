//
//  UserRowView.swift
//  serverly
//
//  Created by Miguel Themann on 30.06.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import SwiftUI

struct UserRowView: View {
    let user: User
    var body: some View {
        HStack {
            Text(String(user.id))
                .bold()
                .padding(.leading)
            Text(user.username)
                .padding(.leading, 20)
            Spacer()
        }
    }
}
struct UserRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UserRowView(user: usersForPreview[0])
            UserRowView(user: usersForPreview[1])
            UserRowView(user: usersForPreview[2])
        }.previewLayout(.fixed(width: 250, height: 80))
    }
}
