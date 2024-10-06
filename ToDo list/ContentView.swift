import SwiftUI
import EventKit

struct ContentView: View {
    @State private var tasks: [Task] = loadTasks()
    @State private var showingAddTask = false
    @State private var showingCalendar = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            (colorScheme == .dark ? Color(hex: "561C24") : Color(hex: "FFE7E7"))
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: { showingAddTask = true }) {
                        Image(systemName: "plus")
                            .foregroundColor(colorScheme == .dark ? .white : Color(hex: "4A4947"))
                    }
                    .padding(.trailing, 20.0)
                }
                
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
                            TaskRow(task: $task, onComplete: {
                                markTaskAsComplete(task: task)
                            })
                        }
                        .onDelete(perform: deleteTask)
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
                        .onDelete(perform: deleteTask)
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
            CalendarView(tasks: $tasks)
        }
    }
    
    func markTaskAsComplete(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            if let eventIdentifier = tasks[index].eventIdentifier {
                deleteEventFromCalendar(eventIdentifier)
            }
            tasks[index].isCompleted = true
            saveTasks(tasks)
        }
    }
    
    func deleteEventFromCalendar(_ eventIdentifier: String) {
        let eventStore = EKEventStore()
        print("Attempting to delete event with identifier: \(eventIdentifier)")
        
        if let event = eventStore.event(withIdentifier: eventIdentifier) {
            do {
                try eventStore.remove(event, span: .thisEvent)
                print("Event successfully deleted from calendar")
            } catch let error {
                print("Failed to delete event: \(error.localizedDescription)")
            }
        } else {
            print("Event not found with identifier: \(eventIdentifier)")
        }
    }
    
    func deleteTask(at offsets: IndexSet) {
        for index in offsets {
            let task = tasks[index]
            if let eventIdentifier = task.eventIdentifier {
                deleteEventFromCalendar(eventIdentifier)
            }
            tasks.remove(at: index)
        }
        saveTasks(tasks)
    }
    
    static func loadTasks() -> [Task] {
        if let data = UserDefaults.standard.data(forKey: "tasks"),
           let tasks = try? JSONDecoder().decode([Task].self, from: data) {
            return tasks
        }
        return []
    }
    
    func saveTasks(_ tasks: [Task]) {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "tasks")
        }
    }
}

struct TaskRow: View {
    @Binding var task: Task
    @Environment(\.colorScheme) var colorScheme
    var onComplete: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(task.isCompleted ? .gray : Color(.pink))
                .onTapGesture {
                    onComplete?()
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
        .contentShape(Rectangle()) // Make the entire row tappable
        .onTapGesture {
            onComplete?()
        }
    }
}

#Preview {
    ContentView()
}