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

    var body: some View {
        NavigationStack {
            Form {
                Section("Memory Type") {
                    Picker("Type", selection: $selectedType) {
                        ForEach(MemoryType.allCases) { type in
                            HStack {
                                Image(systemName: type.systemImage)
                                    .foregroundStyle(type.tintColor)
                                Text(type.title)
                            }
                            .tag(type)
                        }
                    }
                }

                Section("Content") {
                    TextEditor(text: $content)
                        .frame(minHeight: 120)
                }
            }
            .navigationTitle("Add Memory")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveMemory()
                    }
                    .disabled(content.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
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