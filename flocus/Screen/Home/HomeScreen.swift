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
    @Query(sort: \TaskModel.createdAt) var tasks: [TaskModel]

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
    @EnvironmentObject var familyControlViewModel: FamilyControlViewModel
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var timerViewModel: TimerViewModel
    @EnvironmentObject var avatarViewModel: AvatarViewModel
    

    var body: some View {
        NavigationStack {
            ZStack {
                Color("Secondary").ignoresSafeArea()

                if taskViewModel.isEmpty(tasks: tasks) {
                    // MARK: - Empty State
                    HomeEmptyView()
                } else {
                    // MARK: - Task List
                    HomeTaskListView(
                        tasks: tasks.filter { task in !task.isDone },
                        isEditingMode: isEditingMode,
                        onDelete: { task in taskViewModel.deleteTask(task) },
                        onMove: { source, destination in taskViewModel.moveTask(tasks: tasks, from: source, to: destination) },
                        onStartTask: { showStartTask = true }
                    )
                }
            }
            // MARK: - Toolbar
            .toolbar { homeToolbar }
            .environment(\.editMode, $editMode)
            // MARK: - Alert system
            .alert("Add your task!", isPresented: $showAddTask) {
                TextField("Input Task", text: $taskInput)
                Button("Cancel", role: .cancel) { taskInput = "" }
                Button("Add") {
                    taskViewModel.addTask(name: taskInput)
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
                PickTimerScreen(isPresented: $showModal1)
                    .environmentObject(timerViewModel)
                    .environmentObject(taskViewModel)
                    .environmentObject(familyControlViewModel)
                    .environmentObject(avatarViewModel)
            }
            .sheet(isPresented: $showCustomAvatar) {
                CustomAvatarScreen(isPresented: $showCustomAvatar)
                    .presentationDragIndicator(.visible)
                    .environmentObject(avatarViewModel)
            }
            .sheet(isPresented: $showCustomMusic) {
                CustomMusicScreen(isPresented: $showCustomMusic)
                    .presentationDragIndicator(.visible)
                    .environmentObject(avatarViewModel)
            }
            .sheet(isPresented: $showExcludeApp) {
                ExcludeApp(isPresented: $showExcludeApp)
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.medium])
                    .environmentObject(familyControlViewModel)
            }
            // MARK: - Event Lifecycle
            .onChange(of: tasks) {
                taskViewModel.save()
                if taskViewModel.isEmpty(tasks: tasks) {
                    isEditingMode = false
                    editMode = .inactive
                }
            }
            .onAppear {
                if taskViewModel.isEmpty(tasks: tasks) {
                    isEditingMode = false
                    editMode = .inactive
                }
            }
        }
    }
}


#Preview {
    let container = try! ModelContainer(for: TaskModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let familyControlViewModel = FamilyControlViewModel()

    HomeScreen()
        .modelContainer(container)
        .environmentObject(familyControlViewModel)
        .environmentObject(TaskViewModel(context: container.mainContext))
        .environmentObject(TimerViewModel(seconds: 0, familyControlViewModel: familyControlViewModel))
        .environmentObject(AvatarViewModel())
}
