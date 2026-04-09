//
//  TaskViewModel.swift
//  flocus
//
//  Created by Bee Wijaya on 09/04/26.
//

import SwiftUI
import SwiftData
import Combine

// MARK: - TaskViewModel

@MainActor
class TaskViewModel: ObservableObject {
    private let context: ModelContext
    
    // MARK: - Init
    
    init(context: ModelContext) {
        self.context = context
    }
    
    // MARK: - CRUD
    
    func addTask(name: String) {
        guard !name.isEmpty else { return }
        context.insert(TaskModel(name: name))
    }
    
    func deleteTask(_ task: TaskModel) {
        context.delete(task)
        try? context.save()
    }
    
    func markDoneTask(_ task: TaskModel) {
        task.isDone.toggle()
        try? context.save()
    }
    
    func clear(tasks: [TaskModel]) {
        tasks.forEach { task in context.delete(task) }
        try? context.save()
    }

    // MARK: - Ordering

    func moveTask(tasks: [TaskModel], from source: IndexSet, to destination: Int) {
        var revised = tasks
        revised.move(fromOffsets: source, toOffset: destination)
        revised.enumerated().forEach { index, task in
            task.createdAt = Date(timeIntervalSinceNow: Double(index))
        }
        try? context.save()
    }

    // MARK: - Persistence

    func save() {
        try? context.save()
    }

    // MARK: - Get

    func getCurrentTask(tasks: [TaskModel]) -> TaskModel? {
        return tasks.first(where: { task in !task.isDone })
    }
    
    
    func isEmpty(tasks: [TaskModel]) -> Bool {
        return tasks.isEmpty || tasks.allSatisfy({ task in task.isDone })
    }
}
