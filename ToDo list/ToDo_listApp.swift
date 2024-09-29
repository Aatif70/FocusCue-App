//
//  ToDo_listApp.swift
//  ToDo list
//
//  Created by Aatif Ahmed on 9/25/24.
//


import SwiftUI
import UserNotifications

@main
struct ToDo_listApp: App {
    init() {
        requestNotificationPermission()
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
}
