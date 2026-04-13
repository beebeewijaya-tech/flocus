//
//  MascotSpeechBubble.swift
//  flocus
//
//  Created by Bee Wijaya on 09/04/26.
//

import SwiftUI

struct MascotSpeechBubble: View {
    let message: String

    var body: some View {
        ZStack {
            Image("bubblechat")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 100)
            Text(message)
                .font(.system(size: 16))
                .foregroundColor(Color("Primary"))
                .padding(.bottom, 10)
                .padding(.trailing, -10)
        }
    }
}

#Preview {
    MascotSpeechBubble(message: "Add a task to get started")
}
