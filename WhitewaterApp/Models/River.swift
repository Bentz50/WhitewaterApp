// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation

enum AWRating: String, Codable, CaseIterable {
    case classI     = "I"
    case classII    = "II"
    case classIII   = "III"
    case classIV    = "IV"
    case classV     = "V"
    case classV_plus = "V+"
    case unrated    = "unrated"

    var displayName: String {
        switch self {
        case .classI:    return "Class I"
        case .classII:   return "Class II"
        case .classIII:  return "Class III"
        case .classIV:   return "Class IV"
        case .classV:    return "Class V"
        case .classV_plus: return "Class V+"
        case .unrated:   return "Unrated"
        }
    }
}

struct River: Codable, Identifiable {
    let id: Int
    let name: String
    let state: String
    let region: String
    let lat: Double
    let lng: Double
    let putInLat: Double
    let putInLng: Double
    let takeOutLat: Double
    let takeOutLng: Double
    let awRating: AWRating
    let khccRating: String?
    let lengthMiles: Double?
    let description: String?
    let usgsSiteId: String?
    let noaaGageId: String?
    let tags: [String]
    let isRunnable: Bool?
    let sections: [RiverSection]?

    /// Whether this river has been broken down into runnable sections.
    var hasSections: Bool {
        guard let sections else { return false }
        return !sections.isEmpty
    }
}
