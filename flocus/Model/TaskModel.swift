//
//  Task.swift
//  flocus
//
//  Created by Bee Wijaya on 06/04/26.
//
import Foundation
import SwiftData


@Model
class TaskModel {
    @Attribute(.unique) var id: UUID
    var name: String
    var isDone: Bool
    var order: Int
    
    init(name: String, order: Int) {
        self.id = UUID()
        self.name = name
        self.isDone = false
        self.order = order
    }
}
