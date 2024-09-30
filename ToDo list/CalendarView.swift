import SwiftUI

struct CalendarView: View {
    @Binding var tasks: [Task]
        @State private var selectedDate: Date = Date()
        private let calendar = Calendar.current
        @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            CalendarHeaderView(selectedDate: $selectedDate)
            CalendarGridView(selectedDate: $selectedDate, tasks: tasks)
            CalendarTaskListView(tasks: tasksForSelectedMonth())
        }
        .background(colorScheme == .dark ? Color.black : Color.white)
        
    }
    
    private func tasksForSelectedMonth() -> [Task] {
           guard let monthInterval = calendar.dateInterval(of: .month, for: selectedDate) else {
               return []
           }
           
           return tasks.filter { task in
               guard let dueDate = task.dueDate else { return false }
               return dueDate >= monthInterval.start && dueDate < monthInterval.end
           }.sorted { $0.dueDate! < $1.dueDate! }
       }
   }
    
    private func monthYearString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }




struct CalendarTaskListView: View {
    let tasks: [Task]
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
            List {
               
                ForEach(tasks) { task in
                    CalendarTaskRow(task: task)
                }
               
                if tasks.isEmpty {
                    Text("No tasks yet")
                        .font(.headline)
                        .foregroundColor(colorScheme == .dark ? .gray : .black)
                }
            }
//            .listStyle(InsetGroupedListStyle())
            .background(colorScheme == .dark ? Color.black : Color(hex: "F8EDE3"))
            
        
    }
}



struct CalendarTaskRow: View {
    let task: Task
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(task.isCompleted ? .gray : Color(hex: "006D77"))
            
            VStack(alignment: .leading) {
                Text(task.title)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .strikethrough(task.isCompleted)
                if let dueDate = task.dueDate {
                    Text(dueDate, style: .date)
                        .font(.caption)
                        .foregroundColor(colorScheme == .dark ? .gray : Color(hex: "795757"))
                }
            }
            
            Spacer()
            
            Circle()
                .fill(task.priority.color)
                .frame(width: 10, height: 10)
        }
        .padding(.vertical, 8)
    }
}





struct CalendarHeaderView: View {
    @Binding var selectedDate: Date
    private let calendar = Calendar.current
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        HStack {
            Button(action: { selectedDate = calendar.date(byAdding: .month, value: -1, to: selectedDate)! }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(colorScheme == .dark ? Color.pink : Color.pink)
            }
            
            Spacer()
            Text(monthYearString(for: selectedDate))
                .font(.title2)
            Spacer()
            
            Button(action: { selectedDate = calendar.date(byAdding: .month, value: 1, to: selectedDate)! }) {
                Image(systemName: "chevron.right")
                    .foregroundColor(colorScheme == .dark ? Color.pink : Color.pink)
            }
        }
        .padding()
        .foregroundColor(colorScheme == .dark ? Color(.pink) : Color(.black))
    }
    
    private func monthYearString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}





struct CalendarGridView: View {
    @Binding var selectedDate: Date
        let tasks: [Task]
        private let calendar = Calendar.current
        private let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.gray)
                        .bold()
                }
            }
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                ForEach(daysInMonth(for: selectedDate), id: \.self) { date in
                    if let date = date {
                        DayView(date: date, selectedDate: $selectedDate, tasks: tasksForDate(date))
                    } else {
                        Color.clear.frame(height: 40)
                    }
                }
            }
        }
        .padding()
        .foregroundColor(colorScheme == .dark ? .white : .black)
    }
    
    private func daysInMonth(for date: Date) -> [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: date) else {
            return []
        }
        
        let monthStartDate = monthInterval.start
        let monthEndDate = calendar.date(byAdding: DateComponents(day: -1), to: monthInterval.end)!
        
        let numberOfDays = calendar.component(.day, from: monthEndDate)
        let firstWeekday = calendar.component(.weekday, from: monthStartDate)
        
        let leadingEmptyDays = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        var days: [Date?] = Array(repeating: nil, count: leadingEmptyDays)
        
        for day in 1...numberOfDays {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: monthStartDate) {
                days.append(date)
            }
        }
        return days
    }
    
    private func tasksForDate(_ date: Date) -> [Task] {
           let startOfDay = calendar.startOfDay(for: date)
           let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
           
           return tasks.filter { task in
               guard let taskDate = task.dueDate else { return false }
               let taskStartOfDay = calendar.startOfDay(for: taskDate)
               return taskStartOfDay >= startOfDay && taskStartOfDay < endOfDay
           }
       }
   }



// MARK: DAY VIEW

struct DayView: View {
    let date: Date
    @Binding var selectedDate: Date
    let tasks: [Task]
    private let calendar = Calendar.current
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Text("\(calendar.component(.day, from: date))")
            
                .foregroundColor(calendar.isDate(date, inSameDayAs: selectedDate) ?
                    (colorScheme == .dark ? .white : Color(hex: "D80032")) :
                    (colorScheme == .dark ? .gray : .black))
            
            
                .frame(width: 30, height: 30)
            
                .background(calendar.isDate(date, inSameDayAs: selectedDate) ?
                            (colorScheme == .dark ? Color(.pink) : Color(hex: "FFC4C4")) : Color.clear)
                .clipShape(Circle())
                .onTapGesture {
                    selectedDate = date
                }
             
            if !tasks.isEmpty {
                Circle()
                    .fill(colorScheme == .dark ? Color.red : Color.red)
                    .frame(width: 3, height: 3)
            }
        }
//        .frame(height: 40)
    }
}






// MARK: TASK VIEW

struct TaskListView: View {
    let tasks: [Task]
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        List {
            ForEach(tasks) { task in
                TaskRow(task: .constant(task))
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}



#Preview {
  CalendarView(tasks: .constant([]))
}


