//
//  HomeEmptyState.swift
//  flocus
//
//  Created by Bee Wijaya on 10/04/26.
//

import SwiftUI


struct HomeEmptyView: View {
    var body: some View {
        VStack(spacing: 0) {
            MascotSpeechBubble(message: "Add a task to get started")
                .padding(.top, 40)

            Image("Mascot")
                .resizable()
                .frame(width: 300, height: 300)
                .padding(.top, -20)

            Text("Let's finish your tasks one at a time!")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color("Primary"))

            Spacer()
        }
    }
}


#Preview {
    HomeEmptyView()
}
