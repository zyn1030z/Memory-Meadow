//
//  MeadowTheme.swift
//  Memory Meadow
//

import Foundation
import UIKit

enum MeadowTheme: String, CaseIterable, Identifiable {
    case spring
    case night
    case autumn
    case winter
    case minimal
    case fantasy

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .spring: return "🌱 Spring"
        case .night: return "🌙 Night"
        case .autumn: return "🍂 Autumn"
        case .winter: return "❄️ Winter"
        case .minimal: return "🏔 Minimal"
        case .fantasy: return "🌌 Fantasy"
        }
    }

    var description: String {
        switch self {
        case .spring: return "Hoa nhiều, màu sáng"
        case .night: return "Trời đêm, đom đóm"
        case .autumn: return "Lá vàng, gió"
        case .winter: return "Tuyết rơi"
        case .minimal: return "Ít vật thể, tối giản"
        case .fantasy: return "Cây phát sáng, sao rơi"
        }
    }

    var skyColor: UIColor {
        switch self {
        case .spring: return UIColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0)
        case .night: return UIColor(red: 0.05, green: 0.08, blue: 0.15, alpha: 1.0)
        case .autumn: return UIColor(red: 0.85, green: 0.65, blue: 0.45, alpha: 1.0)
        case .winter: return UIColor(red: 0.75, green: 0.82, blue: 0.88, alpha: 1.0)
        case .minimal: return UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        case .fantasy: return UIColor(red: 0.15, green: 0.12, blue: 0.35, alpha: 1.0)
        }
    }

    var grassColor: UIColor {
        switch self {
        case .spring: return UIColor(red: 0.2, green: 0.75, blue: 0.3, alpha: 1.0)
        case .night: return UIColor(red: 0.12, green: 0.25, blue: 0.15, alpha: 1.0)
        case .autumn: return UIColor(red: 0.65, green: 0.55, blue: 0.25, alpha: 1.0)
        case .winter: return UIColor(red: 0.88, green: 0.92, blue: 0.95, alpha: 1.0)
        case .minimal: return UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        case .fantasy: return UIColor(red: 0.25, green: 0.55, blue: 0.65, alpha: 1.0)
        }
    }

    var sunIntensity: CGFloat {
        switch self {
        case .spring: return 980
        case .night: return 150
        case .autumn: return 750
        case .winter: return 850
        case .minimal: return 1200
        case .fantasy: return 400
        }
    }

    var ambientIntensity: CGFloat {
        switch self {
        case .spring: return 420
        case .night: return 80
        case .autumn: return 350
        case .winter: return 500
        case .minimal: return 600
        case .fantasy: return 200
        }
    }

    var decorCounts: (grass: Int, flowers: Int, stones: Int, trees: Int, fireflies: Int) {
        switch self {
        case .spring: return (grass: 60, flowers: 40, stones: 5, trees: 8, fireflies: 0)
        case .night: return (grass: 30, flowers: 10, stones: 8, trees: 5, fireflies: 25)
        case .autumn: return (grass: 40, flowers: 15, stones: 12, trees: 10, fireflies: 0)
        case .winter: return (grass: 20, flowers: 5, stones: 15, trees: 3, fireflies: 0)
        case .minimal: return (grass: 10, flowers: 5, stones: 3, trees: 2, fireflies: 0)
        case .fantasy: return (grass: 35, flowers: 30, stones: 5, trees: 12, fireflies: 20)
        }
    }

    var enableClouds: Bool {
        switch self {
        case .spring, .autumn, .winter: return true
        case .night, .minimal, .fantasy: return false
        }
    }

    var enableBirds: Bool {
        switch self {
        case .spring, .autumn: return true
        case .night, .winter, .minimal, .fantasy: return false
        }
    }
}
