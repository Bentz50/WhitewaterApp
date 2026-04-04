// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation

/// Shared Codable post structure used by feed endpoints.
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

    func toSocialPost() -> SocialPost {
        SocialPost(
            id: id,
            userId: userId,
            username: username,
            avatarURL: avatarUrl,
            content: content,
            type: type,
            createdAt: createdAt,
            likeCount: likeCount,
            isLiked: isLiked,
            commentCount: commentCount
        )
    }
}
