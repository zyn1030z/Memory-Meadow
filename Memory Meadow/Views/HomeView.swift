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

    var body: some View {
        ZStack {
            MeadowSceneView(memories: memories, selectedMemory: $selectedMemory)
                .ignoresSafeArea()

            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Memory Meadow")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("\(memories.count) memories")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Button(action: { showingAddMemory = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundStyle(.blue)
                    }
                }
                .padding()
                .background(Color(uiColor: .systemBackground).opacity(0.9))
                .cornerRadius(12)
                .padding()

                Spacer()
            }
        }
        .sheet(isPresented: $showingAddMemory) {
            AddMemoryView()
        }
        .sheet(item: $selectedMemory) { memory in
            MemoryDetailView(memory: memory)
        }
    }
}