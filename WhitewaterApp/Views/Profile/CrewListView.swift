// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

struct CrewListView: View {

    @ObservedObject var viewModel: ProfileViewModel
    @State private var searchText: String = ""
    @State private var searchResults: [User] = []
    @State private var isSearching = false
    @State private var errorMessage: String?

    private let api = APIService.shared

    var body: some View {
        List {
            // Search section
            Section("Find Paddlers") {
                HStack {
                    Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                    TextField("Search username or name", text: $searchText)
                        .autocapitalization(.none)
                        .submitLabel(.search)
                        .onSubmit { Task { await searchUsers() } }
                    if isSearching {
                        ProgressView().progressViewStyle(.circular)
                    }
                }
                ForEach(searchResults) { user in
                    if !viewModel.crew.contains(where: { $0.id == user.id }) {
                        HStack {
                            AvatarView(url: user.avatarURL, size: 40)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(user.displayName).font(.headline)
                                Text("@\(user.username)").font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Button("Add") {
                                Task {
                                    do {
                                        try await viewModel.addCrewMember(userId: user.id)
                                        searchResults.removeAll { $0.id == user.id }
                                    } catch {
                                        errorMessage = error.localizedDescription
                                    }
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(Color.appTeal)
                            .font(.caption)
                        }
                    }
                }
            }

            // Current crew
            Section("My Crew (\(viewModel.crew.count))") {
                ForEach(viewModel.crew) { member in
                    HStack {
                        AvatarView(url: member.avatarURL, size: 40)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(member.displayName).font(.headline)
                            Text("@\(member.username)").font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                }
                .onDelete { indexSet in
                    for idx in indexSet {
                        let id = viewModel.crew[idx].id
                        Task {
                            do { try await viewModel.removeCrewMember(userId: id) }
                            catch { errorMessage = error.localizedDescription }
                        }
                    }
                }
            }
        }
        .navigationTitle("Crew")
        .alert("Error", isPresented: .init(get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "")
        }
        .task { await viewModel.loadCrew() }
    }

    private func searchUsers() async {
        guard !searchText.isEmpty else { searchResults = []; return }
        isSearching = true
        defer { isSearching = false }
        let q = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? searchText
        searchResults = (try? await api.get("/users/search?q=\(q)", responseType: [User].self)) ?? []
    }
}

// MARK: - Avatar helper

private struct AvatarView: View {
    let url: String?
    let size: CGFloat

    var body: some View {
        Circle()
            .fill(Color.appTeal.opacity(0.15))
            .frame(width: size, height: size)
            .overlay {
                if let urlString = url, let imageURL = URL(string: urlString) {
                    AsyncImage(url: imageURL) { img in
                        img.resizable().scaledToFill()
                    } placeholder: {
                        Image(systemName: "person.fill").foregroundStyle(Color.appTeal)
                    }
                    .clipShape(Circle())
                } else {
                    Image(systemName: "person.fill").foregroundStyle(Color.appTeal)
                }
            }
    }
}
