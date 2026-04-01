// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

/// RegisterView is no longer used. Account creation is handled automatically
/// via third-party sign-in (Apple / Google) in LoginView. This view redirects
/// to LoginView for backward compatibility if it is still referenced anywhere.
struct RegisterView: View {

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "water.waves")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .foregroundStyle(Color.appTeal)

            Text("Create your account using\nSign in with Apple or Google")
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            Button("Go to Sign In") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.appTeal)

            Spacer()
        }
        .padding()
    }
}
