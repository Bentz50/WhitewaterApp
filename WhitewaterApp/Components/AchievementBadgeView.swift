// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

struct AchievementBadgeView: View {

    let achievement: Achievement
    let isUnlocked: Bool
    let progress: Double   // 0.0–1.0

    @State private var animateUnlock: Bool = false

    private var badgeColor: Color {
        switch achievement.category {
        case "distance":    return .blue
        case "runs":        return .green
        case "safety":      return .red
        case "skills":      return .purple
        case "social":      return .orange
        default:            return .appTeal
        }
    }

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(isUnlocked ? badgeColor.opacity(0.15) : Color(.systemGray5))
                    .frame(width: 72, height: 72)

                Image(systemName: achievement.icon)
                    .font(.title)
                    .foregroundStyle(isUnlocked ? badgeColor : .gray)
                    .scaleEffect(animateUnlock ? 1.2 : 1.0)

                if !isUnlocked {
                    // Gray lock overlay
                    Circle()
                        .fill(Color(.systemBackground).opacity(0.55))
                        .frame(width: 72, height: 72)
                    Image(systemName: "lock.fill")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                }

                // Progress ring
                if !isUnlocked && progress > 0 {
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(badgeColor, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .frame(width: 72, height: 72)
                        .rotationEffect(.degrees(-90))
                }
            }

            Text(achievement.name)
                .font(.caption.weight(.medium))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .foregroundStyle(isUnlocked ? .primary : .secondary)

            if !isUnlocked && progress > 0 {
                Text("\(Int(progress * 100))%")
                    .font(.caption2)
                    .foregroundStyle(badgeColor)
            }
        }
        .frame(width: 90)
        .onChange(of: isUnlocked) { _, unlocked in
            if unlocked {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                    animateUnlock = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    withAnimation { animateUnlock = false }
                }
            }
        }
    }
}
