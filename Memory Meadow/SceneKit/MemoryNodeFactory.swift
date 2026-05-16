//
//  MemoryNodeFactory.swift
//  Memory Meadow
//
//  Created by Macbook on 16/5/26.
//

import SceneKit
import UIKit

enum MemoryNodeFactory {
    static func makeNode(for memory: MemoryItem, animated: Bool) -> SCNNode {
        let container = SCNNode()
        container.name = memory.id.uuidString
        container.position = SCNVector3(memory.xPosition, 0, memory.zPosition)

        let contentNode: SCNNode
        switch memory.type {
        case .knowledge:
            contentNode = makeKnowledgeFlower()
        case .task:
            contentNode = makeTaskTree()
        case .emotion:
            contentNode = makeEmotionNode()
        }

        container.addChildNode(contentNode)

        if animated {
            runGrowthAnimation(on: container)
        }

        return container
    }

    static func makePreviewNode(for memory: MemoryItem) -> SCNNode {
        let node: SCNNode
        switch memory.type {
        case .knowledge:
            node = makeKnowledgeFlower()
        case .task:
            node = makeTaskTree()
        case .emotion:
            node = makeEmotionNode()
        }

        node.position = SCNVector3(0, 0, 0)
        let spin = SCNAction.rotateBy(x: 0, y: CGFloat.pi * 2, z: 0, duration: 8)
        node.runAction(.repeatForever(spin))
        return node
    }

    static func runGrowthAnimation(on node: SCNNode) {
        node.scale = SCNVector3(0.01, 0.01, 0.01)

        let grow = SCNAction.scale(to: 1.0, duration: 0.55)
        grow.timingMode = .easeOut

        let bounceUp = SCNAction.scale(to: 1.12, duration: 0.12)
        let settle = SCNAction.scale(to: 1.0, duration: 0.12)
        bounceUp.timingMode = .easeOut
        settle.timingMode = .easeInEaseOut

        node.runAction(.sequence([grow, bounceUp, settle]))
    }

    private static func makeKnowledgeFlower() -> SCNNode {
        let root = SCNNode()

        let stem = SCNCylinder(radius: 0.05, height: 0.9)
        stem.firstMaterial = material(diffuse: UIColor.systemGreen)
        let stemNode = SCNNode(geometry: stem)
        stemNode.position = SCNVector3(0, 0.45, 0)
        root.addChildNode(stemNode)

        let center = SCNSphere(radius: 0.12)
        center.firstMaterial = material(diffuse: UIColor.systemYellow)
        let centerNode = SCNNode(geometry: center)
        centerNode.position = SCNVector3(0, 0.96, 0)
        root.addChildNode(centerNode)

        let petalColor = UIColor.systemPink
        let petalOffsets: [SCNVector3] = [
            SCNVector3(0.18, 0.96, 0),
            SCNVector3(-0.18, 0.96, 0),
            SCNVector3(0, 1.12, 0),
            SCNVector3(0, 0.8, 0),
            SCNVector3(0.13, 1.06, 0.05),
            SCNVector3(-0.13, 0.86, -0.05)
        ]

        for offset in petalOffsets {
            let petal = SCNSphere(radius: 0.11)
            petal.firstMaterial = material(diffuse: petalColor)
            let petalNode = SCNNode(geometry: petal)
            petalNode.position = offset
            petalNode.scale = SCNVector3(1, 0.7, 0.35)
            root.addChildNode(petalNode)
        }

        let sway = SCNAction.rotateBy(x: 0.04, y: 0, z: 0.06, duration: 2.1)
        sway.timingMode = .easeInEaseOut
        let swayBack = SCNAction.rotateBy(x: -0.08, y: 0, z: -0.12, duration: 2.1)
        swayBack.timingMode = .easeInEaseOut
        let reset = SCNAction.rotateBy(x: 0.04, y: 0, z: 0.06, duration: 2.1)
        root.runAction(.repeatForever(.sequence([sway, swayBack, reset])))

        return root
    }

