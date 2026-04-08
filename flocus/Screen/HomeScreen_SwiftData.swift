//
//  HomeScreen-SwiftData.swift
//  flocus
//
//  Created by Richie Daryl Kwenandar on 08/04/26.
//

import SwiftUI
import SwiftData

struct HomeScreen_SwiftData: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \TaskModel.order) private var tasks: [TaskModel]
    @State private var showAddTask = false
    @State private var taskInput = ""
    
    
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
                                ScrollView {
                                    VStack(spacing: 0) {
                                        ForEach(tasks) { task in
                                            HStack {
                                                Text("\(task.order + 1). \(task.name)")
                                                    .foregroundColor(Color("Primary"))
                                                Spacer()
                                            }
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 14)
                                            
                                            if task.id != tasks.last?.id {
                                                Divider()
                                                    .padding(.horizontal, 16)
                                            }
                                        }
                                    }
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
                    Image(systemName: "pencil")
                    Button(action: { showAddTask = true }) {
                        Image(systemName: "plus")
                    }
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
        }
    }
}

#Preview {
    HomeScreen_SwiftData()
        .modelContainer(for: TaskModel.self)
}
