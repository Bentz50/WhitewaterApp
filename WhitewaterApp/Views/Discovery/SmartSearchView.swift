// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

struct SmartSearchView: View {

    @ObservedObject var viewModel: DiscoveryViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showRiverDetail = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Filter chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        // Runnable filter
                        FilterChip(
                            label: "Runnable Only",
                            isActive: viewModel.showRunnableOnly
                        ) {
                            viewModel.showRunnableOnly.toggle()
                            Task { await viewModel.searchRivers() }
                        }

                        // Rating filters
                        ForEach(AWRating.allCases, id: \.self) { rating in
                            FilterChip(
                                label: rating.displayName,
                                isActive: viewModel.selectedRatings.contains(rating)
                            ) {
                                if viewModel.selectedRatings.contains(rating) {
                                    viewModel.selectedRatings.removeAll { $0 == rating }
                                } else {
                                    viewModel.selectedRatings.append(rating)
                                }
                                Task { await viewModel.searchRivers() }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }

                // Radius slider
                VStack(alignment: .leading, spacing: 4) {
                    Text("Radius: \(Int(viewModel.searchRadius)) mi")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Slider(value: $viewModel.searchRadius, in: 10...200, step: 10) {
                        Text("Radius")
                    }
                    .tint(Color.appTeal)
                    .onChange(of: viewModel.searchRadius) { _, _ in
                        Task { await viewModel.searchRivers() }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)

                Divider()

                // Results list
                if viewModel.isLoading {
                    ProgressView("Searching…").frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.rivers.isEmpty {
                    ContentUnavailableView("No Rivers Found", systemImage: "map.fill", description: Text("Try adjusting your filters or radius."))
                } else {
                    List(viewModel.rivers) { river in
                        RiverCard(river: river) {
                            viewModel.selectRiver(river)
                            showRiverDetail = true
                        }
                        .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Discover Rivers")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
            .sheet(isPresented: $showRiverDetail) {
                if let river = viewModel.selectedRiver {
                    RiverDetailView(river: river)
                }
            }
        }
    }
}

// MARK: - River Card

struct RiverCard: View {
    let river: River
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                // Rating badge
                VStack(spacing: 2) {
                    Text(river.awRating.rawValue)
                        .font(.headline.bold())
                        .foregroundStyle(.white)
                }
                .frame(width: 44, height: 44)
                .background(ratingColor(river.awRating), in: RoundedRectangle(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 4) {
                    Text(river.name).font(.headline)
                    Text(river.state).font(.caption).foregroundStyle(.secondary)
                    HStack(spacing: 8) {
                        if let miles = river.lengthMiles {
                            Text("\(String(format: "%.1f", miles)) mi")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                        }
                        if let runnable = river.isRunnable {
                            Label(runnable ? "Runnable" : "Not Runnable",
                                  systemImage: runnable ? "checkmark.circle" : "xmark.circle")
                                .font(.caption2)
                                .foregroundStyle(runnable ? .green : .red)
                                .labelStyle(.titleAndIcon)
                        }
                        if let sections = river.sections, !sections.isEmpty {
                            Label("\(sections.count) sections", systemImage: "list.bullet")
                                .font(.caption2)
                                .foregroundStyle(Color.appTeal)
                                .labelStyle(.titleAndIcon)
                        }
                    }
                }

                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(.tertiary).font(.caption)
            }
            .padding(12)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }

    private func ratingColor(_ rating: AWRating) -> Color {
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

// MARK: - Filter Chip

private struct FilterChip: View {
    let label: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.caption.bold())
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isActive ? Color.appTeal : Color(.systemGray5), in: Capsule())
                .foregroundStyle(isActive ? .white : .primary)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isActive)
    }
}
