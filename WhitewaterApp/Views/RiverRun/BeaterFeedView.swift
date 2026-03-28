// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

struct BeaterFeedView: View {

    @ObservedObject var viewModel: RiverRunViewModel

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.beaterFeed.isEmpty {
                    ContentUnavailableView(
                        "No Posts Yet",
                        systemImage: "bubble.left",
                        description: Text("Be the first to report conditions on this section.")
                    )
                } else {
                    List(viewModel.beaterFeed) { post in
                        BeaterPostRow(post: post)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Beater Feed")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task { await viewModel.loadBeaterFeed() }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .task { await viewModel.loadBeaterFeed() }
        }
    }
}

// MARK: - Post Row

private struct BeaterPostRow: View {
    let post: RiverPost

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(Color.appTeal.opacity(0.2))
                    .frame(width: 32, height: 32)
                    .overlay {
                        Text(String(post.username.prefix(1)).uppercased())
                            .font(.caption.bold())
                            .foregroundStyle(Color.appTeal)
                    }
                VStack(alignment: .leading, spacing: 1) {
                    Text(post.username).font(.subheadline.bold())
                    Text(post.createdAt.timeAgoString)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            Text(post.content)
                .font(.subheadline)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Time Ago Helper

private extension Date {
    var timeAgoString: String {
        let diff = Date().timeIntervalSince(self)
        switch diff {
        case ..<60:       return "just now"
        case ..<3600:     return "\(Int(diff / 60))m ago"
        case ..<86400:    return "\(Int(diff / 3600))h ago"
        default:          return "\(Int(diff / 86400))d ago"
        }
    }
}
