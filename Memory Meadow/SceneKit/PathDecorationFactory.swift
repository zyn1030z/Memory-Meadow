//
//  PathDecorationFactory.swift
//  Memory Meadow
//
//  Created by Macbook on 17/5/26.
//

import SceneKit

enum PathDecorationFactory {
    static func makeDecorationNodes(along points: [SCNVector3]) -> [SCNNode] {
        guard points.count > 2 else { return [] }

        var nodes: [SCNNode] = []

        for index in stride(from: 1, to: points.count - 1, by: 2) {
            let point = points[index]
            let sideOffset: Float = index.isMultiple(of: 4) ? 0.42 : -0.42

            let grass = LowPolyFactory.makeGrassClump()
            grass.position = SCNVector3(point.x + sideOffset, 0, point.z)
            grass.scale = SCNVector3(0.55, 0.55, 0.55)
            nodes.append(grass)

            if index.isMultiple(of: 3) {
                let flower = LowPolyFactory.makeFlower()
                flower.position = SCNVector3(point.x - sideOffset * 0.6, 0, point.z + 0.12)
                flower.scale = SCNVector3(0.45, 0.45, 0.45)
                nodes.append(flower)
            }

            if index.isMultiple(of: 5) {
                let stone = LowPolyFactory.makeStone()
                stone.position = SCNVector3(point.x + sideOffset * 0.4, 0.03, point.z - 0.1)
                stone.scale = SCNVector3(0.45, 0.45, 0.45)
                nodes.append(stone)
            }
        }

        return nodes
    }

    static func makePhase3Decorations(for connectionCount: Int) -> [SCNNode] {
        guard connectionCount >= 50 else { return [] }

        var nodes: [SCNNode] = []

        // Bridge - 1 per 25 connections, max 3
        let bridgeCount = min(connectionCount / 25, 3)
        for _ in 0..<bridgeCount {
            let bridge = makeBridgeNode()
            bridge.position = SCNVector3(
                Float.random(in: -15...15),
                0.15,
                Float.random(in: -15...15)
            )
            nodes.append(bridge)
        }

        // Lamp posts - 1 per 15 connections, max 6
        let lampCount = min(connectionCount / 15, 6)
        for _ in 0..<lampCount {
            let lamp = makeLampPostNode()
            lamp.position = SCNVector3(
                Float.random(in: -18...18),
                0.05,
                Float.random(in: -18...18)
            )
            nodes.append(lamp)
        }

        // Signposts - 1 per 30 connections, max 2
        let signCount = min(connectionCount / 30, 2)
        for _ in 0..<signCount {
            let sign = makeSignpostNode()
            sign.position = SCNVector3(
                Float.random(in: -16...16),
                0.08,
                Float.random(in: -16...16)
            )
            nodes.append(sign)
        }

        return nodes
    }

    private static func makeBridgeNode() -> SCNNode {
        let bridge = SCNNode()

        // Deck
        let deck = SCNBox(width: 2.2, height: 0.1, length: 3.5, chamferRadius: 0.05)
        deck.firstMaterial = SCNMaterial()
        deck.firstMaterial?.diffuse.contents = UIColor(red: 0.52, green: 0.38, blue: 0.22, alpha: 1.0)
        deck.firstMaterial?.lightingModel = .physicallyBased
        deck.firstMaterial?.roughness.contents = 0.85

        let deckNode = SCNNode(geometry: deck)
        deckNode.position.y = 0.15
        bridge.addChildNode(deckNode)

        // Rails
        let rail = SCNBox(width: 2.3, height: 0.3, length: 0.1, chamferRadius: 0.02)
        rail.firstMaterial = deck.firstMaterial

        let leftRail = SCNNode(geometry: rail)
        leftRail.position = SCNVector3(-1.05, 0.3, 0)
        bridge.addChildNode(leftRail)

        let rightRail = SCNNode(geometry: rail)
        rightRail.position = SCNVector3(1.05, 0.3, 0)
        bridge.addChildNode(rightRail)

        // Posts
        for offset in [-0.8, 0, 0.8] {
            let post = SCNBox(width: 0.15, height: 0.6, length: 0.15, chamferRadius: 0.02)
            post.firstMaterial = deck.firstMaterial

            let postNode = SCNNode(geometry: post)
            postNode.position = SCNVector3(offset, 0.45, 0)
            bridge.addChildNode(postNode)
        }

        return bridge
    }

    private static func makeLampPostNode() -> SCNNode {
        let lamp = SCNNode()

        // Pole
        let pole = SCNCylinder(radius: 0.05, height: 2.2)
        pole.firstMaterial = SCNMaterial()
        pole.firstMaterial?.diffuse.contents = UIColor(red: 0.35, green: 0.32, blue: 0.28, alpha: 1.0)
        pole.firstMaterial?.lightingModel = .physicallyBased
        pole.firstMaterial?.roughness.contents = 0.6

        let poleNode = SCNNode(geometry: pole)
        poleNode.position.y = 1.1
        lamp.addChildNode(poleNode)

        // Light head
        let head = SCNSphere(radius: 0.18)
        head.firstMaterial = SCNMaterial()
        head.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.9)
        head.firstMaterial?.lightingModel = .physicallyBased
        head.firstMaterial?.emission.contents = UIColor.yellow.withAlphaComponent(0.6)

        let headNode = SCNNode(geometry: head)
        headNode.position.y = 2.2
        lamp.addChildNode(headNode)

        // Light cone
        let cone = SCNCone(topRadius: 0, bottomRadius: 0.8, height: 1.5)
        cone.firstMaterial = SCNMaterial()
        cone.firstMaterial?.diffuse.contents = UIColor.yellow.withAlphaComponent(0.15)
        cone.firstMaterial?.transparency = 0.7

        let coneNode = SCNNode(geometry: cone)
        coneNode.position.y = 1.5
        coneNode.eulerAngles.x = Float.pi
        lamp.addChildNode(coneNode)

        return lamp
    }

    private static func makeSignpostNode() -> SCNNode {
        let sign = SCNNode()

        // Post
        let post = SCNCylinder(radius: 0.08, height: 1.8)
        post.firstMaterial = SCNMaterial()
        post.firstMaterial?.diffuse.contents = UIColor(red: 0.42, green: 0.32, blue: 0.24, alpha: 1.0)
        post.firstMaterial?.lightingModel = .physicallyBased
        post.firstMaterial?.roughness.contents = 0.7

        let postNode = SCNNode(geometry: post)
        postNode.position.y = 0.9
        sign.addChildNode(postNode)

        // Sign board
        let board = SCNBox(width: 0.8, height: 0.5, length: 0.05, chamferRadius: 0.03)
        board.firstMaterial = SCNMaterial()
        board.firstMaterial?.diffuse.contents = UIColor(red: 0.88, green: 0.82, blue: 0.72, alpha: 1.0)
        board.firstMaterial?.lightingModel = .physicallyBased
        board.firstMaterial?.roughness.contents = 0.5

        let boardNode = SCNNode(geometry: board)
        boardNode.position.y = 1.65
        sign.addChildNode(boardNode)

        // Arrow
        let arrow = SCNBox(width: 0.3, height: 0.1, length: 0.05, chamferRadius: 0.02)
        arrow.firstMaterial = SCNMaterial()
        arrow.firstMaterial?.diffuse.contents = UIColor(red: 0.2, green: 0.5, blue: 0.8, alpha: 1.0)

        let arrowNode = SCNNode(geometry: arrow)
        arrowNode.position = SCNVector3(0, 1.65, 0.03)
        sign.addChildNode(arrowNode)

        return sign
    }
}
