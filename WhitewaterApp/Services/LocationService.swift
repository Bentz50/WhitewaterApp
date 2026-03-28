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

    /// Uses MET (metabolic equivalent) values per vessel type against a standard 70 kg body weight.
    private func recalculateCalories() {
        let met: Double
        switch activeVesselType {
        case .kayak: met = 5.0
        case .canoe: met = 4.0
        case .raft:  met = 3.5
        }
        let hours = Double(elapsedSeconds) / 3_600
        caloriesBurned = Int(met * 70.0 * hours)
    }
}
