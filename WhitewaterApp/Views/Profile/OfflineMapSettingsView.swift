// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

struct OfflineMapSettingsView: View {

    @StateObject private var mapManager = OfflineMapManager.shared
    @State private var showClearConfirmation = false

    var body: some View {
        List {
            Section {
                HStack {
                    Label("Cache Size", systemImage: "internaldrive")
                    Spacer()
                    Text(String(format: "%.1f MB", mapManager.cacheSizeMB))
                        .foregroundStyle(.secondary)
                }

                Button(role: .destructive) {
                    showClearConfirmation = true
                } label: {
                    Label("Clear Cache", systemImage: "trash")
                }
                .disabled(mapManager.cacheSizeMB == 0)
                .confirmationDialog(
                    "Clear all cached map tiles?",
                    isPresented: $showClearConfirmation,
                    titleVisibility: .visible
                ) {
                    Button("Clear Cache", role: .destructive) {
                        Task { await mapManager.clearCache() }
                    }
                    Button("Cancel", role: .cancel) {}
                }
            } header: {
                Text("Storage")
            }

            Section {
                Text("Map tiles are automatically cached as you browse rivers on the map. Cached tiles are available offline so you can navigate even without cell service.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } header: {
                Text("About Offline Maps")
            }

            if mapManager.isCaching {
                Section {
                    HStack {
                        ProgressView()
                            .padding(.trailing, 8)
                        Text("Downloading tiles…")
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Offline Maps")
        .task {
            await mapManager.refreshCacheSize()
        }
    }
}
