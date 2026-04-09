//
//  HomeScreen.swift
//  flocus
//
//  Created by Bee Wijaya on 06/04/26.
//

import SwiftUI


struct HomeScreen: View {
    @State private var showAddTask = false
    @State private var taskInput = ""
    @State private var tasks: [String] = []
    @State private var isEditingMode = false
    @State private var editMode: EditMode = .inactive
//    @Environment(\.modelContext) private var modelContext
//    @Query(sort: \TaskModel.order) private var tasks: [TaskModel]
    
    func moveTask(from source: IndexSet, to destination: Int) {
        tasks.move(fromOffsets: source, toOffset: destination)
    }
    
//    func moveTask(from source: IndexSet, to destination: Int) {
//        var revisedTasks = tasks
//        revisedTasks.move(fromOffsets: source, toOffset: destination)
//
//        for index in revisedTasks.indices {
//            revisedTasks[index].order = index
//        }
//    }
    
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
                                        ForEach(tasks.indices, id: \.self) { index in
                                            HStack {
                                                if isEditingMode {
                                                    TextField ("Edit Task", text: $tasks[index])
                                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                                    Button {
                                                        tasks.remove(at: index)
                                                    } label: {
                                                        Image(systemName: "trash")
                                                            .foregroundStyle(.red)
                                                    }
                                                }
                                                else {
                                                    Text("\(index + 1). \(tasks[index])")
                                                        .foregroundColor(Color("Primary"))
                                                    Spacer()
                                                }
                                            }
                                            
//                                            .padding(.horizontal, 16)
//                                            .padding(.vertical, 14)
                                            
//                                            if index < tasks.count - 1 {
//                                                Divider()
//                                                    .padding(.horizontal, 16)
//                                            }
                                        }
                                    
//                                    ForEach(tasks) { task in
//                                        HStack {
//                                            if editMode == .active {
//                                                TextField("Edit Task", text: Binding(
//                                                    get: { task.name },
//                                                    set: { task.name = $0 }
//                                                ))
//
//                                                Button {
//                                                    modelContext.delete(task)
//                                                } label: {
//                                                    Image(systemName: "trash")
//                                                        .foregroundStyle(.red)
//                                                }
//
//                                            } else {
//                                                Text(task.name)
//                                            }
//                                        }
//                                    }
                                        .onMove(perform: moveTask)
                                        .listStyle(.plain)
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                            .padding(.horizontal, 24)
                        
                        PrimaryButton(title: "Start Task") {
                            // alert
                        }
                        .padding(.vertical, 16)
                    }
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu("", systemImage: "gear") {
                        Button("Custom Avatar") {}
                        Button("Custom Music") {}
                        Button("Exclude Apps") {}
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
                        Button(action: { showAddTask = true }) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .environment(\.editMode, $editMode)
            
            .alert("Add your task!", isPresented: $showAddTask) {
                TextField("Input Task", text: $taskInput)
                Button("Cancel", role: .cancel) { taskInput = "" }
                Button("Add") {
                    if !taskInput.isEmpty {
                        tasks.append(taskInput)
                        taskInput = ""
                    }
                }
//                Button("Add") {
//                    let trimmed = taskInput.trimmingCharacters(in: .whitespacesAndNewlines)
//
//                    if !trimmed.isEmpty {
//                        let newTask = TaskModel(
//                            name: trimmed,
//                            order: tasks.count
//                        )
//                        modelContext.insert(newTask)
//                        taskInput = ""
//                    }
//                }
            }
            message: {
                Text("Each task should be one clear action.")
            }
        }
    }
}

#Preview {
    HomeScreen()
}
