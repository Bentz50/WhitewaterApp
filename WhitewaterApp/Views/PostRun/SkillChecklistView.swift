// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

struct SkillChecklistView: View {

    @ObservedObject var viewModel: PostRunViewModel
    @Environment(\.dismiss) private var dismiss

    private var groupedSkills: [(SkillCategory, [Skill])] {
        Dictionary(grouping: viewModel.selectedSkills, by: \.category)
            .sorted { $0.key.rawValue < $1.key.rawValue }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(groupedSkills, id: \.0) { category, skills in
                    Section(category.displayName) {
                        ForEach(skills) { skill in
                            SkillCheckmarkView(
                                skill: skill,
                                isChecked: viewModel.selectedSkills.contains(where: { $0.id == skill.id })
                            ) {
                                viewModel.toggleSkill(skill)
                            }
                        }
                    }
                }

                if groupedSkills.isEmpty {
                    ContentUnavailableView(
                        "No Skills Loaded",
                        systemImage: "star.slash",
                        description: Text("Skills will appear here once loaded from your profile defaults.")
                    )
                }
            }
            .navigationTitle("Skills Practiced")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .task { await viewModel.loadSkills() }
        }
    }
}
