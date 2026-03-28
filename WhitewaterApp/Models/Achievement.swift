// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation

struct Achievement: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String
    let icon: String
    let category: String
    let thresholdType: String
    let thresholdValue: Double
}

struct UserAchievement: Codable, Identifiable {
    let id: Int
    let userId: Int
    let achievementId: Int
    let achievement: Achievement?
    let unlockedAt: Date
    let data: [String: Double]?
}
