// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation

// MARK: - Feed Post

struct RiverPost: Identifiable {
    let id: Int
    let content: String
    let username: String
    let createdAt: Date
    let isCrew: Bool
}

// MARK: - ViewModel

@MainActor
final class RiverRunViewModel: ObservableObject {

    // MARK: - Published State

    @Published var river: River?
    @Published var section: RiverSection?
    @Published var gaugeData: GaugeData?
    @Published var hazards: [Hazard] = []
    @Published var beaterFeed: [RiverPost] = []
    @Published var videos: [RiverVideo] = []
    @Published var crewOnlyFeed = false
    @Published var isTracking: Bool = false
    @Published var elapsedSeconds: Int = 0
    @Published var distanceMiles: Double = 0.0
    @Published var currentSpeedMph: Double = 0.0
    @Published var caloriesBurned: Int = 0
    @Published var isLoading: Bool = false

    private let api = APIService.shared
    private let location = LocationService.shared
    private let gauge = GaugeService.shared

    private var trackingTask: Task<Void, Never>?

    // MARK: - River Loading

    func loadRiver(id: Int) async {
        isLoading = true
        defer { isLoading = false }
        do {
            river = try await api.get("/rivers/\(id)", responseType: River.self)
            await refreshGauge()
            await loadHazards()
            await loadBeaterFeed()
            await loadVideos()
        } catch {
            // Non-fatal: river may already be set from navigation context
        }
    }

    // MARK: - Section Loading

    func loadSection(riverId: Int, sectionId: Int) async {
        isLoading = true
        defer { isLoading = false }
        do {
            section = try await api.get(
                "/rivers/\(riverId)/sections/\(sectionId)",
                responseType: RiverSection.self
            )
            if river == nil {
                river = try await api.get("/rivers/\(riverId)", responseType: River.self)
            }
            await refreshSectionGauge(riverId: riverId, sectionId: sectionId)
            await loadSectionHazards(riverId: riverId, sectionId: sectionId)
            await loadSectionVideos(riverId: riverId, sectionId: sectionId)
        } catch {
            // Non-fatal: section may already be set from navigation context
        }
    }

    // MARK: - Run Tracking

    func startRun() {
        let vesselType = VesselType.kayak  // default; callers set vessel prior
        location.startTracking(vesselType: vesselType)
        isTracking = true

        trackingTask = Task { [weak self] in
            guard let self else { return }
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                self.elapsedSeconds = location.elapsedSeconds
                self.distanceMiles = location.distanceMiles
                self.currentSpeedMph = location.currentSpeedMph
                self.caloriesBurned = location.caloriesBurned
            }
        }
    }

    /// Stops tracking and returns a partial RunLog draft for the post-run flow.
    @discardableResult
    func stopRun() -> RunLog? {
        trackingTask?.cancel()
        trackingTask = nil

        let (trackPoints, miles, duration) = location.stopTracking()
        isTracking = false

        guard let river else { return nil }

        let gpsTrack: [[Double]] = trackPoints.map { [$0.coordinate.latitude, $0.coordinate.longitude] }

        // Build a placeholder RunLog (id = 0 signals draft; vessel resolved post-run)
        return RunLog(
            id: 0,
            userId: 0,
            riverId: river.id,
            sectionId: section?.id,
            vesselId: 0,
            startTime: Date().addingTimeInterval(-Double(duration)),
            endTime: Date(),
            distanceMiles: miles,
            durationSeconds: duration,
            caloriesBurned: caloriesBurned,
            startGaugeLevel: gaugeData?.gageHeightFt,
            endGaugeLevel: nil,
            gpsTrack: gpsTrack,
            notes: nil,
            privacy: .public
        )
    }

    // MARK: - Gauge

    func refreshGauge() async {
        guard let river else { return }
        do {
            if let siteId = river.usgsSiteId {
                gaugeData = try await gauge.fetchUSGSGauge(siteId: siteId)
            } else {
                gaugeData = try await gauge.fetchGauge(riverId: river.id)
            }
        } catch {
            gaugeData = gauge.getCachedGauge(siteId: river.usgsSiteId ?? "")
        }
    }

    // MARK: - Hazards

    func loadHazards() async {
        guard let river else { return }
        do {
            hazards = try await api.get("/rivers/\(river.id)/hazards", responseType: [Hazard].self)
        } catch {
            hazards = []
        }
    }

    // MARK: - Beater Feed

    func loadBeaterFeed(crewOnly: Bool = false) async {
        guard let river else { return }
        do {
            struct FeedPost: Codable {
                let id: Int
                let content: String
                let username: String
                let createdAt: Date
                let isCrew: Bool
            }
            var path = "/rivers/\(river.id)/feed"
            if crewOnly { path += "?scope=crew" }
            let raw = try await api.get(path, responseType: [FeedPost].self)
            beaterFeed = raw.map {
                RiverPost(id: $0.id, content: $0.content, username: $0.username,
                          createdAt: $0.createdAt, isCrew: $0.isCrew)
            }
        } catch {
            beaterFeed = []
        }
    }

    // MARK: - Videos

    func loadVideos() async {
        guard let river else { return }
        do {
            var path = "/rivers/\(river.id)/videos"
            if let level = gaugeData?.gageHeightFt {
                path += "?level=\(level)"
            }
            videos = try await api.get(path, responseType: [RiverVideo].self)
        } catch {
            videos = []
        }
    }

    // MARK: - Section-Specific Loading

    private func refreshSectionGauge(riverId: Int, sectionId: Int) async {
        do {
            if let siteId = section?.usgsSiteId {
                gaugeData = try await gauge.fetchUSGSGauge(siteId: siteId)
            } else {
                gaugeData = try await api.get(
                    "/rivers/\(riverId)/sections/\(sectionId)/gauge",
                    responseType: GaugeData.self
                )
            }
        } catch {
            gaugeData = gauge.getCachedGauge(siteId: section?.usgsSiteId ?? "")
        }
    }

    private func loadSectionHazards(riverId: Int, sectionId: Int) async {
        do {
            hazards = try await api.get(
                "/rivers/\(riverId)/sections/\(sectionId)/hazards",
                responseType: [Hazard].self
            )
        } catch {
            hazards = []
        }
    }

    private func loadSectionVideos(riverId: Int, sectionId: Int) async {
        do {
            var path = "/rivers/\(riverId)/sections/\(sectionId)/videos"
            if let level = gaugeData?.gageHeightFt {
                path += "?level=\(level)"
            }
            videos = try await api.get(path, responseType: [RiverVideo].self)
        } catch {
            videos = []
        }
    }
}
