// Copyright © 2026 BentzTech LLC. All rights reserved.

import AuthenticationServices
import Foundation

@MainActor
final class AuthService: ObservableObject {

    static let shared = AuthService()

    @Published private(set) var currentUser: User?
    @Published private(set) var isAuthenticated = false
    @Published private(set) var isNewUser = false

    private let api = APIService.shared
    private let tokenKey = "authToken"
    private let userKey  = "currentUser"

    private let localDecoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        d.dateDecodingStrategy = .iso8601
        return d
    }()

    private let localEncoder: JSONEncoder = {
        let e = JSONEncoder()
        e.keyEncodingStrategy = .convertToSnakeCase
        e.dateEncodingStrategy = .iso8601
        return e
    }()

    private init() {
        restoreSession()
    }

    // MARK: - Session Restore

    private func restoreSession() {
        guard
            let token    = UserDefaults.standard.string(forKey: tokenKey),
            let userData = UserDefaults.standard.data(forKey: userKey),
            let user     = try? localDecoder.decode(User.self, from: userData)
        else { return }

        api.authToken    = token
        currentUser      = user
        isAuthenticated  = true
    }

    // MARK: - Sign in with Apple

    func signInWithApple(
        identityToken: String,
        authorizationCode: String,
        fullName: PersonNameComponents?,
        email: String?
    ) async throws -> User {
        struct Body: Encodable {
            let identityToken: String
            let authorizationCode: String
            let fullName: FullNameBody?
            let email: String?
        }
        struct FullNameBody: Encodable {
            let givenName: String?
            let familyName: String?
        }
        struct AuthResponse: Codable {
            let token: String
            let user: User
            let refreshToken: String?
            let isNewUser: Bool?
        }

        let nameBody: FullNameBody? = fullName.map {
            FullNameBody(givenName: $0.givenName, familyName: $0.familyName)
        }

        let response = try await api.post(
            "/auth/apple",
            body: Body(
                identityToken: identityToken,
                authorizationCode: authorizationCode,
                fullName: nameBody,
                email: email
            ),
            responseType: AuthResponse.self
        )

        isNewUser = response.isNewUser ?? false
        persist(token: response.token, user: response.user)
        return response.user
    }

    // MARK: - Sign in with Google

    func signInWithGoogle(idToken: String) async throws -> User {
        struct Body: Encodable { let idToken: String }
        struct AuthResponse: Codable {
            let token: String
            let user: User
            let refreshToken: String?
            let isNewUser: Bool?
        }

        let response = try await api.post(
            "/auth/google",
            body: Body(idToken: idToken),
            responseType: AuthResponse.self
        )

        isNewUser = response.isNewUser ?? false
        persist(token: response.token, user: response.user)
        return response.user
    }

    // MARK: - Logout

    func logout() {
        api.authToken   = nil
        currentUser     = nil
        isAuthenticated = false
        isNewUser       = false
        UserDefaults.standard.removeObject(forKey: tokenKey)
        UserDefaults.standard.removeObject(forKey: userKey)
    }

    // MARK: - Token Refresh

    func refreshToken() async throws {
        struct Response: Codable { let token: String; let user: User }
        let response = try await api.post("/auth/refresh", responseType: Response.self)
        persist(token: response.token, user: response.user)
    }

    // MARK: - Onboarding complete

    func onboardingComplete() {
        isNewUser = false
    }

    // MARK: - Helpers

    private func persist(token: String, user: User) {
        api.authToken   = token
        currentUser     = user
        isAuthenticated = true
        UserDefaults.standard.set(token, forKey: tokenKey)
        if let data = try? localEncoder.encode(user) {
            UserDefaults.standard.set(data, forKey: userKey)
        }
    }
}
