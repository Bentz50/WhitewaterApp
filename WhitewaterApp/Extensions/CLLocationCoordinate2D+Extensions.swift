// Copyright © 2026 BentzTech LLC. All rights reserved.

import CoreLocation
import MapKit

// MARK: - CLLocationCoordinate2D + Equatable

extension CLLocationCoordinate2D: @retroactive Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }

    /// Wraps the coordinate in a CLLocation for distance calculations.
    var asCLLocation: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }

    /// Returns the distance in meters between this coordinate and another.
    func distance(to other: CLLocationCoordinate2D) -> CLLocationDistance {
        asCLLocation.distance(from: other.asCLLocation)
    }
}

// MARK: - MKCoordinateRegion helpers

extension MKCoordinateRegion {

    /// Creates a region centred on `center` spanning `radiusMiles` in each direction.
    init(center: CLLocationCoordinate2D, radiusMiles: Double) {
        let metersPerMile: Double = 1_609.344
        let radiusMeters = radiusMiles * metersPerMile
        self.init(
            center: center,
            latitudinalMeters: radiusMeters * 2,
            longitudinalMeters: radiusMeters * 2
        )
    }

    /// A default region centred on the contiguous United States.
    static var usaDefault: MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 39.5, longitude: -98.35),
            span: MKCoordinateSpan(latitudeDelta: 40.0, longitudeDelta: 60.0)
        )
    }
}
