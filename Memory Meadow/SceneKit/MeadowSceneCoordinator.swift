//
//  MeadowSceneCoordinator.swift
//  Memory Meadow
//
//  Created by Macbook on 16/5/26.
//

import SceneKit
import UIKit

final class MeadowSceneCoordinator: NSObject {
    var parent: MeadowSceneView
    var cameraNode: SCNNode?
    var memoriesByID: [UUID: MemoryItem] = [:]
    var knownMemoryIDs: Set<UUID> = []
    var knownPathConnections: Set<PathConnection> = []
    var hasPerformedInitialSync = false
    private let parallaxController = DeviceParallaxController()

    init(parent: MeadowSceneView) {
        self.parent = parent
    }

    func configure(scnView: SCNView, scene: SCNScene, cameraNode: SCNNode) {
        self.cameraNode = cameraNode

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        scnView.addGestureRecognizer(panGesture)

        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        scnView.addGestureRecognizer(pinchGesture)

        panGesture.delegate = self
        pinchGesture.delegate = self

//        parallaxController.start(with: cameraNode)
    }

    deinit {
        parallaxController.stop()
    }

    func updateMemories(_ memories: [MemoryItem]) {
        memoriesByID = Dictionary(uniqueKeysWithValues: memories.map { ($0.id, $0) })
    }

    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let scnView = gesture.view as? SCNView else { return }
        let location = gesture.location(in: scnView)
        let results = scnView.hitTest(location, options: nil)

        guard let hitNode = results.first?.node,
              let memoryID = hitNode.nearestMemoryID(),
              let memory = memoriesByID[memoryID] else { return }

        parent.selectedMemory = memory
    }

    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let cameraNode = cameraNode else { return }

        let translation = gesture.translation(in: gesture.view)
        CameraController.pan(cameraNode: cameraNode, translation: translation)
        gesture.setTranslation(.zero, in: gesture.view)
    }

    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let cameraNode = cameraNode else { return }

        CameraController.zoom(cameraNode: cameraNode, scale: gesture.scale)
        gesture.scale = 1.0
    }
}

extension MeadowSceneCoordinator: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
    }
}