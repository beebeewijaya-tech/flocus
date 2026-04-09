//
//  flocusApp.swift
//  flocus
//
//  Created by Bee Wijaya on 06/04/26.
//

import SwiftUI
import SwiftData

@main
struct flocusApp: App {
    let container: ModelContainer
    let familyControlViewModel: FamilyControlViewModel
    let taskViewModel: TaskViewModel
    let timerViewModel: TimerViewModel
    let avatarViewModel: AvatarViewModel

    init() {
        let container = try! ModelContainer(for: TaskModel.self)
        let familyControlViewModel = FamilyControlViewModel()
        self.container = container
        self.familyControlViewModel = familyControlViewModel
        self.taskViewModel = TaskViewModel(context: container.mainContext)
        self.timerViewModel = TimerViewModel(seconds: 0, familyControlViewModel: familyControlViewModel)
        self.avatarViewModel = AvatarViewModel()
    }

    var body: some Scene {
        WindowGroup {
            HomeScreen()
                .environmentObject(taskViewModel)
                .environmentObject(familyControlViewModel)
                .environmentObject(timerViewModel)
                .environmentObject(avatarViewModel)
        }
        .modelContainer(container)
    }
}
