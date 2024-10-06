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
                    
                    addTaskToCalendar(task: newTask) { success, eventIdentifier, error in
                        if success, let eventIdentifier = eventIdentifier {
                            newTask.eventIdentifier = eventIdentifier
                            tasks.append(newTask)
                            saveTasks(tasks)
                            print("Task added to calendar")
                        } else {
                            print("Failed to add task to calendar: \(String(describing: error))")
                        }
                    }
                    
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(title.isEmpty)
            )
        }
    }
    
    // Function to add task to calendar
    func addTaskToCalendar(task: Task, completion: @escaping (Bool, String?, Error?) -> Void) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { granted, error in
            guard granted else {
                completion(false, nil, error)
                return
            }
            
            let event = EKEvent(eventStore: eventStore)
            event.title = task.title
            event.notes = task.description
            event.startDate = task.dueDate ?? Date()
            event.endDate = (task.dueDate ?? Date()).addingTimeInterval(3600) // 1 hour duration
            event.calendar = eventStore.defaultCalendarForNewEvents
            
            do {
                try eventStore.save(event, span: .thisEvent)
                completion(true, event.eventIdentifier, nil)
            } catch let error {
                completion(false, nil, error)
            }
        }
    }
    
    func saveTasks(_ tasks: [Task]) {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "tasks")
        }
    }
}

#Preview {
    AddTaskView(tasks: .constant([]))
}