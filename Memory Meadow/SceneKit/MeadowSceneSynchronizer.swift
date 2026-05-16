//
//  MeadowSceneSynchronizer.swift
//  Memory Meadow
//
//  Created by Macbook on 16/5/26.
//

import SceneKit

enum MeadowSceneSynchronizer {
    static func sync(
        memories: [MemoryItem],
        in scene: SCNScene,
        knownIDs: inout Set<UUID>,
        hasPerformedInitialSync: inout Bool
    ) {
        guard let rootNode = scene.rootNode.childNode(
            withName: MeadowSceneBuilder.memoryRootName,
            recursively: false
        ) else { return }

        let currentIDs = Set(memories.map { $0.id })

        for memory in memories where !knownIDs.contains(memory.id) {
            let animated = hasPerformedInitialSync
            let node = MemoryNodeFactory.makeNode(for: memory, animated: animated)
            rootNode.addChildNode(node)
            knownIDs.insert(memory.id)
        }

        for id in knownIDs where !currentIDs.contains(id) {
            if let nodeToRemove = rootNode.childNode(
                withName: id.uuidString,
                recursively: false
            ) {
                nodeToRemove.removeFromParentNode()
            }
        }

        knownIDs = currentIDs
        hasPerformedInitialSync = true
    }
}