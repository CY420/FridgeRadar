//
//  FridgeRadarApp.swift
//  FridgeRadarApp
//
//  Created by Patrick on 2026/3/9.
//

import SwiftUI
import SwiftData

@main
struct FridgeRadarApp: App {
    
    init() {
        // App 啟動時請求通知授權
        NotificationManager.shared.requestPermission()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: FoodItem.self)
    }
}
