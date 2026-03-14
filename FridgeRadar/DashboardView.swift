//
//  DashboardView.swift
//  FridgeRadarApp
//
//  Created by Patrick on 2026/3/9.
//

import SwiftUI
import SwiftData

struct DashboardView: View {

    @Query(sort: \FoodItem.expirationDate) private var items: [FoodItem]

    // MARK: Derived data

    private var expiringSoon: [FoodItem] {
        items.filter { $0.daysRemaining >= 0 && $0.daysRemaining <= 3 }
    }

    private var expiredItems: [FoodItem] {
        items.filter { $0.isExpired }
    }

    private var totalCount: Int { items.count }

    // MARK: Body

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack(alignment: .top) {

                    // ── 背景：冰箱插圖（置頂，淡化後做裝飾底圖）──
                    Image("fridge_illustration")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height * 1.50)
                        .clipped()
                        .opacity(0.15)
                        // 底部漸層淡出，與內容卡片自然銜接
                        .mask(
                            LinearGradient(
                                stops: [
                                    .init(color: .black, location: 0.0),
                                    .init(color: .black, location: 0.6),
                                    .init(color: .clear, location: 1.0)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .ignoresSafeArea(edges: .top)

                    // ── 前景：可捲動內容 ──
                    ScrollView {
                        VStack(spacing: 20) {
                            // ── 統計卡片列 ──
                            statisticsRow

                            // ── 快過期清單 ──
                            expiringSoonSection
                        }
                        .padding(.horizontal)
                        .padding(.top, 12)
                        .padding(.bottom, 32)
                    }
                }
            }
            .navigationTitle("總覽")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: Statistics

    private var statisticsRow: some View {
        HStack(spacing: 12) {
            StatCard(
                title: "食材總數",
                value: "\(totalCount)",
                systemImage: "list.bullet",
                tint: .blue
            )
            StatCard(
                title: "快過期",
                value: "\(expiringSoon.count)",
                systemImage: "exclamationmark.triangle.fill",
                tint: .orange
            )
            StatCard(
                title: "已過期",
                value: "\(expiredItems.count)",
                systemImage: "xmark.circle.fill",
                tint: .red
            )
        }
    }

    // MARK: Expiring Soon

    @ViewBuilder
    private var expiringSoonSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("即將過期（≤ 3 天）")
                .font(.custom("Huiwen-mincho", size: 20).bold())

            if expiringSoon.isEmpty {
                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.green)
                        Text("目前沒有快過期的食材 🎉")
                            .font(.custom("Huiwen-mincho", size: 15))
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding(.vertical, 24)
            } else {
                ForEach(expiringSoon) { item in
                    ExpiringSoonRow(item: item)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - StatCard

private struct StatCard: View {
    let title: String
    let value: String
    let systemImage: String
    let tint: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.title)
                .foregroundStyle(tint)
                .padding(12)
                .background(tint.opacity(0.15), in: Circle())

            Text(value)
                .font(.custom("Huiwen-mincho", size: 34).bold())
                .foregroundStyle(.primary)

            Text(title)
                .font(.custom("Huiwen-mincho", size: 15))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 22)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(.white.opacity(0.85), lineWidth: 1.2)
        )
        .shadow(color: tint.opacity(0.55), radius: 8, x: 0, y: 4)
    }
}

// MARK: - ExpiringSoonRow

private struct ExpiringSoonRow: View {
    let item: FoodItem

    private var badgeColor: Color {
        let days = item.daysRemaining
        return days < 3 ? .orange : .orange
    }

    var body: some View {
        HStack(spacing: 0) {
            // ── 左側色條 ──
            RoundedRectangle(cornerRadius: 3)
                .fill(badgeColor)
                .frame(width: 5)
                .padding(.vertical, 4)
                .padding(.trailing, 14)

            // ── 分區圖示 ──
            Image(systemName: item.storageSection.systemImage)
                .font(.title2)
                .foregroundStyle(badgeColor)
                .frame(width: 36)

            // ── 名稱 ＋ 副標題 ──
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.custom("Huiwen-mincho", size: 17).bold())
                Text("\(item.quantity.formatted()) \(item.unit) · \(item.storageSection.rawValue)")
                    .font(.custom("Huiwen-mincho", size: 15))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            // ── 天數徽章 ──
            let days = item.daysRemaining
            VStack(spacing: 3) {
                Text(days < 0 ? "已過期" : days == 0 ? "今天" : "\(days)")
                    .font(.custom("Huiwen-mincho", size: 22).bold())
                    .foregroundStyle(badgeColor)
                if days > 0 {
                    Text("天後到期")
                        .font(.custom("Huiwen-mincho", size: 11))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(badgeColor.opacity(0.35), lineWidth: 1)
        )
        .shadow(color: badgeColor.opacity(0.18), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Preview

#Preview {
    DashboardView()
        .modelContainer(PreviewContainer.withSamples)
}
