// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation

@MainActor
final class AuthService: ObservableObject {

    static let shared = AuthService()

    @Published private(set) var currentUser: User?
    @Published private(set) var isAuthenticated = false

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

    // MARK: - Auth Actions

    func login(email: String, password: String) async throws -> User {
        struct Body: Encodable { let email, password: String }
        struct Response: Codable { let token: String; let user: User }

        let response = try await api.post(
            "/auth/login",
            body: Body(email: email, password: password),
            responseType: Response.self
        )
        persist(token: response.token, user: response.user)
        return response.user
    }

    func register(
        email: String,
        username: String,
        password: String,
        displayName: String
    ) async throws -> User {
        struct Body: Encodable { let email, username, password, displayName: String }
        struct Response: Codable { let token: String; let user: User }

        let response = try await api.post(
            "/auth/register",
            body: Body(email: email, username: username, password: password, displayName: displayName),
            responseType: Response.self
        )
        persist(token: response.token, user: response.user)
        return response.user
    }

    func logout() {
        api.authToken   = nil
        currentUser     = nil
        isAuthenticated = false
        UserDefaults.standard.removeObject(forKey: tokenKey)
        UserDefaults.standard.removeObject(forKey: userKey)
    }

    func refreshToken() async throws {
        struct Response: Codable { let token: String; let user: User }
        let response = try await api.post("/auth/refresh", responseType: Response.self)
        persist(token: response.token, user: response.user)
    }

    func forgotPassword(email: String) async throws {
        struct Body: Encodable { let email: String }
        struct Empty: Codable {}
        _ = try await api.post(
            "/auth/forgot-password",
            body: Body(email: email),
            responseType: Empty.self
        )
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
