// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

struct WeatherView: View {

    // TODO: Integrate WeatherKit (import WeatherKit, use WeatherService.shared) for live data.
    // Current values are placeholders until API integration is complete.

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Conditions")
                .font(.headline)

            // Current conditions
            HStack(spacing: 24) {
                WeatherTile(
                    icon: "thermometer.medium",
                    value: "—°F",
                    label: "Air Temp",
                    color: .orange
                )
                WeatherTile(
                    icon: "drop.fill",
                    value: "—°F",
                    label: "Water Temp",
                    color: .blue
                )
                WeatherTile(
                    icon: "wind",
                    value: "— mph",
                    label: "Wind",
                    color: .gray
                )
                WeatherTile(
                    icon: "cloud.sun.fill",
                    value: "—",
                    label: "Sky",
                    color: .yellow
                )
            }

            Divider()

            // 48-hour forecast placeholder
            Text("48-Hour Forecast")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(forecastPlaceholders, id: \.hour) { item in
                        VStack(spacing: 6) {
                            Text(item.hour)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            Image(systemName: item.icon)
                                .font(.title3)
                                .foregroundStyle(item.color)
                            Text(item.temp)
                                .font(.caption.bold())
                        }
                        .frame(width: 50)
                    }
                }
                .padding(.vertical, 4)
            }

            Text("Weather data: TODO — integrate WeatherKit or Open-Meteo API.")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14))
    }

    // Placeholder forecast rows
    private struct ForecastItem {
        let hour: String
        let icon: String
        let color: Color
        let temp: String
    }

    private var forecastPlaceholders: [ForecastItem] {
        let icons: [(String, Color)] = [
            ("sun.max.fill", .yellow), ("cloud.sun.fill", .orange),
            ("cloud.fill", .gray), ("cloud.drizzle.fill", .blue),
            ("cloud.sun.fill", .orange), ("sun.max.fill", .yellow),
            ("sun.max.fill", .yellow), ("cloud.fill", .gray)
        ]
        return icons.enumerated().map { i, pair in
            ForecastItem(
                hour: i == 0 ? "Now" : "+\(i * 6)h",
                icon: pair.0,
                color: pair.1,
                temp: "—°"
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
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
