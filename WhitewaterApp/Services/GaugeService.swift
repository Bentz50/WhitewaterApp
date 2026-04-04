// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation

@MainActor
final class GaugeService: ObservableObject {

    static let shared = GaugeService()

    private let api = APIService.shared
    private let cachePrefix = "gauge_"

    private let cacheEncoder: JSONEncoder = {
        let e = JSONEncoder()
        e.dateEncodingStrategy = .iso8601
        return e
    }()

    private let cacheDecoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()

    private init() {}

    // MARK: - Public API

    /// Fetches real-time streamflow and gage height from USGS Instantaneous Values.
    /// Parameters: 00060 (streamflow, cfs) and 00065 (gage height, ft).
    func fetchUSGSGauge(siteId: String) async throws -> GaugeData {
        let urlString = "https://waterservices.usgs.gov/nwis/iv/?format=json&sites=\(siteId)&parameterCd=00060,00065"
        guard let url = URL(string: urlString) else {
            throw WhitewaterError.serverError("Invalid USGS URL for site \(siteId)")
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let gaugeData = try parseUSGSResponse(data, siteId: siteId)
        cacheGaugeData(gaugeData, siteId: siteId)
        return gaugeData
    }

    /// Fetches forecast data from NOAA Advanced Hydrologic Prediction Service (AHPS) XML feed.
    func fetchNOAAForecast(gageId: String) async throws -> GaugeData {
        let urlString = "https://water.weather.gov/ahps2/hydrograph_to_xml.php?gage=\(gageId)&output=xml"
        guard let url = URL(string: urlString) else {
            throw WhitewaterError.serverError("Invalid NOAA URL for gage \(gageId)")
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let gaugeData = try parseNOAAXML(data, gageId: gageId)
        cacheGaugeData(gaugeData, siteId: gageId)
        return gaugeData
    }

    /// Fetches gauge data via the app's backend proxy (merges USGS + NOAA where available).
    func fetchGauge(riverId: Int) async throws -> GaugeData {
        try await api.get("/rivers/\(riverId)/gauge", responseType: GaugeData.self)
    }

    // MARK: - Caching

    func cacheGaugeData(_ data: GaugeData, siteId: String) {
        guard let encoded = try? cacheEncoder.encode(data) else { return }
        UserDefaults.standard.set(encoded, forKey: cachePrefix + siteId)
    }

    func getCachedGauge(siteId: String) -> GaugeData? {
        guard let data = UserDefaults.standard.data(forKey: cachePrefix + siteId) else { return nil }
        return try? cacheDecoder.decode(GaugeData.self, from: data)
    }

    // MARK: - Runnability check

    func isRunnable(gaugeData: GaugeData, river: River) -> Bool {
        // Above flood stage → not runnable
        if let floodStage = gaugeData.floodStage,
           let gageHeight = gaugeData.gageHeightFt,
           gageHeight >= floodStage {
            return false
        }
        // Positive streamflow → runnable
        if let cfs = gaugeData.streamflowCfs { return cfs > 0 }
        // Positive gage height → runnable
        if let ft = gaugeData.gageHeightFt   { return ft > 0 }
        // Fall back to river's stored flag
        return river.isRunnable ?? true
    }

    // MARK: - USGS JSON parsing

    /// USGS parameter codes for streamflow and gage height.
    private enum USGSParameter: String {
        case streamflow = "00060"
        case gageHeight = "00065"

        var unit: String {
            switch self {
            case .streamflow: return "cfs"
            case .gageHeight: return "ft"
            }
        }
    }

    /// ISO 8601 formatters (with and without fractional seconds) reused across parsing calls.
    private static let isoFull: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }()

    private static let isoBasic: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        return f
    }()

