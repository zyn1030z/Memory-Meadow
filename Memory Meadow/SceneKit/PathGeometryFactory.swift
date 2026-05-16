//
//  PathGeometryFactory.swift
//  Memory Meadow
//
//  Created by Macbook on 17/5/26.
//

import SceneKit
import UIKit

enum PathGeometryFactory {
    static func makePathNode(from start: SCNVector3, to end: SCNVector3) -> SCNNode {
        let pathNode = SCNNode()
        pathNode.position = SCNVector3(0, 0.02, 0)

        let points = sampledCurvePoints(from: start, to: end)
        for segmentIndex in 0..<(points.count - 1) {
            let segment = makeSegment(from: points[segmentIndex], to: points[segmentIndex + 1])
            pathNode.addChildNode(segment)
        }

        for decoration in PathDecorationFactory.makeDecorationNodes(along: points) {
            pathNode.addChildNode(decoration)
        }

        return pathNode
    }

    static func sampledCurvePoints(from start: SCNVector3, to end: SCNVector3) -> [SCNVector3] {
        let midpoint = SCNVector3(
            (start.x + end.x) * 0.5,
            0,
            (start.z + end.z) * 0.5
        )

        let dx = end.x - start.x
        let dz = end.z - start.z
        let length = sqrt((dx * dx) + (dz * dz))

        // Smoother curve offset: smaller for short paths, gentle for long paths
        let curveOffset = min(max(length * 0.12, 0.15), 0.6)
        let normal = SCNVector3(-dz / max(length, 0.001), 0, dx / max(length, 0.001))

        // Add subtle randomness for natural feel
        let randomVariation = Float.random(in: -0.08...0.08)
        let control = SCNVector3(
            midpoint.x + normal.x * (curveOffset + randomVariation),
            0,
            midpoint.z + normal.z * (curveOffset + randomVariation)
        )

        var points: [SCNVector3] = []
        // More sample points for smoother curves
        for step in 0...12 {
            let t = Float(step) / 12
            let oneMinusT = 1 - t
            let x = (oneMinusT * oneMinusT * start.x) + (2 * oneMinusT * t * control.x) + (t * t * end.x)
            let z = (oneMinusT * oneMinusT * start.z) + (2 * oneMinusT * t * control.z) + (t * t * end.z)
            points.append(SCNVector3(x, 0, z))
        }
        return points
    }

    static func makeSegment(from start: SCNVector3, to end: SCNVector3) -> SCNNode {
        let dx = end.x - start.x
        let dz = end.z - start.z
        let length = sqrt((dx * dx) + (dz * dz))

        // Slightly wider path with softer edges
        let segment = SCNBox(width: 0.85, height: 0.04, length: CGFloat(length), chamferRadius: 0.12)
        segment.firstMaterial = makePathMaterial()

        let node = SCNNode(geometry: segment)
        node.position = SCNVector3((start.x + end.x) * 0.5, 0.02, (start.z + end.z) * 0.5)
        node.eulerAngles.y = atan2(dx, dz)
        return node
    }

    static func makePathMaterial() -> SCNMaterial {
        let material = SCNMaterial()
        // Warmer dirt path color with subtle variation
        material.diffuse.contents = UIColor(red: 0.82, green: 0.68, blue: 0.52, alpha: 1.0)
        material.roughness.contents = 0.92
        material.metalness.contents = 0
        material.lightingModel = .physicallyBased
        material.normal.intensity = 0.3
        return material
    }
}