//
//  FocusScreenExtension.swift
//  flocus
//
//  Created by Bee Wijaya on 09/04/26.
//

import SwiftUI


extension View {
    func taskFinishedAlert(
        parentAlert: Binding<Bool>,
        pageState: Binding<PageState>,
        showTaskFinished: Binding<Bool>,
    ) -> some View {
        self.alert("Task Finished!", isPresented: showTaskFinished) {
            Button("No Break", role: .cancel) {
                showTaskFinished.wrappedValue = false
                parentAlert.wrappedValue = false
            }
            Button("Yes") {
                pageState.wrappedValue = .rest
            }
        } message: {
            Text("Would you like to take a break?")
        }
    }
    
    
    func timesUpAlert(
        parentAlert: Binding<Bool>,
        pageState: Binding<PageState>,
        showTimerEnded: Binding<Bool>,
        moreTimeAction: @escaping () -> Void = {}
    ) -> some View {
        self.alert("Time's up!", isPresented: showTimerEnded) {
            Button("More Time") {
                parentAlert.wrappedValue = false
                showTimerEnded.wrappedValue = false
            }
            Button("Continue after break") {
                pageState.wrappedValue = .rest
                showTimerEnded.wrappedValue = false
            }
            Button("Finish") {
                pageState.wrappedValue = .rest
                showTimerEnded.wrappedValue = false
            }
        } message: {
            Text("What would you like to do next?")
        }
    }

}
