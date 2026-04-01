// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

struct ProfileView: View {

    @StateObject var viewModel: ProfileViewModel
    @EnvironmentObject var authService: AuthService
    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            List {
                // Header Section
                Section {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color.appTeal.opacity(0.2))
                            .frame(width: 72, height: 72)
                            .overlay {
                                if let url = viewModel.user?.avatarURL, let imageURL = URL(string: url) {
                                    AsyncImage(url: imageURL) { image in
                                        image.resizable().scaledToFill()
                                    } placeholder: {
                                        Image(systemName: "person.fill")
                                            .font(.largeTitle)
                                            .foregroundStyle(Color.appTeal)
                                    }
                                    .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.largeTitle)
                                        .foregroundStyle(Color.appTeal)
                                }
                            }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.user?.displayName ?? "—")
                                .font(.title2.bold())
                            Text("@\(viewModel.user?.username ?? "—")")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }

                // Stats
                Section("Activity") {
                    HStack {
                        StatCell(value: "—", label: "Runs")
                        Divider()
                        StatCell(value: "—", label: "Miles")
                        Divider()
                        StatCell(value: "\(viewModel.user?.crewCount ?? 0)", label: "Crew")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
                }

                // Boats
                Section("Gear") {
                    NavigationLink {
                        VesselManagementView(viewModel: viewModel)
                    } label: {
                        Label("My Boats", systemImage: "ferry")
                    }

                    NavigationLink {
                        SkillTrackingView(viewModel: viewModel)
                    } label: {
                        Label("Skills", systemImage: "star.fill")
                    }

                    NavigationLink {
                        OfflineMapSettingsView()
                    } label: {
                        Label("Offline Maps", systemImage: "map.fill")
                    }
                }

                // Social
                Section("Community") {
                    NavigationLink {
                        CrewListView(viewModel: viewModel)
                    } label: {
                        Label("Crew", systemImage: "person.2.fill")
                    }

                    NavigationLink {
                        ClubMembershipView(viewModel: viewModel)
                    } label: {
                        Label("Clubs", systemImage: "building.2.fill")
                    }

                    NavigationLink {
                        AchievementsView()
                    } label: {
                        Label("Achievements", systemImage: "trophy.fill")
                    }
                }
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .confirmationDialog("Settings", isPresented: $showSettings) {
                Button("Log Out", role: .destructive) {
                    authService.logout()
                }
                Button("Cancel", role: .cancel) {}
            }
            .task {
                await viewModel.loadProfile()
                await viewModel.loadVessels()
                await viewModel.loadClubs()
            }
            .refreshable {
                await viewModel.loadProfile()
            }
        }
    }
}

private struct StatCell: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value).font(.title2.bold())
            Text(label).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
