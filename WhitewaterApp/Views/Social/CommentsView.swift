// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

struct CommentsView: View {

    let postId: Int
    @ObservedObject var viewModel: SocialViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var commentText: String = ""
    @State private var comments: [CommentItem] = []
    @State private var isLoading = false
    @State private var isSending = false
    @FocusState private var isInputFocused: Bool

    struct CommentItem: Identifiable {
        let id: Int
        let username: String
        let content: String
        let createdAt: Date
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if isLoading && comments.isEmpty {
                    ProgressView("Loading comments…").frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if comments.isEmpty {
                    ContentUnavailableView(
                        "No Comments",
                        systemImage: "bubble.right",
                        description: Text("Be the first to comment!")
                    )
                    .frame(maxHeight: .infinity)
                } else {
                    List(comments) { comment in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(comment.username).font(.subheadline.bold())
                                Spacer()
                                Text(comment.createdAt.timeAgo)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            Text(comment.content).font(.body)
                        }
                        .padding(.vertical, 4)
                    }
                    .listStyle(.plain)
                }

                // Input bar
                Divider()
                HStack(spacing: 12) {
                    TextField("Add a comment…", text: $commentText, axis: .vertical)
                        .lineLimit(3)
                        .padding(10)
                        .background(.quaternary, in: RoundedRectangle(cornerRadius: 18))
                        .focused($isInputFocused)
                        .submitLabel(.send)
                        .onSubmit { Task { await postComment() } }

                    Button {
                        Task { await postComment() }
                    } label: {
                        Image(systemName: isSending ? "ellipsis.circle" : "paperplane.fill")
                            .font(.title3)
                            .foregroundStyle(commentText.isEmpty ? .secondary : Color.appTeal)
                    }
                    .disabled(commentText.trimmingCharacters(in: .whitespaces).isEmpty || isSending)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(.regularMaterial)
            }
            .navigationTitle("Comments")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
            .task { await loadComments() }
        }
    }

    private func loadComments() async {
        isLoading = true
        defer { isLoading = false }
        struct RawComment: Codable {
            let id: Int
            let username: String
            let content: String
            let createdAt: Date
        }
        let raw = (try? await APIService.shared.get("/posts/\(postId)/comments", responseType: [RawComment].self)) ?? []
        comments = raw.map { CommentItem(id: $0.id, username: $0.username, content: $0.content, createdAt: $0.createdAt) }
    }

    private func postComment() async {
        let content = commentText.trimmingCharacters(in: .whitespaces)
        guard !content.isEmpty else { return }
        isSending = true
        commentText = ""
        defer { isSending = false }

        struct Body: Encodable { let content: String }
        struct RawComment: Codable { let id: Int; let username: String; let content: String; let createdAt: Date }
        if let raw = try? await APIService.shared.post(
            "/posts/\(postId)/comments",
            body: Body(content: content),
            responseType: RawComment.self
        ) {
            comments.append(CommentItem(id: raw.id, username: raw.username, content: raw.content, createdAt: raw.createdAt))
        }
    }
}

// MARK: - Date Extension

private extension Date {
    var timeAgo: String {
        let diff = Date().timeIntervalSince(self)
        switch diff {
        case ..<60:    return "just now"
        case ..<3600:  return "\(Int(diff / 60))m"
        case ..<86400: return "\(Int(diff / 3600))h"
        default:       return self.formatted(date: .abbreviated, time: .omitted)
        }
    }
}
