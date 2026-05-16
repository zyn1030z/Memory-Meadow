//
//  MeadowSceneBuilder.swift
//  Memory Meadow
//
//  Created by Macbook on 16/5/26.
//

import SceneKit
import UIKit

enum MeadowSceneBuilder {
    static let memoryRootName = "MemoryNodesRoot"

    static func makeScene() -> (scene: SCNScene, cameraNode: SCNNode) {
        let scene = SCNScene()
        scene.background.contents = UIColor(red: 0.55, green: 0.78, blue: 1.0, alpha: 1.0)

        addGround(to: scene)
        addHills(to: scene)
        addGrass(to: scene)
        addStones(to: scene)
//        addMountains(to: scene)
        addStream(to: scene)
//        addClouds(to: scene)
        addBirds(to: scene)
        addLights(to: scene)
        addMemoryRoot(to: scene)

        let cameraNode = CameraController.makeCameraNode()
        scene.rootNode.addChildNode(cameraNode)
        scene.rootNode.camera = cameraNode.camera

        MeadowEnvironmentAnimator.startAnimations(in: scene)

        return (scene, cameraNode)
    }

    private static func addGround(to scene: SCNScene) {
        let plane = SCNPlane(width: 44, height: 44)
        plane.firstMaterial?.diffuse.contents = UIColor(red: 0.28, green: 0.66, blue: 0.27, alpha: 1.0)
        plane.firstMaterial?.roughness.contents = 0.9

        let groundNode = SCNNode(geometry: plane)
        groundNode.name = "GroundNode"
        groundNode.eulerAngles.x = -.pi / 2
        scene.rootNode.addChildNode(groundNode)
    }

    private static func addLights(to scene: SCNScene) {
        let sun = SCNLight()
        sun.type = .directional
        sun.intensity = 850
        sun.castsShadow = true

        let sunNode = SCNNode()
        sunNode.name = MeadowEnvironmentAnimator.sunLightName
        sunNode.light = sun
        sunNode.position = SCNVector3(6, 12, 8)
        sunNode.eulerAngles = SCNVector3(-Float.pi / 3, Float.pi / 4, 0)
        scene.rootNode.addChildNode(sunNode)

        let ambient = SCNLight()
        ambient.type = .ambient
        ambient.intensity = 350
        ambient.color = UIColor.white

        let ambientNode = SCNNode()
        ambientNode.name = MeadowEnvironmentAnimator.ambientLightName
        ambientNode.light = ambient
        scene.rootNode.addChildNode(ambientNode)
    }

    private static func addHills(to scene: SCNScene) {
        let hillRoot = SCNNode()
        hillRoot.name = "HillRoot"

        let hillPositions: [SCNVector3] = [
            SCNVector3(-12, -0.8, 8),
            SCNVector3(0, -0.6, 10),
            SCNVector3(12, -0.9, 7)
        ]

        for position in hillPositions {
            let hill = makeHillNode()
            hill.position = position
            hillRoot.addChildNode(hill)
        }

        scene.rootNode.addChildNode(hillRoot)
    }

    private static func makeHillNode() -> SCNNode {
        let hill = SCNNode()
        let geometry = SCNSphere(radius: 6.0)
        geometry.firstMaterial?.diffuse.contents = UIColor(red: 0.48, green: 0.72, blue: 0.48, alpha: 1.0)
        geometry.firstMaterial?.lightingModel = .physicallyBased
        geometry.firstMaterial?.roughness.contents = 0.9

        hill.geometry = geometry
        hill.scale = SCNVector3(1.0, 0.35, 1.0)
        return hill
    }

    private static func addStones(to scene: SCNScene) {
        let stoneRoot = SCNNode()
        stoneRoot.name = "StoneRoot"

        for _ in 0..<6 {
            let stone = makeStoneNode()
            stone.position = SCNVector3(
                Float.random(in: -18...18),
                0.08,
                Float.random(in: -14...14)
            )
            stoneRoot.addChildNode(stone)
        }

        scene.rootNode.addChildNode(stoneRoot)
    }

    private static func makeStoneNode() -> SCNNode {
        let stone = SCNNode()
        let geometry = SCNSphere(radius: CGFloat.random(in: 0.2...0.4))
        geometry.firstMaterial?.diffuse.contents = UIColor(red: 0.58, green: 0.52, blue: 0.46, alpha: 1.0)
        geometry.firstMaterial?.lightingModel = .physicallyBased
        geometry.firstMaterial?.roughness.contents = 0.95

        stone.geometry = geometry
        stone.scale = SCNVector3(1.2, 0.5, 1.0)
        return stone
    }

    private static func addGrass(to scene: SCNScene) {
        let grassRoot = SCNNode()
        grassRoot.name = MeadowEnvironmentAnimator.grassRootName

        for i in 0..<12 {
            let blade = SCNNode()
            blade.position = SCNVector3(
                Float.random(in: -18...18),
                0.1,
                Float.random(in: -18...18)
            )

            let geometry = SCNCylinder(radius: 0.04, height: 0.6)
            geometry.firstMaterial?.diffuse.contents = UIColor(red: 0.2, green: 0.7, blue: 0.25, alpha: 1.0)
            blade.geometry = geometry
            blade.position.y = 0.3

            grassRoot.addChildNode(blade)
        }

        scene.rootNode.addChildNode(grassRoot)
    }

