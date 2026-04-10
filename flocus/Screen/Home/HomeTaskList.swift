//
//  HomeTaskList.swift
//  flocus
//
//  Created by Bee Wijaya on 10/04/26.
//

import SwiftUI

struct HomeTaskListView: View {
    let tasks: [TaskModel]
    let isEditingMode: Bool
    let onDelete: (TaskModel) -> Void
    let onMove: (IndexSet, Int) -> Void
    let onStartTask: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            SectionHeader(
                title: "Here's your task today!",
                subtitle: "Start from the top and work your way down!"
            )
            .padding(.top, 16)
            .padding(.bottom, 12)

            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .overlay {
                    List {
                        ForEach(Array(tasks.enumerated()), id: \.element.id) { index, task in
                            HStack {
                                if isEditingMode {
                                    // MARK: - Edit Task
                                    TextField("Edit Task", text: Binding(
                                        get: { task.name },
                                        set: { newName in task.name = newName }
                                    ))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())

                                    Button {
                                        // MARK: - Deleting Task
                                        onDelete(task)
                                    } label: {
                                        Image(systemName: "trash")
                                            .foregroundStyle(.red)
                                    }
                                } else {
                                    Text("\(index + 1). \(task.name)")
                                        .foregroundColor(Color("Primary"))
                                    Spacer()
                                }
                            }
                            .listRowBackground(Color.white)
                            .listRowSeparatorTint(Color.gray.opacity(0.3))
                            .listRowSeparator(tasks.first?.id == task.id ? .hidden : .visible, edges: .top)
                            .listRowSeparator(tasks.last?.id == task.id ? .hidden : .visible, edges: .bottom)
                        }
                        // MARK: - Move Task
                        .onMove(perform: onMove)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 24)

            PrimaryButton(title: "Start Task") {
                // MARK: - Start Task
                onStartTask()
            }
            .padding(.vertical, 16)
            .disabled(isEditingMode)
            .opacity(isEditingMode ? 0.5 : 1)
        }
    }
}

