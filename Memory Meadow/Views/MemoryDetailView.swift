//
//  MemoryDetailView.swift
//  Memory Meadow
//
//  Created by Macbook on 16/5/26.
//

import SwiftUI

struct MemoryDetailView: View {
    @Environment(\.dismiss) private var dismiss

    let memory: MemoryItem

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: memory.type.systemImage)
                        .foregroundStyle(memory.type.tintColor)
                    Text(memory.type.title)
                        .font(.headline)
                }

                Text(memory.content)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(memory.createdAt, format: .dateTime.year().month().day().hour().minute())
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()
            }
            .padding()
            .navigationTitle("Memory Detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}