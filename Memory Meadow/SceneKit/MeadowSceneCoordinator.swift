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
    var currentMemoryCount = 0
    var currentCameraBounds: (x: ClosedRange<Float>, z: ClosedRange<Float>) = (x: -14...14, z: 8...20)
    var currentMaxZoom: Double = 28
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

        let newCount = memories.count
        if newCount != currentMemoryCount {
            currentMemoryCount = newCount
            currentCameraBounds = ZoneManager.cameraBounds(for: newCount)
            currentMaxZoom = ZoneManager.isPhase4Active(memoryCount: newCount) ? 35 : 28
        }
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
        CameraController.pan(cameraNode: cameraNode, translation: translation, bounds: currentCameraBounds)
        gesture.setTranslation(.zero, in: gesture.view)
    }

    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let cameraNode = cameraNode else { return }

        CameraController.zoom(cameraNode: cameraNode, scale: gesture.scale, maxZoom: currentMaxZoom)
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