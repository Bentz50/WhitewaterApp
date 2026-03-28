// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

struct RegisterView: View {

    @EnvironmentObject var authService: AuthService
    @Environment(\.dismiss) private var dismiss

    @State private var email: String = ""
    @State private var username: String = ""
    @State private var displayName: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?

    private var isEmailValid: Bool {
        let regex = /^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$/
        return (try? regex.wholeMatch(in: email)) != nil
    }

    private var passwordsMatch: Bool {
        password == confirmPassword
    }

    private var canSubmit: Bool {
        isEmailValid &&
        !username.isEmpty &&
        !displayName.isEmpty &&
        password.count >= 6 &&
        passwordsMatch &&
        !isLoading
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 8) {
                        Image(systemName: "water.waves")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 56, height: 56)
                            .foregroundStyle(Color.appTeal)
                        Text("Create Account")
                            .font(.largeTitle.bold())
                    }
                    .padding(.top, 32)

                    VStack(spacing: 14) {
                        FormField(label: "Email", text: $email, contentType: .emailAddress, keyboard: .emailAddress)
                            .overlay(alignment: .trailing) {
                                if !email.isEmpty {
                                    Image(systemName: isEmailValid ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundStyle(isEmailValid ? .green : .red)
                                        .padding(.trailing, 12)
                                }
                            }

                        FormField(label: "Username", text: $username, contentType: .username)

                        FormField(label: "Display Name", text: $displayName, contentType: .name)

                        FormField(label: "Password", text: $password, contentType: .newPassword, isSecure: true)
                            .overlay(alignment: .trailing) {
                                if !password.isEmpty {
                                    Image(systemName: password.count >= 6 ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundStyle(password.count >= 6 ? .green : .red)
                                        .padding(.trailing, 12)
                                }
                            }

                        FormField(label: "Confirm Password", text: $confirmPassword, contentType: .newPassword, isSecure: true)
                            .overlay(alignment: .trailing) {
                                if !confirmPassword.isEmpty {
                                    Image(systemName: passwordsMatch ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundStyle(passwordsMatch ? .green : .red)
                                        .padding(.trailing, 12)
                                }
                            }
                    }
                    .padding(.horizontal)

                    if let errorMessage {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }

                    Button {
                        Task { await register() }
                    } label: {
                        if isLoading {
                            ProgressView().progressViewStyle(.circular).frame(maxWidth: .infinity)
                        } else {
                            Text("Create Account").frame(maxWidth: .infinity)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.appTeal)
                    .disabled(!canSubmit)
                    .padding(.horizontal)

                    Button {
                        dismiss()
                    } label: {
                        Text("Already have an account? ")
                            .foregroundStyle(.secondary)
                        + Text("Login")
                            .foregroundStyle(Color.appTeal)
                            .bold()
                    }
                    .font(.footnote)
                    .padding(.bottom, 24)
                }
            }
        }
    }

    // MARK: - Actions

    private func register() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            _ = try await authService.register(
                email: email,
                username: username,
                password: password,
                displayName: displayName
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

// MARK: - Helper

private struct FormField: View {
    let label: String
    @Binding var text: String
    var contentType: UITextContentType? = nil
    var keyboard: UIKeyboardType = .default
    var isSecure: Bool = false

    var body: some View {
        Group {
            if isSecure {
                SecureField(label, text: $text)
                    .textContentType(contentType)
            } else {
                TextField(label, text: $text)
                    .keyboardType(keyboard)
                    .autocapitalization(.none)
                    .textContentType(contentType)
            }
        }
        .padding()
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
    }
}
