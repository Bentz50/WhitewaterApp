// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI
import Charts

struct GaugeChartView: View {

    let readings: [GaugeReading]

    /// Determine axis label from first reading unit; default to "Value".
    private var unitLabel: String {
        readings.first?.unit ?? "Value"
    }

    private var lineColor: Color {
        unitLabel.lowercased().contains("cfs") ? .green : .blue
    }

    var body: some View {
        Chart(readings, id: \.timestamp) { reading in
            LineMark(
                x: .value("Time", reading.timestamp),
                y: .value(unitLabel, reading.value)
            )
            .foregroundStyle(lineColor)
            .interpolationMethod(.catmullRom)

            AreaMark(
                x: .value("Time", reading.timestamp),
                y: .value(unitLabel, reading.value)
            )
            .foregroundStyle(lineColor.opacity(0.1))
            .interpolationMethod(.catmullRom)
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .hour, count: 6)) { _ in
                AxisGridLine()
                AxisValueLabel(format: .dateTime.hour())
            }
        }
        .chartYAxis {
            AxisMarks { value in
                AxisGridLine()
                AxisValueLabel("\(value.as(Double.self).map { String(format: "%.0f", $0) } ?? "") \(unitLabel)")
            }
        }
    }
}
