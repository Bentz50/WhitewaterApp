// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI
import MapKit

struct DiscoveryMapView: View {

    @StateObject var viewModel: DiscoveryViewModel
    @State private var showSearchSheet = false
    @State private var showFeelingLucky = false
    @State private var showRiverDetail = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // Map
                Map(position: .constant(.region(viewModel.mapRegion))) {
                    ForEach(viewModel.rivers) { river in
                        Annotation(river.name, coordinate: CLLocationCoordinate2D(latitude: river.lat, longitude: river.lng)) {
                            Button {
                                viewModel.selectRiver(river)
                                showRiverDetail = true
                            } label: {
                                VStack(spacing: 2) {
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.title2)
                                        .foregroundStyle(ratingColor(river.awRating))
                                    Text(river.name)
                                        .font(.caption2.bold())
                                        .padding(.horizontal, 4)
                                        .background(.regularMaterial, in: Capsule())
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    UserAnnotation()
                }
                .ignoresSafeArea(edges: .top)

                // Search + filter bar
                VStack(spacing: 8) {
                    HStack(spacing: 10) {
                        HStack {
                            Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                            TextField("Search rivers…", text: $viewModel.searchQuery)
                                .submitLabel(.search)
                                .onSubmit { Task { await viewModel.searchRivers() } }
                        }
                        .padding(10)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))

                        Button {
                            showSearchSheet = true
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                                .padding(10)
                                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    // Filter chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            FilterChip(
                                label: "Runnable",
                                isActive: viewModel.showRunnableOnly
                            ) {
                                viewModel.showRunnableOnly.toggle()
                                Task { await viewModel.searchRivers() }
                            }

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
                    }
                }

                // Feeling Lucky button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            Task {
                                await viewModel.feelingLucky()
                                showFeelingLucky = true
                            }
                        } label: {
                            Label("Feeling Lucky", systemImage: "dice.fill")
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(Color.appTeal, in: Capsule())
                                .foregroundStyle(.white)
                                .font(.subheadline.bold())
                        }
                        .padding()
                        .shadow(radius: 4)
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showSearchSheet) {
                SmartSearchView(viewModel: viewModel)
                    .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $showRiverDetail) {
                if let river = viewModel.selectedRiver {
                    RiverDetailView(river: river)
                }
            }
            .sheet(isPresented: $showFeelingLucky) {
                if let river = viewModel.feelingLuckyRiver {
                    FeelingLuckyView(river: river) {
                        showFeelingLucky = false
                        Task { await viewModel.feelingLucky() }
                    } onSelect: {
                        viewModel.selectRiver(river)
                        showFeelingLucky = false
                        showRiverDetail = true
                    }
                }
            }
            .task {
                await viewModel.searchRivers()
            }
        }
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
