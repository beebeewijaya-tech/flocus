//
//  FocusNavigationScreen.swift
//  flocus
//
//  Created by Bee Wijaya on 09/04/26.
//

import SwiftUI


extension FocusNavigationScreen {
    func renderFocusScreen(isPresented: Binding<Bool>, pageState: Binding<PageState>) -> some View {
        FocusScreen(isPresented: isPresented, pageState: pageState)
    }
    
    func renderRestScreen(isPresented: Binding<Bool>) -> some View {
        return BreakScreen(isPresented: isPresented)
    }
    
    func renderSuccessScreen(isPresented: Binding<Bool>, isPickTimerPresented: Binding<Bool>) -> some View {
        return CongratsScreen(isPresented: isPresented, isPickTimerPresented: isPickTimerPresented)
    }
}
