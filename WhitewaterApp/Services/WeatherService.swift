// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

// MARK: - Models

struct WeatherData: Codable {
    let airTempF: Double
    let waterTempEstimateF: Double
    let windSpeedMph: Double
    let weatherDescription: String
    let weatherIcon: String
    let hourlyForecasts: [HourlyForecast]
}

struct HourlyForecast: Codable, Identifiable {
    var id: String { hour }
    let hour: String
    let tempF: Double
    let icon: String
    let colorName: String

    var color: Color {
        switch colorName {
        case "yellow": return .yellow
        case "orange": return .orange
        case "blue":   return .blue
        case "gray":   return .gray
        case "red":    return .red
        default:       return .primary
        }
    }
}

// MARK: - Service

@MainActor
final class WeatherService: ObservableObject {

    static let shared = WeatherService()

    private let cachePrefix = "weather_"
    private let offline = OfflineManager.shared

    private init() {}

    // MARK: - Public API

    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherData {
        let urlString = "https://api.open-meteo.com/v1/forecast"
            + "?latitude=\(latitude)&longitude=\(longitude)"
            + "&current=temperature_2m,wind_speed_10m,weather_code"
            + "&hourly=temperature_2m,weather_code"
            + "&temperature_unit=fahrenheit&wind_speed_unit=mph&forecast_days=2"

        guard let url = URL(string: urlString) else {
            throw WhitewaterError.serverError("Invalid Open-Meteo URL")
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let weather = try parseResponse(data)
        cacheWeather(weather, latitude: latitude, longitude: longitude)
        return weather
    }

    // MARK: - Caching

    func cacheWeather(_ data: WeatherData, latitude: Double, longitude: Double) {
        let key = cacheKey(latitude: latitude, longitude: longitude)
        offline.cacheData(data, key: key)
    }

    func getCachedWeather(latitude: Double, longitude: Double) -> WeatherData? {
        let key = cacheKey(latitude: latitude, longitude: longitude)
        return offline.getCachedData(key: key, type: WeatherData.self)
    }

    private func cacheKey(latitude: Double, longitude: Double) -> String {
        cachePrefix + "\(String(format: "%.2f", latitude))_\(String(format: "%.2f", longitude))"
    }

    // MARK: - JSON Parsing

    private func parseResponse(_ data: Data) throws -> WeatherData {

        struct Current: Decodable {
            let temperature_2m: Double
            let wind_speed_10m: Double
            let weather_code: Int
        }

        struct Hourly: Decodable {
            let time: [String]
            let temperature_2m: [Double]
            let weather_code: [Int]
        }

        struct Root: Decodable {
            let current: Current
            let hourly: Hourly
        }

        let root = try JSONDecoder().decode(Root.self, from: data)

        let airTempF = root.current.temperature_2m
        let windMph = root.current.wind_speed_10m
        let currentCode = root.current.weather_code

        let (description, icon) = Self.mapWeatherCode(currentCode)
        let waterTempF = estimateWaterTemp(airTempF: airTempF)
        let forecasts = buildHourlyForecasts(
            times: root.hourly.time,
            temps: root.hourly.temperature_2m,
            codes: root.hourly.weather_code
        )

        return WeatherData(
            airTempF: airTempF,
            waterTempEstimateF: waterTempF,
            windSpeedMph: windMph,
            weatherDescription: description,
            weatherIcon: icon,
            hourlyForecasts: forecasts
        )
    }

    // MARK: - Water Temp Estimate

    private func estimateWaterTemp(airTempF: Double) -> Double {
        let month = Calendar.current.component(.month, from: Date())
        let isSummer = month >= 5 && month <= 9
        let offset: Double = isSummer ? 10.0 : 5.0
        return airTempF - offset
    }

    // MARK: - Hourly Forecast Builder

    private func buildHourlyForecasts(times: [String], temps: [Double], codes: [Int]) -> [HourlyForecast] {
        var results: [HourlyForecast] = []
        let count = min(times.count, min(temps.count, codes.count))
        // Sample at 6-hour intervals: 0, 6, 12, 18, 24, 30, 36, 42
        var index = 0
        while index < count {
            let label = index == 0 ? "Now" : "+\(index)h"
            let (_, icon) = Self.mapWeatherCode(codes[index])
            let colorName = Self.colorForCode(codes[index])
            results.append(HourlyForecast(
                hour: label,
                tempF: temps[index],
                icon: icon,
                colorName: colorName
            ))
            index += 6
        }
        return results
    }

    // MARK: - WMO Weather Code Mapping

    static func mapWeatherCode(_ code: Int) -> (description: String, icon: String) {
        switch code {
        case 0:
            return ("Clear Sky", "sun.max.fill")
        case 1:
            return ("Mainly Clear", "sun.min.fill")
        case 2:
            return ("Partly Cloudy", "cloud.sun.fill")
        case 3:
            return ("Overcast", "cloud.fill")
        case 45, 48:
            return ("Fog", "cloud.fog.fill")
        case 51:
            return ("Light Drizzle", "cloud.drizzle.fill")
        case 53:
            return ("Moderate Drizzle", "cloud.drizzle.fill")
        case 55:
            return ("Dense Drizzle", "cloud.drizzle.fill")
        case 61:
            return ("Light Rain", "cloud.rain.fill")
        case 63:
            return ("Moderate Rain", "cloud.rain.fill")
        case 65:
            return ("Heavy Rain", "cloud.heavyrain.fill")
        case 71:
            return ("Light Snow", "cloud.snow.fill")
        case 73:
            return ("Moderate Snow", "cloud.snow.fill")
        case 75:
            return ("Heavy Snow", "cloud.snow.fill")
        case 80:
            return ("Light Showers", "cloud.rain.fill")
        case 81:
            return ("Moderate Showers", "cloud.rain.fill")
        case 82:
            return ("Violent Showers", "cloud.heavyrain.fill")
        case 95:
            return ("Thunderstorm", "cloud.bolt.fill")
        case 96, 99:
            return ("Thunderstorm w/ Hail", "cloud.bolt.rain.fill")
        default:
            return ("Unknown", "questionmark.circle")
        }
    }

    static func colorForCode(_ code: Int) -> String {
        switch code {
        case 0, 1:          return "yellow"
        case 2, 3:          return "gray"
        case 45, 48:        return "gray"
        case 51...55:       return "blue"
        case 61...65:       return "blue"
        case 71...75:       return "blue"
        case 80...82:       return "orange"
        case 95, 96, 99:    return "red"
        default:            return "gray"
        }
    }
}
