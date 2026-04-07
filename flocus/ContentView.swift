//
//  ContentView.swift
//  flocus
//
//  Created by Bee Wijaya on 06/04/26.
//

import SwiftUI

struct ContentView: View {
    /**
     DUMMY FILES: for testing purposes
     */
    @StateObject private var timerViewModel: TimerViewModel = TimerViewModel()
    
    var body: some View {
        VStack {
            Button("Click me") {
                timerViewModel.startTimer()
            }
        }
    }
}

#Preview {
    ContentView()
}
