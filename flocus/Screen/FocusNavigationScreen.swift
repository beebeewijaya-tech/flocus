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
    // MARK: Binding
    @Binding var isPresented: Bool
    
    // MARK: State
    @State var pageState: PageState = .focused
    
    // MARK: - ViewModel
    @ObservedObject var timerViewModel: TimerViewModel
    @ObservedObject var taskViewModel: TaskViewModel

    init(
        isPresented: Binding<Bool>,
        timerViewModel: TimerViewModel,
        taskViewModel: TaskViewModel
    ) {
        self._isPresented = isPresented
        self._timerViewModel = ObservedObject(wrappedValue: timerViewModel)
        self._taskViewModel = ObservedObject(wrappedValue: taskViewModel)
    }
    
    var body: some View {
        FullModal(content: {
            switch pageState {
            case .focused:
                renderFocusScreen(
                    isPresented: $isPresented,
                    timerViewModel: timerViewModel,
                    pageState: $pageState,
                    taskViewModel: taskViewModel
                )
            case .rest:
                renderRestScreen()
            }
        }, isPresented: $isPresented, showCloseBtn: false)
    }
}
