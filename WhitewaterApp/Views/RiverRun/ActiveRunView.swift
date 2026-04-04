// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI
import MapKit

struct ActiveRunView: View {

    @StateObject var viewModel: RiverRunViewModel
    @State private var showBeaterFeed = false
    @State private var showWeather = false
    @State private var navigateToPostRun = false
    @State private var draftRunLog: RunLog?
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)

    var body: some View {
        ZStack(alignment: .bottom) {
            // Full-screen map
            Map(position: $cameraPosition) {
                UserAnnotation()
                ForEach(viewModel.hazards) { hazard in
                    Annotation(
                        hazard.type.displayName,
                        coordinate: CLLocationCoordinate2D(latitude: hazard.lat, longitude: hazard.lng)
                    ) {
                        HazardIconView(size: 28)
                    }
                }
            }
            .mapStyle(.standard(elevation: .realistic))
            .ignoresSafeArea()

            // Stats overlay
            VStack(spacing: 0) {
                // Elapsed time (large)
                HStack {
                    Spacer()
                    VStack(spacing: 2) {
                        Text(formattedElapsed)
                            .font(.system(size: LayoutConstants.elapsedTimeFontSize, weight: .bold, design: .monospaced))
                            .foregroundStyle(.white)
                        Text("ELAPSED")
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    Spacer()
                }
                .padding(.vertical, 16)
                .background(.ultraThinMaterial)
                .padding(.top)

                Spacer()

                // Metrics row
                HStack(spacing: 0) {
                    MetricCell(value: viewModel.distanceMiles.formattedDistance, unit: "mi")
                    Divider().frame(height: LayoutConstants.metricDividerHeight)
                    MetricCell(value: viewModel.currentSpeedMph.formattedSpeed, unit: "mph")
                    Divider().frame(height: LayoutConstants.metricDividerHeight)
                    MetricCell(value: "\(viewModel.caloriesBurned)", unit: "cal")
                }
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)

                // Action bar
                HStack(spacing: 20) {
                    // Beaters feed
                    ActionIconButton(icon: "bubble.left.and.bubble.right.fill", label: "Beaters") {
                        showBeaterFeed = true
                    }

                    Spacer()

                    // Stop run
                    Button {
                        draftRunLog = viewModel.stopRun()
                        navigateToPostRun = true
                    } label: {
                        Label("Stop Run", systemImage: "stop.fill")
                            .font(.headline)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 14)
                            .background(.red, in: Capsule())
                            .foregroundStyle(.white)
                    }

                    Spacer()

                    // Gauge refresh
                    ActionIconButton(icon: "arrow.clockwise", label: "Gauge") {
                        Task { await viewModel.refreshGauge() }
                    }

                    // Weather
                    ActionIconButton(icon: "cloud.sun.fill", label: "Weather") {
                        showWeather = true
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(.ultraThinMaterial)
            }
        }
        .sheet(isPresented: $showBeaterFeed) {
            BeaterFeedView(viewModel: viewModel)
                .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showWeather) {
            if let river = viewModel.river {
                NavigationStack {
                    ScrollView {
                        WeatherView(
                            latitude: river.lat,
                            longitude: river.lng,
                            gaugeForecasts: viewModel.gaugeData?.forecast ?? []
                        )
                        .padding()
                    }
                    .navigationTitle("Weather")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Done") { showWeather = false }
                        }
                    }
                }
                .presentationDetents([.medium, .large])
            }
        }
        .navigationDestination(isPresented: $navigateToPostRun) {
            if let river = viewModel.river {
                PostRunSummaryView(
                    river: river,
                    distanceMiles: viewModel.distanceMiles,
                    durationSeconds: viewModel.elapsedSeconds,
                    caloriesBurned: viewModel.caloriesBurned,
                    startGauge: viewModel.gaugeData?.gageHeightFt
                )
            }
        }
        .navigationBarHidden(true)
        .task { await viewModel.loadHazards() }
    }

    private var formattedElapsed: String {
        viewModel.elapsedSeconds.formattedDuration
    }
}
