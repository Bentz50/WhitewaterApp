// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation

extension Date {

    /// Relative time string, e.g. "just now", "2 hours ago", "yesterday", "3 days ago"
    var timeAgoString: String {
        let seconds = Int(-timeIntervalSinceNow)
        switch seconds {
        case ..<60:
            return "just now"
        case 60..<3600:
            let minutes = seconds / 60
            return "\(minutes) minute\(minutes == 1 ? "" : "s") ago"
        case 3600..<86400:
            let hours = seconds / 3600
            return "\(hours) hour\(hours == 1 ? "" : "s") ago"
        case 86400..<172800:
            return "yesterday"
        default:
            let days = seconds / 86400
            return "\(days) day\(days == 1 ? "" : "s") ago"
        }
    }

    /// Long date string, e.g. "March 28, 2026"
    var runDateString: String {
        formatted(.dateTime.month(.wide).day().year())
    }

    /// Short date string, e.g. "Mar 28"
    var shortDateString: String {
        formatted(.dateTime.month(.abbreviated).day())
    }

    /// Time string, e.g. "2:34 PM"
    var timeString: String {
        formatted(.dateTime.hour().minute())
    }

    /// Formats a duration in seconds to a human-readable string, e.g. "1h 23m 45s"
    static func formattedDuration(seconds: Int) -> String {
        let hours   = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let secs    = seconds % 60

        if hours > 0 {
            return "\(hours)h \(minutes)m \(secs)s"
        } else if minutes > 0 {
            return "\(minutes)m \(secs)s"
        } else {
            return "\(secs)s"
        }
    }
}
