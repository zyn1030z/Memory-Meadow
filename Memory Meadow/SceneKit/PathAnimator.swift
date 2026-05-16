//
//  PathAnimator.swift
//  Memory Meadow
//
//  Created by Macbook on 17/5/26.
//

import SceneKit

enum PathAnimator {
    static func animatePathCreation(_ pathNode: SCNNode) {
        for (index, segmentNode) in pathNode.childNodes.enumerated() {
            segmentNode.scale = SCNVector3(1, 1, 0.01)
            segmentNode.opacity = 0.0

            let delay = SCNAction.wait(duration: Double(index) * 0.08)
            let fadeIn = SCNAction.fadeIn(duration: 0.2)
            let grow = SCNAction.customAction(duration: 0.9) { node, elapsedTime in
                let progress = max(0.01, elapsedTime / 0.9)
                node.scale.z = Float(progress)
            }

            let pulseUp = SCNAction.scale(to: 1.03, duration: 0.12)
            let settle = SCNAction.scale(to: 1.0, duration: 0.12)

            let sequence = SCNAction.sequence([
                delay,
                .group([fadeIn, grow]),
                pulseUp,
                settle
            ])

            segmentNode.runAction(sequence)
        }
    }
}
