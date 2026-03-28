// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation

// MARK: - Feed Post

struct RiverPost: Identifiable {
    let id: Int
    let content: String
    let username: String
    let createdAt: Date
}

// MARK: - ViewModel

@MainActor
final class RiverRunViewModel: ObservableObject {

    // MARK: - Published State

    @Published var river: River?
    @Published var gaugeData: GaugeData?
    @Published var hazards: [Hazard] = []
    @Published var beaterFeed: [RiverPost] = []
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
        } catch {
            // Non-fatal: river may already be set from navigation context
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

    func loadBeaterFeed() async {
        guard let river else { return }
        do {
            struct FeedPost: Codable {
                let id: Int
                let content: String
                let username: String
                let createdAt: Date
            }
            let raw = try await api.get("/rivers/\(river.id)/feed", responseType: [FeedPost].self)
            beaterFeed = raw.map { RiverPost(id: $0.id, content: $0.content, username: $0.username, createdAt: $0.createdAt) }
        } catch {
            beaterFeed = []
        }
    }
}
