//
//  TestScreen.swift
//  flocus
//
//  Created by Bee Wijaya on 10/04/26.
//

import SwiftUI


struct TestScreen: View {
    var body: some View {
        ZStack {
            Color("Secondary")
                .ignoresSafeArea()
            
            VStack {
                MascotSpeechBubble(message: "Hello world")

                Image("Mascot")
                    .resizable()
                    .frame(width: 300, height: 300)
                    .padding(.top, -20)
            }
        }
    }
}


#Preview {
    TestScreen()
}
