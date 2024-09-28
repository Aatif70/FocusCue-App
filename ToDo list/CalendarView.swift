import SwiftUI

struct CalendarView: View {
    @Binding var tasks: [Task]
    
    @State private var selectedDate = Date()
    
    private var tasksByDate: [Date: [Task]] {
        Dictionary(grouping: tasks.filter { $0.dueDate != nil }, by: { Calendar.current.startOfDay(for: $0.dueDate!) })
    }
    
    var body: some View {
        VStack {
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
            
            List {
                ForEach(tasksForSelectedDate(), id: \.id) { task in
                    VStack(alignment: .leading) {
                        Text(task.title)
                            .font(.headline)
                        Text(task.description)
                            .font(.subheadline)
                        if let dueDate = task.dueDate {
                            Text(dueDate, style: .time)
                                .font(.caption)
                        }
                    }
                }
            }
        }
        .navigationTitle("Task Calendar")
    }
    
    private func tasksForSelectedDate() -> [Task] {
        let startOfDay = Calendar.current.startOfDay(for: selectedDate)
        return tasksByDate[startOfDay] ?? []
    }
}