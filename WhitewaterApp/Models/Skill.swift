// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation

enum SkillCategory: String, Codable, CaseIterable {
    case rolling
    case surfing
    case strokes
    case safety
    case attainment
    case playboating

    var displayName: String {
        switch self {
        case .rolling:     return "Rolling"
        case .surfing:     return "Surfing"
        case .strokes:     return "Strokes"
        case .safety:      return "Safety"
        case .attainment:  return "Attainment"
        case .playboating: return "Playboating"
        }
    }
}

struct Skill: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let category: SkillCategory
    let description: String?
    let icon: String?
}

struct RunSkill: Codable, Identifiable {
    let id: Int
    let runLogId: Int
    let skillId: Int
    let skill: Skill?
    let achieved: Bool
}
