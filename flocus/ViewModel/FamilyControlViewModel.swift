//
//  FamilyControlViewModel.swift
//  flocus
//
//  Created by Bee Wijaya on 08/04/26.
//

import SwiftUI
import Combine
import FamilyControls
import ManagedSettings
import DeviceActivity

struct AppItem: Identifiable {
    var id: UUID = UUID()
    var name: String
    var isEnabled: Bool
    var image: String
}

@MainActor
class FamilyControlViewModel: ObservableObject {
    /**
    controlling the LOCKING APP implementation
    we use ManagedSettings and also FamilyControl library to do the task of locking
     */
    @Published var selection = FamilyActivitySelection(includeEntireCategory: true)
    private let store = ManagedSettingsStore()
    
    init() {
        Task {
            do {
                // before we able to use family control, we need to request for authorization
                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            } catch {
                print("Error \(error)")
            }
        }
    }
    
    func lockApps() {
        // we will lock all app except what user "select" on the picker
        store.shield.applicationCategories = .all(except: selection.applicationTokens)
        print("Locked \(selection.applicationTokens.count) apps")
    }
    
    func unlockApps() {
        store.shield.applications = nil
        store.shield.applicationCategories = nil
        print("Apps unlock")
    }
}
