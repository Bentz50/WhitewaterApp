// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation

struct ClubMembership: Codable, Identifiable, Hashable {
    let id: Int
    let userId: Int
    let clubName: String
    let verified: Bool
    let joinedAt: Date?
}
