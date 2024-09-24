//
//  Task.swift
//  ToDo list
//
//  Created by Aatif Ahmed on 9/25/24.
//


import SwiftUI

struct Task: Identifiable {
    let id = UUID()
    var title: String
    var description: String
    var dueDate: Date?
    var priority: Priority
    var isCompleted: Bool = false
}

enum Priority: String, CaseIterable {
    case low, medium, high
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .yellow
        case .high: return .red
        }
    }
}