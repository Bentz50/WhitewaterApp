// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

struct ClubMembershipView: View {

    @ObservedObject var viewModel: ProfileViewModel
    @State private var showAddSheet = false
    @State private var newClubName: String = ""
    @State private var errorMessage: String?

    var body: some View {
        List {
            if viewModel.clubs.isEmpty {
                Section {
                    VStack(spacing: 12) {
                        Image(systemName: "building.2.fill")
                            .font(.largeTitle)
                            .foregroundStyle(Color.appTeal.opacity(0.5))
                        Text("No Club Memberships")
                            .font(.headline)
                        Text("Join a paddling club to connect with your local community.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                }
            } else {
                Section("My Clubs (\(viewModel.clubs.count))") {
                    ForEach(viewModel.clubs) { club in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 6) {
                                    Text(club.clubName)
                                        .font(.headline)
                                    if club.verified {
                                        Image(systemName: "checkmark.seal.fill")
                                            .foregroundStyle(Color.appTeal)
                                            .font(.subheadline)
                                    }
                                }
                                if let joined = club.joinedAt {
                                    Text("Joined \(joined, format: .dateTime.month().year())")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            Spacer()
                        }
                    }
                    .onDelete { indexSet in
                        for idx in indexSet {
                            let id = viewModel.clubs[idx].id
                            Task {
                                do { try await viewModel.removeClub(id: id) }
                                catch { errorMessage = error.localizedDescription }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Clubs")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAddSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddSheet) {
            addClubSheet
        }
        .alert("Error", isPresented: .init(get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "")
        }
        .task { await viewModel.loadClubs() }
    }

    // MARK: - Add Club Sheet

    private var addClubSheet: some View {
        NavigationStack {
            Form {
                Section("Club Name") {
                    TextField("e.g. River Runners Club", text: $newClubName)
                        .autocapitalization(.words)
                }
            }
            .navigationTitle("Add Club")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        newClubName = ""
                        showAddSheet = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        Task {
                            do {
                                try await viewModel.addClub(name: newClubName)
                                newClubName = ""
                                showAddSheet = false
                            } catch {
                                errorMessage = error.localizedDescription
                            }
                        }
                    }
                    .disabled(newClubName.trimmingCharacters(in: .whitespaces).isEmpty)
                    .tint(Color.appTeal)
                }
            }
        }
        .presentationDetents([.medium])
    }
}
