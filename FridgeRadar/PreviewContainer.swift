//
//  PreviewContainer.swift
//  FirstApp
//
//  Created by 114-2Student03 on 2026/3/9.
//

import SwiftData
import Foundation

/// Preview 專用的 ModelContainer 工廠，避免 try! 導致 memory crash。
@MainActor
enum PreviewContainer {

    /// 空的記憶體容器（不含 MockData）
    static var empty: ModelContainer {
        make(withMockData: false)
    }

    /// 含 MockData 的記憶體容器
    static var withSamples: ModelContainer {
        make(withMockData: true)
    }

    // MARK: Private

    private static func make(withMockData: Bool) -> ModelContainer {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: FoodItem.self,
                                               configurations: config)
            if withMockData {
                MockData.sampleItems.forEach { container.mainContext.insert($0) }
            }
            return container
        } catch {
            fatalError("❌ PreviewContainer 建立失敗：\(error)")
        }
    }
}
