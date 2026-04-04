// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation

extension Double {
    /// Formats as a distance value (e.g. "3.25").
    var formattedDistance: String {
        String(format: LayoutConstants.NumberFormat.distance, self)
    }

    /// Formats as a speed value (e.g. "4.2").
    var formattedSpeed: String {
        String(format: LayoutConstants.NumberFormat.speed, self)
    }

    /// Formats as a gauge reading (e.g. "5.12").
    var formattedGauge: String {
        String(format: LayoutConstants.NumberFormat.gauge, self)
    }
}
