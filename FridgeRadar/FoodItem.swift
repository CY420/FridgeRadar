//
//  FoodItem.swift
//  FridgeRadarApp
//
//  Created by Patrick on 2026/3/9.
//

import Foundation
import SwiftData

// MARK: - StorageSection

/// 食物存儲分區
enum StorageSection: String, Codable, CaseIterable, Sendable {
    case refrigerated = "冷藏"
    case frozen       = "冷凍"
    case dryGoods     = "乾貨"

    var systemImage: String {
        switch self {
        case .refrigerated: return "thermometer.medium"
        case .frozen:       return "snowflake"
        case .dryGoods:     return "archivebox"
        }
    }
}

// MARK: - FoodItem

/// 冰箱食材資料模型（SwiftData）
@Model
final class FoodItem {

    // MARK: Stored Properties

    var name: String
    var quantity: Double
    var unit: String
    var expirationDate: Date
    var storageSectionRaw: String   // 以 String 儲存 Enum 原始值，相容 SwiftData
    var addedDate: Date

    // MARK: Computed Properties

    /// 存儲分區（透過 Enum 存取）
    @Transient
    var storageSection: StorageSection {
        get { StorageSection(rawValue: storageSectionRaw) ?? .refrigerated }
        set { storageSectionRaw = newValue.rawValue }
    }

    /// 距離有效日期的剩餘天數（負數表示已過期）
    @Transient
    var daysRemaining: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let expiry = calendar.startOfDay(for: expirationDate)
        return calendar.dateComponents([.day], from: today, to: expiry).day ?? 0
    }

    /// 是否已過期
    @Transient
    var isExpired: Bool { daysRemaining < 0 }

    // MARK: Init

    init(
        name: String,
        quantity: Double,
        unit: String,
        expirationDate: Date,
        storageSection: StorageSection = .refrigerated,
        addedDate: Date = .now
    ) {
        self.name              = name
        self.quantity          = quantity
        self.unit              = unit
        self.expirationDate    = expirationDate
        self.storageSectionRaw = storageSection.rawValue
        self.addedDate         = addedDate
    }
}
