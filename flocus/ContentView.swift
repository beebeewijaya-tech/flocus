//
//  ContentView.swift
//  flocus
//
//  Created by Bee Wijaya on 06/04/26.
//

import SwiftUI

struct ContentView: View {
    @State private var showModal1 = false
    /**
     DUMMY FILES: for testing purposes
     */
    @StateObject private var timerViewModel: TimerViewModel = TimerViewModel()
    
    var body: some View {
        VStack (spacing: 100) {
            Button("Click me") {
                timerViewModel.startTimer()
            }
            Button("Modal 1") {
                showModal1 = true
            }
            .fullScreenCover(isPresented: $showModal1) {
                Modal1Screen(showed: $showModal1)
            }
        }
    }
}

#Preview {
    ContentView()
}
