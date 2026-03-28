// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation
import UIKit

@MainActor
final class PostRunViewModel: ObservableObject {

    // MARK: - Published State

    @Published var runLog: RunLog?
    @Published var selectedSkills: [Skill] = []
    @Published var hazardsToVerify: [Hazard] = []
    @Published var selectedImages: [UIImage] = []
    @Published var mediaPrivacy: MediaPrivacy = .public
    @Published var notes: String = ""
    @Published var tags: [String] = []
    @Published var isSubmitting: Bool = false
    @Published var submitSuccess: Bool = false

    private let api = APIService.shared
    private let mediaService = MediaService.shared

    // Draft data stored before API submission
    private var draftRiver: River?
    private var draftDistanceMiles: Double = 0
    private var draftDurationSeconds: Int = 0
    private var draftCaloriesBurned: Int = 0
    private var draftGpsTrack: [[Double]] = []
    private var draftStartGauge: Double?
    private var draftEndGauge: Double?

    // MARK: - Initialization

    func initializeWithDraft(
        river: River,
        distanceMiles: Double,
        durationSeconds: Int,
        caloriesBurned: Int,
        gpsTrack: [[Double]],
        startGauge: Double?,
        endGauge: Double?
    ) {
        draftRiver = river
        draftDistanceMiles = distanceMiles
        draftDurationSeconds = durationSeconds
        draftCaloriesBurned = caloriesBurned
        draftGpsTrack = gpsTrack
        draftStartGauge = startGauge
        draftEndGauge = endGauge
    }

    // MARK: - Skills

    func loadSkills() async {
        do {
            let allSkills = try await api.get("/skills", responseType: [Skill].self)
            // Pre-select defaults from user profile
            let defaults = (try? await api.get("/users/me/default-skills", responseType: [Int].self)) ?? []
            selectedSkills = allSkills.filter { defaults.contains($0.id) }
        } catch {
            selectedSkills = []
        }
    }

    func toggleSkill(_ skill: Skill) {
        if let idx = selectedSkills.firstIndex(where: { $0.id == skill.id }) {
            selectedSkills.remove(at: idx)
        } else {
            selectedSkills.append(skill)
        }
    }

    // MARK: - Hazard Verification

    func verifyHazard(id: Int, status: String, notes: String) async throws {
        struct Body: Encodable { let status: String; let notes: String }
        struct Empty: Codable {}
        _ = try await api.put(
            "/hazards/\(id)",
            body: Body(status: status, notes: notes),
            responseType: Empty.self
        )
        // Update local list to reflect verification
        hazardsToVerify.removeAll { $0.id == id }
    }

    // MARK: - Submission

    func submitRun() async throws {
        guard let river = draftRiver else { return }
        isSubmitting = true
        defer { isSubmitting = false }

        struct RunLogBody: Encodable {
            let riverId: Int
            let distanceMiles: Double
            let durationSeconds: Int
            let caloriesBurned: Int
            let gpsTrack: [[Double]]
            let startGaugeLevel: Double?
            let endGaugeLevel: Double?
            let notes: String
            let tags: [String]
            let skillIds: [Int]
        }

        let created = try await api.post(
            "/run-logs",
            body: RunLogBody(
                riverId: river.id,
                distanceMiles: draftDistanceMiles,
                durationSeconds: draftDurationSeconds,
                caloriesBurned: draftCaloriesBurned,
                gpsTrack: draftGpsTrack,
                startGaugeLevel: draftStartGauge,
                endGaugeLevel: draftEndGauge,
                notes: notes,
                tags: tags,
                skillIds: selectedSkills.map(\.id)
            ),
            responseType: RunLog.self
        )
        runLog = created

        if !selectedImages.isEmpty {
            try await uploadMedia()
        }

        submitSuccess = true
    }

    func uploadMedia() async throws {
        guard let runLog else { return }
        for image in selectedImages {
            guard let data = image.jpegData(compressionQuality: 0.8) else { continue }
            _ = try await mediaService.uploadMedia(
                data: data,
                type: .photo,
                runLogId: runLog.id,
                privacy: mediaPrivacy
            )
        }
    }
}
