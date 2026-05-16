//
//  MemoryPositionGenerator.swift
//  Memory Meadow
//
//  Created by Macbook on 16/5/26.
//

import Foundation

enum MemoryPositionGenerator {
    static func randomPosition() -> (x: Float, z: Float) {
        (
            x: Float.random(in: -8...8),
            z: Float.random(in: -8...8)
        )
    }
}