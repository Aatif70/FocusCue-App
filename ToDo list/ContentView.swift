import SwiftUI

struct ContentView: View {
    @State private var tasks: [Task] = []
    @State private var showingAddTask = false
    @State private var showingCalendar = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                (colorScheme == .dark ? Color(hex: "561C24") : Color(hex: "FFE7E7"))
                    .ignoresSafeArea()
                
                
                
                
                VStack {
                    Text("Task List")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(colorScheme == .dark ? .white : Color(hex: "FF6969"))
                       
                    
                    List {
                        
                        
                        // MARK: UPCOMING TASKS
                        Section(header: Text("Upcoming Tasks")
                            .foregroundColor(Color.pink)
                            .bold()
                            .fontWeight(.bold)
                            .padding(.top, 10)
                           
                            
                    
                    ) {
                            ForEach($tasks.filter { !$0.isCompleted.wrappedValue }, id: \.id) { $task in
                                TaskRow(task: $task)
                            }
                            .onDelete(perform: deleteUncompletedTask)
                        }
                            if tasks.isEmpty {
                                Text("No tasks yet")
                                    .font(.body)
                                    
                            }
                        
                        // MARK: COMPLETED TASKS
                        Section(header: Text("Completed Tasks")
                            .foregroundColor(Color.pink)
                            .bold()
                            .fontWeight(.bold)
                            .padding(.top, 50)
                        
                        ) {
                            ForEach($tasks.filter { $0.isCompleted.wrappedValue }, id: \.id) { $task in
                                TaskRow(task: $task)
                            }
                            .onDelete(perform: deleteCompletedTask)
                        }
                        if tasks.isEmpty {
                            Text("You haven't done anything yet")
                                .font(.body)
                            }
                            
                        
                    }
                    .listStyle(InsetGroupedListStyle())
                    .background(colorScheme == .dark ? Color(hex: "692323") : Color(hex: "F8EDE3"))
                    .cornerRadius(25.0)
                    Spacer()
                    
                    
                    Button(action: {
                        showingCalendar = true
                    }) {
                        HStack {
                            Image(systemName: "calendar")
                            Text("View Calendar")
                        }
                        .padding()
                        .background(colorScheme == .dark ? Color(hex: "C80036") : Color(hex: "FF6969"))
                        .foregroundColor(.white)
                        .cornerRadius(24)
                    }
                    .padding(.top)
                }
                .padding(.all, 20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddTask = true }) {
                        Image(systemName: "plus")
                            .foregroundColor(colorScheme == .dark ? .white : Color(hex: "4A4947"))
                    }
                    .padding(.trailing, 2.0)
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskView(tasks: $tasks)
            }
            .sheet(isPresented: $showingCalendar) {
                NavigationView {
                    CalendarView(tasks: $tasks)
                }
            }
          
        }
    }
    
    func deleteUncompletedTask(at offsets: IndexSet) {
        let uncompletedTasks = tasks.filter { !$0.isCompleted }
        for index in offsets {
            if let taskIndex = tasks.firstIndex(where: { $0.id == uncompletedTasks[index].id }) {
                tasks.remove(at: taskIndex)
            }
        }
    }
    
    func deleteCompletedTask(at offsets: IndexSet) {
        let completedTasks = tasks.filter { $0.isCompleted }
        for index in offsets {
            if let taskIndex = tasks.firstIndex(where: { $0.id == completedTasks[index].id }) {
                tasks.remove(at: taskIndex)
            }
        }
    }
}

struct TaskRow: View {
    @Binding var task: Task
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(task.isCompleted ? .gray : Color(.pink))
                .onTapGesture {
                    task.isCompleted.toggle()
                }
            
            VStack(alignment: .leading) {
                Text(task.title)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .strikethrough(task.isCompleted)
                Text(task.description)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .strikethrough(task.isCompleted)
                    .font(.footnote)
                    
                if let dueDate = task.dueDate {
                    Text(dueDate, style: .date)
                        .font(.caption)
                        .foregroundColor(colorScheme == .dark ? .gray : Color(hex: "795757"))
                }
            }
        
            Spacer()
            
            Circle()
                .fill(task.priority.color)
                .frame(width: 14, height: 14)
        }
        
    }
}

#Preview {
    ContentView()
}
