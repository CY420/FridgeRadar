//
//  ZoneListView.swift
//  FirstApp
//
//  Created by 114-2Student03 on 2026/3/9.
//

import SwiftUI
import SwiftData

struct ZoneListView: View {

    @Query(sort: \FoodItem.expirationDate) private var items: [FoodItem]
    @Environment(\.modelContext) private var modelContext

    @State private var showAddSheet = false
    @State private var preselectedSection: StorageSection = .refrigerated

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

                    // ── 前景：List ──
                    List {
                        ForEach(StorageSection.allCases, id: \.self) { section in
                            ZoneSectionView(
                                section: section,
                                items: items.filter { $0.storageSection == section },
                                onDelete: delete
                            )
                        }
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("冰箱分區")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddFoodItemView()
            }
        }
    }

    // MARK: Delete

    private func delete(item: FoodItem) {
        modelContext.delete(item)
    }
}

// MARK: - ZoneSectionView

private struct ZoneSectionView: View {
    let section: StorageSection
    let items: [FoodItem]
    let onDelete: (FoodItem) -> Void

    private var sectionColor: Color {
        switch section {
        case .refrigerated: return .cyan
        case .frozen:       return .blue
        case .dryGoods:     return .orange
        }
    }

    var body: some View {
        Section {
            if items.isEmpty {
                Label("此分區尚無食材", systemImage: "tray")
                    .foregroundStyle(.tertiary)
                    .font(.custom("Huiwen-mincho", size: 15))
            } else {
                ForEach(items) { item in
                    FoodItemRowView(item: item)
                }
                .onDelete { indexSet in
                    indexSet.map { items[$0] }.forEach(onDelete)
                }
            }
        } header: {
            HStack(spacing: 10) {
                Image(systemName: section.systemImage)
                    .font(.subheadline.bold())
                    .foregroundStyle(sectionColor)
                    .padding(7)
                    .background(sectionColor.opacity(0.15), in: Circle())

                Text(section.rawValue)
                    .font(.custom("Huiwen-mincho", size: 17).bold())
                    .foregroundStyle(.primary)

                Spacer()

                Text("\(items.count) 項")
                    .font(.custom("Huiwen-mincho", size: 12).bold())
                    .foregroundStyle(sectionColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(sectionColor.opacity(0.12), in: Capsule())
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 4)
        }
    }
}

// MARK: - FoodItemRowView

private struct FoodItemRowView: View {
    let item: FoodItem

    private var statusColor: Color {
        let days = item.daysRemaining
        if days < 0  { return .red }
        if days <= 3 { return .orange }
        return .green
    }

    var body: some View {
        HStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 3)
                .fill(statusColor)
                .frame(width: 4)
                .padding(.vertical, 4)
                .padding(.trailing, 12)

            VStack(alignment: .leading, spacing: 3) {
                Text(item.name)
                    .font(.custom("Huiwen-mincho", size: 17).bold())
                Text("\(item.quantity.formatted()) \(item.unit)")
                    .font(.custom("Huiwen-mincho", size: 14))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                let days = item.daysRemaining
                Text(days < 0 ? "已過期" : days == 0 ? "今天" : "\(days)")
                    .font(.custom("Huiwen-mincho", size: 20).bold())
                    .foregroundStyle(statusColor)
                if days > 0 {
                    Text("天後到期")
                        .font(.custom("Huiwen-mincho", size: 11))
                        .foregroundStyle(.secondary)
                } else if days == 0 {
                    Text("今天到期")
                        .font(.custom("Huiwen-mincho", size: 11))
                        .foregroundStyle(statusColor)
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(statusColor.opacity(0.35), lineWidth: 1)
        )
        .shadow(color: statusColor.opacity(0.22), radius: 6, x: 0, y: 3)
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16))
    }
}

// MARK: - Preview

#Preview {
    ZoneListView()
        .modelContainer(PreviewContainer.withSamples)
}
