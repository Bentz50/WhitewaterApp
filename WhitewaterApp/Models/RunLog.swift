// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation

enum RunPrivacy: String, Codable, CaseIterable {
    case `public`  = "public"
    case crew      = "crew"
    case `private` = "private"
}

struct RunLog: Codable, Identifiable {
    let id: Int
    let userId: Int
    let riverId: Int
    let sectionId: Int?
    let vesselId: Int
    let startTime: Date
    let endTime: Date
    let distanceMiles: Double
    let durationSeconds: Int
    let caloriesBurned: Int?
    let startGaugeLevel: Double?
    let endGaugeLevel: Double?
    let gpsTrack: [[Double]]?
    let notes: String?
    let privacy: RunPrivacy

    /// Formats elapsed duration as `h:mm:ss` (or `mm:ss` when under an hour).
    var formattedDuration: String {
        let hours   = durationSeconds / 3600
        let minutes = (durationSeconds % 3600) / 60
        let seconds = durationSeconds % 60
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
