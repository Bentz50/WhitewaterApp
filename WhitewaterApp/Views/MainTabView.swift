// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

struct MainTabView: View {

    @StateObject private var discoveryVM = DiscoveryViewModel()
    @StateObject private var socialVM    = SocialViewModel()
    @StateObject private var profileVM   = ProfileViewModel()
    @StateObject private var eventsVM    = EventsViewModel()

    var body: some View {
        TabView {
            // TODO: Replace with a dedicated ActiveRunSelectionView or run-start flow
            DiscoveryMapView(viewModel: discoveryVM)
                .tabItem {
                    Label("Run", systemImage: "figure.water.fitness")
                }

            DiscoveryMapView(viewModel: discoveryVM)
                .tabItem {
                    Label("Discover", systemImage: "map.fill")
                }

            // TODO: Replace with a dedicated RunHistoryView / run log list
            CommunityFeedView(viewModel: socialVM)
                .tabItem {
                    Label("Log", systemImage: "list.bullet.clipboard")
                }

            CommunityFeedView(viewModel: socialVM)
                .tabItem {
                    Label("Social", systemImage: "person.2.fill")
                }

            ProfileView(viewModel: profileVM)
                .tabItem {
                    Label("Profile", systemImage: "person.circle.fill")
                }
        }
        .tint(Color.appTeal)
    }
}
