//
//  HomeScreen.swift
//  flocus
//
//  Created by Bee Wijaya on 06/04/26.
//

import SwiftUI
import SwiftData

struct HomeScreen: View {
    // MARK: - Model
    @Environment(\.modelContext) private var context
    @Query(sort: \TaskModel.order) var tasks: [TaskModel]

    // MARK: - State
    @State var showAddTask = false
    @State private var showStartTask = false
    @State private var showModal1 = false
    @State var showCustomAvatar = false
    @State var showCustomMusic = false
    @State var showExcludeApp = false
    @State private var taskInput = ""
    @State var isEditingMode = false
    @State var editMode: EditMode = .inactive

    // MARK: - ViewModel
    @StateObject private var familyControlViewModel = FamilyControlViewModel()
    @EnvironmentObject var taskViewModel: TaskViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Color("Secondary").ignoresSafeArea()

                if tasks.isEmpty {
                    HomeEmptyView()
                } else {
                    HomeTaskListView(
                        tasks: tasks,
                        isEditingMode: isEditingMode,
                        onDelete: { taskViewModel.deleteTask($0, tasks: tasks) },
                        onMove: { taskViewModel.moveTask(tasks: tasks, from: $0, to: $1) },
                        onStartTask: { showStartTask = true }
                    )
                }
            }
            .toolbar { homeToolbar }
            .environment(\.editMode, $editMode)
            .onChange(of: tasks) {
                taskViewModel.save()
                if tasks.isEmpty {
                    isEditingMode = false
                    editMode = .inactive
                }
            }
            .alert("Add your task!", isPresented: $showAddTask) {
                TextField("Input Task", text: $taskInput)
                Button("Cancel", role: .cancel) { taskInput = "" }
                Button("Add") {
                    taskViewModel.addTask(name: taskInput, count: tasks.count)
                    taskInput = ""
                }
            } message: {
                Text("Each task should be one clear action.")
            }
            .alert("Continue?", isPresented: $showStartTask) {
                Button("Cancel", role: .cancel) { showStartTask = false }
                Button("Continue") {
                    showModal1 = true
                    showStartTask = false
                }
            } message: {
                Text("This action will lock all of your apps.")
            }
            .fullScreenCover(isPresented: $showModal1) {
                PickTimerScreen(isPresented: $showModal1, familyControlViewModel: familyControlViewModel)
                    .environmentObject(taskViewModel)
            }
            .sheet(isPresented: $showCustomAvatar) {
                CustomAvatarScreen(isPresented: $showCustomAvatar)
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showCustomMusic) {
                CustomMusicScreen(isPresented: $showCustomMusic)
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showExcludeApp) {
                ExcludeApp(isPresented: $showExcludeApp, familyControlViewModel: familyControlViewModel)
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.medium])
            }
        }
    }
}

// MARK: - Empty State

struct HomeEmptyView: View {
    var body: some View {
        VStack(spacing: 0) {
            MascotSpeechBubble(message: "Add a task to get started")
                .padding(.top, 40)

            Image("Mascot")
                .resizable()
                .frame(width: 300, height: 300)
                .padding(.top, -20)

            Text("Let's finish your tasks one at a time!")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color("Primary"))

            Spacer()
        }
    }
}

// MARK: - Task List

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
                        ForEach(tasks) { task in
                            HStack {
                                if isEditingMode {
                                    TextField("Edit Task", text: Binding(
                                        get: { task.name },
                                        set: { task.name = $0 }
                                    ))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())

                                    Button {
                                        onDelete(task)
                                    } label: {
                                        Image(systemName: "trash")
                                            .foregroundStyle(.red)
                                    }
                                } else {
                                    Text("\(task.order + 1). \(task.name)")
                                        .foregroundColor(Color("Primary"))
                                    Spacer()
                                }
                            }
                            .listRowBackground(Color.white)
                            .listRowSeparatorTint(Color.gray.opacity(0.3))
                            .listRowSeparator(tasks.first?.id == task.id ? .hidden : .visible, edges: .top)
                            .listRowSeparator(tasks.last?.id == task.id ? .hidden : .visible, edges: .bottom)
                        }
                        .onMove(perform: onMove)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 24)

            PrimaryButton(title: "Start Task") {
                onStartTask()
            }
            .padding(.vertical, 16)
            .disabled(isEditingMode)
            .opacity(isEditingMode ? 0.5 : 1)
        }
    }
}

#Preview {
    HomeScreen()
        .modelContainer(for: TaskModel.self, inMemory: true)
}
