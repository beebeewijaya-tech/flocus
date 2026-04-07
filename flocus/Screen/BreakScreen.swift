//
//  CongratsScreen.swift
//  flocus
//
//  Created by Muhammad Dzakki Abdullah on 07/04/26.
//

import SwiftUI

struct BreakScreen: View {
    
    @State private var timeRemaining = 1 * 60
    @State private var timer: Timer? = nil
    @State private var HomeScreen = false
    
    var formattedTime: String {
            let minutes = timeRemaining / 60
            let seconds = timeRemaining % 60
            return String(format: "%02d : %02d", minutes, seconds)
        }

    var body: some View {
        ZStack(alignment: .top) {
            Color("Secondary")
                .ignoresSafeArea(edges: .all)
            VStack {
                Image("Banner")
                    .frame(maxWidth: .infinity, maxHeight: 300)
                Text("Break Time !")
                    .padding(.top, 20)
                    .padding(.bottom, 35)
                    .font(.system(size: 30, weight: .black))
                    .foregroundStyle(Color("Primary"))
                
                Image("Cactus")
                    .resizable()
                    .frame(width: 144, height: 157)
                Text("Starting ")
                    .padding(.top, 35)
                    .font(.system(size: 24))
                    .foregroundStyle(Color("Primary"))
                Text(formattedTime)
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(Color("Primary"))
                
                Button("Start Early") {
                    timer?.invalidate()
                }
                .frame(width: 100, height: 40)
                .padding()
                .background(Color("Primary"))
                .foregroundStyle(Color("Secondary"))
                .clipShape(Capsule())
            }
        }
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    timer?.invalidate()
                    HomeScreen = true
                }
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
}

#Preview {
    BreakScreen()
}
