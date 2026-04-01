// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI
import SafariServices

struct YouTubeLinkView: View {

    let title: String
    let url: String
    let waterLevel: String?

    @State private var showSafari = false

    var body: some View {
        Button {
            showSafari = true
        } label: {
            HStack(spacing: 14) {
                // Thumbnail placeholder
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray5))
                    .frame(width: 80, height: 56)
                    .overlay {
                        Image(systemName: "play.rectangle.fill")
                            .font(.title2)
                            .foregroundStyle(.red)
                    }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline.bold())
                        .foregroundStyle(.primary)
                        .lineLimit(2)

                    if let waterLevel {
                        Label("Level: \(waterLevel)", systemImage: "water.waves")
                            .font(.caption)
                            .foregroundStyle(Color.appTeal)
                    }

                    Label("Watch on YouTube", systemImage: "arrow.up.right.square")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
            .padding(12)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showSafari) {
            if let videoURL = URL(string: url) {
                SafariView(url: videoURL)
                    .ignoresSafeArea()
            }
        }
    }
}

// MARK: - SafariView Wrapper

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = false
        return SFSafariViewController(url: url, configuration: config)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

// MARK: - River Video List View

struct RiverVideoListView: View {

    let videos: [RiverVideo]
    let currentLevel: Double?

    private var filteredVideos: [RiverVideo] {
        guard let level = currentLevel else { return videos }
        return videos.filter { video in
            let aboveMin = video.minLevel.map { level >= $0 } ?? true
            let belowMax = video.maxLevel.map { level <= $0 } ?? true
            return aboveMin && belowMax
        }
    }

    private var isFiltered: Bool {
        currentLevel != nil && filteredVideos.count != videos.count
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(isFiltered ? "Videos at Current Level" : "Videos")
                    .font(.headline)
                Spacer()
                Text("\(filteredVideos.count)/\(videos.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if filteredVideos.isEmpty {
                Text("No videos match the current water level.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 8)
            } else {
                ForEach(filteredVideos) { video in
                    YouTubeLinkView(
                        title: video.title,
                        url: video.url,
                        waterLevel: formatLevel(video)
                    )
                }
            }
        }
    }

    private func formatLevel(_ video: RiverVideo) -> String? {
        switch (video.minLevel, video.maxLevel) {
        case let (min?, max?):
            return String(format: "%.1f–%.1f ft", min, max)
        case let (min?, nil):
            return String(format: "%.1f+ ft", min)
        case let (nil, max?):
            return String(format: "≤%.1f ft", max)
        default:
            return nil
        }
    }
}