    private static func addClouds(to scene: SCNScene) {
        let cloudRoot = SCNNode()
        cloudRoot.name = MeadowEnvironmentAnimator.cloudRootName

        let cloudPositions: [SCNVector3] = [
            SCNVector3(-16, 8.4, -8),
            SCNVector3(-9, 9.1, -6),
            SCNVector3(-1, 8.8, -7),
            SCNVector3(7, 9.5, -5),
            SCNVector3(15, 8.6, -8)
        ]

        for position in cloudPositions {
            let cloud = makeCloudNode()
            cloud.position = position
            cloudRoot.addChildNode(cloud)
        }

        scene.rootNode.addChildNode(cloudRoot)
    }

    private static func makeCloudNode() -> SCNNode {
        // Try loading real asset first
        if let assetNode = AssetLoader.loadCloudAsset() ?? AssetLoader.loadCloudAssetFromBundle() {
            assetNode.scale = SCNVector3(0.8, 0.8, 0.8)
            return assetNode
        }

        // Fallback to procedural cloud
        let cloud = SCNNode()

        // Generate 12-18 puffs with random sizes and positions
        let puffCount = Int.random(in: 12...18)
        for i in 0..<puffCount {
            let radius = CGFloat.random(in: 0.4...1.2)
            let x = Float.random(in: -2.5...2.5)
            let y = Float.random(in: -0.6...0.4)
            let z = Float.random(in: -0.3...0.3)
            let opacity = Double.random(in: 0.65...0.95)

            let geometry = SCNSphere(radius: radius)
            geometry.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(opacity)
            geometry.firstMaterial?.lightingModel = .physicallyBased
            geometry.firstMaterial?.roughness.contents = 0.95

            let node = SCNNode(geometry: geometry)
            node.position = SCNVector3(x, y, z)
            node.scale = SCNVector3(1.0, 0.65 + Float.random(in: -0.1...0.15), 0.65 + Float.random(in: -0.1...0.15))
            cloud.addChildNode(node)
        }

        // Add internal shadow for depth
        let shadowCount = Int.random(in: 2...4)
        for _ in 0..<shadowCount {
            let shadow = SCNSphere(radius: CGFloat.random(in: 0.5...1.0))
            shadow.firstMaterial?.diffuse.contents = UIColor.gray.withAlphaComponent(Double.random(in: 0.08...0.15))
            let shadowNode = SCNNode(geometry: shadow)
            shadowNode.position = SCNVector3(
                Float.random(in: -1.5...1.5),
                Float.random(in: -0.3...0.2),
                Float.random(in: -0.2...0.2)
            )
            cloud.addChildNode(shadowNode)
        }

        return cloud
    }

    private static func addBirds(to scene: SCNScene) {
        let birdRoot = SCNNode()
        birdRoot.name = MeadowEnvironmentAnimator.birdRootName

        for i in 0..<2 {
            let bird = makeBirdNode()
            bird.position = SCNVector3(
                Float(-14 + i * 10),
                Float(14 + i),
                Float(-12 + i * 4)
            )
            birdRoot.addChildNode(bird)
        }

        scene.rootNode.addChildNode(birdRoot)
    }

    private static func makeBirdNode() -> SCNNode {
        let bird = SCNNode()
        let body = SCNSphere(radius: 0.15)
        body.firstMaterial?.diffuse.contents = UIColor(red: 0.3, green: 0.5, blue: 0.8, alpha: 1.0)
        let bodyNode = SCNNode(geometry: body)
        bird.addChildNode(bodyNode)

        let wing = SCNPlane(width: 0.6, height: 0.2)
        wing.firstMaterial?.diffuse.contents = UIColor(red: 0.25, green: 0.45, blue: 0.75, alpha: 1.0)
        let wingNode = SCNNode(geometry: wing)
        wingNode.position.z = 0.1
        bird.addChildNode(wingNode)

        return bird
    }

    private static func addMemoryRoot(to scene: SCNScene) {
        let root = SCNNode()
        root.name = memoryRootName
        scene.rootNode.addChildNode(root)
    }

    private static func addMountains(to scene: SCNScene) {
        let mountainRoot = SCNNode()
        mountainRoot.name = "MountainRoot"

        let mountainPositions: [SCNVector3] = [
            SCNVector3(-18, 0.8, 12),
            SCNVector3(-10, 0.6, 14),
            SCNVector3(2, 0.9, 11),
            SCNVector3(14, 0.5, 13),
            SCNVector3(18, 0.7, 12)
        ]

        for position in mountainPositions {
            let mountain = makeMountainNode()
            mountain.position = position
            mountainRoot.addChildNode(mountain)
        }

        scene.rootNode.addChildNode(mountainRoot)
    }

