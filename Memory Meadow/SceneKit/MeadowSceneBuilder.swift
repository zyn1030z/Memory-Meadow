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
        addGrass(to: scene)
        addClouds(to: scene)
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
        let cloud = SCNNode()
        let puffs: [(radius: CGFloat, x: Float, y: Float)] = [
            (0.95, -1.8, 0.0),
            (1.15, -0.8, 0.2),
            (1.3, 0.2, 0.25),
            (1.05, 1.3, 0.05),
            (0.85, 2.1, -0.05),
            (0.9, -0.1, -0.45)
        ]

        for puff in puffs {
            let geometry = SCNSphere(radius: puff.radius)
            geometry.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.92)
            geometry.firstMaterial?.lightingModel = .physicallyBased
            geometry.firstMaterial?.roughness.contents = 0.95

            let node = SCNNode(geometry: geometry)
            node.position = SCNVector3(puff.x, puff.y, 0)
            node.scale = SCNVector3(1.0, 0.72, 0.72)
            cloud.addChildNode(node)
        }

        let shadow = SCNCapsule(capRadius: 1.9, height: 5.0)
        shadow.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.18)
        let shadowNode = SCNNode(geometry: shadow)
        shadowNode.eulerAngles.z = .pi / 2
        shadowNode.position = SCNVector3(0.1, -0.18, -0.35)
        shadowNode.scale = SCNVector3(1.0, 0.22, 0.18)
        cloud.addChildNode(shadowNode)

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
}