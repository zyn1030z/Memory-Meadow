//
//  PathNetworkBuilder.swift
//  Memory Meadow
//
//  Created by Macbook on 17/5/26.
//

import Foundation

struct PathConnection: Hashable {
    let startID: UUID
    let endID: UUID

    init(_ first: UUID, _ second: UUID) {
        if first.uuidString < second.uuidString {
            self.startID = first
            self.endID = second
        } else {
            self.startID = second
            self.endID = first
        }
    }
}

enum PathNetworkBuilder {
    static func nearestNeighborConnections(for memories: [MemoryItem]) -> [PathConnection] {
        guard memories.count > 1 else { return [] }

        var connections = Set<PathConnection>()

        for memory in memories {
            let nearest = memories
                .filter { $0.id != memory.id }
                .min { distance(from: memory, to: $0) < distance(from: memory, to: $1) }

            guard let nearest else { continue }
            connections.insert(PathConnection(memory.id, nearest.id))
        }

        return Array(connections)
    }

    static func distance(from first: MemoryItem, to second: MemoryItem) -> Float {
        let dx = first.xPosition - second.xPosition
        let dz = first.zPosition - second.zPosition
        return sqrt((dx * dx) + (dz * dz))
    }
}