// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

struct DirectMessageView: View {

    let userId: Int
    let username: String
    @ObservedObject var viewModel: SocialViewModel

    @State private var messageText: String = ""
    @State private var isSending = false
    @FocusState private var isInputFocused: Bool

    private var currentUserId: Int {
        AuthService.shared.currentUser?.id ?? -1
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(viewModel.messages) { message in
                                MessageBubble(message: message, isSent: message.senderId == currentUserId)
                                    .id(message.id)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: viewModel.messages.count) { _, _ in
                        if let last = viewModel.messages.last {
                            withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                        }
                    }
                }

                // Input bar
                Divider()
                HStack(spacing: 12) {
                    TextField("Message…", text: $messageText, axis: .vertical)
                        .lineLimit(4)
                        .padding(10)
                        .background(.quaternary, in: RoundedRectangle(cornerRadius: 20))
                        .focused($isInputFocused)
                        .submitLabel(.send)
                        .onSubmit { Task { await sendMessage() } }

                    Button {
                        Task { await sendMessage() }
                    } label: {
                        Image(systemName: isSending ? "ellipsis.circle.fill" : "paperplane.circle.fill")
                            .font(.title2)
                            .foregroundStyle(messageText.isEmpty ? .secondary : Color.appTeal)
                    }
                    .disabled(messageText.trimmingCharacters(in: .whitespaces).isEmpty || isSending)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(.regularMaterial)
            }
            .navigationTitle(username)
            .navigationBarTitleDisplayMode(.inline)
            .task {
                _ = await viewModel.loadMessages(userId: userId)
            }
        }
    }

    private func sendMessage() async {
        let content = messageText.trimmingCharacters(in: .whitespaces)
        guard !content.isEmpty else { return }
        isSending = true
        messageText = ""
        do {
            try await viewModel.sendMessage(to: userId, content: content)
        } catch {
            messageText = content  // Restore on failure
        }
        isSending = false
    }
}

// MARK: - Message Bubble

private struct MessageBubble: View {
    let message: Message
    let isSent: Bool

    var body: some View {
        HStack {
            if isSent { Spacer(minLength: 60) }

            VStack(alignment: isSent ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(isSent ? Color.appTeal : Color(.systemGray5),
                                in: RoundedRectangle(cornerRadius: 18))
                    .foregroundStyle(isSent ? .white : .primary)

                Text(message.createdAt.formatted(date: .omitted, time: .shortened))
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .padding(.horizontal, 4)
            }

            if !isSent { Spacer(minLength: 60) }
        }
    }
}
