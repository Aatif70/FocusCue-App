import SwiftUI
import EventKit

extension Color {
    static let lightBackground = Color(hex: "#FFFFFF")
    static let lightText = Color(hex: "#2E2E2E")
    static let lightCardBackground = Color(hex: "#F9F9F9")
    static let lightCardBorder = Color(hex: "#E0E0E0")
    static let lightDivider = Color(hex: "#D1D1D1")
    static let lightButtonColor = Color(hex: "#4A90E2")
    
    static let darkBackground = Color(hex: "#1C1C1E")
    static let darkText = Color(hex: "#E5E5E5")
    static let darkCardBackground = Color(hex: "#2C2C2E")
    static let darkCardBorder = Color(hex: "#3A3A3C")
    static let darkDivider = Color(hex: "#444446")
    static let darkButtonColor = Color(hex: "#357ABD")
}

struct ContentView: View {
    @State private var tasks: [Task] = [] // Start with an empty array
    @State private var showingAddTask = false
    @State private var showingCalendar = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            (colorScheme == .dark ? Color.darkBackground : Color.lightBackground)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: { showingAddTask = true }) {
                        Image(systemName: "plus")
                            .foregroundColor(colorScheme == .dark ? .white : Color.lightButtonColor)
                    }
                    .padding(.trailing, 20.0)
                }
                
                Text("Task List")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(colorScheme == .dark ? .white : Color.lightText)
                
                List {
                    // MARK: UPCOMING TASKS
                    Section(header: Text("Upcoming Tasks")
                        .foregroundColor(Color.pink)
                        .bold()
                        .fontWeight(.bold)
                        .padding(.top, 10)
                    ) {
                        ForEach(tasks.filter { !$0.isCompleted }, id: \.id) { task in
                            TaskRow(task: .constant(task), onComplete: {
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
                        ForEach(tasks.filter { $0.isCompleted }, id: \.id) { task in
                            TaskRow(task: .constant(task))
                        }
                        .onDelete(perform: deleteTask)
                    }
                    
                    if tasks.isEmpty {
                        Text("You haven't done anything yet")
                            .font(.body)
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .background(colorScheme == .dark ? Color.darkBackground : Color.lightBackground)
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
                    .background(colorScheme == .dark ? Color.darkButtonColor : Color.lightButtonColor)
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
                        .foregroundColor(colorScheme == .dark ? .white : Color.lightButtonColor)
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
        }
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
    
    func deleteTask(at offsets: IndexSet) {
        for index in offsets {
            let task = tasks[index]
            if let eventIdentifier = task.eventIdentifier {
                deleteEventFromCalendar(eventIdentifier)
            }
            tasks.remove(at: index)
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
                .foregroundColor(task.isCompleted ? .gray : Color(hex: "006D77"))
                .onTapGesture {
                    onComplete?()
                }
            
            VStack(alignment: .leading) {
                Text(task.title)
                    .foregroundColor(colorScheme == .dark ? .white : Color.lightText)
                    .strikethrough(task.isCompleted)
                Text(task.description)
                    .foregroundColor(colorScheme == .dark ? .white : Color.lightText)
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
        .padding()
        .background(colorScheme == .dark ? Color.darkCardBackground : Color.lightCardBackground)
        .cornerRadius(10)
        .shadow(color: colorScheme == .dark ? Color.darkCardBorder : Color.lightCardBorder, radius: 1, x: 0, y: 1)
    }
}

#Preview {
    ContentView()
}