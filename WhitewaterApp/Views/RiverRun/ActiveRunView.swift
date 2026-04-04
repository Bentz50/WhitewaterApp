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
                            .font(.system(size: 48, weight: .bold, design: .monospaced))
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
                    MetricCell(value: String(format: "%.2f", viewModel.distanceMiles), unit: "mi")
                    Divider().frame(height: 40)
                    MetricCell(value: String(format: "%.1f", viewModel.currentSpeedMph), unit: "mph")
                    Divider().frame(height: 40)
                    MetricCell(value: "\(viewModel.caloriesBurned)", unit: "cal")
                }
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)

                // Action bar
                HStack(spacing: 20) {
                    // Beaters feed
                    Button {
                        showBeaterFeed = true
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: "bubble.left.and.bubble.right.fill")
                                .font(.title2)
                            Text("Beaters")
                                .font(.caption2)
                        }
                        .foregroundStyle(Color.appTeal)
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
                    Button {
                        Task { await viewModel.refreshGauge() }
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: "arrow.clockwise")
                                .font(.title2)
                            Text("Gauge")
                                .font(.caption2)
                        }
                        .foregroundStyle(Color.appTeal)
                    }

                    // Weather
                    Button {
                        showWeather = true
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: "cloud.sun.fill")
                                .font(.title2)
                            Text("Weather")
                                .font(.caption2)
                        }
                        .foregroundStyle(Color.appTeal)
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
