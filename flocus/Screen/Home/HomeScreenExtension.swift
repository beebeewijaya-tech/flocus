//
//  HomeScreenExtension.swift
//  flocus
//
//  Created by Bee Wijaya on 09/04/26.
//

import SwiftUI

extension HomeScreen {
    @ToolbarContentBuilder
    var homeToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            if !isEditingMode {
                // MARK: - Pulldown Btn
                Menu("", systemImage: "gear") {
                    Button("Custom Avatar") { showCustomAvatar = true }
                    Button("Custom Music") { showCustomMusic = true }
                    Button("Exclude App") { showExcludeApp = true }
                }
            }
        }
        ToolbarItemGroup(placement: .topBarTrailing) {
            // MARK: - Edit True
            if isEditingMode {
                Button {
                    isEditingMode = false
                    editMode = .inactive
                } label: {
                    Image(systemName: "checkmark")
                }
            } else {
                // MARK: - Edit False
                Button {
                    isEditingMode = true
                    editMode = .active
                } label: {
                    Image(systemName: "pencil")
                }
                .disabled(tasks.isEmpty)
                Button(action: { showAddTask = true }) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}
