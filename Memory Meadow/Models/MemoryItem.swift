//
//  MemoryItem.swift
//  Memory Meadow
//
//  Created by Macbook on 16/5/26.
//

import Foundation
import SwiftData

@Model
final class MemoryItem: Identifiable {
    @Attribute(.unique) var id: UUID
    var content: String
    var type: MemoryType
    var createdAt: Date
    var xPosition: Float
    var zPosition: Float

    init(
        id: UUID = UUID(),
        content: String,
        type: MemoryType,
        createdAt: Date = Date(),
        xPosition: Float,
        zPosition: Float
    ) {
        self.id = id
        self.content = content
        self.type = type
        self.createdAt = createdAt
        self.xPosition = xPosition
        self.zPosition = zPosition
    }
}