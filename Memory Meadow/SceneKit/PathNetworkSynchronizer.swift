//
//  PathNetworkSynchronizer.swift
//  Memory Meadow
//
//  Created by Macbook on 17/5/26.
//

import SceneKit

enum PathNetworkSynchronizer {
    static let rootName = "PathNetworkRoot"
    static let phase3RootName = "Phase3DecorationRoot"
    static let phase4RootName = "Phase4ZoneRoot"

    static func sync(
        memories: [MemoryItem],
        in scene: SCNScene,
        knownConnections: inout Set<PathConnection>,
        animated: Bool
    ) {
        guard let root = scene.rootNode.childNode(withName: rootName, recursively: false) else { return }

        let connections = Set(PathNetworkBuilder.nearestNeighborConnections(for: memories))
        let memoriesByID = Dictionary(uniqueKeysWithValues: memories.map { ($0.id, $0) })

        for connection in knownConnections where !connections.contains(connection) {
            root.childNode(withName: nodeName(for: connection), recursively: false)?.removeFromParentNode()
        }

        for connection in connections where !knownConnections.contains(connection) {
            guard let start = memoriesByID[connection.startID],
                  let end = memoriesByID[connection.endID] else { continue }

            let node = PathGeometryFactory.makePathNode(
                from: SCNVector3(start.xPosition, 0, start.zPosition),
                to: SCNVector3(end.xPosition, 0, end.zPosition)
            )
            node.name = nodeName(for: connection)
            root.addChildNode(node)

            if animated {
                PathAnimator.animatePathCreation(node)
            }
        }

        knownConnections = connections

        // Phase 3: Add bridges/lamps/signs when connection count >= 50
        syncPhase3Decorations(connectionCount: connections.count, in: scene)

        // Phase 4: Add world zones when memory count >= 100
        syncPhase4Zones(memoryCount: memories.count, in: scene)
    }

    private static func syncPhase3Decorations(connectionCount: Int, in scene: SCNScene) {
        let phase3Root = scene.rootNode.childNode(withName: phase3RootName, recursively: false) ?? {
            let root = SCNNode()
            root.name = phase3RootName
            scene.rootNode.addChildNode(root)
            return root
        }()

        // Only add decorations once when crossing threshold
        if connectionCount >= 50 && phase3Root.childNodes.isEmpty {
            let decorations = PathDecorationFactory.makePhase3Decorations(for: connectionCount)
            for decoration in decorations {
                phase3Root.addChildNode(decoration)
            }
        }
    }

    private static func syncPhase4Zones(memoryCount: Int, in scene: SCNScene) {
        let phase4Root = scene.rootNode.childNode(withName: phase4RootName, recursively: false) ?? {
            let root = SCNNode()
            root.name = phase4RootName
            scene.rootNode.addChildNode(root)
            return root
        }()

        // Only add zones once when crossing threshold
        if ZoneManager.isPhase4Active(memoryCount: memoryCount) && phase4Root.childNodes.isEmpty {
            MeadowWorldBuilder.populatePhase4Zones(scene: scene)
        }
    }

    static func nodeName(for connection: PathConnection) -> String {
        "path-\(connection.startID.uuidString)-\(connection.endID.uuidString)"
    }
}