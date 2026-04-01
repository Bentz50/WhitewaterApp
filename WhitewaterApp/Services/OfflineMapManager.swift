// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation
import MapKit

@MainActor
final class OfflineMapManager: ObservableObject {

    static let shared = OfflineMapManager()

    @Published private(set) var isCaching = false
    @Published private(set) var cacheSizeMB: Double = 0.0

    private let cacheDirectory: URL
    private let tileURLTemplate = "https://tile.openstreetmap.org/{z}/{x}/{y}.png"

    private init() {
        let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheDirectory = caches.appendingPathComponent("MapTiles", isDirectory: true)
        try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        Task { await refreshCacheSize() }
    }

    // MARK: - Preload

    /// Downloads tiles for a circular region at zoom levels 10-15.
    func preloadTiles(latitude: Double, longitude: Double, radiusMiles: Double = 5.0) async {
        guard !isCaching else { return }
        isCaching = true
        defer { isCaching = false }

        let radiusDegrees = radiusMiles / 69.0

        for zoom in 10...15 {
            let n = Double(1 << zoom)

            let minLat = latitude - radiusDegrees
            let maxLat = latitude + radiusDegrees
            let minLng = longitude - radiusDegrees
            let maxLng = longitude + radiusDegrees

            let xMin = Int(floor((minLng + 180.0) / 360.0 * n))
            let xMax = Int(floor((maxLng + 180.0) / 360.0 * n))
            let yMin = Int(floor((1.0 - log(tan(maxLat * .pi / 180.0) + 1.0 / cos(maxLat * .pi / 180.0)) / .pi) / 2.0 * n))
            let yMax = Int(floor((1.0 - log(tan(minLat * .pi / 180.0) + 1.0 / cos(minLat * .pi / 180.0)) / .pi) / 2.0 * n))

            for x in max(xMin, 0)...min(xMax, Int(n) - 1) {
                for y in max(yMin, 0)...min(yMax, Int(n) - 1) {
                    let path = MKTileOverlayPath(x: x, y: y, z: zoom, contentScaleFactor: 1.0)
                    if getCachedTile(path: path) != nil { continue }
                    await downloadAndCacheTile(path: path)
                }
            }
        }

        await refreshCacheSize()
    }

    // MARK: - Cache Access

    func getCachedTile(path: MKTileOverlayPath) -> Data? {
        let fileURL = tileFileURL(for: path)
        return try? Data(contentsOf: fileURL)
    }

    func cacheTile(data: Data, path: MKTileOverlayPath) {
        let fileURL = tileFileURL(for: path)
        let dir = fileURL.deletingLastPathComponent()
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        try? data.write(to: fileURL, options: .atomic)
    }

    // MARK: - Cache Management

    func clearCache() async {
        try? FileManager.default.removeItem(at: cacheDirectory)
        try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        cacheSizeMB = 0.0
    }

    func refreshCacheSize() async {
        let fm = FileManager.default
        guard let enumerator = fm.enumerator(at: cacheDirectory, includingPropertiesForKeys: [.fileSizeKey]) else {
            cacheSizeMB = 0.0
            return
        }
        var totalBytes: Int64 = 0
        for case let fileURL as URL in enumerator {
            if let values = try? fileURL.resourceValues(forKeys: [.fileSizeKey]),
               let size = values.fileSize {
                totalBytes += Int64(size)
            }
        }
        cacheSizeMB = Double(totalBytes) / (1024.0 * 1024.0)
    }

    // MARK: - Private Helpers

    private func tileFileURL(for path: MKTileOverlayPath) -> URL {
        cacheDirectory
            .appendingPathComponent("\(path.z)", isDirectory: true)
            .appendingPathComponent("\(path.x)", isDirectory: true)
            .appendingPathComponent("\(path.y).png")
    }

    private func downloadAndCacheTile(path: MKTileOverlayPath) async {
        let urlString = tileURLTemplate
            .replacingOccurrences(of: "{z}", with: "\(path.z)")
            .replacingOccurrences(of: "{x}", with: "\(path.x)")
            .replacingOccurrences(of: "{y}", with: "\(path.y)")

        guard let url = URL(string: urlString) else { return }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            if let http = response as? HTTPURLResponse, http.statusCode == 200 {
                cacheTile(data: data, path: path)
            }
        } catch {
            // Network errors are non-fatal during preload
        }
    }
}

// MARK: - Cached Tile Overlay

class CachedTileOverlay: MKTileOverlay {

    override func loadTile(at path: MKTileOverlayPath,
                           result: @escaping (Data?, Error?) -> Void) {
        // Check disk cache first
        if let cached = OfflineMapManager.shared.getCachedTile(path: path) {
            result(cached, nil)
            return
        }
        // Otherwise fetch from network and cache the result
        super.loadTile(at: path) { data, error in
            if let data {
                OfflineMapManager.shared.cacheTile(data: data, path: path)
            }
            result(data, error)
        }
    }
}
