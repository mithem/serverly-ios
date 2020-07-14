//
//  RefreshButton.swift
//  serverly
//
//  Created by Miguel Themann on 13.07.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import SwiftUI

struct RefreshButton: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @State var callback: () -> Void
    
    @State private var rotation = 0.0
    
    var body: some View {
        Button(action: {
            if rotation >= 20 {
                rotation = 0
            } else {
                rotation += 1
            }
            callback()
        }) {
            Image(systemName: "arrow.clockwise")
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .rotationEffect(Angle(radians: 2 * Double.pi * rotation))
                .padding()
        }
        .animation(.easeInOut(duration: rotation == 0 ? 3.0 : 0.3))
    }
}

struct RefreshButton_Previews: PreviewProvider {
    static var previews: some View {
        RefreshButton() {}
    }
}
