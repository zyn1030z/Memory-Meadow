# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

Memory Meadow is an iOS app (SwiftUI + SceneKit + SwiftData). Users save memories (`knowledge`, `task`, `emotion`) and each memory appears as a 3D object in a meadow scene.

## Commands

```bash
# Build (primary validation command used in this repo)
xcodebuild -project "Memory Meadow.xcodeproj" -scheme "Memory Meadow" -destination 'platform=iOS Simulator,name=iPhone 17' build

# Open project in Xcode
open "Memory Meadow.xcodeproj"

# Inspect schemes/targets
xcodebuild -list -project "Memory Meadow.xcodeproj"
```

### Tests / lint status

- There is currently no dedicated lint command configured in the repo.
- There is currently no confirmed active test target in normal workflow.
- If/when tests are added, run a single test with:

```bash
xcodebuild test -project "Memory Meadow.xcodeproj" -scheme "Memory Meadow" -destination 'platform=iOS Simulator,name=iPhone 17' -only-testing:TargetName/TestCaseName
```

## High-level architecture

### 1) SwiftUI app shell + SwiftData

- `Memory_MeadowApp.swift`: app entry point + SwiftData container.
- `Models/MemoryItem.swift`, `Models/MemoryType.swift`: persisted memory data and semantic type.
- `Views/HomeView.swift`: main screen, full-screen SceneKit view + HUD overlay.
- `Views/AddMemoryView.swift`: create memory.
- `Views/MemoryDetailView.swift`: detail screen with 3D preview.

Flow:
- `HomeView` reads SwiftData memories via `@Query`.
- The memory list is passed into SceneKit bridge (`MeadowSceneView`).

### 2) SceneKit rendering stack

Core files (read together):
- `SceneKit/MeadowSceneView.swift`
  - `UIViewRepresentable` bridge for `SCNView`.
- `SceneKit/MeadowSceneBuilder.swift`
  - Builds base scene (ground/horizon/hills/lights/memory root).
- `SceneKit/MeadowWorldBuilder.swift`
  - Populates decorative world objects (grass clusters, flowers, stones, trees, birds, clouds).
- `SceneKit/LowPolyFactory.swift`
  - Reusable low-poly geometry constructors for world props.
- `SceneKit/MeadowMaterials.swift`
  - Centralized color/material palette for scene consistency.
- `SceneKit/MeadowEnvironmentAnimator.swift`
  - Environmental animation loops (grass, clouds, birds, lighting cycle, optional fireflies).

### 3) Interaction + camera + memory node sync

- `SceneKit/MeadowSceneCoordinator.swift`
  - Gesture handling: tap select + pan + pinch.
- `SceneKit/CameraController.swift`
  - Camera behavior and constraints.
  - Current setup keeps a fixed presentation angle (~30°); pan translates view, pinch zooms.
- `SceneKit/MemoryNodeFactory.swift`
  - Converts persisted memories into tappable 3D nodes.
- `SceneKit/MeadowSceneSynchronizer.swift`
  - Incrementally syncs SwiftData memory list into scene nodes.
- `SceneKit/SCNNode+MemoryID.swift`
  - Node-to-memory ID resolution for hit testing.

## Important current toggles / behavior

- Device parallax exists but is currently disabled in `MeadowSceneCoordinator`.
- Fireflies are currently disabled in `MeadowWorldBuilder.populate(scene:)` (commented call).
- Optional asset-based cloud/mountain loading exists in `SceneKit/AssetLoader.swift`; procedural fallback is still used when assets are absent.

## Practical guidance for changes

- For visual polish, start with `MeadowMaterials.swift` and `LowPolyFactory.swift`.
- For scene composition/layout depth, edit `MeadowSceneBuilder.swift` + `MeadowWorldBuilder.swift`.
- For navigation feel, edit `CameraController.swift` + `MeadowSceneCoordinator.swift`.
- For memory-object visuals, edit `MemoryNodeFactory.swift` and ensure `MemoryDetailView` preview still matches.