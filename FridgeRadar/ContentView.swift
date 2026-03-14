//
//  ContentView.swift
//  FridgeRadarApp
//
//  Created by Patrick on 2026/3/9.
//

import SwiftUI
import SwiftData

/// App 根視圖，直接呈現 MainTabView
struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}

// MARK: - Preview

#Preview {
    ContentView()
        .modelContainer(PreviewContainer.withSamples)
}
