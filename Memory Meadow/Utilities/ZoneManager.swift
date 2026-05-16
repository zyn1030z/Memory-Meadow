//
//  ZoneManager.swift
//  Memory Meadow
//

import Foundation

enum ZoneManager {
    static let phase4Threshold = 100

    typealias PositionBounds = (x: ClosedRange<Float>, z: ClosedRange<Float>)

    static func isPhase4Active(memoryCount: Int) -> Bool {
        memoryCount >= phase4Threshold
    }

    static func placementRange(for memoryCount: Int) -> PositionBounds {
        if isPhase4Active(memoryCount: memoryCount) {
            return (x: -20...20, z: -20...20)
        }
        return (x: -8...8, z: -8...8)
    }

    static func cameraBounds(for memoryCount: Int) -> PositionBounds {
        if isPhase4Active(memoryCount: memoryCount) {
            return (x: -28...28, z: -10...30)
        }
        return (x: -14...14, z: 8...20)
    }
}