    private static func makeMountainNode() -> SCNNode {
        // Try loading real asset first
        if let assetNode = AssetLoader.loadMountainAsset() ?? AssetLoader.loadMountainAssetFromBundle() {
            assetNode.scale = SCNVector3(1.2, 1.2, 1.2)
            return assetNode
        }

        // Fallback to procedural mountain
        let mountain = SCNNode()

        // Base layers with varying sizes for jagged appearance
        let layerCount = Int.random(in: 4...6)
        for i in 0..<layerCount {
            let progress = Float(i) / Float(layerCount)
            let baseRadius = 2.2 - (progress * 1.8) + Float.random(in: -0.2...0.2)
            let height = 0.5 + Float.random(in: -0.1...0.15)

            let greenShade = 0.35 + Double(progress) * 0.15 + Double.random(in: -0.05...0.05)

            let layer = SCNCone(topRadius: CGFloat(baseRadius * 0.4), bottomRadius: CGFloat(baseRadius), height: CGFloat(height))
            layer.firstMaterial?.diffuse.contents = UIColor(
                red: greenShade,
                green: 0.52 + Double.random(in: -0.08...0.08),
                blue: 0.42 + Double.random(in: -0.06...0.06),
                alpha: 1.0
            )
            layer.firstMaterial?.lightingModel = .physicallyBased
            layer.firstMaterial?.roughness.contents = 0.95

            let layerNode = SCNNode(geometry: layer)
            layerNode.position.y = Float(i) * 0.35 + Float.random(in: -0.05...0.05)
            layerNode.eulerAngles.y = Float.random(in: -0.15...0.15)
            mountain.addChildNode(layerNode)
        }

        // Snow cap at peak
        let snowCap = SCNCone(topRadius: 0.05, bottomRadius: 0.45, height: 0.35)
        snowCap.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.95)
        snowCap.firstMaterial?.lightingModel = .physicallyBased
        snowCap.firstMaterial?.roughness.contents = 0.3

        let snowNode = SCNNode(geometry: snowCap)
        snowNode.position.y = Float(layerCount) * 0.35 + 0.15
        mountain.addChildNode(snowNode)

        // Add small rocky details
        for _ in 0..<Int.random(in: 2...4) {
            let rock = SCNCone(topRadius: 0, bottomRadius: CGFloat.random(in: 0.15...0.35), height: CGFloat.random(in: 0.2...0.4))
            rock.firstMaterial?.diffuse.contents = UIColor(red: 0.3, green: 0.45, blue: 0.38, alpha: 1.0)

            let rockNode = SCNNode(geometry: rock)
            rockNode.position = SCNVector3(
                Float.random(in: -0.8...0.8),
                Float.random(in: 0.3...1.2),
                Float.random(in: -0.3...0.3)
            )
            rockNode.eulerAngles.y = Float.random(in: 0...(.pi * 2))
            mountain.addChildNode(rockNode)
        }

        return mountain
    }

    private static func addStream(to scene: SCNScene) {
        let streamRoot = SCNNode()
        streamRoot.name = "StreamRoot"

        let streamPositions: [SCNVector3] = [
            SCNVector3(-16, 0.05, -18),
            SCNVector3(-8, 0.04, -17),
            SCNVector3(0, 0.06, -19),
            SCNVector3(8, 0.03, -16),
            SCNVector3(16, 0.05, -18)
        ]

        for position in streamPositions {
            let stream = makeStreamNode()
            stream.position = position
            streamRoot.addChildNode(stream)
        }

        scene.rootNode.addChildNode(streamRoot)
    }

    private static func makeStreamNode() -> SCNNode {
        let stream = SCNNode()

        let water = SCNCylinder(radius: 1.8, height: 0.1)
        water.firstMaterial?.diffuse.contents = UIColor(red: 0.42, green: 0.72, blue: 0.88, alpha: 0.85)
        water.firstMaterial?.lightingModel = .physicallyBased
        water.firstMaterial?.roughness.contents = 0.2

        let waterNode = SCNNode(geometry: water)
        waterNode.position.y = 0.05
        stream.addChildNode(waterNode)

        let bankLeft = SCNCylinder(radius: 1.6, height: 0.08)
        bankLeft.firstMaterial?.diffuse.contents = UIColor(red: 0.52, green: 0.42, blue: 0.32, alpha: 1.0)
        bankLeft.firstMaterial?.roughness.contents = 0.9

        let bankLeftNode = SCNNode(geometry: bankLeft)
        bankLeftNode.position.y = 0.04
        bankLeftNode.scale = SCNVector3(1.0, 0.6, 0.6)
        stream.addChildNode(bankLeftNode)

        let bankRight = SCNCylinder(radius: 1.6, height: 0.08)
        bankRight.firstMaterial?.diffuse.contents = UIColor(red: 0.48, green: 0.38, blue: 0.28, alpha: 1.0)
        bankRight.firstMaterial?.roughness.contents = 0.9

        let bankRightNode = SCNNode(geometry: bankRight)
        bankRightNode.position.y = 0.04
        bankRightNode.scale = SCNVector3(1.0, 0.5, 0.6)
        bankRightNode.position.x = 0.3
        stream.addChildNode(bankRightNode)

        return stream
    }
}