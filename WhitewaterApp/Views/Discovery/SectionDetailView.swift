// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

struct SectionDetailView: View {

    let river: River
    let section: RiverSection
    @StateObject private var runVM = RiverRunViewModel()
    @State private var navigateToRun = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(section.name).font(.largeTitle.bold())
                            Text(river.state + " · " + river.region)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        VStack(spacing: 4) {
                            Text(section.awRating.displayName)
                                .font(.headline.bold())
                                .foregroundStyle(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.appTeal, in: RoundedRectangle(cornerRadius: 10))
                            if let khcc = section.khccRating {
                                Text("KHCC: \(khcc)")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }

                    HStack(spacing: 16) {
                        if let miles = section.lengthMiles {
                            Label("\(String(format: "%.1f", miles)) mi", systemImage: "ruler")
                                .font(.caption)
                        }
                        if let runnable = section.isRunnable {
                            Label(runnable ? "Runnable" : "Not Runnable",
                                  systemImage: runnable ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .font(.caption)
                                .foregroundStyle(runnable ? .green : .red)
                        }
                    }
                    .foregroundStyle(.secondary)
                }
                .padding(.horizontal)

                // Description
                if let desc = section.description {
                    Text(desc)
                        .font(.body)
                        .padding(.horizontal)
                }

                // Gauge dashboard
                if let gaugeData = runVM.gaugeData {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Current Conditions")
                            .font(.headline)
                            .padding(.horizontal)
                        GaugeDashboardView(gaugeData: gaugeData, river: river)
                            .padding(.horizontal)
                    }
                } else if runVM.isLoading {
                    ProgressView("Loading gauge…")
                        .padding(.horizontal)
                }

                // Weather
                VStack(alignment: .leading, spacing: 8) {
                    Text("Weather")
                        .font(.headline)
                        .padding(.horizontal)
                    WeatherView(
                        latitude: section.putInLat ?? river.lat,
                        longitude: section.putInLng ?? river.lng,
                        gaugeForecasts: runVM.gaugeData?.forecast ?? []
                    )
                    .padding(.horizontal)
                }

                // Videos
                if !runVM.videos.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        RiverVideoListView(
                            videos: runVM.videos,
                            currentLevel: runVM.gaugeData?.gageHeightFt
                        )
                        .padding(.horizontal)
                    }
                }

                // Hazards
                if !runVM.hazards.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hazards")
                            .font(.headline)
                            .padding(.horizontal)
                        ForEach(runVM.hazards) { hazard in
                            SectionHazardRow(hazard: hazard)
                                .padding(.horizontal)
                        }
                    }
                }

                // Tags
                if let tags = section.tags, !tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(tags, id: \.self) { tag in
                                Text("#\(tag)")
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.appTeal.opacity(0.12), in: Capsule())
                                    .foregroundStyle(Color.appTeal)
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                Spacer(minLength: 80)
            }
            .padding(.top, 16)
        }
        .overlay(alignment: .bottom) {
            // Start Run button
            Button {
                runVM.river = river
                runVM.section = section
                runVM.startRun()
                navigateToRun = true
            } label: {
                Label("Start Run", systemImage: "play.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.appTeal)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
            .background(.regularMaterial)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $navigateToRun) {
            ActiveRunView(viewModel: runVM)
        }
        .task {
            await runVM.loadSection(riverId: river.id, sectionId: section.id)
        }
    }
}

// MARK: - Hazard Row

private struct SectionHazardRow: View {
    let hazard: Hazard

    var body: some View {
        HStack(spacing: 12) {
            HazardIconView(size: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(hazard.type.displayName).font(.subheadline.bold())
                Text(hazard.description).font(.caption).foregroundStyle(.secondary).lineLimit(2)
            }
            Spacer()
            Text(hazard.status == .active ? "Active" : "Cleared")
                .font(.caption2.bold())
                .foregroundStyle(hazard.status == .active ? .red : .green)
        }
        .padding(10)
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 10))
    }
}
