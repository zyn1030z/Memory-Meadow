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
        animateFireflies(in: scene)
    }

    private static func animateGrass(in scene: SCNScene) {
        guard let root = scene.rootNode.childNode(withName: grassRootName, recursively: false) else { return }
        for (index, clump) in root.childNodes.enumerated() {
            let angle = CGFloat(0.05 + Double(index % 6) * 0.008)
            let duration = 1.8 + Double(index % 4) * 0.2
            let swayLeft = SCNAction.rotateBy(x: 0, y: 0, z: angle, duration: duration)
            swayLeft.timingMode = .easeInEaseOut
            let swayRight = SCNAction.rotateBy(x: 0, y: 0, z: -angle * 2, duration: duration)
            swayRight.timingMode = .easeInEaseOut
            let reset = SCNAction.rotateBy(x: 0, y: 0, z: angle, duration: duration)
            reset.timingMode = .easeInEaseOut

            clump.runAction(.repeatForever(.sequence([swayLeft, swayRight, reset])), forKey: "windSway")
        }
    }

    private static func animateClouds(in scene: SCNScene) {
        guard let root = scene.rootNode.childNode(withName: cloudRootName, recursively: false) else { return }

        for (index, cloud) in root.childNodes.enumerated() {
            let driftX = 36.0 + Double(index) * 4.0
            let duration = 32.0 + Double(index) * 5.0

            let drift = SCNAction.moveBy(x: CGFloat(driftX), y: 0, z: 0, duration: duration)
            drift.timingMode = .easeInEaseOut

            let bobUp = SCNAction.moveBy(x: 0, y: 0.12, z: 0, duration: 3.5 + Double(index) * 0.5)
            bobUp.timingMode = .easeInEaseOut
            let bobDown = SCNAction.moveBy(x: 0, y: -0.12, z: 0, duration: 3.5 + Double(index) * 0.5)
            bobDown.timingMode = .easeInEaseOut

            let reset = SCNAction.moveBy(x: -CGFloat(driftX), y: 0, z: 0, duration: 0)

            cloud.runAction(.repeatForever(.sequence([drift, reset])))
            cloud.runAction(.repeatForever(.sequence([bobUp, bobDown])), forKey: "cloudBob")
        }
    }

    private static func animateBirds(in scene: SCNScene) {
        guard let root = scene.rootNode.childNode(withName: birdRootName, recursively: false) else { return }

        for (index, bird) in root.childNodes.enumerated() {
            let flightX = 26.0 + Double(index) * 3.0
            let duration = 12.0 + Double(index) * 2.0

            let flight = SCNAction.moveBy(x: CGFloat(flightX), y: 0.3, z: -2, duration: duration)
            flight.timingMode = .easeInEaseOut

            let flapUp = SCNAction.moveBy(x: 0, y: 0.12, z: 0, duration: 0.4)
            flapUp.timingMode = .easeInEaseOut
            let flapDown = SCNAction.moveBy(x: 0, y: -0.12, z: 0, duration: 0.4)
            flapDown.timingMode = .easeInEaseOut

            let reset = SCNAction.moveBy(x: -CGFloat(flightX), y: -0.3, z: 2, duration: 0)

            bird.runAction(.repeatForever(.sequence([flight, reset])))
            bird.runAction(.repeatForever(.sequence([flapUp, flapDown])), forKey: "birdFlap")
        }
    }

    private static func animateLighting(in scene: SCNScene) {
        guard let sunNode = scene.rootNode.childNode(withName: sunLightName, recursively: false),
              let ambientNode = scene.rootNode.childNode(withName: ambientLightName, recursively: false),
              let sun = sunNode.light,
              let ambient = ambientNode.light else { return }

        let cycle = SCNAction.customAction(duration: 20) { _, elapsed in
            let progress = elapsed / 20
            let phase = sin(progress * .pi * 2)
            sun.intensity = CGFloat(800 + phase * 220)
            ambient.intensity = CGFloat(300 + phase * 100)
            if phase > 0.25 {
                sun.color = UIColor(red: 1.0, green: 0.92, blue: 0.75, alpha: 1.0)
            } else if phase < -0.25 {
                sun.color = UIColor(red: 0.52, green: 0.63, blue: 0.95, alpha: 1.0)
            } else {
                sun.color = UIColor(red: 1.0, green: 0.72, blue: 0.48, alpha: 1.0)
            }
        }

        sunNode.runAction(.repeatForever(cycle))
    }

    private static func animateFireflies(in scene: SCNScene) {
        guard let root = scene.rootNode.childNode(withName: "FireflyRoot", recursively: false) else { return }

        for (index, firefly) in root.childNodes.enumerated() {
            let floatUp = SCNAction.moveBy(x: 0, y: 0.25, z: 0, duration: 1.5 + Double(index) * 0.3)
            floatUp.timingMode = .easeInEaseOut
            let floatDown = SCNAction.moveBy(x: 0, y: -0.25, z: 0, duration: 1.5 + Double(index) * 0.3)
            floatDown.timingMode = .easeInEaseOut

            firefly.runAction(.repeatForever(.sequence([floatUp, floatDown])), forKey: "fireflyFloat")
        }
    }
}