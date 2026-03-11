//
//  MainTabView.swift
//  FirstApp
//
//  Created by 114-2Student03 on 2026/3/9.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("總覽", systemImage: "chart.bar.fill")
                }

            ZoneListView()
                .tabItem {
                    Label("冰箱分區", systemImage: "refrigerator.fill")
                }
        }
    }
}

#Preview {
    MainTabView()
        .modelContainer(PreviewContainer.withSamples)
}
