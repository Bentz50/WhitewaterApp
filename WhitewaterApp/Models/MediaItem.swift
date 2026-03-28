// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation

enum MediaType: String, Codable {
    case photo
    case video
}

enum MediaPrivacy: String, Codable {
    case `public`  = "public"
    case crew      = "crew"
    case `private` = "private"
}

struct MediaItem: Codable, Identifiable {
    let id: Int
    let runLogId: Int
    let userId: Int
    let fileURL: String
    let fileType: MediaType
    let privacy: MediaPrivacy
    let tags: [String]
    let createdAt: Date
}
