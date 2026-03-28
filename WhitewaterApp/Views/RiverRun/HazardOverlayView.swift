// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI
import MapKit

// MARK: - Hazard Annotation

final class HazardAnnotation: MKPointAnnotation {
    let hazard: Hazard

    init(hazard: Hazard) {
        self.hazard = hazard
        super.init()
        self.coordinate = CLLocationCoordinate2D(latitude: hazard.lat, longitude: hazard.lng)
        self.title = hazard.type.displayName
        self.subtitle = hazard.description
    }
}

// MARK: - Hazard Callout View

struct HazardCalloutView: View {
    let hazard: Hazard

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                HazardIconView(size: 24)
                Text(hazard.type.displayName)
                    .font(.headline)
                Spacer()
                HazardStatusBadge(status: hazard.status)
            }

            Text(hazard.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if let observed = hazard.lastObserved {
                Text("Last observed: \(observed.formatted(date: .abbreviated, time: .omitted))")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(12)
        .frame(minWidth: 220, maxWidth: 300)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Hazard Marker SwiftUI View

struct HazardMarkerView: View {
    let hazard: Hazard
    @State private var showCallout = false

    var body: some View {
        Button {
            showCallout.toggle()
        } label: {
            HazardIconView(size: 32)
        }
        .buttonStyle(.plain)
        .popover(isPresented: $showCallout) {
            HazardCalloutView(hazard: hazard)
        }
    }
}

// MARK: - Status Badge

private struct HazardStatusBadge: View {
    let status: HazardStatus

    var body: some View {
        Text(status == .active ? "Active" : "Cleared")
            .font(.caption2.bold())
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(status == .active ? Color.red.opacity(0.15) : Color.green.opacity(0.15), in: Capsule())
            .foregroundStyle(status == .active ? .red : .green)
    }
}
