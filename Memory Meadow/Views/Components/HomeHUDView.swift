//
//  HomeHUDView.swift
//  Memory Meadow
//
//  Created by Macbook on 16/5/26.
//

import SwiftUI

struct HomeHUDView: View {
    let greeting: String
    let subtitle: String
    let weatherIcon: String
    let notificationCount: Int
    let flowerCount: Int
    let treeCount: Int
    let totalCount: Int
    let onAddPressed: () -> Void

    var body: some View {
        VStack {
            // Top: Avatar + Greeting + Icons
            HStack {
                HStack(spacing: 8) {
                    Circle()
                        .fill(LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Text("H")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        )

                    VStack(alignment: .leading, spacing: 2) {
                        Text(greeting)
                            .font(.title3)
                            .fontWeight(.semibold)
                        Text(subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                HStack(spacing: 12) {
                    IconBadge(icon: weatherIcon, color: .orange, badge: nil)
                    IconBadge(icon: "bell.fill", color: .blue, badge: notificationCount > 0 ? notificationCount : nil)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)

            Spacer()

            // Bottom: Stats + FAB
            HStack {
                // Stats block
                HStack(spacing: 16) {
                    StatsBadge(icon: "🌼", count: flowerCount, label: "Hoa")
                    StatsBadge(icon: "🌳", count: treeCount, label: "Cây")
                    StatsBadge(icon: "✨", count: totalCount, label: "Ký ức")
                }
                .padding(.bottom, 16)
                .padding(.horizontal, 16)

                Spacer()

                // Floating Add button
                GlassFAB(icon: "plus", size: 56, action: onAddPressed)
            }
        }
    }
}

struct IconBadge: View {
    let icon: String
    let color: Color
    let badge: Int?

    var body: some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.15))
                .frame(width: 36, height: 36)

            Image(systemName: icon)
                .font(.caption2)
                .foregroundStyle(color)

            if let badge = badge, badge > 0 {
                Circle()
                    .fill(.red)
                    .frame(width: 16, height: 16)
                    .position(x: 24, y: 8)
                    .overlay(
                        Text("\(badge)")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    )
            }
        }
    }
}