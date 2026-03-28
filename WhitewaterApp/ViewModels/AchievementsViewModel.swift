// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation

@MainActor
final class AchievementsViewModel: ObservableObject {

    // MARK: - Published State

    @Published var allAchievements: [Achievement] = []
    @Published var userAchievements: [UserAchievement] = []
    @Published var isLoading: Bool = false

    private let api = APIService.shared

    // MARK: - Computed

    var unlockedIds: Set<Int> {
        Set(userAchievements.map(\.achievementId))
    }

    // MARK: - Loading

    func loadAchievements() async {
        isLoading = true
        defer { isLoading = false }
        async let all = api.get("/achievements", responseType: [Achievement].self)
        async let user = api.get("/users/me/achievements", responseType: [UserAchievement].self)
        allAchievements = (try? await all) ?? []
        userAchievements = (try? await user) ?? []
    }

    func checkNewAchievements() async -> [Achievement] {
        let before = unlockedIds
        do {
            userAchievements = try await api.get("/users/me/achievements", responseType: [UserAchievement].self)
        } catch {
            return []
        }
        let newIds = unlockedIds.subtracting(before)
        return allAchievements.filter { newIds.contains($0.id) }
    }

    // MARK: - Helpers

    func isUnlocked(_ achievement: Achievement) -> Bool {
        unlockedIds.contains(achievement.id)
    }

    func progress(for achievement: Achievement) -> Double {
        guard !isUnlocked(achievement) else { return 1.0 }
        guard achievement.thresholdValue > 0 else { return 0.0 }

        // Use the `data` dictionary from a matching UserAchievement if available
        if let ua = userAchievements.first(where: { $0.achievementId == achievement.id }),
           let data = ua.data,
           let current = data[achievement.thresholdType] {
            return min(current / achievement.thresholdValue, 1.0)
        }
        return 0.0
    }
}
