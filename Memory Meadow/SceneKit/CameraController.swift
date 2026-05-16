//
//  CameraController.swift
//  Memory Meadow
//
//  Created by Macbook on 16/5/26.
//

import SceneKit
import UIKit

enum CameraController {
    static func makeCameraNode() -> SCNNode {
        let camera = SCNCamera()
        camera.usesOrthographicProjection = true
        camera.orthographicScale = 18
        camera.zNear = 0.1
        camera.zFar = 100

        let node = SCNNode()
        node.name = "CameraNode"
        node.camera = camera
        node.position = SCNVector3(0, 12, 16)
        lookAtMeadow(from: node)
        return node
    }

    static func pan(cameraNode: SCNNode, translation: CGPoint) {
        guard let camera = cameraNode.camera else { return }
        let sensitivity = Float(camera.orthographicScale) * 0.0018

        cameraNode.position.x -= Float(translation.x) * sensitivity
        cameraNode.position.z -= Float(translation.y) * sensitivity
        cameraNode.position.x = cameraNode.position.x.clamped(to: -14...14)
        cameraNode.position.z = cameraNode.position.z.clamped(to: 6...26)
        lookAtMeadow(from: cameraNode)
    }

    static func zoom(cameraNode: SCNNode, scale: CGFloat) {
        guard let camera = cameraNode.camera else { return }
        let nextScale = camera.orthographicScale / Double(scale)
        camera.orthographicScale = nextScale.clamped(to: 7...28)
    }

    static func lookAtMeadow(from cameraNode: SCNNode) {
        let target = SCNVector3(cameraNode.position.x * 0.25, 0, 0)
        cameraNode.look(at: target)
    }
}

private extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}