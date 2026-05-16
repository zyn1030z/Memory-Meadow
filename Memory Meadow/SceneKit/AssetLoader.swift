//
//  AssetLoader.swift
//  Memory Meadow
//
//  Created by Macbook on 17/5/26.
//

import SceneKit

enum AssetLoader {
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
        guard let assetURL = Bundle.main.url(forResource: "mountain", withExtension: "usdz") else {
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
}