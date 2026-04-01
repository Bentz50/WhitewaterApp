// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation
import UIKit

/// Handles Google Sign-In using the Google Identity Services SDK.
///
/// The actual GIDSignIn SDK must be added to the project via Swift Package Manager
/// (`https://github.com/google/GoogleSignIn-iOS`). This service wraps its usage so
/// the rest of the app only deals with a simple `signIn()` call.
///
/// **Setup required:**
/// 1. Add the GoogleSignIn package in Xcode → File → Add Packages.
/// 2. Set a valid `GOOGLE_CLIENT_ID` below from the Google Cloud Console.
/// 3. Add the reversed client-ID as a URL scheme in Info.plist.
@MainActor
final class GoogleSignInService: ObservableObject {

    struct GoogleAuthResult {
        let idToken: String
        let email: String?
        let fullName: String?
    }

    /// Replace with your actual Google OAuth client ID from Google Cloud Console.
    static let clientID = "YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com"

    /// Triggers the Google Sign-In flow.
    ///
    /// - Note: This is a placeholder that demonstrates the intended integration
    ///   pattern. Once the GoogleSignIn SDK is added to the project, uncomment the
    ///   real implementation below and remove the placeholder error.
    func signIn() async throws -> GoogleAuthResult {
        // ──────────────────────────────────────────────────────────────
        // TODO: Uncomment the block below after adding the GoogleSignIn
        //       SPM package to the Xcode project.
        // ──────────────────────────────────────────────────────────────
        //
        // import GoogleSignIn   // add at the top of the file
        //
        // guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
        //       let rootVC = windowScene.windows.first?.rootViewController else {
        //     throw WhitewaterError.serverError("No root view controller available")
        // }
        //
        // let config = GIDConfiguration(clientID: Self.clientID)
        // GIDSignIn.sharedInstance.configuration = config
        //
        // let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootVC)
        // guard let idToken = result.user.idToken?.tokenString else {
        //     throw WhitewaterError.serverError("Google Sign-In failed: missing ID token")
        // }
        //
        // return GoogleAuthResult(
        //     idToken: idToken,
        //     email: result.user.profile?.email,
        //     fullName: result.user.profile?.name
        // )
        // ──────────────────────────────────────────────────────────────

        throw WhitewaterError.serverError(
            "Google Sign-In SDK not yet integrated. Add the GoogleSignIn SPM package and enable the code above."
        )
    }
}
