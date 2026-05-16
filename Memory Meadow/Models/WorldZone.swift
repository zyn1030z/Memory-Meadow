//
//  WorldZone.swift
//  Memory Meadow
//

import Foundation

enum WorldZone: String, CaseIterable {
    case centralMeadow
    case easternGrove
    case westernHills
    case northernGarden
    case southernShore

    var xRange: ClosedRange<Float> {
        switch self {
        case .centralMeadow: return -8...8
        case .easternGrove: return 8...20
        case .westernHills: return -20 ... -8
        case .northernGarden: return -8...8
        case .southernShore: return -8...8
        }
    }

    var zRange: ClosedRange<Float> {
        switch self {
        case .centralMeadow: return -8...8
        case .easternGrove: return -8...8
        case .westernHills: return -8...8
        case .northernGarden: return 8...20
        case .southernShore: return -20 ... -8
        }
    }

    static func zone(for x: Float, z: Float) -> WorldZone {
        for zone in Self.allCases where zone.xRange.contains(x) && zone.zRange.contains(z) {
            return zone
        }
        return .centralMeadow
    }
}
