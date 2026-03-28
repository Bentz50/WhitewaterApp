// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

extension Color {
    /// Primary brand teal color — falls back to a built-in teal if the asset catalog
    /// color named "AppTeal" is not present.
    static let appTeal: Color = Color("AppTeal", bundle: nil) != .clear
        ? Color("AppTeal")
        : Color(red: 0.00, green: 0.67, blue: 0.72)
}
