// Copyright © 2026 BentzTech LLC. All rights reserved.

import AuthenticationServices
import Foundation

/// Coordinates the Sign in with Apple authorization flow.
@MainActor
final class AppleSignInCoordinator: NSObject, ObservableObject {

    /// Result delivered after the Apple authorization completes.
    struct AppleAuthResult {
        let identityToken: String
        let authorizationCode: String
        let fullName: PersonNameComponents?
        let email: String?
    }

    private var continuation: CheckedContinuation<AppleAuthResult, Error>?

    /// Triggers the Apple Sign-In sheet and returns credentials on success.
    func signIn() async throws -> AppleAuthResult {
        try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            let provider = ASAuthorizationAppleIDProvider()
            let request  = provider.createRequest()
            request.requestedScopes = [.fullName, .email]

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.performRequests()
        }
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension AppleSignInCoordinator: ASAuthorizationControllerDelegate {

    nonisolated func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let idTokenData = credential.identityToken,
              let idToken = String(data: idTokenData, encoding: .utf8),
              let authCodeData = credential.authorizationCode,
              let authCode = String(data: authCodeData, encoding: .utf8)
        else {
            continuation?.resume(throwing: WhitewaterError.serverError("Apple Sign-In failed: missing credentials"))
            continuation = nil
            return
        }

        let result = AppleAuthResult(
            identityToken: idToken,
            authorizationCode: authCode,
            fullName: credential.fullName,
            email: credential.email
        )
        continuation?.resume(returning: result)
        continuation = nil
    }

    nonisolated func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
}
