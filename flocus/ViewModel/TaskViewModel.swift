//
//  TaskViewModel.swift
//  flocus
//
//  Created by Bee Wijaya on 09/04/26.
//

import SwiftUI
import SwiftData
import Combine


@MainActor
class TaskViewModel: ObservableObject {
    private let context: ModelContext
    
    // MARK: - Init
    
    init(context: ModelContext) {
        self.context = context
    }
    
    // MARK: - CRUD
    func getCurrentTask(tasks: [TaskModel]) -> TaskModel? {
        return tasks.first(where: { task in !task.isDone })
    }
    
    func addTask(name: String) {
        // INSERTING into the swiftdata
        guard !name.isEmpty else { return }
        context.insert(TaskModel(name: name))
    }
    
    func deleteTask(_ task: TaskModel) {
        // DELETE record in the swiftdata
        context.delete(task)
        try? context.save()
    }
    
    func markDoneTask(_ task: TaskModel) {
        // MARK the task done
        task.isDone.toggle()
        try? context.save()
    }
    
    func clear(tasks: [TaskModel]) {
        // DELETE all tasks
        tasks.forEach { task in context.delete(task) }
        try? context.save()
    }
    
    func save() {
        // SAVE into the swiftdata
        try? context.save()
    }
    
    // MARK: - Ordering
    
    func moveTask(tasks: [TaskModel], from source: IndexSet, to destination: Int) {
        var revised = tasks
        revised.move(fromOffsets: source, toOffset: destination)
        let base = Date(timeIntervalSince1970: 0)
        revised.enumerated().forEach { index, task in
            task.createdAt = base.addingTimeInterval(Double(index))
        }
        try? context.save()
    }
    
    
    // MARK: - isEmpty
    func isEmpty(tasks: [TaskModel]) -> Bool {
        return tasks.isEmpty || tasks.allSatisfy({ task in task.isDone })
    }
}
