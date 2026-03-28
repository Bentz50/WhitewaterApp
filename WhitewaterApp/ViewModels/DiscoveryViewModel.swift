// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation
import MapKit

@MainActor
final class DiscoveryViewModel: ObservableObject {

    // MARK: - Published State

    @Published var rivers: [River] = []
    @Published var searchRadius: Double = 50.0
    @Published var selectedRatings: [AWRating] = []
    @Published var showRunnableOnly: Bool = false
    @Published var searchQuery: String = ""
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -95.7129),
        span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20)
    )
    @Published var selectedRiver: River?
    @Published var feelingLuckyRiver: River?
    @Published var isLoading: Bool = false

    private let api = APIService.shared
    private let location = LocationService.shared

    // MARK: - Search

    func searchRivers() async {
        isLoading = true
        defer { isLoading = false }
        do {
            var endpoint = "/rivers?limit=50"
            if !searchQuery.isEmpty {
                let encoded = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? searchQuery
                endpoint += "&q=\(encoded)"
            }
            if showRunnableOnly {
                endpoint += "&runnable=true"
            }
            if !selectedRatings.isEmpty {
                let ratings = selectedRatings.map(\.rawValue).joined(separator: ",")
                let encoded = ratings.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ratings
                endpoint += "&rating=\(encoded)"
            }
            rivers = try await api.get(endpoint, responseType: [River].self)
        } catch {
            rivers = []
        }
    }

    func feelingLucky() async {
        isLoading = true
        defer { isLoading = false }
        do {
            var endpoint = "/rivers/lucky?"
            if let loc = location.currentLocation {
                endpoint += "lat=\(loc.coordinate.latitude)&lng=\(loc.coordinate.longitude)&radius=\(searchRadius)"
            }
            feelingLuckyRiver = try await api.get(endpoint, responseType: River.self)
        } catch {
            // Fall back to a random river from the current list
            feelingLuckyRiver = rivers.randomElement()
        }
    }

    func loadNearbyRivers(lat: Double, lng: Double) async {
        isLoading = true
        defer { isLoading = false }
        do {
            rivers = try await api.get(
                "/rivers/nearby?lat=\(lat)&lng=\(lng)&radius=\(searchRadius)",
                responseType: [River].self
            )
            mapRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: lat, longitude: lng),
                latitudinalMeters: searchRadius * 1_609.34,
                longitudinalMeters: searchRadius * 1_609.34
            )
        } catch {
            rivers = []
        }
    }

    func selectRiver(_ river: River) {
        selectedRiver = river
        mapRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: river.lat, longitude: river.lng),
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )
    }
}
