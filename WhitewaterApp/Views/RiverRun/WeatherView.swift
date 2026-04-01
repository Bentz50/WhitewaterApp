// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI
import Charts

struct WeatherView: View {

    let latitude: Double
    let longitude: Double
    var gaugeForecasts: [GaugeReading] = []

    @State private var weather: WeatherData?
    @State private var isLoading = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Conditions")
                .font(.headline)

            // Current conditions
            if let weather {
                HStack(spacing: 24) {
                    WeatherTile(
                        icon: "thermometer.medium",
                        value: String(format: "%.0f°F", weather.airTempF),
                        label: "Air Temp",
                        color: .orange
                    )
                    WeatherTile(
                        icon: "drop.fill",
                        value: String(format: "%.0f°F", weather.waterTempEstimateF),
                        label: "Water Est.",
                        color: .blue
                    )
                    WeatherTile(
                        icon: "wind",
                        value: String(format: "%.0f mph", weather.windSpeedMph),
                        label: "Wind",
                        color: .gray
                    )
                    WeatherTile(
                        icon: weather.weatherIcon,
                        value: weather.weatherDescription,
                        label: "Sky",
                        color: .yellow
                    )
                }
            } else if isLoading {
                HStack {
                    Spacer()
                    ProgressView("Loading weather…")
                    Spacer()
                }
            } else {
                HStack(spacing: 24) {
                    WeatherTile(icon: "thermometer.medium", value: "—°F", label: "Air Temp", color: .orange)
                    WeatherTile(icon: "drop.fill", value: "—°F", label: "Water Est.", color: .blue)
                    WeatherTile(icon: "wind", value: "— mph", label: "Wind", color: .gray)
                    WeatherTile(icon: "cloud.sun.fill", value: "—", label: "Sky", color: .yellow)
                }
            }

            Divider()

            // 48-hour forecast
            if !gaugeForecasts.isEmpty {
                Text("48-Hour Gauge Forecast")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)

                GaugeChartView(readings: gaugeForecasts)
                    .frame(height: 120)
            } else if let weather, !weather.hourlyForecasts.isEmpty {
                Text("48-Hour Forecast")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(weather.hourlyForecasts) { forecast in
                            VStack(spacing: 6) {
                                Text(forecast.hour)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                Image(systemName: forecast.icon)
                                    .font(.title3)
                                    .foregroundStyle(forecast.color)
                                Text(String(format: "%.0f°", forecast.tempF))
                                    .font(.caption.bold())
                            }
                            .frame(width: 50)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }

            Text("Weather data from Open-Meteo. Water temp is estimated.")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14))
        .task {
            await loadWeather()
        }
    }

    private func loadWeather() async {
        isLoading = true
        defer { isLoading = false }
        do {
            weather = try await WeatherService.shared.fetchWeather(
                latitude: latitude,
                longitude: longitude
            )
        } catch {
            weather = WeatherService.shared.getCachedWeather(
                latitude: latitude,
                longitude: longitude
            )
        }
    }
}

// MARK: - WeatherTile

private struct WeatherTile: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            Text(value)
                .font(.subheadline.bold())
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
