//
//  MeadowSceneView.swift
//  Memory Meadow
//
//  Created by Macbook on 16/5/26.
//

import SwiftUI
import SceneKit

struct MeadowSceneView: UIViewRepresentable {
    let memories: [MemoryItem]
    @Binding var selectedMemory: MemoryItem?

    func makeCoordinator() -> MeadowSceneCoordinator {
        MeadowSceneCoordinator(parent: self)
    }

    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        let (scene, cameraNode) = MeadowSceneBuilder.makeScene()
        scnView.scene = scene
        scnView.backgroundColor = UIColor.systemTeal
        scnView.allowsCameraControl = false
        scnView.autoenablesDefaultLighting = false
        scnView.antialiasingMode = .multisampling4X

        context.coordinator.configure(scnView: scnView, scene: scene, cameraNode: cameraNode)

        return scnView
    }

    func updateUIView(_ scnView: SCNView, context: Context) {
        context.coordinator.parent = self
        context.coordinator.updateMemories(memories)

        guard let scene = scnView.scene else { return }
        MeadowSceneSynchronizer.sync(
            memories: memories,
            in: scene,
            knownIDs: &context.coordinator.knownMemoryIDs,
            hasPerformedInitialSync: &context.coordinator.hasPerformedInitialSync
        )
    }
}