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
        color: UIColor(red: 0.48, green: 0.76, blue: 0.50, alpha: 1.0),
        roughness: 0.82,
        metalness: 0.0
    )

    static let grassLight = createGrassMaterial(
        color: UIColor(red: 0.60, green: 0.84, blue: 0.62, alpha: 1.0),
        roughness: 0.8,
        metalness: 0.0
    )

    static let grassDark = createGrassMaterial(
        color: UIColor(red: 0.40, green: 0.68, blue: 0.42, alpha: 1.0),
        roughness: 0.86,
        metalness: 0.0
    )

    static let grassAccent = createGrassMaterial(
        color: UIColor(red: 0.67, green: 0.88, blue: 0.64, alpha: 1.0),
        roughness: 0.78,
        metalness: 0.0
    )

    static let hillSoft = createGrassMaterial(
        color: UIColor(red: 0.56, green: 0.78, blue: 0.58, alpha: 1.0),
        roughness: 0.9,
        metalness: 0.0
    )

    static let groundWarm = createGrassMaterial(
        color: UIColor(red: 0.50, green: 0.74, blue: 0.50, alpha: 1.0),
        roughness: 0.9,
        metalness: 0.0
    )

    static let barkLight = createTreeMaterial(
        color: UIColor(red: 0.52, green: 0.42, blue: 0.34, alpha: 1.0),
        roughness: 0.9,
        metalness: 0.0
    )

    static let barkDark = createTreeMaterial(
        color: UIColor(red: 0.42, green: 0.34, blue: 0.28, alpha: 1.0),
        roughness: 0.94,
        metalness: 0.0
    )

    static let petalPeach = createFlowerMaterial(
        color: UIColor(red: 0.98, green: 0.78, blue: 0.66, alpha: 1.0),
        roughness: 0.62,
        metalness: 0.05
    )

    static let petalLavender = createFlowerMaterial(
        color: UIColor(red: 0.86, green: 0.76, blue: 0.95, alpha: 1.0),
        roughness: 0.62,
        metalness: 0.05
    )

    static let stoneWarm = createStoneMaterial(
        color: UIColor(red: 0.62, green: 0.57, blue: 0.52, alpha: 1.0),
        roughness: 0.95,
        metalness: 0.0
    )

    static let waterSoft = createCloudMaterial(
        color: UIColor(red: 0.55, green: 0.79, blue: 0.91, alpha: 0.92),
        roughness: 0.3,
        metalness: 0.0
    )

    static let birdSoft = createCloudMaterial(
        color: UIColor(red: 0.93, green: 0.95, blue: 0.98, alpha: 1.0),
        roughness: 0.7,
        metalness: 0.0
    )

    static let cloudShadow = createCloudMaterial(
        color: UIColor(red: 0.85, green: 0.89, blue: 0.95, alpha: 0.65),
        roughness: 0.98,
        metalness: 0.0
    )

    static let horizonMist = createCloudMaterial(
        color: UIColor(red: 0.88, green: 0.94, blue: 0.99, alpha: 0.18),
        roughness: 1.0,
        metalness: 0.0
    )

    static let horizonLine = createCloudMaterial(
        color: UIColor(red: 0.82, green: 0.90, blue: 0.97, alpha: 0.16),
        roughness: 1.0,
        metalness: 0.0
    )

    static let skyTop = UIColor(red: 0.68, green: 0.84, blue: 1.0, alpha: 1.0)
    static let skyBottom = UIColor(red: 0.86, green: 0.94, blue: 1.0, alpha: 1.0)

    // Flower materials
    static let flowerStem = createGrassMaterial(
        color: UIColor(red: 0.46, green: 0.72, blue: 0.42, alpha: 1.0),
        roughness: 0.78,
        metalness: 0.0
    )

    static let flowerPetalsPink = createFlowerMaterial(
        color: UIColor(red: 0.96, green: 0.72, blue: 0.84, alpha: 1.0),
        roughness: 0.62,
        metalness: 0.05
    )

    static let flowerPetalsYellow = createFlowerMaterial(
        color: UIColor(red: 0.98, green: 0.86, blue: 0.55, alpha: 1.0),
        roughness: 0.62,
        metalness: 0.05
    )

    // Tree materials
    static let treeTrunk = createTreeMaterial(
        color: UIColor(red: 0.48, green: 0.38, blue: 0.30, alpha: 1.0),
        roughness: 0.92,
        metalness: 0.0
    )

    static let treeLeaves = createTreeMaterial(
        color: UIColor(red: 0.45, green: 0.68, blue: 0.47, alpha: 1.0),
        roughness: 0.84,
        metalness: 0.0
    )

    // Stone materials
    static let stone = createStoneMaterial(
        color: UIColor(red: 0.60, green: 0.55, blue: 0.50, alpha: 1.0),
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
        color: UIColor.white.withAlphaComponent(0.88),
        roughness: 0.98,
        metalness: 0.0
    )

    // Sky/fog color
    static let skyColor = UIColor(red: 0.72, green: 0.86, blue: 1.0, alpha: 1.0)
    static let fogColor = UIColor(red: 0.78, green: 0.88, blue: 1.0, alpha: 0.36)

    static func groundMaterial(for theme: MeadowTheme) -> SCNMaterial {
        createGrassMaterial(color: theme.grassColor, roughness: 0.88, metalness: 0.0)
    }

    static func grassMaterial(for theme: MeadowTheme) -> SCNMaterial {
        createGrassMaterial(color: theme.grassColor, roughness: 0.82, metalness: 0.0)
    }

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