// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation

enum EventType: String, Codable, CaseIterable {
    case race
    case festival
    case cleanup
    case safety_course
    case dam_release
    case volunteer

    var displayName: String {
        switch self {
        case .race:          return "Race"
        case .festival:      return "Festival"
        case .cleanup:       return "Cleanup"
        case .safety_course: return "Safety Course"
        case .dam_release:   return "Dam Release"
        case .volunteer:     return "Volunteer"
        }
    }

    /// SF Symbol name for this event type.
    var icon: String {
        switch self {
        case .race:          return "flag.checkered"
        case .festival:      return "star.fill"
        case .cleanup:       return "trash.fill"
        case .safety_course: return "shield.fill"
        case .dam_release:   return "water.waves"
        case .volunteer:     return "hands.sparkles.fill"
        }
    }
}

struct Event: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let type: EventType
    let lat: Double?
    let lng: Double?
    let startDate: Date
    let endDate: Date
    let organizer: String?
    let url: String?
    let createdAt: Date
}
