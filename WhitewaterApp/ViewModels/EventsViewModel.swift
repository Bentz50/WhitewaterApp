// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation

@MainActor
final class EventsViewModel: ObservableObject {

    // MARK: - Published State

    @Published var events: [Event] = []
    @Published var selectedEventType: EventType?
    @Published var isLoading: Bool = false
    @Published var searchRadius: Double = 50.0

    private let api = APIService.shared
    private var allEvents: [Event] = []

    // MARK: - Loading

    func loadEvents() async {
        isLoading = true
        defer { isLoading = false }
        do {
            allEvents = try await api.get("/events", responseType: [Event].self)
            applyFilter()
        } catch {
            allEvents = []
            events = []
        }
    }

    func loadNearbyEvents(lat: Double, lng: Double) async {
        isLoading = true
        defer { isLoading = false }
        do {
            allEvents = try await api.get(
                "/events/nearby?lat=\(lat)&lng=\(lng)&radius=\(searchRadius)",
                responseType: [Event].self
            )
            applyFilter()
        } catch {
            allEvents = []
            events = []
        }
    }

    // MARK: - Filter

    func filterByType(_ type: EventType?) {
        selectedEventType = type
        applyFilter()
    }

    private func applyFilter() {
        if let type = selectedEventType {
            events = allEvents.filter { $0.type == type }
        } else {
            events = allEvents
        }
    }
}
