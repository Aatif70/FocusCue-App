# FocusCue App

## Overview

The FocusCue List App is a simple task management application for iOS built using SwiftUI and EventKit. It allows users to create, manage, and delete tasks while synchronizing with the iCloud Calendar. The app provides a clean and minimalistic interface, supporting both light and dark modes.

## Features

- **Task Management**: Add, view, and delete tasks.
- **iCloud Calendar Integration**: Sync tasks with the iCloud Calendar, ensuring that tasks are reflected in the user's calendar.
- **Notifications**: Schedule notifications for tasks to remind users of upcoming deadlines.
- **Light and Dark Mode Support**: The app automatically adjusts its appearance based on the user's system settings.

## Technologies Used

- **SwiftUI**: For building the user interface.
- **EventKit**: For managing calendar events and reminders.
- **UserNotifications**: For scheduling local notifications.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Aatif70/todo-list-app.git
   cd todo-list-app
   ```

2. Open the project in Xcode:
   ```bash
   open ToDo\ list.xcodeproj
   ```

3. Build and run the app on a physical device or simulator.

## Usage

1. **Adding a Task**:
   - Tap the "+" button to open the "Add Task" view.
   - Fill in the task title, description, due date, and priority.
   - Tap "Add" to save the task, which will also create an event in the iCloud Calendar.

2. **Viewing Tasks**:
   - The main view displays a list of upcoming tasks.
   - Completed tasks can be viewed in a separate section.

3. **Deleting a Task**:
   - Swipe left on a task to reveal the delete option.
   - Deleting a task will also remove the corresponding event from the iCloud Calendar.

4. **Calendar View**:
   - Access the calendar view to see tasks organized by date.

## Code Structure

- **`AddTaskView.swift`**: Handles the UI and logic for adding new tasks.
- **`ContentView.swift`**: The main view displaying the list of tasks.
- **`CalendarView.swift`**: Displays tasks in a calendar format.
- **`Task.swift`**: Defines the `Task` model and its properties.
- **`ToDo_listApp.swift`**: The main entry point of the app, setting up notifications and permissions.

## Contributing

Contributions are welcome! If you have suggestions for improvements or new features, feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.


