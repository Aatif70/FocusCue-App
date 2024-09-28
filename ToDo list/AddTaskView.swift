//
//  AddTaskView.swift
//  ToDo list
//
//  Created by Aatif Ahmed on 9/25/24.
//

import SwiftUI

struct AddTaskView: View {
    @Binding var tasks: [Task]
    @State private var title = ""
    @State private var description = ""
    @State private var dueDate = Date()
    @State private var priority = Priority.medium
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Description", text: $description)
                DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                Picker("Priority", selection: $priority) {
                    ForEach(Priority.allCases, id: \.self) { priority in
                        Text(priority.rawValue.capitalized)
                    }
                }
            }
            .navigationTitle("Add Task")
            .foregroundColor(Color(hex: "4A4947"))
            
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    let newTask = Task(title: title, description: description, dueDate: dueDate, priority: priority)
                    tasks.append(newTask)
                    newTask.scheduleNotification()
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(Color(hex: "4A4947"))
                .disabled(title.isEmpty)
            )
        }
    }
}
