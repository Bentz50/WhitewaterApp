// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

struct CommunityFeedView: View {

    @StateObject var viewModel: SocialViewModel
    @State private var selectedTab: FeedTab = .all
    @State private var showComments: SocialPost?
    @State private var showDM: (userId: Int, username: String)?

    enum FeedTab: String, CaseIterable {
        case all = "All"
        case crew = "Crew"
    }

    private var displayedFeed: [SocialPost] {
        selectedTab == .all ? viewModel.feed : viewModel.crewFeed
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Tab switcher
                Picker("Feed", selection: $selectedTab) {
                    ForEach(FeedTab.allCases, id: \.self) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.vertical, 8)

                if viewModel.isLoading && displayedFeed.isEmpty {
                    ProgressView("Loading feed…").frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if displayedFeed.isEmpty {
                    ContentUnavailableView(
                        "Nothing Yet",
                        systemImage: "bubble.left.and.bubble.right",
                        description: Text("Posts from your crew will appear here.")
                    )
                    .frame(maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(displayedFeed) { post in
                                PostCard(post: post) {
                                    Task { try? await viewModel.likePost(id: post.id) }
                                } onComment: {
                                    showComments = post
                                } onDM: {
                                    showDM = (post.userId, post.username)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    }
                    .refreshable {
                        await selectedTab == .all ? viewModel.loadFeed() : viewModel.loadCrewFeed()
                    }
                }
            }
            .navigationTitle("Community")
            .sheet(item: $showComments) { post in
                CommentsView(postId: post.id, viewModel: viewModel)
                    .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: .init(get: { showDM != nil }, set: { if !$0 { showDM = nil } })) {
                if let dm = showDM {
                    DirectMessageView(userId: dm.userId, username: dm.username, viewModel: viewModel)
                }
            }
            .task {
                async let f: () = viewModel.loadFeed()
                async let c: () = viewModel.loadCrewFeed()
                _ = await (f, c)
            }
        }
    }
}

// MARK: - Post Card

private struct PostCard: View {
    let post: SocialPost
    let onLike: () -> Void
    let onComment: () -> Void
    let onDM: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack(spacing: 10) {
                Circle()
                    .fill(Color.appTeal.opacity(0.2))
                    .frame(width: 40, height: 40)
                    .overlay {
                        if let urlString = post.avatarURL, let url = URL(string: urlString) {
                            AsyncImage(url: url) { img in img.resizable().scaledToFill() }
                                placeholder: { Image(systemName: "person.fill").foregroundStyle(Color.appTeal) }
                            .clipShape(Circle())
                        } else {
                            Text(String(post.username.prefix(1)).uppercased())
                                .font(.subheadline.bold())
                                .foregroundStyle(Color.appTeal)
                        }
                    }

                VStack(alignment: .leading, spacing: 2) {
                    Text(post.username).font(.subheadline.bold())
                    Text(post.createdAt.timeAgo)
                        .font(.caption2).foregroundStyle(.secondary)
                }
                Spacer()
                Button(action: onDM) {
                    Image(systemName: "paperplane").foregroundStyle(Color.appTeal)
                }
            }

            // Content
            Text(post.content).font(.body)

            // River tag
            Label(post.type, systemImage: "water.waves")
                .font(.caption)
                .foregroundStyle(Color.appTeal)

            // Actions
            HStack(spacing: 20) {
                Button(action: onLike) {
                    Label("\(post.likeCount)", systemImage: post.isLiked ? "heart.fill" : "heart")
                        .foregroundStyle(post.isLiked ? .red : .secondary)
                }
                Button(action: onComment) {
                    Label("\(post.commentCount)", systemImage: "bubble.right")
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            .font(.subheadline)
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Date Extension

private extension Date {
    var timeAgo: String {
        let diff = Date().timeIntervalSince(self)
        switch diff {
        case ..<60:    return "just now"
        case ..<3600:  return "\(Int(diff / 60))m ago"
        case ..<86400: return "\(Int(diff / 3600))h ago"
        default:       return "\(Int(diff / 86400))d ago"
        }
    }
}
