// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation

// MARK: - AW Difficulty Scale

enum AWScale: String, CaseIterable {
    case classI      = "Class I"
    case classII     = "Class II"
    case classIII    = "Class III"
    case classIV     = "Class IV"
    case classV      = "Class V"
    case classV_plus = "Class V+"

    var description: String {
        switch self {
        case .classI:
            return "Easy. Fast moving water with riffles and small waves. Few obstructions."
        case .classII:
            return "Novice. Straightforward rapids with wide, clear channels. Some maneuvering required."
        case .classIII:
            return "Intermediate. Moderate, irregular waves. Complex maneuvers in fast current."
        case .classIV:
            return "Advanced. Intense, powerful but predictable rapids requiring precise boat handling."
        case .classV:
            return "Expert. Extremely long, obstructed, or violent rapids exposing paddlers to significant risk."
        case .classV_plus:
            return "Extreme. Nearly impossible and very dangerous. For teams of experts only."
        }
    }
}

// MARK: - KHCC Skill Scale

enum KHCCScale: String, CaseIterable {
    case beginner     = "Beginner"
    case novice       = "Novice"
    case intermediate = "Intermediate"
    case advanced     = "Advanced"
    case expert       = "Expert"

    var description: String {
        switch self {
        case .beginner:
            return "New to paddling. Comfortable on flatwater with basic paddle strokes."
        case .novice:
            return "Can handle Class I–II water. Familiar with basic river features and self-rescue."
        case .intermediate:
            return "Comfortable on Class III water. Reliable roll, eddy turns, and ferries."
        case .advanced:
            return "Handles Class IV water confidently. Strong rescue skills and leadership ability."
        case .expert:
            return "Proficient on Class V and above. Advanced rescue, expedition, and coaching skills."
        }
    }
}

// MARK: - Water Experience Types

enum WaterExperience: String, CaseIterable, Codable {
    case surf        = "surf"
    case riverRun    = "riverRun"
    case relaxingDay = "relaxingDay"
    case attainment  = "attainment"
    case slalom      = "slalom"
    case creeking    = "creeking"
    case bigWater    = "bigWater"
    case playBoating = "playBoating"

    var displayName: String {
        switch self {
        case .surf:        return "Surf"
        case .riverRun:    return "River Run"
        case .relaxingDay: return "Relaxing Day"
        case .attainment:  return "Attainment"
        case .slalom:      return "Slalom"
        case .creeking:    return "Creeking"
        case .bigWater:    return "Big Water"
        case .playBoating: return "Play Boating"
        }
    }
}

// MARK: - User Interests

enum UserInterest: String, CaseIterable, Codable {
    case races         = "races"
    case festivals     = "festivals"
    case cleanups      = "cleanups"
    case volunteer     = "volunteer"
    case safetyCourses = "safetyCourses"
    case events        = "events"

    var displayName: String {
        switch self {
        case .races:         return "Races"
        case .festivals:     return "Festivals"
        case .cleanups:      return "Cleanups"
        case .volunteer:     return "Volunteer"
        case .safetyCourses: return "Safety Courses"
        case .events:        return "Events"
        }
    }

    var icon: String {
        switch self {
        case .races:         return "flag.checkered"
        case .festivals:     return "party.popper"
        case .cleanups:      return "trash.fill"
        case .volunteer:     return "hand.raised.fill"
        case .safetyCourses: return "cross.fill"
        case .events:        return "calendar"
        }
    }
}

// MARK: - Skill Constants

enum SkillConstants {
    static let defaultSkillNames: [String] = [
        "Combat Roll",
        "Dry Hair Day",
        "Boof Stroke",
        "Stern Squirt",
        "Cartwheel",
        "Bow Stall",
        "Wave Surf",
        "Hole Surf",
        "Attainment",
        "Ferry",
        "Eddy Catch",
        "Peel Out",
        "Blunt",
        "Loop",
        "Splitwheel",
        "Pistol Flip",
        "Back Deck Roll",
        "Hand Roll",
        "C-to-C Roll",
        "Eskimo Roll"
    ]
}

// MARK: - App-wide Constants

enum AppConstants {
    /// Radius in miles within which dam release notifications are triggered.
    static let damReleaseNotificationRadius: Double = 50.0

    static let maxPhotoUploadSizeMB: Int = 10
    static let maxVideoUploadSizeMB: Int = 100
    static let feedPageSize: Int = 20
    static let defaultSearchRadiusMiles: Double = 50.0

    static let caloriesPerHourKayak: Int = 300
    static let caloriesPerHourCanoe: Int = 250
    static let caloriesPerHourRaft:  Int = 200
}
