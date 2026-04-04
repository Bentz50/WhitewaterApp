// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation

// MARK: - Social Post

struct SocialPost: Identifiable {
    let id: Int
    let userId: Int
    let username: String
    let avatarURL: String?
    let content: String
    let type: String
    let createdAt: Date
    var likeCount: Int
    var isLiked: Bool
    let commentCount: Int
}

// MARK: - ViewModel

@MainActor
final class SocialViewModel: ObservableObject {

    // MARK: - Published State

    @Published var feed: [SocialPost] = []
    @Published var crewFeed: [SocialPost] = []
    @Published var messages: [Message] = []
    @Published var conversations: [(userId: Int, username: String, lastMessage: Message?)] = []
    @Published var isLoading: Bool = false

    private let api = APIService.shared

    // MARK: - Feed

    func loadFeed() async {
        isLoading = true
        defer { isLoading = false }
        feed = await loadFeedFromEndpoint("/feed")
    }

    func loadCrewFeed() async {
        isLoading = true
        defer { isLoading = false }
        crewFeed = await loadFeedFromEndpoint("/feed/crew")
    }

    private func loadFeedFromEndpoint(_ endpoint: String) async -> [SocialPost] {
        do {
            let raw = try await api.get(endpoint, responseType: [RawPost].self)
            return raw.map { $0.toSocialPost() }
        } catch {
            return []
        }
    }

    // MARK: - Likes

    func likePost(id: Int) async throws {

        if let idx = feed.firstIndex(where: { $0.id == id }) {
            let post = feed[idx]
            if post.isLiked {
                _ = try await api.delete("/posts/\(id)/like", responseType: Empty.self)
                feed[idx] = SocialPost(
                    id: post.id, userId: post.userId, username: post.username,
                    avatarURL: post.avatarURL, content: post.content, type: post.type,
                    createdAt: post.createdAt, likeCount: post.likeCount - 1,
                    isLiked: false, commentCount: post.commentCount
                )
            } else {
                _ = try await api.post("/posts/\(id)/like", responseType: Empty.self)
                feed[idx] = SocialPost(
                    id: post.id, userId: post.userId, username: post.username,
                    avatarURL: post.avatarURL, content: post.content, type: post.type,
                    createdAt: post.createdAt, likeCount: post.likeCount + 1,
                    isLiked: true, commentCount: post.commentCount
                )
            }
        }
    }

    // MARK: - Messages

    func loadMessages(userId: Int) async -> [Message] {
        do {
            messages = try await api.get("/messages/\(userId)", responseType: [Message].self)
            return messages
        } catch {
            return []
        }
    }

    func sendMessage(to userId: Int, content: String) async throws {
        struct Body: Encodable { let receiverId: Int; let content: String }
        let msg = try await api.post(
            "/messages",
            body: Body(receiverId: userId, content: content),
            responseType: Message.self
        )
        messages.append(msg)
    }

    func loadConversations() async {
        do {
            struct Convo: Codable {
                let userId: Int
                let username: String
                let lastMessage: Message?
            }
            let raw = try await api.get("/messages/conversations", responseType: [Convo].self)
            conversations = raw.map { (userId: $0.userId, username: $0.username, lastMessage: $0.lastMessage) }
        } catch {
            conversations = []
        }
    }
}
