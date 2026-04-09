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
    let container = try! ModelContainer(for: TaskModel.self)

    var body: some Scene {
        WindowGroup {
            HomeScreen()
                .environmentObject(TaskViewModel(context: container.mainContext))
        }
        .modelContainer(container)
    }
}
