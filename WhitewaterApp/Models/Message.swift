// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation

struct Message: Codable, Identifiable {
    let id: Int
    let senderId: Int
    let receiverId: Int
    let content: String
    let readAt: Date?
    let createdAt: Date

    var isRead: Bool { readAt != nil }
}
