//
//  ContentView.swift
//  ToDo list
//
//  Created by Aatif Ahmed on 9/25/24.
//


import SwiftUI

struct ContentView: View {
    @State private var tasks: [Task] = []
    @State private var showingAddTask = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Upcoming Tasks")) {
                    ForEach($tasks.filter { !$0.isCompleted.wrappedValue }, id: \.id) { $task in
                        TaskRow(task: $task)
                    }
                    .onDelete(perform: deleteTask)
                }
                
                Section(header: Text("Completed Tasks")) {
                    ForEach($tasks.filter { $0.isCompleted.wrappedValue }, id: \.id) { $task in
                        TaskRow(task: $task)
                    }
                    .onDelete(perform: deleteTask)
                }
            }
            .navigationTitle("Task List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddTask = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskView(tasks: $tasks)
            }
        }
    }
    
    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
}

struct TaskRow: View {
    @Binding var task: Task
    
    var body: some View {
        HStack {
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(task.isCompleted ? .green : .gray)
                .onTapGesture {
                    task.isCompleted.toggle()
                }
            
            VStack(alignment: .leading) {
                Text(task.title)
                    .strikethrough(task.isCompleted)
                if let dueDate = task.dueDate {
                    Text(dueDate, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Circle()
                .fill(task.priority.color)
                .frame(width: 10, height: 10)
        }
    }
}


#Preview {
    ContentView()
}
