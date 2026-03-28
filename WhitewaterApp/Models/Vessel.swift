// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation

enum VesselType: String, Codable, CaseIterable {
    case kayak
    case canoe
    case raft

    var displayName: String {
        switch self {
        case .kayak: return "Kayak"
        case .canoe: return "Canoe"
        case .raft:  return "Raft"
        }
    }
}

struct Vessel: Codable, Identifiable, Hashable {
    let id: Int
    let userId: Int
    let type: VesselType
    let name: String
    let brand: String?
    let model: String?
    let isDefault: Bool
}
