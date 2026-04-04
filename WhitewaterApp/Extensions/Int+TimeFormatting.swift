// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation

extension Int {
    /// Formats seconds as "H:MM:SS" or "MM:SS".
    var formattedDuration: String {
        let h = self / 3600
        let m = (self % 3600) / 60
        let s = self % 60
        if h > 0 { return String(format: "%d:%02d:%02d", h, m, s) }
        return String(format: "%02d:%02d", m, s)
    }
}
