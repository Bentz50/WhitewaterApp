// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation

enum GaugeSource: String, Codable {
    case usgs
    case noaa
}

struct GaugeReading: Codable {
    let timestamp: Date
    let value: Double
    let unit: String
}

struct GaugeData: Codable, Identifiable {
    let siteId: String
    let siteName: String
    let source: GaugeSource
    let streamflowCfs: Double?
    let gageHeightFt: Double?
    let floodStage: Double?
    let readings: [GaugeReading]
    let forecast: [GaugeReading]
    let cachedAt: Date?

    var id: String { siteId }
}
