//
//  DeviceParallaxController.swift
//  Memory Meadow
//
//  Created by Macbook on 16/5/26.
//

import CoreMotion
import SceneKit

final class DeviceParallaxController {
    private let motionManager = CMMotionManager()
    private var cameraNode: SCNNode?
    private var isRunning = false

    func start(with cameraNode: SCNNode) {
        guard !isRunning else { return }
        self.cameraNode = cameraNode

        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
            self?.applyParallax(from: data?.acceleration)
        }

        isRunning = true
    }

    func stop() {
        guard isRunning else { return }
        motionManager.stopAccelerometerUpdates()
        isRunning = false
        cameraNode = nil
    }

    private func applyParallax(from acceleration: CMAcceleration?) {
        guard let acc = acceleration,
              let node = cameraNode,
              let camera = node.camera else { return }

        let xTilt = acc.x.clamped(to: -0.5...0.5)
        let yTilt = acc.y.clamped(to: -0.5...0.5)

        let sensitivity = 0.03 * camera.orthographicScale / 18.0
        let xOffset = Float(xTilt * sensitivity)
        let yOffset = Float(yTilt * sensitivity)

        node.position.x += xOffset
        node.position.y += yOffset
    }
}

private extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}