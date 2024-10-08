//
//  AddTaskView.swift
//  ToDo list
//
//  Created by Aatif Ahmed on 9/25/24.
//

import SwiftUI
import EventKit

struct AddTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var tasks: [Task]
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var dueDate: Date = Date()
    @State private var dueTime: Date = Date()
    @State private var priority: Priority = .medium
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Description", text: $description)
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                DatePicker("Due Time", selection: $dueTime, displayedComponents: .hourAndMinute)
                Picker("Priority", selection: $priority) {
                    ForEach(Priority.allCases, id: \.self) { priority in
                        Text(priority.rawValue.capitalized)
                    }
                }
            }
            .navigationBarTitle("Add Task")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Add") {
                    let combinedDate = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: dueTime),
                                                             minute: Calendar.current.component(.minute, from: dueTime),
                                                             second: 0,
                                                             of: dueDate) ?? dueDate
                    
                    var newTask = Task(title: title, description: description, dueDate: combinedDate, priority: priority)
                    
                    print("Adding task: \(newTask.title) with due date: \(String(describing: newTask.dueDate))")
                    
                    addTaskToCalendar(task: newTask) { success, eventIdentifier, error in
                        if success, let eventIdentifier = eventIdentifier {
                            newTask.eventIdentifier = eventIdentifier
                            tasks.append(newTask)
                            print("Task added to calendar")
                            
                            // Schedule notification for the new task
                            scheduleNotification(for: newTask)
                        } else {
                            print("Failed to add task to calendar: \(String(describing: error))")
                        }
                    }
                    
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(title.isEmpty)
            )
            .background(colorScheme == .dark ? Color.darkBackground : Color.lightBackground)
        }
    }
    
    // Function to add task to calendar
    func addTaskToCalendar(task: Task, completion: @escaping (Bool, String?, Error?) -> Void) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { granted, error in
            if let error = error {
                print("Error requesting calendar access: \(error.localizedDescription)")
                completion(false, nil, error)
                return
            }
            
            guard granted else {
                print("Calendar access not granted")
                completion(false, nil, nil)
                return
            }
            
            let event = EKEvent(eventStore: eventStore)
            event.title = task.title
            event.notes = task.description
            event.startDate = task.dueDate ?? Date()
            event.endDate = (task.dueDate ?? Date()).addingTimeInterval(3600) // 1 hour duration
            
            // Set the calendar to the default calendar for new events
            if let defaultCalendar = eventStore.defaultCalendarForNewEvents {
                event.calendar = defaultCalendar
            } else {
                print("No default calendar found.")
                completion(false, nil, nil)
                return
            }
            
            do {
                try eventStore.save(event, span: .thisEvent)
                print("Event saved: \(event.title) at \(event.startDate) with identifier: \(event.eventIdentifier)")
                completion(true, event.eventIdentifier, nil)
            } catch let error {
                print("Failed to save event: \(error.localizedDescription)")
                completion(false, nil, error)
            }
        }
    }
    
    func saveTasks(_ tasks: [Task]) {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "tasks")
        }
    }
    
    func scheduleNotification(for task: Task) {
        guard let dueDate = task.dueDate else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Task Due: \(task.title)"
        content.body = task.description
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "TASK_CATEGORY"

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: task.id.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled for task: \(task.title)")
            }
        }
    }
    
    func setupNotificationCategories() {
        let completeAction = UNNotificationAction(identifier: "COMPLETE_ACTION", title: "Complete", options: [.foreground])
        let category = UNNotificationCategory(identifier: "TASK_CATEGORY", actions: [completeAction], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    func deleteEventFromCalendar(_ eventIdentifier: String) {
        let eventStore = EKEventStore()
        print("Attempting to delete event with identifier: \(eventIdentifier)")
        
        eventStore.requestAccess(to: .event) { granted, error in
            if let error = error {
                print("Error requesting access: \(error.localizedDescription)")
            }
            
            guard granted else {
                print("Access to calendar not granted")
                return
            }
            
            DispatchQueue.main.async {
                if let event = eventStore.event(withIdentifier: eventIdentifier) {
                    do {
                        try eventStore.remove(event, span: .thisEvent)
                        print("Event successfully deleted from calendar")
                    } catch let error {
                        print("Failed to delete event: \(error.localizedDescription)")
                    }
                } else {
                    print("Event not found with identifier: \(eventIdentifier). It may have been deleted already.")
                }
            }
        }
    }
}

#Preview {
    AddTaskView(tasks: .constant([]))
}
