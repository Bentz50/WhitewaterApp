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
        do {
            struct RawPost: Codable {
                let id: Int
                let userId: Int
                let username: String
                let avatarUrl: String?
                let content: String
                let type: String
                let createdAt: Date
                let likeCount: Int
                let isLiked: Bool
                let commentCount: Int
            }
            let raw = try await api.get("/feed", responseType: [RawPost].self)
            feed = raw.map {
                SocialPost(
                    id: $0.id,
                    userId: $0.userId,
                    username: $0.username,
                    avatarURL: $0.avatarUrl,
                    content: $0.content,
                    type: $0.type,
                    createdAt: $0.createdAt,
                    likeCount: $0.likeCount,
                    isLiked: $0.isLiked,
                    commentCount: $0.commentCount
                )
            }
        } catch {
            feed = []
        }
    }

    func loadCrewFeed() async {
        isLoading = true
        defer { isLoading = false }
        do {
            struct RawPost: Codable {
                let id: Int
                let userId: Int
                let username: String
                let avatarUrl: String?
                let content: String
                let type: String
                let createdAt: Date
                let likeCount: Int
                let isLiked: Bool
                let commentCount: Int
            }
            let raw = try await api.get("/feed/crew", responseType: [RawPost].self)
            crewFeed = raw.map {
                SocialPost(
                    id: $0.id,
                    userId: $0.userId,
                    username: $0.username,
                    avatarURL: $0.avatarUrl,
                    content: $0.content,
                    type: $0.type,
                    createdAt: $0.createdAt,
                    likeCount: $0.likeCount,
                    isLiked: $0.isLiked,
                    commentCount: $0.commentCount
                )
            }
        } catch {
            crewFeed = []
        }
    }

    // MARK: - Likes

    func likePost(id: Int) async throws {
        struct Empty: Codable {}

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
