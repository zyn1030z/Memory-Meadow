//
//  MeadowEnvironmentAnimator.swift
//  Memory Meadow
//
//  Created by Macbook on 16/5/26.
//

import SceneKit
import UIKit

enum MeadowEnvironmentAnimator {
    static let grassRootName = "GrassRoot"
    static let cloudRootName = "CloudRoot"
    static let birdRootName = "BirdRoot"
    static let sunLightName = "SunLightNode"
    static let ambientLightName = "AmbientLightNode"

    static func startAnimations(in scene: SCNScene) {
        animateGrass(in: scene)
        animateClouds(in: scene)
        animateBirds(in: scene)
        animateLighting(in: scene)
    }

    private static func animateGrass(in scene: SCNScene) {
        guard let root = scene.rootNode.childNode(withName: grassRootName, recursively: false) else { return }
        for (index, blade) in root.childNodes.enumerated() {
            let angle = CGFloat(0.08 + Double(index % 5) * 0.01)
            let swayLeft = SCNAction.rotateBy(x: 0, y: 0, z: angle, duration: 1.6)
            let swayRight = SCNAction.rotateBy(x: 0, y: 0, z: -angle * 2, duration: 1.6)
            let reset = SCNAction.rotateBy(x: 0, y: 0, z: angle, duration: 1.6)
            blade.runAction(.repeatForever(.sequence([swayLeft, swayRight, reset])))
        }
    }

    private static func animateClouds(in scene: SCNScene) {
        guard let root = scene.rootNode.childNode(withName: cloudRootName, recursively: false) else { return }

        for (index, cloud) in root.childNodes.enumerated() {
            let driftX = 34.0 + Double(index) * 3.5
            let duration = 30.0 + Double(index) * 4.0

            let drift = SCNAction.moveBy(x: CGFloat(driftX), y: 0, z: 0, duration: duration)
            drift.timingMode = .easeInEaseOut

            let bobUp = SCNAction.moveBy(x: 0, y: 0.15, z: 0, duration: 4.0 + Double(index) * 0.35)
            bobUp.timingMode = .easeInEaseOut
            let bobDown = SCNAction.moveBy(x: 0, y: -0.15, z: 0, duration: 4.0 + Double(index) * 0.35)
            bobDown.timingMode = .easeInEaseOut

            let reset = SCNAction.moveBy(x: -CGFloat(driftX), y: 0, z: 0, duration: 0)

            cloud.runAction(.repeatForever(.sequence([drift, reset])))
            cloud.runAction(.repeatForever(.sequence([bobUp, bobDown])), forKey: "cloudBob")
        }
    }

    private static func animateBirds(in scene: SCNScene) {
        guard let root = scene.rootNode.childNode(withName: birdRootName, recursively: false) else { return }
        for (index, bird) in root.childNodes.enumerated() {
            let flight = SCNAction.moveBy(x: 28, y: 0.4, z: -3, duration: 14 + Double(index * 3))
            let reset = SCNAction.moveBy(x: -28, y: -0.4, z: 3, duration: 0)
            let flapUp = SCNAction.moveBy(x: 0, y: 0.16, z: 0, duration: 0.6)
            let flapDown = SCNAction.moveBy(x: 0, y: -0.16, z: 0, duration: 0.6)
            bird.runAction(.repeatForever(.sequence([flight, reset])))
            bird.childNodes.first?.runAction(.repeatForever(.sequence([flapUp, flapDown])))
        }
    }

    private static func animateLighting(in scene: SCNScene) {
        guard let sunNode = scene.rootNode.childNode(withName: sunLightName, recursively: false),
              let ambientNode = scene.rootNode.childNode(withName: ambientLightName, recursively: false),
              let sun = sunNode.light,
              let ambient = ambientNode.light else { return }

        let cycle = SCNAction.customAction(duration: 18) { _, elapsed in
            let progress = elapsed / 18
            let phase = sin(progress * .pi * 2)
            sun.intensity = CGFloat(700 + phase * 250)
            ambient.intensity = CGFloat(260 + phase * 120)
            if phase > 0.2 {
                sun.color = UIColor(red: 1.0, green: 0.93, blue: 0.75, alpha: 1.0)
            } else if phase < -0.2 {
                sun.color = UIColor(red: 0.52, green: 0.63, blue: 0.95, alpha: 1.0)
            } else {
                sun.color = UIColor(red: 1.0, green: 0.72, blue: 0.48, alpha: 1.0)
            }
        }

        sunNode.runAction(.repeatForever(cycle))
    }
}