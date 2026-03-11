
# 冰箱雷達 (FridgeRadar)

[![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-orange.svg)](https://developer.apple.com/xcode/swiftui/)
[![SwiftData](https://img.shields.io/badge/SwiftData-Ready-blue.svg)](https://developer.apple.com/documentation/swiftdata)
[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)](https://www.apple.com/ios/)

**冰箱雷達** 是一款簡潔高效的冰箱食材管理 App，旨在幫助您輕鬆追蹤家中食材的有效期限，減少食物浪費。透過直觀的儀表板和智慧提醒，您再也不會忘記那些藏在冰箱深處的寶貴食材。

![App icon](FridgeRadar/Assets.xcassets/AppIcon.appiconset/appicon.png)

## ✨ 主要功能

*   **智慧儀表板**：一目了然地查看食材總數、即將過期和已過期的項目統計。
*   **分區管理**：將食材分類至「冷藏」、「冷凍」、「乾貨」三個區域，方便查找與管理。
*   **到期日追蹤**：為每項食材設定有效日期，App 會自動計算剩餘天數並以醒目方式標示。
*   **即時新增與刪除**：流暢地新增食材，並在用完或丟棄時輕鬆滑動刪除。
*   **到期提醒**：在食材過期的前一天自動發送本地通知，提醒您及時處理。
*   **自訂單位**：提供常用單位快速選擇，也支援輸入自訂單位，滿足各種需求。

## 🛠️ 技術棧與架構

本專案完全採用 Apple 最新的原生技術開發，確保最佳的效能與使用者體驗。

*   **使用者介面 (UI)**：
    *   **SwiftUI**：整個 App 的介面皆由 SwiftUI 宣告式語法構建，實現了響應式且易於維護的視圖。
    *   **SF Symbols**：廣泛使用 Apple 的 SF Symbols 來提供一致且清晰的圖示。

*   **資料持久化**：
    *   **SwiftData**：採用 SwiftData 框架來管理 `FoodItem` 模型物件的本地儲存，取代了傳統的 Core Data，程式碼更簡潔、更 Swift-native。

*   **通知系統**：
    *   **UserNotifications**：整合 `UserNotifications` 框架，實現本地到期提醒的排程與發送。

*   **架構設計**：
    *   **MVVM (Model-View-ViewModel)**：專案遵循 MVVM 設計模式，將資料 (`FoodItem`)、視圖 (SwiftUI Views) 和業務邏輯清晰分離。
    *   **單例模式 (Singleton)**：`NotificationManager` 採用單例模式，確保在 App 中只有一個實例負責管理所有通知相關任務。
    *   **關注點分離 (Separation of Concerns)**：每個 SwiftUI 視圖都專注於其特定功能（例如 `DashboardView` 負責總覽，`ZoneListView` 負責列表展示），提高了程式碼的模組化與可讀性。

## 📂 專案結構

```
FridgeRadar/
├── FridgeRadarApp.swift        # App 入口點
├── MainTabView.swift           # 主分頁視圖 (總覽, 冰箱分區)
├── DashboardView.swift         # 總覽儀表板視圖
├── ZoneListView.swift          # 食材分區列表視圖
├── AddFoodItemView.swift       # 新增食材的表單視圖
├── FoodItem.swift              # SwiftData 資料模型
├── NotificationManager.swift   # 本地通知管理器
├── MockData.swift              # SwiftUI 預覽用的假資料
└── Assets.xcassets/            # 圖片與顏色資源
```
