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
    var body: some Scene {
        WindowGroup {
            HomeScreen_SwiftData()
        }
        .modelContainer(for: TaskModel.self)
    }
}
