// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation

struct User: Codable, Identifiable, Hashable {
    let id: Int
    let email: String
    let username: String
    let displayName: String
    let avatarURL: String?
    let preferredDifficulty: [String]
    let waterExperiences: [String]
    let interests: [String]
    let crewCount: Int
    let createdAt: Date
}
