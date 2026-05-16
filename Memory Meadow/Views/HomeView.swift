//
//  HomeView.swift
//  Memory Meadow
//
//  Created by Macbook on 16/5/26.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MemoryItem.createdAt, order: .reverse) private var memories: [MemoryItem]

    @State private var showingAddMemory = false
    @State private var selectedMemory: MemoryItem?

    var flowerCount: Int {
        memories.filter { $0.type == .knowledge }.count
    }

    var treeCount: Int {
        memories.filter { $0.type == .task }.count
    }

    var body: some View {
        ZStack {
            MeadowSceneView(memories: memories, selectedMemory: $selectedMemory)
                .ignoresSafeArea()

            HomeHUDView(
                greeting: "Chào Hùng",
                subtitle: "Hôm nay cánh đồng của bạn thế nào?",
                weatherIcon: "sun.max.fill",
                notificationCount: 0,
                flowerCount: flowerCount,
                treeCount: treeCount,
                totalCount: memories.count,
                onAddPressed: { showingAddMemory = true }
            )
        }
        .sheet(isPresented: $showingAddMemory) {
            AddMemoryView()
        }
        .sheet(item: $selectedMemory) { memory in
            MemoryDetailView(memory: memory)
        }
    }
}