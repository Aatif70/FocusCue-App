import SwiftUI

struct ContentView: View {
    @State private var tasks: [Task] = []
    @State private var showingAddTask = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemPink)
                    .ignoresSafeArea()
                
                VStack {
                    Text("Task List")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(.white))        // To do list FONT COLOR
                       
                        
                        
                    
                    List {
                        
                        // Upcoming task
                        Section(header: Text("Upcoming Tasks")
                            .foregroundColor(Color(hex: "006D77"))
                            .padding([.top, .bottom, .trailing], 10.0)) {
                            ForEach($tasks.filter { !$0.isCompleted.wrappedValue }, id: \.id) { $task in
                                TaskRow(task: $task)
                            }
                            .onDelete(perform: deleteTask)
                        }
                        
                        // Completed task
                        Section(header: Text("Completed Tasks")
                            .foregroundColor(Color(hex: "006D77"))
                            .padding([.top, .bottom, .trailing], 10.0)) {
                            ForEach($tasks.filter { $0.isCompleted.wrappedValue }, id: \.id) { $task in
                                TaskRow(task: $task)
                            }
                            .onDelete(perform: deleteTask)
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    Spacer()
                    
                    
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddTask = true }) {
                        Image(systemName: "plus")
                            .foregroundColor(Color.white)
                            .padding()
                            
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
                .foregroundColor(task.isCompleted ? .gray : Color(hex: "006D77"))
                .onTapGesture {
                    task.isCompleted.toggle()
                }
            
            VStack(alignment: .leading) {
                Text(task.title)
                    .foregroundColor(.black) // Keep task title black
                    .strikethrough(task.isCompleted)
                if let dueDate = task.dueDate {
                    Text(dueDate, style: .date)
                        .font(.caption)
                        .foregroundColor(Color(hex: "006D77"))
                }
            }
            
            Spacer()
            
            Circle()
                .fill(task.priority.color)
                .frame(width: 10, height: 10)
        }
        .listRowBackground(Color(hex: "edf6f9"))
    }
}


#Preview {
    ContentView()
}
