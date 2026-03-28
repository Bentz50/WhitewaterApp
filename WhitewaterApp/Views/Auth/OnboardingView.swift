// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

struct OnboardingView: View {

    @StateObject private var profileVM = ProfileViewModel()
    @EnvironmentObject var authService: AuthService

    @State private var currentStep: Int = 0
    @State private var selectedVesselTypes: Set<VesselType> = []
    @State private var selectedDifficulties: Set<AWRating> = []
    @State private var selectedExperiences: Set<String> = []
    @State private var isSubmitting: Bool = false

    private let waterExperienceOptions: [String] = [
        "River Run", "Surfing Waves", "Relaxing Day Float",
        "Whitewater Racing", "Fishing", "Wildlife Watching",
        "Camping + Paddling", "Photography"
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Progress indicator
            HStack(spacing: 8) {
                ForEach(0..<3) { i in
                    Capsule()
                        .fill(i <= currentStep ? Color.appTeal : Color.gray.opacity(0.3))
                        .frame(height: 4)
                }
            }
            .padding(.horizontal, 32)
            .padding(.top, 24)

            TabView(selection: $currentStep) {
                stepOne.tag(0)
                stepTwo.tag(1)
                stepThree.tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentStep)

            // Navigation buttons
            HStack {
                if currentStep > 0 {
                    Button("Back") { currentStep -= 1 }
                        .buttonStyle(.bordered)
                }
                Spacer()
                if currentStep < 2 {
                    Button("Next") { currentStep += 1 }
                        .buttonStyle(.borderedProminent)
                        .tint(Color.appTeal)
                } else {
                    Button {
                        Task { await finish() }
                    } label: {
                        if isSubmitting {
                            ProgressView().progressViewStyle(.circular)
                        } else {
                            Text("Get Started")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.appTeal)
                    .disabled(isSubmitting)
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
    }

    // MARK: - Step 1: Vessel Type

    private var stepOne: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "water.waves")
                .resizable()
                .scaledToFit()
                .frame(width: 72, height: 72)
                .foregroundStyle(Color.appTeal)

            Text("Welcome to WhitewaterApp")
                .font(.title.bold())
                .multilineTextAlignment(.center)

            Text("What do you paddle?")
                .font(.headline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                ForEach(VesselType.allCases, id: \.self) { type in
                    ChoiceChip(
                        label: type.displayName,
                        icon: vesselIcon(type),
                        isSelected: selectedVesselTypes.contains(type)
                    ) {
                        toggleSet(&selectedVesselTypes, value: type)
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal, 24)
    }

    // MARK: - Step 2: Difficulty

    private var stepTwo: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("Preferred Difficulty")
                .font(.title.bold())
            Text("Select all that apply")
                .foregroundStyle(.secondary)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 12) {
                ForEach(AWRating.allCases, id: \.self) { rating in
                    ChoiceChip(
                        label: rating.displayName,
                        isSelected: selectedDifficulties.contains(rating)
                    ) {
                        toggleSet(&selectedDifficulties, value: rating)
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal, 24)
    }

    // MARK: - Step 3: Water Experiences

    private var stepThree: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("Your Water Experiences")
                .font(.title.bold())
                .multilineTextAlignment(.center)
            Text("What do you enjoy on the water?")
                .foregroundStyle(.secondary)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))], spacing: 12) {
                ForEach(waterExperienceOptions, id: \.self) { exp in
                    ChoiceChip(
                        label: exp,
                        isSelected: selectedExperiences.contains(exp)
                    ) {
                        toggleSet(&selectedExperiences, value: exp)
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal, 24)
    }

    // MARK: - Helpers

    private func toggleSet<T: Hashable>(_ set: inout Set<T>, value: T) {
        if set.contains(value) { set.remove(value) } else { set.insert(value) }
    }

    private func vesselIcon(_ type: VesselType) -> String {
        switch type {
        case .kayak: return "figure.water.fitness"
        case .canoe: return "oar.2.crossed"
        case .raft:  return "ferry"
        }
    }

    private func finish() async {
        isSubmitting = true
        defer { isSubmitting = false }
        try? await profileVM.updateProfile(
            displayName: authService.currentUser?.displayName ?? "",
            preferredDifficulty: selectedDifficulties.map(\.rawValue),
            waterExperiences: Array(selectedExperiences),
            interests: selectedVesselTypes.map(\.rawValue)
        )
    }
}

// MARK: - ChoiceChip

private struct ChoiceChip: View {
    let label: String
    var icon: String? = nil
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let icon {
                    Image(systemName: icon)
                }
                Text(label)
                    .font(.subheadline.weight(.medium))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .foregroundStyle(isSelected ? .white : .primary)
            .background(isSelected ? Color.appTeal : Color(.systemGray5), in: Capsule())
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}
