//
//  MemoryPositionGenerator.swift
//  Memory Meadow
//
//  Created by Macbook on 16/5/26.
//

import Foundation

enum MemoryPositionGenerator {
    static func randomPosition(memoryCount: Int = 0) -> (x: Float, z: Float) {
        let bounds = ZoneManager.placementRange(for: memoryCount)
        return (
            x: Float.random(in: bounds.x),
            z: Float.random(in: bounds.z)
        )
    }
}