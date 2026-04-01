// Copyright © 2026 BentzTech LLC. All rights reserved.

import AuthenticationServices
import SwiftUI

struct LoginView: View {

    @EnvironmentObject var authService: AuthService

    @StateObject private var googleService = GoogleSignInService()

    @State private var isLoading: Bool = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // Logo / Header
            VStack(spacing: 8) {
                Image(systemName: "water.waves")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(Color.appTeal)
                Text("WhitewaterApp")
                    .font(.largeTitle.bold())
                Text("Paddle smarter.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if let errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            if isLoading {
                ProgressView("Signing in…")
                    .progressViewStyle(.circular)
            }

            // Sign-in buttons
            VStack(spacing: 14) {
                // Sign in with Apple
                SignInWithAppleButton(.signIn) { request in
                    request.requestedScopes = [.fullName, .email]
                } onCompletion: { result in
                    Task { await handleAppleResult(result) }
                }
                .signInWithAppleButtonStyle(.black)
                .frame(height: 50)
                .cornerRadius(12)

                // Sign in with Google
                Button {
                    Task { await signInWithGoogle() }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "g.circle.fill")
                            .font(.title2)
                        Text("Sign in with Google")
                            .font(.body.weight(.medium))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(.systemBackground))
                    .foregroundStyle(.primary)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.separator), lineWidth: 1)
                    )
                }
            }
            .disabled(isLoading)
            .padding(.horizontal)

            // Legal text
            Text("By signing in, you agree to our Terms of Service and Privacy Policy.")
                .font(.caption2)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.bottom, 24)
        }
    }

    // MARK: - Apple Sign-In

    private func handleAppleResult(_ result: Result<ASAuthorization, Error>) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        switch result {
        case .success(let authorization):
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
                  let idTokenData = credential.identityToken,
                  let idToken = String(data: idTokenData, encoding: .utf8),
                  let authCodeData = credential.authorizationCode,
                  let authCode = String(data: authCodeData, encoding: .utf8)
            else {
                errorMessage = "Apple Sign-In failed: missing credentials."
                return
            }

            do {
                _ = try await authService.signInWithApple(
                    identityToken: idToken,
                    authorizationCode: authCode,
                    fullName: credential.fullName,
                    email: credential.email
                )
            } catch {
                errorMessage = error.localizedDescription
            }

        case .failure(let error):
            // ASAuthorizationError.canceled means user dismissed the sheet – not an error
            if (error as? ASAuthorizationError)?.code == .canceled { return }
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Google Sign-In

    private func signInWithGoogle() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let result = try await googleService.signIn()
            _ = try await authService.signInWithGoogle(idToken: result.idToken)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
