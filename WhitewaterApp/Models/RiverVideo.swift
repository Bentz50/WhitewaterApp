// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation

struct RiverVideo: Codable, Identifiable {
    let id: Int
    let riverId: Int
    let sectionId: Int?
    let title: String
    let url: String
    let minLevel: Double?
    let maxLevel: Double?
    let submittedBy: Int?
    let createdAt: Date?
}
