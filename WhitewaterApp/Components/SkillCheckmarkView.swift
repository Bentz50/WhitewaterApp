// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

/// A single skill row with a checkbox, name, and optional description.
/// Uses category color coding.
struct SkillCheckmarkView: View {

    let skill: Skill
    let isChecked: Bool
    let onToggle: () -> Void

    private var categoryColor: Color {
        switch skill.category {
        case .rolling:     return .blue
        case .surfing:     return .cyan
        case .strokes:     return .green
        case .safety:      return .red
        case .attainment:  return .orange
        case .playboating: return .purple
        }
    }

    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 14) {
                // Checkbox
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(isChecked ? categoryColor : Color(.systemGray3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                        .background(
                            isChecked ? categoryColor.opacity(0.15) : Color.clear,
                            in: RoundedRectangle(cornerRadius: 6)
                        )

                    if isChecked {
                        Image(systemName: "checkmark")
                            .font(.caption.bold())
                            .foregroundStyle(categoryColor)
                    }
                }
                .animation(.easeInOut(duration: 0.15), value: isChecked)

                // Icon + name + description
                HStack(spacing: 10) {
                    if let icon = skill.icon {
                        Image(systemName: icon)
                            .font(.subheadline)
                            .foregroundStyle(categoryColor)
                            .frame(width: 22)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(skill.name)
                            .font(.subheadline)
                            .foregroundStyle(.primary)

                        if let description = skill.description {
                            Text(description)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                    }
                }

                Spacer()

                // Category label
                Text(skill.category.displayName)
                    .font(.caption2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(categoryColor.opacity(0.12), in: Capsule())
                    .foregroundStyle(categoryColor)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.vertical, 2)
    }
}
