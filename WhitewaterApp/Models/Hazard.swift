// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation

enum HazardType: String, Codable, CaseIterable {
    case strainer
    case sieve
    case hydraulic
    case lowhead_dam
    case portage_required
    case other

    var displayName: String {
        switch self {
        case .strainer:         return "Strainer"
        case .sieve:            return "Sieve"
        case .hydraulic:        return "Hydraulic"
        case .lowhead_dam:      return "Lowhead Dam"
        case .portage_required: return "Portage Required"
        case .other:            return "Other"
        }
    }
}

enum HazardStatus: String, Codable {
    case active
    case cleared
}

struct Hazard: Codable, Identifiable {
    let id: Int
    let riverId: Int
    let sectionId: Int?
    let reportedBy: Int
    let lat: Double
    let lng: Double
    let type: HazardType
    let description: String
    let lastObserved: Date?
    let status: HazardStatus
    let createdAt: Date
}
