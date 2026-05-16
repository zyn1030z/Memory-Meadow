//
//  PremiumHUDView.swift
//  Memory Meadow
//
//  Created by Macbook on 16/5/26.
//

import SwiftUI

struct PremiumHUDView: View {
    let greeting: String
    let subtitle: String
    let weatherIcon: String
    let notificationCount: Int
    let flowerCount: Int
    let treeCount: Int
    let totalCount: Int
    let onAddPressed: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Top Header
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                // Avatar
                Circle()
                    .fill(LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 48, height: 48)
                    .overlay(
                        Text("H")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.white)
                    )

                // Greeting text
                VStack(alignment: .leading, spacing: 4) {
                    Text(greeting)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.primary)

                    Text(subtitle)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(.secondary.opacity(0.6))
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 24)

            Spacer()

            // Bottom Section
            VStack(spacing: 0) {
                // Glass stats card
                HStack(spacing: 24) {
                    StatItem(icon: "🌼", count: flowerCount, label: "Hoa")
                    StatItem(icon: "🌳", count: treeCount, label: "Cây")
                    StatItem(icon: "✨", count: totalCount, label: "Ký ức")
                }
                .padding(16)
                .frame(height: 90)
                .background(
                    .ultraThinMaterial,
                    in: RoundedRectangle(cornerRadius: 30)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)

                // Floating FAB
                FloatingAddButton(action: onAddPressed)
            }
            .padding(.bottom, 24)
            .padding(.horizontal, 24)
        }
    }
}

struct StatItem: View {
    let icon: String
    let count: Int
    let label: String

    var body: some View {
        VStack(spacing: 6) {
            Text(icon)
                .font(.system(size: 22))
            Text("\(count)")
                .font(.system(size: 18, weight: .semibold))
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.secondary)
        }
    }
}

struct FloatingAddButton: View {
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [.green, .blue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 70, height: 70)
                    .scaleEffect(isPressed ? 0.92 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)

                Image(systemName: "plus")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
            }
        }
        .onLongPressGesture(minimumDuration: 0.1, maximumDistance: 30, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
        .shadow(color: .blue.opacity(0.3), radius: 16, x: 0, y: 8)
    }
}