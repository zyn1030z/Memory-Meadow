//
//  Memory_MeadowApp.swift
//  Memory Meadow
//
//  Created by Macbook on 16/5/26.
//

import SwiftUI
import SwiftData

@main
struct Memory_MeadowApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: MemoryItem.self)
    }
}
