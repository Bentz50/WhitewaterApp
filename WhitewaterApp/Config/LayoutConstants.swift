// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

// MARK: - Layout Constants

/// Shared layout constants to eliminate magic numbers across views.
enum LayoutConstants {
    // Dividers
    static let metricDividerHeight: CGFloat = 40

    // Fonts
    static let elapsedTimeFontSize: CGFloat = 48

    // Text editors / inputs
    static let textEditorMinHeight: CGFloat = 80
    static let tagGridMinimum: CGFloat = 80

    // Number formatting
    enum NumberFormat {
        static let distance = "%.2f"
        static let speed    = "%.1f"
        static let gauge    = "%.2f"
    }
}
