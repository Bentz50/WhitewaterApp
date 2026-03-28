// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation
import Network

final class OfflineManager: ObservableObject {

    static let shared = OfflineManager()

    @Published private(set) var isOnline = true

    // MARK: - Pending request model

    struct PendingRequest: Codable {
        let endpoint: String
        let method: String
        let body: Data?
    }

    private let pendingKey   = "offlineManager.pendingRequests"
    private let monitor      = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "com.bentztech.offline.monitor")

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            let online = path.status == .satisfied
            DispatchQueue.main.async {
                guard let self else { return }
                let wasOffline = !self.isOnline
                self.isOnline = online
                if wasOffline && online {
                    Task { await self.syncPendingRequests() }
                }
            }
        }
        monitor.start(queue: monitorQueue)
    }

    // MARK: - Queue management

    var pendingRequests: [(endpoint: String, method: String, body: Data?)] {
        loadPending().map { ($0.endpoint, $0.method, $0.body) }
    }

    func queueRequest(endpoint: String, method: String, body: Data?) {
        var list = loadPending()
        list.append(PendingRequest(endpoint: endpoint, method: method, body: body))
        savePending(list)
    }

    // MARK: - Sync

    func syncPendingRequests() async {
        var remaining: [PendingRequest] = []

        for request in loadPending() {
            guard let url = URL(string: APIConfig.baseURL + request.endpoint) else { continue }

            var urlRequest        = URLRequest(url: url)
            urlRequest.httpMethod = request.method
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            if let token = APIService.shared.authToken {
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            urlRequest.httpBody = request.body

            do {
                let (_, response) = try await URLSession.shared.data(for: urlRequest)
                if let http = response as? HTTPURLResponse, http.statusCode >= 400 {
                    remaining.append(request)  // server-side error — keep for retry
                }
            } catch {
                remaining.append(request)      // network error — keep for retry
            }
        }

        await MainActor.run { savePending(remaining) }
    }

    // MARK: - Generic cache

    func cacheData<T: Codable>(_ data: T, key: String) {
        guard let encoded = try? encoder.encode(data) else { return }
        UserDefaults.standard.set(encoded, forKey: "cache_\(key)")
    }

    func getCachedData<T: Codable>(key: String, type: T.Type) -> T? {
        guard let data = UserDefaults.standard.data(forKey: "cache_\(key)") else { return nil }
        return try? decoder.decode(T.self, from: data)
    }

    // MARK: - Persistence helpers

    private func loadPending() -> [PendingRequest] {
        guard
            let data = UserDefaults.standard.data(forKey: pendingKey),
            let list = try? decoder.decode([PendingRequest].self, from: data)
        else { return [] }
        return list
    }

    private func savePending(_ list: [PendingRequest]) {
        guard let data = try? encoder.encode(list) else { return }
        UserDefaults.standard.set(data, forKey: pendingKey)
    }
}
