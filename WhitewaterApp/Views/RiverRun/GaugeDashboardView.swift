// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI
import Charts

struct GaugeDashboardView: View {

    let gaugeData: GaugeData
    let river: River?

    private var isRunnable: Bool {
        guard let river else { return true }
        return GaugeService.shared.isRunnable(gaugeData: gaugeData, river: river)
    }

    private var runnabilityColor: Color {
        guard let floodStage = gaugeData.floodStage,
              let height = gaugeData.gageHeightFt else { return .green }
        if height >= floodStage { return .red }
        if height >= floodStage * 0.85 { return .yellow }
        return .green
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Current readings
            HStack(spacing: 20) {
                if let cfs = gaugeData.streamflowCfs {
                    GaugeValueCell(
                        value: String(format: "%.0f", cfs),
                        unit: "CFS",
                        icon: "water.waves"
                    )
                }
                if let height = gaugeData.gageHeightFt {
                    GaugeValueCell(
                        value: String(format: "%.2f", height),
                        unit: "ft",
                        icon: "ruler"
                    )
                }
                if let flood = gaugeData.floodStage {
                    GaugeValueCell(
                        value: String(format: "%.1f", flood),
                        unit: "flood",
                        icon: "exclamationmark.triangle.fill",
                        color: .red
                    )
                }
                Spacer()
                // Runnable badge
                Label(isRunnable ? "Runnable" : "Not Runnable", systemImage: isRunnable ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.caption.bold())
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(runnabilityColor.opacity(0.15), in: Capsule())
                    .foregroundStyle(runnabilityColor)
            }

            // 24-hour chart
            if !gaugeData.readings.isEmpty {
                let last24 = gaugeData.readings.filter {
                    $0.timestamp > Date().addingTimeInterval(-86_400)
                }
                if !last24.isEmpty {
                    Text("Last 24 Hours")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                    GaugeChartView(readings: last24)
                        .frame(height: 120)
                }
            }

            Text("Source: \(gaugeData.siteName) (\(gaugeData.source.rawValue.uppercased()))")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14))
    }
}

private struct GaugeValueCell: View {
    let value: String
    let unit: String
    let icon: String
    var color: Color = .appTeal

    var body: some View {
        VStack(spacing: 2) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(color)
            Text(value)
                .font(.title3.bold())
            Text(unit)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}
