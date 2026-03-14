//
//  NotificationManager.swift
//  FridgeRadarApp
//
//  Created by Patrick on 2026/3/9.
//

import UserNotifications
import Foundation
import SwiftData

/// 管理本地通知的單例，負責權限請求與排程食材到期提醒。
@MainActor
final class NotificationManager {

    static let shared = NotificationManager()
    private init() {}

    private let center = UNUserNotificationCenter.current()

    // MARK: - 請求通知權限

    /// 向使用者請求通知授權（alert、badge、sound）。
    /// 若已授權則靜默成功；若被拒絕則不重複詢問。
    func requestPermission() {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error {
                print("⚠️ 通知授權請求失敗：\(error.localizedDescription)")
            } else {
                print(granted ? "✅ 通知授權已取得" : "🔕 使用者拒絕通知授權")
            }
        }
    }

    // MARK: - 排程食材到期通知

    /// 為指定食材排程一個「到期前 24 小時」的本地通知。
    /// - Parameter item: 要提醒的 FoodItem（需有唯一的 persistentModelID）
    func scheduleExpirationNotification(for item: FoodItem) {
        // 計算觸發時間：到期日當天午夜 - 提前 24 小時 = 到期日前一天的相同時間
        let triggerDate = Calendar.current
            .date(byAdding: .hour, value: -24, to: item.expirationDate) ?? item.expirationDate

        // 若觸發時間已過，不排程（避免立即爆發舊資料通知）
        guard triggerDate > .now else {
            print("ℹ️ \(item.name) 的通知觸發時間已過，跳過排程")
            return
        }

        // 預先擷取需要用到的值，避免在 @Sendable 閉包中捕獲非 Sendable 的 model
        let itemName = item.name
        let identifier = item.persistentModelID.hashValue.description
        let scheduledTime = triggerDate

        // 通知內容
        let content = UNMutableNotificationContent()
        content.title = "🧊 食材即將到期"
        content.body = "\(itemName)（\(item.quantity.formatted()) \(item.unit)）將於明天到期，請盡快使用！"
        content.sound = .default
        content.badge = 1

        // 以日期元件作為觸發器（精確到分鐘）
        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: triggerDate
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )

        center.add(request) { error in
            if let error {
                print("⚠️ 通知排程失敗（\(itemName)）：\(error.localizedDescription)")
            } else {
                print("🔔 已排程通知：\(itemName) — 觸發時間：\(scheduledTime.formatted())")
            }
        }
    }

    // MARK: - 取消通知

    /// 取消指定食材的待發通知（刪除食材時呼叫）。
    func cancelNotification(for item: FoodItem) {
        let identifier = item.persistentModelID.hashValue.description
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}

