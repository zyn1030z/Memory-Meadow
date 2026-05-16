//
//  SCNNode+MemoryID.swift
//  Memory Meadow
//
//  Created by Macbook on 16/5/26.
//

import SceneKit

extension SCNNode {
    func nearestMemoryID() -> UUID? {
        var node: SCNNode? = self
        while let current = node {
            if let name = current.name, let id = UUID(uuidString: name) {
                return id
            }
            node = current.parent
        }
        return nil
    }
}