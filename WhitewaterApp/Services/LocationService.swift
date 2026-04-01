// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation
import CoreLocation

final class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {

    static let shared = LocationService()

    @Published private(set) var currentLocation: CLLocation?
    @Published private(set) var isTracking     = false
    @Published private(set) var trackPoints: [CLLocation] = []
    @Published private(set) var distanceMiles  = 0.0
    @Published private(set) var elapsedSeconds = 0
    @Published private(set) var currentSpeedMph = 0.0
    @Published private(set) var caloriesBurned = 0

    private let manager = CLLocationManager()
    private var trackingTimer: Timer?
    private var activeVesselType: VesselType = .kayak

    private override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter  = 10                     // metres between updates
        manager.activityType    = .fitness
        manager.allowsBackgroundLocationUpdates  = true
        manager.pausesLocationUpdatesAutomatically = false
    }

    // MARK: - Public Interface

    func requestAlwaysAuthorization() {
        manager.requestAlwaysAuthorization()
    }

    func startTracking(vesselType: VesselType) {
        activeVesselType = vesselType
        trackPoints   = []
        distanceMiles = 0
        elapsedSeconds = 0
        caloriesBurned = 0
        currentSpeedMph = 0
        isTracking = true

        manager.startUpdatingLocation()

        trackingTimer = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            DispatchQueue.main.async {
                self.elapsedSeconds += 1
                self.recalculateCalories()
            }
        }
        RunLoop.main.add(trackingTimer!, forMode: .common)
    }

    /// Stops tracking and returns the collected track, total distance, and elapsed seconds.
    @discardableResult
    func stopTracking() -> ([CLLocation], Double, Int) {
        isTracking = false
        manager.stopUpdatingLocation()
        trackingTimer?.invalidate()
        trackingTimer = nil
        return (trackPoints, distanceMiles, elapsedSeconds)
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            self.currentLocation = location

            if location.speed >= 0 {
                self.currentSpeedMph = location.speed * 2.23694  // m/s → mph
            }

            guard self.isTracking else { return }

            if let lastPoint = self.trackPoints.last {
                let metres = location.distance(from: lastPoint)
                self.distanceMiles += metres / 1_609.344
            }
            self.trackPoints.append(location)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Errors are non-fatal; callers observe `currentLocation`.
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            if isTracking { manager.startUpdatingLocation() }
        default:
            break
        }
    }

    // MARK: - Calorie Estimation

    /// Adaptive calorie calculation using GPS-derived speed to estimate variable intensity.
    /// Base MET values per vessel type are scaled by current speed relative to typical cruising speed.
    private func recalculateCalories() {
        let baseMET: Double
        let cruiseSpeedMph: Double

        switch activeVesselType {
        case .kayak: baseMET = 5.0; cruiseSpeedMph = 3.5
        case .canoe: baseMET = 4.0; cruiseSpeedMph = 3.0
        case .raft:  baseMET = 3.5; cruiseSpeedMph = 2.5
        }

        let effectiveMET: Double
        if currentSpeedMph < 0.5 {
            effectiveMET = 1.5  // resting/eddied out
        } else {
            let speedRatio = currentSpeedMph / cruiseSpeedMph
            let intensityFactor = min(max(speedRatio, 0.7), 2.0)
            effectiveMET = baseMET * intensityFactor
        }

        // Increment calories for this tick (1 second)
        let hourFraction = 1.0 / 3_600.0
        caloriesBurned += Int(effectiveMET * 70.0 * hourFraction)
    }
}
