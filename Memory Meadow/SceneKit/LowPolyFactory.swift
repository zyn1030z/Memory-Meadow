//
//  LowPolyFactory.swift
//  Memory Meadow
//
//  Created by Macbook on 17/5/26.
//

import SceneKit

enum LowPolyFactory {
    static func makeGrassClump() -> SCNNode {
        let clump = SCNNode()
        let bladeCount = Int.random(in: 4...7)

        for index in 0..<bladeCount {
            let blade = SCNCone(topRadius: 0, bottomRadius: CGFloat.random(in: 0.04...0.08), height: CGFloat.random(in: 0.45...0.85))
            blade.firstMaterial = index.isMultiple(of: 2) ? MeadowMaterials.grassLight : MeadowMaterials.grassDark

            let bladeNode = SCNNode(geometry: blade)
            bladeNode.position = SCNVector3(
                Float.random(in: -0.16...0.16),
                Float.random(in: 0.2...0.38),
                Float.random(in: -0.16...0.16)
            )
            bladeNode.eulerAngles.y = Float.random(in: 0...(Float.pi * 2))
            clump.addChildNode(bladeNode)
        }

        return clump
    }

    static func makeFlower() -> SCNNode {
        let root = SCNNode()

        let stem = SCNCylinder(radius: 0.03, height: 0.55)
        stem.firstMaterial = MeadowMaterials.flowerStem
        let stemNode = SCNNode(geometry: stem)
        stemNode.position.y = 0.27
        root.addChildNode(stemNode)

        let center = SCNBox(width: 0.11, height: 0.11, length: 0.11, chamferRadius: 0.02)
        center.firstMaterial = MeadowMaterials.flowerPetalsYellow
        let centerNode = SCNNode(geometry: center)
        centerNode.position.y = 0.58
        root.addChildNode(centerNode)

        for angle in stride(from: 0.0, to: Double.pi * 2, by: Double.pi / 3) {
            let petal = SCNBox(width: 0.14, height: 0.08, length: 0.08, chamferRadius: 0.02)
            petal.firstMaterial = MeadowMaterials.flowerPetalsPink
            let petalNode = SCNNode(geometry: petal)
            petalNode.position = SCNVector3(Float(cos(angle)) * 0.12, 0.58, Float(sin(angle)) * 0.12)
            petalNode.eulerAngles.y = Float(angle)
            root.addChildNode(petalNode)
        }

        return root
    }

    static func makeStone() -> SCNNode {
        let stone = SCNNode()
        let body = SCNBox(
            width: CGFloat.random(in: 0.28...0.52),
            height: CGFloat.random(in: 0.12...0.24),
            length: CGFloat.random(in: 0.24...0.48),
            chamferRadius: 0.08
        )
        body.firstMaterial = MeadowMaterials.stone
        stone.geometry = body
        stone.eulerAngles = SCNVector3(
            Float.random(in: -0.12...0.12),
            Float.random(in: 0...(Float.pi * 2)),
            Float.random(in: -0.08...0.08)
        )
        return stone
    }

    static func makeSmallTree() -> SCNNode {
        let root = SCNNode()

        let trunk = SCNCylinder(radius: 0.09, height: 0.7)
        trunk.firstMaterial = MeadowMaterials.treeTrunk
        let trunkNode = SCNNode(geometry: trunk)
        trunkNode.position.y = 0.35
        root.addChildNode(trunkNode)

        let canopy = SCNCone(topRadius: 0.14, bottomRadius: 0.52, height: 0.9)
        canopy.firstMaterial = MeadowMaterials.treeLeaves
        let canopyNode = SCNNode(geometry: canopy)
        canopyNode.position.y = 0.95
        root.addChildNode(canopyNode)

        return root
    }

    static func makeFirefly() -> SCNNode {
        let root = SCNNode()
        let orb = SCNSphere(radius: 0.08)
        orb.firstMaterial = MeadowMaterials.fireflyGlow
        let orbNode = SCNNode(geometry: orb)
        root.addChildNode(orbNode)

        let light = SCNLight()
        light.type = .omni
        light.intensity = 260
        light.color = MeadowMaterials.fogColor
        let lightNode = SCNNode()
        lightNode.light = light
        root.addChildNode(lightNode)

        return root
    }

    static func makeBird() -> SCNNode {
        let root = SCNNode()

        let body = SCNBox(width: 0.34, height: 0.15, length: 0.18, chamferRadius: 0.03)
        body.firstMaterial = MeadowMaterials.cloud
        let bodyNode = SCNNode(geometry: body)
        root.addChildNode(bodyNode)

        let wing = SCNBox(width: 0.46, height: 0.05, length: 0.18, chamferRadius: 0.02)
        wing.firstMaterial = MeadowMaterials.cloud
        let wingNode = SCNNode(geometry: wing)
        wingNode.position.y = 0.04
        root.addChildNode(wingNode)

        return root
    }

    static func makeCloud() -> SCNNode {
        if let assetNode = AssetLoader.loadCloudAsset() ?? AssetLoader.loadCloudAssetFromBundle() {
            return assetNode
        }

        let cloud = SCNNode()
        let chunkCount = Int.random(in: 5...8)

        for _ in 0..<chunkCount {
            let chunk = SCNBox(
                width: CGFloat.random(in: 0.7...1.4),
                height: CGFloat.random(in: 0.28...0.62),
                length: CGFloat.random(in: 0.62...1.3),
                chamferRadius: 0.2
            )
            chunk.firstMaterial = MeadowMaterials.cloud

            let chunkNode = SCNNode(geometry: chunk)
            chunkNode.position = SCNVector3(
                Float.random(in: -2.1...2.1),
                Float.random(in: -0.35...0.35),
                Float.random(in: -0.4...0.4)
            )
            cloud.addChildNode(chunkNode)
        }

        return cloud
    }
}