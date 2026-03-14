//
//  AddFoodItemView.swift
//  FridgeRadarApp
//
//  Created by Patrick on 2026/3/9.
//

import SwiftUI
import SwiftData

struct AddFoodItemView: View {

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    // MARK: Form State

    @State private var name: String = ""
    @State private var quantityText: String = "1"
    @State private var unit: String = "個"
    @State private var expirationDate: Date = Calendar.current.date(
        byAdding: .day, value: 7, to: .now) ?? .now
    @State private var storageSection: StorageSection = .refrigerated

    private let commonUnits = ["個", "顆", "瓶", "罐", "包", "袋", "g", "kg", "ml", "L", "份"]

    // MARK: Validation

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !unit.trimmingCharacters(in: .whitespaces).isEmpty &&
        (Double(quantityText) ?? -1) > 0
    }

    // MARK: Body

    var body: some View {
        NavigationStack {
            Form {
                // ── 基本資料 ──
                Section("食材資訊") {
                    TextField("名稱（例：鮮奶）", text: $name)
                        .font(.custom("Huiwen-mincho", size: 16))

                    HStack {
                        TextField("數量", text: $quantityText)
                            .keyboardType(.decimalPad)
                            .frame(width: 80)
                            .font(.custom("Huiwen-mincho", size: 16))

                        Divider()

                        // 單位選擇器
                        Menu {
                            ForEach(commonUnits, id: \.self) { u in
                                Button(u) { unit = u }
                            }
                        } label: {
                            HStack {
                                Text(unit.isEmpty ? "單位" : unit)
                                    .font(.custom("Huiwen-mincho", size: 16))
                                    .foregroundStyle(unit.isEmpty ? .secondary : .primary)
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Spacer()

                        // 自訂單位輸入
                        TextField("自訂單位", text: $unit)
                            .frame(width: 70)
                            .multilineTextAlignment(.trailing)
                            .font(.custom("Huiwen-mincho", size: 16))
                    }
                }

                // ── 存儲設定 ──
                Section("存儲設定") {
                    Picker("存儲分區", selection: $storageSection) {
                        ForEach(StorageSection.allCases, id: \.self) { section in
                            Label(section.rawValue, systemImage: section.systemImage)
                                .tag(section)
                        }
                    }
                    .pickerStyle(.segmented)

                    DatePicker(
                        "有效日期",
                        selection: $expirationDate,
                        in: Date.distantPast...,
                        displayedComponents: .date
                    )
                    .font(.custom("Huiwen-mincho", size: 16))
                }

                // ── 預覽剩餘天數 ──
                Section {
                    let days = Calendar.current.dateComponents(
                        [.day],
                        from: Calendar.current.startOfDay(for: .now),
                        to: Calendar.current.startOfDay(for: expirationDate)
                    ).day ?? 0

                    HStack {
                        Text("距離到期")
                            .font(.custom("Huiwen-mincho", size: 16))
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(days < 0 ? "已過期 \(abs(days)) 天" :
                             days == 0 ? "今天到期" :
                             "\(days) 天")
                            .font(.custom("Huiwen-mincho", size: 16).bold())
                            .foregroundStyle(days < 0 ? .red : days <= 3 ? .orange : .green)
                    }
                }
            }
            .navigationTitle("新增食材")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                        .font(.custom("Huiwen-mincho", size: 16))
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("儲存") { save() }
                        .font(.custom("Huiwen-mincho", size: 16))
                        .disabled(!isValid)
                }
            }
        }
    }

    // MARK: Save

    private func save() {
        let quantity = Double(quantityText) ?? 1
        let item = FoodItem(
            name: name.trimmingCharacters(in: .whitespaces),
            quantity: quantity,
            unit: unit.trimmingCharacters(in: .whitespaces),
            expirationDate: expirationDate,
            storageSection: storageSection
        )
        modelContext.insert(item)
        // 儲存後立即排程到期前 24 小時的本地通知
        NotificationManager.shared.scheduleExpirationNotification(for: item)
        dismiss()
    }
}

// MARK: - Preview

#Preview {
    AddFoodItemView()
        .modelContainer(PreviewContainer.empty)
}
