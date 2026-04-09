//
//  FocusNavigationScreen.swift
//  flocus
//
//  Created by Bee Wijaya on 09/04/26.
//

import SwiftUI


extension FocusNavigationScreen {
    func renderFocusScreen(isPresented: Binding<Bool>, timerViewModel: TimerViewModel, pageState: Binding<PageState>) -> some View {
        FocusScreen(isPresented: isPresented, timerViewModel: timerViewModel, pageState: pageState)
    }
    
    
    func renderRestScreen() -> some View {
        return BreakScreen()
    }
}
