//
//  FocusNavigationScreen.swift
//  flocus
//
//  Created by Bee Wijaya on 09/04/26.
//

import SwiftUI

enum PageState {
    case focused
    case rest // break
    case success
}

/// FocusNavigationScreen will be the root of the FOCUS, to navigate between the focus state, break / rest state
struct FocusNavigationScreen: View {
    // MARK: Binding
    @Binding var isPresented: Bool
    @Binding var isPickTimerPresented: Bool
    
    // MARK: State
    @State var pageState: PageState = .focused
    
    // MARK: - ViewModel
    @EnvironmentObject var timerViewModel: TimerViewModel
    @EnvironmentObject var taskViewModel: TaskViewModel

    init(isPresented: Binding<Bool>, isPickTimerPresented: Binding<Bool>) {
        self._isPresented = isPresented
        self._isPickTimerPresented = isPickTimerPresented
    }
    
    var body: some View {
        FullModal(content: {
            switch pageState {
            case .focused:
                renderFocusScreen(isPresented: $isPresented, pageState: $pageState)
            case .rest:
                renderRestScreen(isPresented: $isPresented)
            case .success:
                renderSuccessScreen(isPresented: $isPresented, isPickTimerPresented: $isPickTimerPresented)
            }
        }, isPresented: $isPresented, showCloseBtn: false)
    }
}
