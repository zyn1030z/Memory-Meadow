//
//  MeadowWorldBuilder.swift
//  Memory Meadow
//
//  Created by Macbook on 17/5/26.
//

import SceneKit

enum MeadowWorldBuilder {
    static func populate(scene: SCNScene, memoryCount: Int = 0) {
        addGrassClusters(to: scene, count: 50)
        addFlowers(to: scene, count: 20)
        addStones(to: scene, count: 8)
        addTrees(to: scene, count: 5)
        addBirds(to: scene)
        addClouds(to: scene)
//        addFireflies(to: scene, count: 12)

        if ZoneManager.isPhase4Active(memoryCount: memoryCount) {
            populatePhase4Zones(scene: scene)
        }
    }

    private static func addGrassClusters(to scene: SCNScene, count: Int) {
        let root = SCNNode()
        root.name = MeadowEnvironmentAnimator.grassRootName

        for _ in 0..<count {
            let clump = LowPolyFactory.makeGrassClump()
            clump.position = randomGroundPosition(y: 0)
            root.addChildNode(clump)
        }

        scene.rootNode.addChildNode(root)
    }

    private static func addFlowers(to scene: SCNScene, count: Int) {
        let root = SCNNode()
        root.name = "DecorFlowerRoot"

        for _ in 0..<count {
            let flower = LowPolyFactory.makeFlower()
            flower.position = randomGroundPosition(y: 0)
            flower.scale = SCNVector3(Float.random(in: 0.8...1.15), Float.random(in: 0.8...1.15), Float.random(in: 0.8...1.15))
            root.addChildNode(flower)
        }

        scene.rootNode.addChildNode(root)
    }

    private static func addStones(to scene: SCNScene, count: Int) {
        let root = SCNNode()
        root.name = "StoneRoot"

        for _ in 0..<count {
            let stone = LowPolyFactory.makeStone()
            stone.position = randomGroundPosition(y: 0.06)
            root.addChildNode(stone)
        }

        scene.rootNode.addChildNode(root)
    }

    private static func addTrees(to scene: SCNScene, count: Int) {
        let root = SCNNode()
        root.name = "SmallTreeRoot"

        for _ in 0..<count {
            let tree = LowPolyFactory.makeSmallTree()
            tree.position = SCNVector3(
                Float.random(in: -18...18),
                0,
                Float.random(in: 6...18)
            )
            root.addChildNode(tree)
        }

        scene.rootNode.addChildNode(root)
    }

    private static func addBirds(to scene: SCNScene) {
        let root = SCNNode()
        root.name = MeadowEnvironmentAnimator.birdRootName

        for index in 0..<3 {
            let bird = LowPolyFactory.makeBird()
            bird.position = SCNVector3(Float(-15 + index * 8), Float(11 + index), Float(-10 + index * 2))
            root.addChildNode(bird)
        }

        scene.rootNode.addChildNode(root)
    }

    private static func addClouds(to scene: SCNScene) {
        let root = SCNNode()
        root.name = MeadowEnvironmentAnimator.cloudRootName
        let positions = [
            SCNVector3(-16, 8.5, -10),
            SCNVector3(-8, 9.3, -7),
            SCNVector3(0, 8.8, -9),
            SCNVector3(10, 9.1, -6)
        ]

        for position in positions {
            let cloud = LowPolyFactory.makeCloud()
            cloud.position = position
            cloud.scale = SCNVector3(0.7, 0.7, 0.7)
            root.addChildNode(cloud)
        }

        scene.rootNode.addChildNode(root)
    }

    private static func addFireflies(to scene: SCNScene, count: Int) {
        let root = SCNNode()
        root.name = "FireflyRoot"

        for _ in 0..<count {
            let firefly = LowPolyFactory.makeFirefly()
            firefly.position = SCNVector3(
                Float.random(in: -18...18),
                Float.random(in: 0.6...2.2),
                Float.random(in: -12...14)
            )
            firefly.opacity = CGFloat.random(in: 0.4...0.8)
            root.addChildNode(firefly)
        }

        scene.rootNode.addChildNode(root)
    }

