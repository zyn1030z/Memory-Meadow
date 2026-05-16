//
//  AddMemoryView.swift
//  Memory Meadow
//
//  Created by Macbook on 16/5/26.
//

import SwiftUI
import SwiftData

struct AddMemoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var content = ""
    @State private var selectedType: MemoryType = .knowledge

    var isSaveDisabled: Bool {
        content.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text("Hôm nay bạn muốn lưu điều gì?")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Chọn loại ký ức và chia sẻ suy nghĩ của bạn")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 16)

            // Text Editor
            TextEditor(text: $content)
                .frame(minHeight: 120)
                .padding(12)
                .background(Color(uiColor: .systemBackground))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .padding(.horizontal, 20)

            // Category Cards
            VStack(alignment: .leading, spacing: 12) {
                Text("Loại ký ức")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 20)

                HStack(spacing: 12) {
                    ForEach(MemoryType.allCases) { type in
                        MemoryTypeCard(
                            type: type,
                            isSelected: selectedType == type,
                            action: { selectedType = type }
                        )
                    }
                }
                .padding(.horizontal, 20)
            }

            Spacer()

            // Save Button
            Button(action: saveMemory) {
                Text("Lưu ký ức")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(
                        LinearGradient(
                            colors: [.green, .yellow.opacity(0.7)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                    .shadow(color: Color.green.opacity(0.4), radius: 8, x: 0, y: 4)
            }
            .disabled(isSaveDisabled)
            .opacity(isSaveDisabled ? 0.5 : 1.0)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(Color(uiColor: .systemBackground))
    }

    private func saveMemory() {
        let trimmedContent = content.trimmingCharacters(in: .whitespaces)
        guard !trimmedContent.isEmpty else { return }

        let position = MemoryPositionGenerator.randomPosition()
        let memory = MemoryItem(
            content: trimmedContent,
            type: selectedType,
            xPosition: position.x,
            zPosition: position.z
        )

        modelContext.insert(memory)
        dismiss()
    }
}