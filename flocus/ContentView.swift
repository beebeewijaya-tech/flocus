//
//  ContentView.swift
//  flocus
//
//  Created by Bee Wijaya on 06/04/26.
//

import SwiftUI
import FamilyControls

struct ContentView: View {
    @State private var showModal1 = false
    @State private var showModalExclude = false
    /**
     DUMMY FILES: for testing purposes
     */
    @State var duration: Int = 0
    @StateObject private var timerViewModel: TimerViewModel
    @StateObject private var familyControlViewModel: FamilyControlViewModel = FamilyControlViewModel()

    // persistence variable
    @AppStorage("timerEndDate") var timerEndDate: Double = 0

    init() {
        let initialDuration = 70 // this will replace by PICKER
        
        /**
         setting up the viewmodel on the actual value because we wanted to initialize initial seconds into the logic
         */
        self._duration = State(initialValue: initialDuration)
        self._timerViewModel = StateObject(wrappedValue: TimerViewModel(seconds: initialDuration))
        
        if timerEndDate > 0 {
            // this will behave to re-render timer countdown later
            // if any closing app happened
            print("hello \(Date(timeIntervalSince1970: timerEndDate))")
        }
    }

    var body: some View {
        VStack (spacing: 100) {
            Button("Click me") {
                timerViewModel.startTimer()
            }
            Button("Modal 1") {
                showModal1 = true
            }
            .fullScreenCover(isPresented: $showModal1) {
                Modal1Screen(isPresented: $showModal1)
            }
            
            Button("Modal Exclude") {
                showModalExclude = true
            }
            .sheet(isPresented: $showModalExclude) {
                ExcludeApp(isPresented: $showModalExclude, familyControlViewModel: familyControlViewModel)
                    .presentationDragIndicator(.visible)
            }
            
            
            Button("Modal Lock") {
                familyControlViewModel.lockApps()
            }
            
            Button("Modal Unlock") {
                familyControlViewModel.unlockApps()
            }
        }
    }
}

#Preview {
    ContentView()
}
