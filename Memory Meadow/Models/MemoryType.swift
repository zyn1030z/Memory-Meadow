//
//  MemoryType.swift
//  Memory Meadow
//
//  Created by Macbook on 16/5/26.
//

import SwiftUI

enum MemoryType: String, Codable, CaseIterable, Identifiable {
    case knowledge
    case task
    case emotion

    var id: String { rawValue }

    var title: String {
        switch self {
        case .knowledge:
            return "Knowledge"
        case .task:
            return "Task"
        case .emotion:
            return "Emotion"
        }
    }

    var systemImage: String {
        switch self {
        case .knowledge:
            return "lightbulb"
        case .task:
            return "checklist"
        case .emotion:
            return "heart"
        }
    }

    var tintColor: Color {
        switch self {
        case .knowledge:
            return .yellow
        case .task:
            return .green
        case .emotion:
            return .purple
        }
    }
}