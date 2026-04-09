//
//  HomeScreen.swift
//  flocus
//
//  Created by Bee Wijaya on 06/04/26.
//

import SwiftUI
import SwiftData

struct HomeScreen: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \TaskModel.order) private var tasks: [TaskModel]
    
    @State private var showAddTask = false
    @State private var showStartTask = false
    @State private var showModal1 = false
    @State private var showCustomAvatar = false
    @State private var showExcludeApp = false
    @State private var taskInput = ""
    @State private var isEditingMode = false
    @State private var editMode: EditMode = .inactive
    @StateObject private var familyControlViewModel = FamilyControlViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Secondary").ignoresSafeArea()
                
                if tasks.isEmpty {
                    
                    VStack(spacing: 0) {
                        
                        ZStack {
                            Image("bubblechat")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 300, height: 100)
                            Text("Add a task to get started")
                                .font(.system(size: 16))
                                .foregroundColor(Color("Primary"))
                                .padding(.bottom, 6)
                                .padding(.trailing, 6)
                        }
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
                else {
                    VStack(spacing: 0) {
                        VStack(spacing: 4) {
                            Text("Here's your task today!")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(Color("Primary"))
                            Text("Start from the top and work your way down!")
                                .font(.system(size: 14))
                                .foregroundColor(Color("Primary").opacity(0.6))
                                .padding(.top,5)
                        }
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
                                                    context.delete(task)
                                                    try? context.save()
                                                    reorderAfterDelete()
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
                                    }
                                    .onMove(perform: moveTask)
                                }
                                .listStyle(.plain)
                                .scrollContentBackground(.hidden)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                            .padding(.horizontal, 24)
                        
                        
                        PrimaryButton(title: "Start Task") {
                            showStartTask = true
                        }
                        .padding(.vertical, 16)
                        .disabled(isEditingMode)
                        .opacity(isEditingMode ? 0.5 : 1)
                        
                    }
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if !isEditingMode {
                        Menu("", systemImage: "gear") {
                            Button("Custom Avatar") {showCustomAvatar = true}
                            Button("Custom Music") {}
                            Button("Exclude Apps") {showExcludeApp = true}
                        }
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    if isEditingMode {
                        Button {
                            isEditingMode = false
                            editMode = .inactive
                        } label: {
                            Image(systemName: "checkmark")
                        }
                    } else {
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
            .environment(\.editMode, $editMode)
            .onChange(of: tasks) {
                try? context.save()
                if tasks.isEmpty {
                    isEditingMode = false
                    editMode = .inactive
                }
            }
            .alert("Add your task!", isPresented: $showAddTask) {
                TextField("Input Task", text: $taskInput)
                Button("Cancel", role: .cancel) { taskInput = "" }
                Button("Add") {
                    if !taskInput.isEmpty {
                        let newTask = TaskModel(
                            name: taskInput,
                            order: tasks.count
                        )
                        context.insert(newTask)
                        taskInput = ""
                    }
                }
            } message: {
                Text("Each task should be one clear action.")
            }
            .alert("Continue?", isPresented: $showStartTask) {
                Button("Cancel", role: .cancel) {showStartTask = false}
                Button("Continue") {
                    showModal1 = true
                    showStartTask = false
                }
                
            } message: {
                Text("This action will lock all of your apps.")
            }
            .fullScreenCover(isPresented: $showModal1) {
                Modal1Screen(isPresented: $showModal1)
            }
            .sheet(isPresented: $showCustomAvatar) {
                CustomAvatarScreen(isPresented: $showCustomAvatar)
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showExcludeApp) {
                ExcludeApp(isPresented: $showExcludeApp, familyControlViewModel: familyControlViewModel)
                    .presentationDragIndicator(.visible)
            }
        }
    }
    
    
    func moveTask(from source: IndexSet, to destination: Int) {
        var revisedTasks = tasks
        revisedTasks.move(fromOffsets: source, toOffset: destination)
        for index in revisedTasks.indices {
            revisedTasks[index].order = index
        }
        try? context.save()
    }
    
    func reorderAfterDelete() {
        let sorted = tasks.sorted { $0.order < $1.order }
        for index in sorted.indices {
            sorted[index].order = index
        }
        try? context.save()
    }
}

#Preview {
    HomeScreen()
        .modelContainer(for: TaskModel.self, inMemory: true)
}
