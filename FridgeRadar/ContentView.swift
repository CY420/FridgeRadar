//
//  ContentView.swift
//  FirstApp
//
//  Created by 114-2Student03 on 2026/3/9.
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
