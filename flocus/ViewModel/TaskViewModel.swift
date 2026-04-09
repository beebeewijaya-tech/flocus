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

    func addTask(name: String, count: Int) {
        guard !name.isEmpty else { return }
        let task = TaskModel(name: name, order: count)
        context.insert(task)
    }

    func deleteTask(_ task: TaskModel, tasks: [TaskModel]) {
        context.delete(task)
        try? context.save()
        reorderAfterDelete(tasks: tasks)
    }

    // MARK: - Ordering

    func moveTask(tasks: [TaskModel], from source: IndexSet, to destination: Int) {
        var revised = tasks
        revised.move(fromOffsets: source, toOffset: destination)
        for index in revised.indices {
            revised[index].order = index
        }
        try? context.save()
    }

    func reorderAfterDelete(tasks: [TaskModel]) {
        let sorted = tasks.sorted { $0.order < $1.order }
        for index in sorted.indices {
            sorted[index].order = index
        }
        try? context.save()
    }

    // MARK: - Persistence

    func save() {
        try? context.save()
    }
    
    // MARK: - Get
    
    func getCurrentTask(tasks: [TaskModel]) -> TaskModel? {
        return tasks.first(where: { $0.isDone == false })
    }
}
