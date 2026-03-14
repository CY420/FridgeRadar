//
//  MockData.swift
//  FridgeRadarApp
//
//  Created by Patrick on 2026/3/9.
//

import Foundation

// MARK: - MockData

/// 測試用假資料（不依賴 SwiftData context，可直接用於 Preview）
enum MockData {

    static let sampleItems: [FoodItem] = {
        let calendar = Calendar.current
        let now = Date.now

        func date(daysFromNow days: Int) -> Date {
            calendar.date(byAdding: .day, value: days, to: now) ?? now
        }

        return [
            FoodItem(
                name: "鮮奶",
                quantity: 1,
                unit: "瓶",
                expirationDate: date(daysFromNow: 5),
                storageSection: .refrigerated
            ),
            FoodItem(
                name: "雞蛋",
                quantity: 10,
                unit: "顆",
                expirationDate: date(daysFromNow: 14),
                storageSection: .refrigerated
            ),
            FoodItem(
                name: "冷凍水餃",
                quantity: 30,
                unit: "顆",
                expirationDate: date(daysFromNow: 60),
                storageSection: .frozen
            ),
            FoodItem(
                name: "豬絞肉",
                quantity: 500,
                unit: "g",
                expirationDate: date(daysFromNow: -2),  // 已過期
                storageSection: .frozen
            ),
            FoodItem(
                name: "白米",
                quantity: 5,
                unit: "kg",
                expirationDate: date(daysFromNow: 365),
                storageSection: .dryGoods
            ),
            FoodItem(
                name: "燕麥片",
                quantity: 800,
                unit: "g",
                expirationDate: date(daysFromNow: 180),
                storageSection: .dryGoods
            ),
        ]
    }()
}
