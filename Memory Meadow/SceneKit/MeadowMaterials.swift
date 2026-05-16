//
//  MeadowMaterials.swift
//  Memory Meadow
//
//  Created by Macbook on 16/5/26.
//

import SceneKit
import UIKit

enum MeadowMaterials {
    // Grass materials - low poly style
    static let grassBase = createGrassMaterial(
        color: UIColor(red: 0.42, green: 0.72, blue: 0.42, alpha: 1.0),
        roughness: 0.85,
        metalness: 0.0
    )

    static let grassLight = createGrassMaterial(
        color: UIColor(red: 0.52, green: 0.78, blue: 0.52, alpha: 1.0),
        roughness: 0.85,
        metalness: 0.0
    )

    static let grassDark = createGrassMaterial(
        color: UIColor(red: 0.32, green: 0.66, blue: 0.32, alpha: 1.0),
        roughness: 0.85,
        metalness: 0.0
    )

    // Flower materials
    static let flowerStem = createGrassMaterial(
        color: UIColor(red: 0.35, green: 0.75, blue: 0.35, alpha: 1.0),
        roughness: 0.75,
        metalness: 0.0
    )

    static let flowerPetalsPink = createFlowerMaterial(
        color: UIColor(red: 0.95, green: 0.65, blue: 0.85, alpha: 1.0),
        roughness: 0.6,
        metalness: 0.1
    )

    static let flowerPetalsYellow = createFlowerMaterial(
        color: UIColor(red: 0.98, green: 0.85, blue: 0.45, alpha: 1.0),
        roughness: 0.6,
        metalness: 0.1
    )

    // Tree materials
    static let treeTrunk = createTreeMaterial(
        color: UIColor(red: 0.42, green: 0.32, blue: 0.25, alpha: 1.0),
        roughness: 0.9,
        metalness: 0.0
    )

    static let treeLeaves = createTreeMaterial(
        color: UIColor(red: 0.38, green: 0.62, blue: 0.38, alpha: 1.0),
        roughness: 0.8,
        metalness: 0.0
    )

    // Stone materials
    static let stone = createStoneMaterial(
        color: UIColor(red: 0.55, green: 0.5, blue: 0.45, alpha: 1.0),
        roughness: 0.95,
        metalness: 0.0
    )

    // Firefly materials
    static let fireflyGlow = createFireflyMaterial(
        color: UIColor(red: 0.85, green: 0.65, blue: 1.0, alpha: 1.0),
        emissive: UIColor(red: 0.95, green: 0.85, blue: 1.0, alpha: 1.0)
    )

    // Cloud materials
    static let cloud = createCloudMaterial(
        color: UIColor.white.withAlphaComponent(0.9),
        roughness: 0.95,
        metalness: 0.0
    )

    // Sky/fog color
    static let skyColor = UIColor(red: 0.66, green: 0.84, blue: 1.0, alpha: 1.0)
    static let fogColor = UIColor(red: 0.7, green: 0.85, blue: 1.0, alpha: 0.3)

    // Helper functions
    private static func createGrassMaterial(color: UIColor, roughness: Float, metalness: Float) -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = color
        material.roughness.contents = roughness
        material.metalness.contents = metalness
        material.lightingModel = .physicallyBased
        return material
    }

    private static func createFlowerMaterial(color: UIColor, roughness: Float, metalness: Float) -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = color
        material.roughness.contents = roughness
        material.metalness.contents = metalness
        material.lightingModel = .physicallyBased
        material.transparencyMode = .rgbZero
        return material
    }

    private static func createTreeMaterial(color: UIColor, roughness: Float, metalness: Float) -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = color
        material.roughness.contents = roughness
        material.metalness.contents = metalness
        material.lightingModel = .physicallyBased
        return material
    }

    private static func createStoneMaterial(color: UIColor, roughness: Float, metalness: Float) -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = color
        material.roughness.contents = roughness
        material.metalness.contents = metalness
        material.lightingModel = .physicallyBased
        return material
    }

    private static func createFireflyMaterial(color: UIColor, emissive: UIColor) -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = color
        material.emission.contents = emissive
        material.lightingModel = .physicallyBased
        return material
    }

    private static func createCloudMaterial(color: UIColor, roughness: Float, metalness: Float) -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = color
        material.roughness.contents = roughness
        material.metalness.contents = metalness
        material.lightingModel = .physicallyBased
        return material
    }
}