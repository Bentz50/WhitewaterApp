// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation

struct RiverSection: Codable, Identifiable {
    let id: Int
    let riverId: Int
    let name: String
    let sectionLabel: String?
    let description: String?
    let putInLat: Double?
    let putInLng: Double?
    let takeOutLat: Double?
    let takeOutLng: Double?
    let awRating: AWRating
    let khccRating: String?
    let lengthMiles: Double?
    let usgsSiteId: String?
    let noaaGageId: String?
    let tags: [String]?
    let isRunnable: Bool?
    let sortOrder: Int?
}
