# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Memory Meadow is an iOS 17+ app built with SwiftUI + SceneKit + SwiftData. Users create memories (knowledge, tasks, emotions) that appear as 3D objects (flowers, trees, fireflies) on a meadow.

## Build Commands

```bash
# Build for simulator (iPhone 17 recommended)
xcodebuild -project "Memory Meadow.xcodeproj" -scheme "Memory Meadow" -destination 'platform=iOS Simulator,name=iPhone 17' build

# Open in Xcode
open "Memory Meadow.xcodeproj"
```

## Architecture

**SwiftUI Layer** (`Views/`)
- `HomeView.swift` - Main screen with full-screen 3D scene + HUD overlay
- `AddMemoryView.swift` - Sheet for creating memories (category cards, gradient save button)
- `MemoryDetailView.swift` - 3D object preview + memory content display
- `Views/Components/` - Reusable UI components (PremiumHUDView, stat cards, FAB)

**SwiftData Models** (`Models/`)
- `MemoryItem` - @Model with id, content, type (knowledge/task/emotion), createdAt, xPosition, zPosition
- `MemoryType` - Enum defining memory categories

**SceneKit Layer** (`SceneKit/`)
- `MeadowSceneView.swift` - UIViewRepresentable bridge, coordinator setup
- `MeadowSceneBuilder.swift` - Scene construction: ground, grass, hills, stones, stream, birds, lights
- `MeadowSceneCoordinator.swift` - Gesture handling (tap, pan, pinch), memory lookup
- `MemoryNodeFactory.swift` - Creates 3D objects: flowers (knowledge), trees (task), fireflies (emotion)
- `MeadowSceneSynchronizer.swift` - Syncs SwiftData memories to SceneKit nodes
- `CameraController.swift` - Orthographic camera setup, pan/zoom logic
- `MeadowEnvironmentAnimator.swift` - Animations for grass, clouds, birds, lighting cycle
- `AssetLoader.swift` - Loads .usdz assets with procedural fallback

**Key Patterns**
- Memory objects use `node.name = memory.id.uuidString` for hit-testing
- `MeadowSceneSynchronizer` only animates newly added memories (not all on reload)
- Camera uses orthographic projection for simpler zoom/pan
- All 3D geometry is procedural SceneKit primitives (no external assets required)

## Memory Type → 3D Object Mapping

| Type | Object | Color |
|------|--------|-------|
| knowledge | Flower (stem + petals) | Pink/Yellow |
| task | Tree (trunk + canopy) | Green/Brown |
| emotion | Firefly (glowing sphere + light) | Purple |

## Configuration Flags

In `MeadowSceneBuilder.makeScene()`:
- `addMountains(to:)` - Commented out (awaiting real assets)
- `addClouds(to:)` - Commented out (awaiting real assets)
- `addHills(to:)` - Active, adds depth to meadow
- `addStones(to:)` - Active, foreground detail

In `MeadowSceneCoordinator.configure()`:
- `parallaxController.start()` - Commented out (disable device tilt parallax)

## File Size Constraint

Keep all files under ~300 lines. If a SceneKit factory grows too large, split by object type (e.g., `FlowerNodeFactory.swift`, `TreeNodeFactory.swift`).
