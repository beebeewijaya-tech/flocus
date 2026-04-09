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
                    HomeEmptyView()
                } else {
                    HomeTaskListView(
                        tasks: tasks.filter { task in !task.isDone },
                        isEditingMode: isEditingMode,
                        onDelete: { task in taskViewModel.deleteTask(task) },
                        onMove: { source, destination in taskViewModel.moveTask(tasks: tasks, from: source, to: destination) },
                        onStartTask: { showStartTask = true }
                    )
                }
            }
            .toolbar { homeToolbar }
            .environment(\.editMode, $editMode)
            .onChange(of: tasks) {
                taskViewModel.save()
                if tasks.isEmpty || tasks.allSatisfy({ task in task.isDone }) {
                    isEditingMode = false
                    editMode = .inactive
                }
            }
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
                        ForEach(Array(tasks.enumerated()), id: \.element.id) { index, task in
                            HStack {
                                if isEditingMode {
                                    TextField("Edit Task", text: Binding(
                                        get: { task.name },
                                        set: { newName in task.name = newName }
                                    ))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())

                                    Button {
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
    let container = try! ModelContainer(for: TaskModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let familyControlViewModel = FamilyControlViewModel()

    HomeScreen()
        .modelContainer(container)
        .environmentObject(familyControlViewModel)
        .environmentObject(TaskViewModel(context: container.mainContext))
        .environmentObject(TimerViewModel(seconds: 0, familyControlViewModel: familyControlViewModel))
        .environmentObject(AvatarViewModel())
}
