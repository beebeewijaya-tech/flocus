//
//  PrimaryButton.swift
//  flocus
//
//  Created by Richie Daryl Kwenandar on 08/04/26.
//

import SwiftUI


struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(width: 120, height: 35)
                .padding()
                .background(Color("Primary"))
                .foregroundColor(.white)
                .clipShape(Capsule())
        }
    }
}
