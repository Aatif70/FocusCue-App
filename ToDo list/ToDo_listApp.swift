//
//  ToDo_listApp.swift
//  ToDo list
//
//  Created by Aatif Ahmed on 9/25/24.
//

// A simple todo list app


import SwiftUI
import UserNotifications

@main
struct ToDo_listApp: App {
    init() {
        requestNotificationPermission()
        setupNotificationCategories() 
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
    }
    
    
    
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Error requesting notification permission: \(error)")
            }
        }
    }
    
    func setupNotificationCategories() {
        let completeAction = UNNotificationAction(identifier: "COMPLETE_ACTION", title: "Complete", options: [.foreground])
        let category = UNNotificationCategory(identifier: "TASK_CATEGORY", actions: [completeAction], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
}