    private static func randomGroundPosition(y: Float) -> SCNVector3 {
        SCNVector3(
            Float.random(in: -20...20),
            y,
            Float.random(in: -14...20)
        )
    }

    static func populatePhase4Zones(scene: SCNScene) {
        let root = SCNNode()
        root.name = "Phase4ZoneRoot"

        populateEasternGrove(root: root)
        populateWesternHills(root: root)
        populateNorthernGarden(root: root)
        populateSouthernShore(root: root)

        scene.rootNode.addChildNode(root)
    }

    private static func populateEasternGrove(root: SCNNode) {
        let zoneRoot = SCNNode()
        zoneRoot.name = "EasternGroveRoot"

        for _ in 0..<15 {
            let tree = LowPolyFactory.makeSmallTree()
            tree.position = SCNVector3(
                Float.random(in: 8...20),
                0,
                Float.random(in: -8...8)
            )
            tree.scale = SCNVector3(1.2, 1.2, 1.2)
            zoneRoot.addChildNode(tree)
        }

        for _ in 0..<30 {
            let grass = LowPolyFactory.makeGrassClump()
            grass.position = SCNVector3(
                Float.random(in: 8...20),
                0,
                Float.random(in: -8...8)
            )
            zoneRoot.addChildNode(grass)
        }

        root.addChildNode(zoneRoot)
    }

    private static func populateWesternHills(root: SCNNode) {
        let zoneRoot = SCNNode()
        zoneRoot.name = "WesternHillsRoot"

        for _ in 0..<20 {
            let stone = LowPolyFactory.makeStone()
            stone.position = SCNVector3(
                Float.random(in: -20 ... -8),
                0.08,
                Float.random(in: -8...8)
            )
            stone.scale = SCNVector3(0.6, 0.6, 0.6)
            zoneRoot.addChildNode(stone)
        }

        for _ in 0..<15 {
            let grass = LowPolyFactory.makeGrassClump()
            grass.position = SCNVector3(
                Float.random(in: -20 ... -8),
                0,
                Float.random(in: -8...8)
            )
            grass.scale = SCNVector3(0.7, 0.7, 0.7)
            zoneRoot.addChildNode(grass)
        }

        root.addChildNode(zoneRoot)
    }

    private static func populateNorthernGarden(root: SCNNode) {
        let zoneRoot = SCNNode()
        zoneRoot.name = "NorthernGardenRoot"

        for _ in 0..<40 {
            let flower = LowPolyFactory.makeFlower()
            flower.position = SCNVector3(
                Float.random(in: -8...8),
                0,
                Float.random(in: 8...20)
            )
            flower.scale = SCNVector3(0.9, 0.9, 0.9)
            zoneRoot.addChildNode(flower)
        }

        for _ in 0..<25 {
            let grass = LowPolyFactory.makeGrassClump()
            grass.position = SCNVector3(
                Float.random(in: -8...8),
                0,
                Float.random(in: 8...20)
            )
            grass.scale = SCNVector3(0.5, 0.5, 0.5)
            zoneRoot.addChildNode(grass)
        }

        root.addChildNode(zoneRoot)
    }

    private static func populateSouthernShore(root: SCNNode) {
        let zoneRoot = SCNNode()
        zoneRoot.name = "SouthernShoreRoot"

        for _ in 0..<30 {
            let reed = LowPolyFactory.makeGrassClump()
            reed.position = SCNVector3(
                Float.random(in: -8...8),
                0,
                Float.random(in: -20 ... -8)
            )
            reed.scale = SCNVector3(0.8, 1.4, 0.8)
            zoneRoot.addChildNode(reed)
        }

        for _ in 0..<12 {
            let rock = LowPolyFactory.makeStone()
            rock.position = SCNVector3(
                Float.random(in: -8...8),
                0.05,
                Float.random(in: -20 ... -8)
            )
            rock.scale = SCNVector3(0.5, 0.3, 0.5)
            zoneRoot.addChildNode(rock)
        }

        root.addChildNode(zoneRoot)
    }
}