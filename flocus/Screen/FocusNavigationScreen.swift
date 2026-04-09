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
}

/// FocusNavigationScreen will be the root of the FOCUS, to navigate between the focus state, break / rest state
struct FocusNavigationScreen: View {
    @Binding var isPresented: Bool
    @State var pageState: PageState = .focused
    @ObservedObject var timerViewModel: TimerViewModel

    init(
        isPresented: Binding<Bool>,
        timerViewModel: TimerViewModel
    ) {
        self._isPresented = isPresented
        self._timerViewModel = ObservedObject(wrappedValue: timerViewModel)
    }
    
    var body: some View {
        FullModal(content: {
            switch pageState {
            case .focused:
                renderFocusScreen(isPresented: $isPresented, timerViewModel: timerViewModel, pageState: $pageState)
            case .rest:
                renderRestScreen()
            }
        }, isPresented: $isPresented, showCloseBtn: false)
    }
}
