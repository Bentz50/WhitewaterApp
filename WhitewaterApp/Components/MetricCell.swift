// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

/// A reusable metric display cell showing a value and unit label.
struct MetricCell: View {
    let value: String
    let unit: String

    var body: some View {
        VStack(spacing: 2) {
            Text(value).font(.title2.bold())
            Text(unit).font(.caption2).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
    }
}