    private static func makeTaskTree() -> SCNNode {
        let root = SCNNode()

        let trunk = SCNCylinder(radius: 0.09, height: 1.0)
        trunk.firstMaterial = material(diffuse: UIColor.brown)
        let trunkNode = SCNNode(geometry: trunk)
        trunkNode.position = SCNVector3(0, 0.5, 0)
        root.addChildNode(trunkNode)

        let canopy = SCNSphere(radius: 0.42)
        canopy.firstMaterial = material(diffuse: UIColor(red: 0.2, green: 0.58, blue: 0.2, alpha: 1.0))
        let canopyNode = SCNNode(geometry: canopy)
        canopyNode.position = SCNVector3(0, 1.18, 0)
        root.addChildNode(canopyNode)

        let canopyTwo = SCNSphere(radius: 0.28)
        canopyTwo.firstMaterial = material(diffuse: UIColor(red: 0.15, green: 0.5, blue: 0.18, alpha: 1.0))
        let canopyTwoNode = SCNNode(geometry: canopyTwo)
        canopyTwoNode.position = SCNVector3(0.22, 1.38, 0.1)
        root.addChildNode(canopyTwoNode)

        let sway = SCNAction.rotateBy(x: 0.02, y: 0, z: 0.03, duration: 2.5)
        sway.timingMode = .easeInEaseOut
        let swayBack = SCNAction.rotateBy(x: -0.04, y: 0, z: -0.06, duration: 2.5)
        swayBack.timingMode = .easeInEaseOut
        let reset = SCNAction.rotateBy(x: 0.02, y: 0, z: 0.03, duration: 2.5)
        root.runAction(.repeatForever(.sequence([sway, swayBack, reset])))

        return root
    }

    private static func makeEmotionNode() -> SCNNode {
        let root = SCNNode()

        let glow = SCNSphere(radius: 0.12)
        glow.firstMaterial = emissiveMaterial(
            diffuse: UIColor.systemPurple,
            emissive: UIColor(red: 0.85, green: 0.55, blue: 1.0, alpha: 1.0)
        )
        let glowNode = SCNNode(geometry: glow)
        glowNode.position = SCNVector3(0, 1.1, 0)
        root.addChildNode(glowNode)

        let halo = SCNSphere(radius: 0.22)
        halo.firstMaterial = transparentMaterial(color: UIColor.systemPurple.withAlphaComponent(0.18))
        let haloNode = SCNNode(geometry: halo)
        haloNode.position = SCNVector3(0, 1.1, 0)
        root.addChildNode(haloNode)

        let light = SCNLight()
        light.type = .omni
        light.intensity = 280
        light.color = UIColor(red: 0.88, green: 0.62, blue: 1.0, alpha: 1.0)
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(0, 1.1, 0)
        root.addChildNode(lightNode)

        let floatUp = SCNAction.moveBy(x: 0, y: 0.18, z: 0, duration: 1.2)
        floatUp.timingMode = .easeInEaseOut
        let floatDown = SCNAction.moveBy(x: 0, y: -0.18, z: 0, duration: 1.2)
        floatDown.timingMode = .easeInEaseOut
        root.runAction(.repeatForever(.sequence([floatUp, floatDown])))

        let sway = SCNAction.rotateBy(x: 0, y: 0, z: 0.08, duration: 1.8)
        sway.timingMode = .easeInEaseOut
        let swayBack = SCNAction.rotateBy(x: 0, y: 0, z: -0.16, duration: 1.8)
        swayBack.timingMode = .easeInEaseOut
        let swayReset = SCNAction.rotateBy(x: 0, y: 0, z: 0.08, duration: 1.8)
        swayReset.timingMode = .easeInEaseOut
        root.runAction(.repeatForever(.sequence([sway, swayBack, swayReset])))

        return root
    }

    private static func material(diffuse: UIColor) -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = diffuse
        material.roughness.contents = 0.65
        return material
    }

    private static func emissiveMaterial(diffuse: UIColor, emissive: UIColor) -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = diffuse
        material.emission.contents = emissive
        material.lightingModel = .physicallyBased
        return material
    }

    private static func transparentMaterial(color: UIColor) -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = color
        material.isDoubleSided = true
        material.transparencyMode = .rgbZero
        return material
    }
}