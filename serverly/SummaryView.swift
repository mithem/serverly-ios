//
//  SummaryView.swift
//  serverly
//
//  Created by Miguel Themann on 30.06.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import SwiftUI

struct SummaryView: View {
    let kind: String
    @State var summary: String? = nil
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                    Text(kind)
                        .font(.headline)
                        .padding(.leading)
                Button(action: {
                    serverly.getSummary(for: kind) { summary in
                        self.summary = summary
                    }
                }){Text(summary ?? "⃝").lineLimit(3)}
                        .padding(.top, 8)
                        .padding(.leading)
            }
            .foregroundColor(.black)
            .onAppear {
                getSummary(for: kind) { summary in
                    self.summary = summary
                }
            }
            Spacer()
        }
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView(kind: "users")
    }
}