    private func parseUSGSResponse(_ data: Data, siteId: String) throws -> GaugeData {

        // Internal mirror types matching USGS camelCase JSON (no key conversion applied).
        struct DateValue: Decodable { let value: String; let dateTime: String }
        struct ValueSet: Decodable  { let value: [DateValue] }
        struct VarCode: Decodable   { let value: String }
        struct Variable: Decodable  { let variableCode: [VarCode] }
        struct SiteCode: Decodable  { let value: String }
        struct SourceInfo: Decodable { let siteName: String; let siteCode: [SiteCode] }
        struct Series: Decodable    { let sourceInfo: SourceInfo; let variable: Variable; let values: [ValueSet] }
        struct ResponseValue: Decodable { let timeSeries: [Series] }
        struct Root: Decodable      { let value: ResponseValue }

        let decoder = JSONDecoder() // plain — USGS JSON is already camelCase
        let root = try decoder.decode(Root.self, from: data)

        var streamflowCfs: Double?
        var gageHeightFt: Double?
        var readings: [GaugeReading] = []
        var siteName = siteId

        for series in root.value.timeSeries {
            siteName = series.sourceInfo.siteName
            guard let paramCodeStr = series.variable.variableCode.first?.value,
                  let param = USGSParameter(rawValue: paramCodeStr) else { continue }

            for set in series.values {
                for entry in set.value {
                    guard
                        let value = Double(entry.value),
                        let date  = Self.isoFull.date(from: entry.dateTime)
                                    ?? Self.isoBasic.date(from: entry.dateTime)
                    else { continue }

                    readings.append(GaugeReading(timestamp: date, value: value, unit: param.unit))
                    switch param {
                    case .streamflow: streamflowCfs = value
                    case .gageHeight: gageHeightFt  = value
                    }
                }
            }
        }

        return GaugeData(
            siteId: siteId,
            siteName: siteName,
            source: .usgs,
            streamflowCfs: streamflowCfs,
            gageHeightFt: gageHeightFt,
            floodStage: nil,
            readings: readings,
            forecast: [],
            cachedAt: Date()
        )
    }

    // MARK: - NOAA AHPS XML parsing

    private func parseNOAAXML(_ data: Data, gageId: String) throws -> GaugeData {
        let delegate  = NOAAXMLParserDelegate()
        let xmlParser = XMLParser(data: data)
        xmlParser.delegate = delegate
        xmlParser.parse()

        if let error = delegate.parseError {
            throw WhitewaterError.decodingError(error)
        }

        return GaugeData(
            siteId: gageId,
            siteName: delegate.siteName.isEmpty ? gageId : delegate.siteName,
            source: .noaa,
            streamflowCfs: delegate.latestFlowKcfs.map { $0 * 1_000 },
            gageHeightFt: delegate.latestStageFt,
            floodStage: delegate.floodStageFt,
            readings: delegate.observed,
            forecast: delegate.forecast,
            cachedAt: Date()
        )
    }
}

// MARK: - NOAA XML parser delegate

private final class NOAAXMLParserDelegate: NSObject, XMLParserDelegate {

    var siteName     = ""
    var floodStageFt: Double?
    var latestStageFt: Double?
    var latestFlowKcfs: Double?
    var observed: [GaugeReading] = []
    var forecast: [GaugeReading] = []
    var parseError: Error?

    private var inForecast = false
    private var inObserved = false
    private var inDatum    = false

    private var currentElement = ""
    private var currentText    = ""
    private var pendingDate:  Date?
    private var pendingStage: Double?
    private var pendingFlow:  Double?

    private let iso = ISO8601DateFormatter()

    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName: String?,
        attributes: [String: String] = [:]
    ) {
        currentElement = elementName
        currentText    = ""

        switch elementName {
        case "forecast":
            inForecast = true
            inObserved = false
        case "observed":
            inObserved = true
            inForecast = false
        case "datum":
            inDatum    = true
            pendingDate  = nil
            pendingStage = nil
            pendingFlow  = nil
        case "sigstages":
            if let raw = attributes["flood"], let val = Double(raw) {
                floodStageFt = val
            }
        default:
            break
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentText += string
    }

    func parser(
        _ parser: XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName: String?
    ) {
        let text = currentText.trimmingCharacters(in: .whitespacesAndNewlines)

        switch elementName {
        case "name":
            if siteName.isEmpty { siteName = text }

        case "valid":
            pendingDate = iso.date(from: text)

        case "primary":
            if let v = Double(text) {
                pendingStage  = v
                latestStageFt = v
            }

        case "secondary":
            if let v = Double(text) {
                pendingFlow    = v
                latestFlowKcfs = v
            }

        case "datum":
            if inDatum, let date = pendingDate, let stage = pendingStage {
                let reading = GaugeReading(timestamp: date, value: stage, unit: "ft")
                if inForecast      { forecast.append(reading) }
                else if inObserved { observed.append(reading) }
            }
            inDatum = false

        case "forecast": inForecast = false
        case "observed": inObserved = false
        default: break
        }

        currentElement = ""
        currentText    = ""
    }

    func parser(_ parser: XMLParser, parseErrorOccurred error: Error) {
        parseError = error
    }
}
