// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

struct LoginView: View {

    @EnvironmentObject var authService: AuthService

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Logo / Header
                VStack(spacing: 8) {
                    Image(systemName: "water.waves")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                        .foregroundStyle(Color.appTeal)
                    Text("WhitewaterApp")
                        .font(.largeTitle.bold())
                    Text("Paddle smarter.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 40)

                // Form
                VStack(spacing: 16) {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .textContentType(.emailAddress)
                        .padding()
                        .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))

                    SecureField("Password", text: $password)
                        .textContentType(.password)
                        .padding()
                        .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)

                if let errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                // Login Button
                Button {
                    Task { await login() }
                } label: {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.appTeal)
                .disabled(isLoading || email.isEmpty || password.isEmpty)
                .padding(.horizontal)

                // Forgot Password
                Button("Forgot Password?") {
                    Task { await forgotPassword() }
                }
                .font(.footnote)
                .foregroundStyle(Color.appTeal)

                Spacer()

                // Register
                NavigationLink {
                    RegisterView()
                } label: {
                    Text("Don't have an account? ")
                        .foregroundStyle(.secondary)
                    + Text("Register")
                        .foregroundStyle(Color.appTeal)
                        .bold()
                }
                .font(.footnote)
                .padding(.bottom, 24)
            }
        }
    }

    // MARK: - Actions

    private func login() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            _ = try await authService.login(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func forgotPassword() async {
        guard !email.isEmpty else {
            errorMessage = "Enter your email address first."
            return
        }
        do {
            try await authService.forgotPassword(email: email)
            errorMessage = "Password reset email sent."
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
