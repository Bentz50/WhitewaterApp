// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

/// A reusable icon button used in the active run action bar.
struct ActionIconButton: View {
    let icon: String
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.title2)
                Text(label)
                    .font(.caption2)
            }
            .foregroundStyle(Color.appTeal)
        }
    }
}
