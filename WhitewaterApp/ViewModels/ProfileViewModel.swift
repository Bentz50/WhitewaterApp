// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {

    // MARK: - Published State

    @Published var user: User?
    @Published var vessels: [Vessel] = []
    @Published var skills: [Skill] = []
    @Published var defaultSkills: [Int] = []
    @Published var achievements: [UserAchievement] = []
    @Published var crew: [User] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let api = APIService.shared

    // MARK: - Profile

    func loadProfile() async {
        isLoading = true
        defer { isLoading = false }
        do {
            user = try await api.get("/users/me", responseType: User.self)
            defaultSkills = (try? await api.get("/users/me/default-skills", responseType: [Int].self)) ?? []
            await loadSkills()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func updateProfile(
        displayName: String,
        preferredDifficulty: [String],
        waterExperiences: [String],
        interests: [String]
    ) async throws {
        struct Body: Encodable {
            let displayName: String
            let preferredDifficulty: [String]
            let waterExperiences: [String]
            let interests: [String]
        }
        user = try await api.put(
            "/users/me",
            body: Body(
                displayName: displayName,
                preferredDifficulty: preferredDifficulty,
                waterExperiences: waterExperiences,
                interests: interests
            ),
            responseType: User.self
        )
    }

    // MARK: - Skills

    private func loadSkills() async {
        skills = (try? await api.get("/skills", responseType: [Skill].self)) ?? []
    }

    func updateDefaultSkills(_ skillIds: [Int]) async throws {
        struct Body: Encodable { let skillIds: [Int] }
        struct Empty: Codable {}
        _ = try await api.put(
            "/users/me/default-skills",
            body: Body(skillIds: skillIds),
            responseType: Empty.self
        )
        defaultSkills = skillIds
    }

    // MARK: - Vessels

    func loadVessels() async {
        do {
            vessels = try await api.get("/users/me/vessels", responseType: [Vessel].self)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func addVessel(_ vessel: Vessel) async throws {
        struct Body: Encodable {
            let type: String
            let name: String
            let brand: String?
            let model: String?
        }
        let created = try await api.post(
            "/users/me/vessels",
            body: Body(type: vessel.type.rawValue, name: vessel.name, brand: vessel.brand, model: vessel.model),
            responseType: Vessel.self
        )
        vessels.append(created)
    }

    func deleteVessel(id: Int) async throws {
        struct Empty: Codable {}
        _ = try await api.delete("/users/me/vessels/\(id)", responseType: Empty.self)
        vessels.removeAll { $0.id == id }
    }

    func setDefaultVessel(id: Int) async throws {
        struct Empty: Codable {}
        _ = try await api.put("/users/me/vessels/\(id)/default", responseType: Empty.self)
        vessels = vessels.map { vessel in
            Vessel(
                id: vessel.id,
                userId: vessel.userId,
                type: vessel.type,
                name: vessel.name,
                brand: vessel.brand,
                model: vessel.model,
                isDefault: vessel.id == id
            )
        }
    }

    // MARK: - Achievements

    func loadAchievements() async {
        do {
            achievements = try await api.get("/users/me/achievements", responseType: [UserAchievement].self)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Crew

    func loadCrew() async {
        do {
            crew = try await api.get("/users/me/crew", responseType: [User].self)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func addCrewMember(userId: Int) async throws {
        struct Body: Encodable { let userId: Int }
        let member = try await api.post(
            "/users/me/crew",
            body: Body(userId: userId),
            responseType: User.self
        )
        if !crew.contains(where: { $0.id == member.id }) {
            crew.append(member)
        }
    }

    func removeCrewMember(userId: Int) async throws {
        struct Empty: Codable {}
        _ = try await api.delete("/users/me/crew/\(userId)", responseType: Empty.self)
        crew.removeAll { $0.id == userId }
    }
}
