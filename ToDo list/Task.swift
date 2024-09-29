//
//  Task.swift
//  ToDo list
//
//  Created by Aatif Ahmed on 9/25/24.
//


import SwiftUI
import UserNotifications

struct Task: Identifiable {
    let id = UUID()
        var title: String
        var description: String
        var dueDate: Date?
        var priority: Priority
        var isCompleted: Bool = false
    
    func scheduleNotification() {
        guard let dueDate = dueDate else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Task Due: \(title)"
        content.body = description
        content.sound = UNNotificationSound.default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    static func == (lhs: Task, rhs: Task) -> Bool {
            lhs.id == rhs.id
        }
    
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


