//
//  SectionHeader.swift
//  flocus
//
//  Created by Bee Wijaya on 09/04/26.
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Color("Primary"))
            Text(subtitle)
                .font(.system(size: 14))
                .foregroundColor(Color("Primary").opacity(0.6))
                .padding(.top, 5)
        }
    }
}

#Preview {
    SectionHeader(title: "Here's your task today!", subtitle: "Start from the top and work your way down!")
}
