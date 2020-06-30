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
                if let summary = summary {
                    Text(kind)
                        .font(.headline)
                        .padding(.leading)
                        .foregroundColor(.black)
                    Text(summary)
                        .padding(.top, 8)
                        .padding(.leading)
                }else {
                    HStack {
                        Text(kind)
                            .font(.headline)
                            .padding(.leading)
                            .foregroundColor(.black)
                            .onAppear(perform: self.getSummary)
                        ProgressView()
                            .padding(.leading, 8)
                    }
                }
            }
            Spacer()
        }
    }
    func getSummary() {
        summary = nil
        serverly.getSummary(for: kind) { summary in
            self.summary = summary
        }
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView(kind: "users", summary: "Hello there!")
    }
}
