// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

struct RiverDetailView: View {

    let river: River
    @StateObject private var runVM = RiverRunViewModel()
    @State private var navigateToRun = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(river.name).font(.largeTitle.bold())
                                Text(river.state + " · " + river.region)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            VStack(spacing: 4) {
                                Text(river.awRating.displayName)
                                    .font(.headline.bold())
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.appTeal, in: RoundedRectangle(cornerRadius: 10))
                                if let khcc = river.khccRating {
                                    Text("KHCC: \(khcc)")
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }

                        HStack(spacing: 16) {
                            if let miles = river.lengthMiles {
                                Label("\(String(format: "%.1f", miles)) mi", systemImage: "ruler")
                                    .font(.caption)
                            }
                            if let runnable = river.isRunnable {
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
                    if let desc = river.description {
                        Text(desc)
                            .font(.body)
                            .padding(.horizontal)
                    }

                    // Sections list (when available)
                    if river.hasSections {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Sections")
                                .font(.headline)
                                .padding(.horizontal)
                            ForEach(river.sections!) { section in
                                NavigationLink(destination: SectionDetailView(river: river, section: section)) {
                                    SectionCard(section: section)
                                }
                                .buttonStyle(.plain)
                                .padding(.horizontal)
                            }
                        }
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
                            latitude: river.lat,
                            longitude: river.lng,
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
                                HazardRow(hazard: hazard)
                                    .padding(.horizontal)
                            }
                        }
                    }

                    // Tags
                    if !river.tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(river.tags, id: \.self) { tag in
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
                // Show Start Run only when there are no sections (otherwise user picks a section first)
                if !river.hasSections {
                    Button {
                        runVM.river = river
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
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $navigateToRun) {
                ActiveRunView(viewModel: runVM)
            }
            .task {
                await runVM.loadRiver(id: river.id)
            }
        }
    }
}

// MARK: - Hazard Row

private struct HazardRow: View {
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

// MARK: - Section Card

struct SectionCard: View {
    let section: RiverSection

    var body: some View {
        HStack(spacing: 14) {
            // Rating badge
            VStack(spacing: 2) {
                Text(section.awRating.rawValue)
                    .font(.headline.bold())
                    .foregroundStyle(.white)
            }
            .frame(width: 44, height: 44)
            .background(sectionRatingColor(section.awRating), in: RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(section.name).font(.headline)
                HStack(spacing: 8) {
                    if let miles = section.lengthMiles {
                        Text("\(String(format: "%.1f", miles)) mi")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                    if let runnable = section.isRunnable {
                        Label(runnable ? "Runnable" : "Not Runnable",
                              systemImage: runnable ? "checkmark.circle" : "xmark.circle")
                            .font(.caption2)
                            .foregroundStyle(runnable ? .green : .red)
                            .labelStyle(.titleAndIcon)
                    }
                }
                if let desc = section.description {
                    Text(desc)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }

            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(.tertiary).font(.caption)
        }
        .padding(12)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14))
    }

    private func sectionRatingColor(_ rating: AWRating) -> Color {
        switch rating {
        case .classI:     return .green
        case .classII:    return .blue
        case .classIII:   return .yellow
        case .classIV:    return .orange
        case .classV, .classV_plus: return .red
        case .unrated:    return .gray
        }
    }
}
