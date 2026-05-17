//
//  AssetLoader.swift
//  Memory Meadow
//
//  Created by Macbook on 17/5/26.
//

import SceneKit

enum AssetLoader {
    static func loadPineTreeAsset(yaw: Float = 0) -> SCNNode? {
        guard let rawNode = loadAssetDirect(named: "Pine_4", extension: "usdc") else {
            print("❌ Pine loadAssetDirect returned nil")
            return nil
        }

        let tree = SCNNode()
        rawNode.eulerAngles = SCNVector3(-Float.pi / 2, yaw, 0)
        rawNode.scale = SCNVector3(0.55, 0.55, 0.55)
        tree.addChildNode(rawNode)

        let bounds = tree.flattenedBounds()
        rawNode.position = SCNVector3(
            -((bounds.min.x + bounds.max.x) / 2),
            -bounds.min.y,
            -((bounds.min.z + bounds.max.z) / 2)
        )

        applyTreeMaterial(to: tree)
        print("✅ Pine loaded upright and anchored at spawn")

        return tree
    }

    static func loadCloudAsset() -> SCNNode? {
        if let scene = SCNScene(named: "cloud.usdz") {
            if let rootNode = scene.rootNode.childNodes.first {
                return rootNode.clone()
            }
            return scene.rootNode.clone()
        }
        return nil
    }

    static func loadMountainAsset() -> SCNNode? {
        if let scene = SCNScene(named: "mountain.usdz") {
            if let rootNode = scene.rootNode.childNodes.first {
                return rootNode.clone()
            }
            return scene.rootNode.clone()
        }
        return nil
    }

    static func loadCloudAssetFromBundle() -> SCNNode? {
        guard let assetURL = Bundle.main.url(forResource: "cloud", withExtension: "usdz") else {
            return nil
        }

        do {
            let scene = try SCNScene(url: assetURL, options: nil)
            if let rootNode = scene.rootNode.childNodes.first {
                return rootNode.clone()
            }
            return scene.rootNode.clone()
        } catch {
            return nil
        }
    }

    static func loadMountainAssetFromBundle() -> SCNNode? {
        loadAsset(named: "mountain", extension: "usdz")
    }

    private static func loadAsset(named name: String, extension fileExtension: String) -> SCNNode? {
        guard let scene = loadScene(named: name, extension: fileExtension) else {
            return nil
        }

        if let rootNode = scene.rootNode.childNodes.first {
            return rootNode.clone()
        }
        return scene.rootNode.clone()
    }

    private static func loadAssetRoot(named name: String, extension fileExtension: String) -> SCNNode? {
        guard let scene = loadScene(named: name, extension: fileExtension) else {
            print("❌ Failed to load scene: \(name).\(fileExtension)")
            return nil
        }

        print("📦 Scene loaded: \(name).\(fileExtension)")
        print("   Root children count: \(scene.rootNode.childNodes.count)")

        let container = SCNNode()
        for (index, child) in scene.rootNode.childNodes.enumerated() {
            print("   Child \(index): geometry=\(child.geometry != nil), childNodes=\(child.childNodes.count)")
            container.addChildNode(child.clone())
        }

        if container.childNodes.isEmpty {
            print("⚠️ Container is empty after loading")
            return nil
        }

        print("✅ Returning container with \(container.childNodes.count) children")
        return container
    }

    private static func loadAssetDirect(named name: String, extension fileExtension: String) -> SCNNode? {
        guard let scene = loadScene(named: name, extension: fileExtension) else {
            return nil
        }

        return scene.rootNode.clone()
    }

    private static func loadScene(named name: String, extension fileExtension: String) -> SCNScene? {
        guard let assetURL = Bundle.main.url(forResource: name, withExtension: fileExtension) else {
            return nil
        }

        return try? SCNScene(url: assetURL, options: nil)
    }

    private static func normalize(node: SCNNode, targetHeight: Float) {
        let bounds = node.flattenedBounds()
        let height = bounds.max.y - bounds.min.y
        guard height > 0 else { return }

        let scale = targetHeight / height
        node.scale = SCNVector3(scale, scale, scale)
        node.position = SCNVector3(
            -((bounds.min.x + bounds.max.x) / 2) * scale,
            -bounds.min.y * scale,
            -((bounds.min.z + bounds.max.z) / 2) * scale
        )
    }

    private static func applyTreeMaterial(to node: SCNNode) {
        let leafMaterial = SCNMaterial()
        leafMaterial.diffuse.contents = UIColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 1.0)
        leafMaterial.roughness.contents = 0.8

        node.enumerateChildNodes { child, _ in
            if child.geometry != nil {
                child.geometry?.materials = [leafMaterial]
            }
        }
    }
}

private extension SCNNode {
    func flattenedBounds() -> (min: SCNVector3, max: SCNVector3) {
        var hasBounds = false
        var minPoint = SCNVector3Zero
        var maxPoint = SCNVector3Zero

        enumerateChildNodes { child, _ in
            guard child.geometry != nil else { return }
            let childMin = child.boundingBox.min
            let childMax = child.boundingBox.max
            let points = [
                SCNVector3(childMin.x, childMin.y, childMin.z),
                SCNVector3(childMin.x, childMin.y, childMax.z),
                SCNVector3(childMin.x, childMax.y, childMin.z),
                SCNVector3(childMin.x, childMax.y, childMax.z),
                SCNVector3(childMax.x, childMin.y, childMin.z),
                SCNVector3(childMax.x, childMin.y, childMax.z),
                SCNVector3(childMax.x, childMax.y, childMin.z),
                SCNVector3(childMax.x, childMax.y, childMax.z)
            ]

            for point in points {
                let converted = child.convertPosition(point, to: self)
                if hasBounds {
                    minPoint.x = min(minPoint.x, converted.x)
                    minPoint.y = min(minPoint.y, converted.y)
                    minPoint.z = min(minPoint.z, converted.z)
                    maxPoint.x = max(maxPoint.x, converted.x)
                    maxPoint.y = max(maxPoint.y, converted.y)
                    maxPoint.z = max(maxPoint.z, converted.z)
                } else {
                    minPoint = converted
                    maxPoint = converted
                    hasBounds = true
                }
            }
        }

        return hasBounds ? (minPoint, maxPoint) : (SCNVector3Zero, SCNVector3Zero)
    }
}