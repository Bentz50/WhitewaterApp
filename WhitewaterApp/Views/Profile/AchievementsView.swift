// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

struct AchievementsView: View {

    @StateObject private var viewModel = AchievementsViewModel()

    private let columns = [GridItem(.adaptive(minimum: 100), spacing: 16)]

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.allAchievements.isEmpty {
                ProgressView("Loading achievements…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 24) {
                        ForEach(viewModel.allAchievements) { achievement in
                            AchievementBadgeView(
                                achievement: achievement,
                                isUnlocked: viewModel.isUnlocked(achievement),
                                progress: viewModel.progress(for: achievement)
                            )
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Achievements")
        .task { await viewModel.loadAchievements() }
    }
}
