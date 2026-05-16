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
        addLights(to: scene)
        addMemoryRoot(to: scene)

        let cameraNode = CameraController.makeCameraNode()
        scene.rootNode.addChildNode(cameraNode)
        scene.rootNode.camera = cameraNode.camera

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
        sunNode.light = sun
        sunNode.position = SCNVector3(6, 12, 8)
        sunNode.eulerAngles = SCNVector3(-Float.pi / 3, Float.pi / 4, 0)
        scene.rootNode.addChildNode(sunNode)

        let ambient = SCNLight()
        ambient.type = .ambient
        ambient.intensity = 350
        ambient.color = UIColor.white

        let ambientNode = SCNNode()
        ambientNode.light = ambient
        scene.rootNode.addChildNode(ambientNode)
    }

    private static func addMemoryRoot(to scene: SCNScene) {
        let root = SCNNode()
        root.name = memoryRootName
        scene.rootNode.addChildNode(root)
    }
}