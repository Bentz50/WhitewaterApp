// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

struct SkillTrackingView: View {

    @ObservedObject var viewModel: ProfileViewModel
    @State private var pendingDefaults: Set<Int> = []
    @State private var isSaving = false
    @State private var saveError: String?

    private var grouped: [(SkillCategory, [Skill])] {
        Dictionary(grouping: viewModel.skills, by: \.category)
            .sorted { $0.key.rawValue < $1.key.rawValue }
    }

    var body: some View {
        List {
            ForEach(grouped, id: \.0) { category, skills in
                Section(category.displayName) {
                    ForEach(skills) { skill in
                        SkillCheckmarkView(
                            skill: skill,
                            isChecked: pendingDefaults.contains(skill.id)
                        ) {
                            if pendingDefaults.contains(skill.id) {
                                pendingDefaults.remove(skill.id)
                            } else {
                                pendingDefaults.insert(skill.id)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Skills")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task { await saveDefaults() }
                } label: {
                    if isSaving {
                        ProgressView().progressViewStyle(.circular)
                    } else {
                        Text("Save")
                    }
                }
                .disabled(isSaving)
            }
        }
        .alert("Error", isPresented: .init(get: { saveError != nil }, set: { if !$0 { saveError = nil } })) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(saveError ?? "")
        }
        .task {
            await viewModel.loadProfile()
            pendingDefaults = Set(viewModel.defaultSkills)
        }
    }

    private func saveDefaults() async {
        isSaving = true
        defer { isSaving = false }
        do {
            try await viewModel.updateDefaultSkills(Array(pendingDefaults))
        } catch {
            saveError = error.localizedDescription
        }
    }
}
