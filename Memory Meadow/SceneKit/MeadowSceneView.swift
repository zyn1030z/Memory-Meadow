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
    let theme: MeadowTheme
    @Binding var selectedMemory: MemoryItem?

    func makeCoordinator() -> MeadowSceneCoordinator {
        MeadowSceneCoordinator(parent: self)
    }

    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        let (scene, cameraNode) = MeadowSceneBuilder.makeScene(theme: theme)
        scnView.scene = scene
        scnView.backgroundColor = .clear
        scnView.allowsCameraControl = false
        scnView.autoenablesDefaultLighting = false
        scnView.antialiasingMode = .multisampling4X

        context.coordinator.configure(scnView: scnView, scene: scene, cameraNode: cameraNode)

        return scnView
    }

    func updateUIView(_ scnView: SCNView, context: Context) {
        context.coordinator.parent = self

        if context.coordinator.currentTheme != theme {
            let (scene, cameraNode) = MeadowSceneBuilder.makeScene(theme: theme)
            scnView.scene = scene
            context.coordinator.configureSceneReset(cameraNode: cameraNode, theme: theme)
        }

        context.coordinator.updateMemories(memories)

        guard let scene = scnView.scene else { return }
        MeadowSceneSynchronizer.sync(
            memories: memories,
            in: scene,
            knownIDs: &context.coordinator.knownMemoryIDs,
            hasPerformedInitialSync: &context.coordinator.hasPerformedInitialSync
        )

        PathNetworkSynchronizer.sync(
            memories: memories,
            in: scene,
            knownConnections: &context.coordinator.knownPathConnections,
            animated: context.coordinator.hasPerformedInitialSync
        )
    }
}