//
//  ThemePickerView.swift
//  Memory Meadow
//

import SwiftUI

struct ThemePickerView: View {
    @Binding var selectedTheme: MeadowTheme
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(MeadowTheme.allCases) { theme in
                    Button {
                        selectedTheme = theme
                        dismiss()
                    } label: {
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(theme.displayName)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                Text(theme.description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            if selectedTheme == theme {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            }
                        }
                        .padding(.vertical, 6)
                    }
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle("Đổi chủ đề cánh đồng")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
