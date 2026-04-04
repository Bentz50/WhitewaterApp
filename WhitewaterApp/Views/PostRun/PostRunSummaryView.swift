// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

struct PostRunSummaryView: View {

    let river: River
    let distanceMiles: Double
    let durationSeconds: Int
    let caloriesBurned: Int
    let startGauge: Double?

    @StateObject private var viewModel = PostRunViewModel()
    @State private var showSkillChecklist = false
    @State private var showHazardReport = false
    @State private var showMediaUpload = false
    @State private var showInjuryReport = false
    @State private var errorMessage: String?
    @State private var showSuccessAlert = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Summary card
                SummaryCard(
                    river: river,
                    distanceMiles: distanceMiles,
                    durationSeconds: durationSeconds,
                    caloriesBurned: caloriesBurned,
                    startGauge: startGauge,
                    endGauge: nil
                )

                // Sections
                VStack(spacing: 16) {
                    // Skills
                    SectionButton(
                        icon: "star.fill",
                        title: "Skills",
                        badge: viewModel.selectedSkills.isEmpty ? nil : "\(viewModel.selectedSkills.count)"
                    ) {
                        showSkillChecklist = true
                    }

                    // Hazards
                    SectionButton(
                        icon: "exclamationmark.triangle.fill",
                        title: "Hazards",
                        badge: viewModel.hazardsToVerify.isEmpty ? nil : "\(viewModel.hazardsToVerify.count)",
                        badgeColor: .orange
                    ) {
                        showHazardReport = true
                    }

                    // Media
                    SectionButton(
                        icon: "photo.fill",
                        title: "Photos & Videos",
                        badge: viewModel.selectedImages.isEmpty ? nil : "\(viewModel.selectedImages.count)"
                    ) {
                        showMediaUpload = true
                    }

                    // Notes
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Notes", systemImage: "text.justify")
                            .font(.headline)
                        TextEditor(text: $viewModel.notes)
                            .frame(minHeight: 80)
                            .padding(8)
                            .background(.quaternary, in: RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.horizontal)

                    // Tags
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Tags", systemImage: "tag.fill")
                            .font(.headline)
                        TagInputView(tags: $viewModel.tags)
                    }
                    .padding(.horizontal)

                    // Privacy
                    Picker("Privacy", selection: $viewModel.mediaPrivacy) {
                        Text("Public").tag(MediaPrivacy.public)
                        Text("Crew Only").tag(MediaPrivacy.crew)
                        Text("Private").tag(MediaPrivacy.private)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    // Injury report
                    Button {
                        showInjuryReport = true
                    } label: {
                        Label("Report Injury", systemImage: "cross.case.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                    .padding(.horizontal)
                }

                // Save button
                if let errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .font(.caption)
                        .padding(.horizontal)
                }

                Button {
                    Task { await saveRun() }
                } label: {
                    if viewModel.isSubmitting {
                        ProgressView().progressViewStyle(.circular).frame(maxWidth: .infinity)
                    } else {
                        Text("Save Run").frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.appTeal)
                .disabled(viewModel.isSubmitting)
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Run Summary")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showSkillChecklist) {
            SkillChecklistView(viewModel: viewModel)
        }
        .sheet(isPresented: $showHazardReport) {
            HazardReportView(viewModel: viewModel)
        }
        .sheet(isPresented: $showMediaUpload) {
            MediaUploadView(viewModel: viewModel)
        }
        .sheet(isPresented: $showInjuryReport) {
            InjuryReportView()
        }
        .alert("Run Saved!", isPresented: $showSuccessAlert) {
            Button("OK", role: .cancel) {}
        }
        .task {
            viewModel.initializeWithDraft(
                river: river,
                distanceMiles: distanceMiles,
                durationSeconds: durationSeconds,
                caloriesBurned: caloriesBurned,
                gpsTrack: [],
                startGauge: startGauge,
                endGauge: nil
            )
            await viewModel.loadSkills()
        }
    }

    private func saveRun() async {
        errorMessage = nil
        do {
            try await viewModel.submitRun()
            showSuccessAlert = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

// MARK: - Summary Card

private struct SummaryCard: View {
    let river: River
    let distanceMiles: Double
    let durationSeconds: Int
    let caloriesBurned: Int
    let startGauge: Double?
    let endGauge: Double?

    private var formattedDuration: String {
        durationSeconds.formattedDuration
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(river.name).font(.title2.bold())
                    Text("\(river.state) · \(river.awRating.displayName)")
                        .font(.subheadline).foregroundStyle(.secondary)
                    Text(Date().formatted(date: .long, time: .omitted))
                        .font(.caption).foregroundStyle(.tertiary)
                }
                Spacer()
                Image(systemName: "figure.water.fitness")
                    .font(.largeTitle)
                    .foregroundStyle(Color.appTeal)
            }

            Divider()

            HStack(spacing: 0) {
                MetricCell(value: String(format: "%.2f", distanceMiles), unit: "miles")
                Divider().frame(height: 40)
                MetricCell(value: formattedDuration, unit: "time")
                Divider().frame(height: 40)
                MetricCell(value: "\(caloriesBurned)", unit: "cal")
            }

            if let start = startGauge {
                Divider()
                HStack {
                    Text("Start gauge: \(String(format: "%.2f", start)) ft")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    if let end = endGauge {
                        Text("End: \(String(format: "%.2f", end)) ft")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }
}

// MARK: - Section Button

private struct SectionButton: View {
    let icon: String
    let title: String
    var badge: String? = nil
    var badgeColor: Color = .appTeal
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon).foregroundStyle(Color.appTeal)
                Text(title).font(.headline)
                Spacer()
                if let badge {
                    Text(badge)
                        .font(.caption.bold())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(badgeColor.opacity(0.15), in: Capsule())
                        .foregroundStyle(badgeColor)
                }
                Image(systemName: "chevron.right").foregroundStyle(.secondary).font(.caption)
            }
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }
}

// MARK: - Tag Input View

private struct TagInputView: View {
    @Binding var tags: [String]
    @State private var newTag = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            FlowLayout(tags: tags) { tag in
                HStack(spacing: 4) {
                    Text("#\(tag)").font(.caption)
                    Button { tags.removeAll { $0 == tag } } label: {
                        Image(systemName: "xmark.circle.fill").font(.caption2)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.appTeal.opacity(0.15), in: Capsule())
                .foregroundStyle(Color.appTeal)
            }
            HStack {
                TextField("Add tag", text: $newTag)
                    .autocapitalization(.none)
                    .submitLabel(.done)
                    .onSubmit { addTag() }
                Button("Add", action: addTag)
                    .buttonStyle(.bordered)
                    .tint(Color.appTeal)
                    .disabled(newTag.isEmpty)
            }
        }
    }

    private func addTag() {
        let clean = newTag.trimmingCharacters(in: .whitespaces).lowercased()
        guard !clean.isEmpty, !tags.contains(clean) else { return }
        tags.append(clean)
        newTag = ""
    }
}

private struct FlowLayout<Content: View>: View {
    let tags: [String]
    let content: (String) -> Content

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], alignment: .leading, spacing: 6) {
            ForEach(tags, id: \.self, content: content)
        }
    }
}
