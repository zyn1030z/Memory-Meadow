//
//  MemoryDetailView.swift
//  Memory Meadow
//
//  Created by Macbook on 16/5/26.
//

import SwiftUI

struct MemoryDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var particleOffset: CGFloat = 0

    let memory: MemoryItem

    var body: some View {
        NavigationStack {
            ZStack {
                detailBackground

                VStack(alignment: .leading, spacing: 18) {
                    MemoryPreviewSceneView(memory: memory)
                        .frame(height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 28))
                        .shadow(color: memory.type.tintColor.opacity(0.25), radius: 20, x: 0, y: 10)

                    HStack(spacing: 8) {
                        Image(systemName: memory.type.systemImage)
                            .foregroundStyle(memory.type.tintColor)
                        Text(memory.type.title)
                            .font(.headline)
                    }

                    Text(memory.createdAt, format: .dateTime.year().month().day().hour().minute())
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(memory.content)
                        .font(.body)
                        .lineSpacing(4)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Memory Detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .onAppear {
                withAnimation(.linear(duration: 6).repeatForever(autoreverses: false)) {
                    particleOffset = -80
                }
            }
        }
    }

    private var detailBackground: some View {
        ZStack {
            LinearGradient(
                colors: [memory.type.tintColor.opacity(0.22), Color(uiColor: .systemBackground)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ForEach(0..<16, id: \.self) { index in
                Circle()
                    .fill(memory.type.tintColor.opacity(0.16))
                    .frame(width: CGFloat(4 + index % 4), height: CGFloat(4 + index % 4))
                    .offset(
                        x: CGFloat((index % 5) * 72 - 140),
                        y: CGFloat((index / 5) * 110 + 90) + particleOffset
                    )
                    .blur(radius: 0.5)
            }
        }
    }
}