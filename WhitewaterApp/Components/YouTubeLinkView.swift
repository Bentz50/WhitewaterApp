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
