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
    @State private var priority = Priority.medium     // keeping priority as Medium by default
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    
    
    var body: some View {
        NavigationView {
            
            
            Form {
                
                TextField("Title", text: $title)
                    .foregroundColor(Color(.gray))
                
                TextField("Description", text: $description)
                    .foregroundColor(Color(.gray))
               
                
                DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                    .foregroundColor(Color(.gray))
                
                Picker("Priority", selection: $priority) {
                    ForEach(Priority.allCases, id: \.self) { priority in
                        Text(priority.rawValue.capitalized)
                    }
                }
                .foregroundColor(Color(.gray))
            }
           
            .navigationTitle("Add Task")
            
            
            
            
            // MARK: CANCEL AND SAVE BUTTONS
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
                    .foregroundColor(Color(.pink))
                    .disabled(title.isEmpty)
            )
        }
        //   .accentColor(colorScheme == .dark ? .white : Color(hex: "4A4947"))
        
        .accentColor(colorScheme == .dark ? .pink : Color.pink)
        
        }
    }

//#Preview {
//    AddTaskView(tasks: .constant([]))
//}
