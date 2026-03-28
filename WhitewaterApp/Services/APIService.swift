// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation
import Network

// MARK: - Errors

enum WhitewaterError: LocalizedError {
    case networkError(Error)
    case decodingError(Error)
    case unauthorized
    case serverError(String)
    case notFound
    case offline

    var errorDescription: String? {
        switch self {
        case .networkError(let err):  return "Network error: \(err.localizedDescription)"
        case .decodingError(let err): return "Decoding error: \(err.localizedDescription)"
        case .unauthorized:           return "Unauthorized. Please log in again."
        case .serverError(let msg):   return "Server error: \(msg)"
        case .notFound:               return "Resource not found."
        case .offline:                return "You appear to be offline."
        }
    }
}

// MARK: - API Response envelope

struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let data: T?
    let message: String?
}

// MARK: - Service

final class APIService: ObservableObject {

    static let shared = APIService()

    // MARK: Auth token (UserDefaults-backed)

    var authToken: String? {
        get { UserDefaults.standard.string(forKey: "authToken") }
        set {
            if let token = newValue {
                UserDefaults.standard.set(token, forKey: "authToken")
            } else {
                UserDefaults.standard.removeObject(forKey: "authToken")
            }
        }
    }

    // MARK: Internals

    private let session: URLSession

    /// Shared decoder; also used by GaugeService for backend proxy responses.
    let decoder: JSONDecoder

    private let encoder: JSONEncoder
    private let monitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "com.bentztech.network.monitor")

    /// Updated on `monitorQueue`; safe to read from any context for a simple Bool flag.
    private(set) var isOnline: Bool = true

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest  = 30
        config.timeoutIntervalForResource = 60
        session = URLSession(configuration: config)

        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601

        encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601

        monitor.pathUpdateHandler = { [weak self] path in
            self?.isOnline = path.status == .satisfied
        }
        monitor.start(queue: monitorQueue)
    }

    // MARK: - Generic request

    func request<T: Codable>(
        _ endpoint: String,
        method: String = "GET",
        body: (any Encodable)? = nil,
        responseType: T.Type
    ) async throws -> T {
        guard isOnline else { throw WhitewaterError.offline }

        guard let url = URL(string: APIConfig.baseURL + endpoint) else {
            throw WhitewaterError.serverError("Invalid URL: \(endpoint)")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        if let token = authToken {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if let body {
            urlRequest.httpBody = try encoder.encode(AnyEncodable(body))
        }

        return try await performRequest(urlRequest, responseType: responseType, retriesLeft: 2)
    }

    // MARK: - Retry loop

    private func performRequest<T: Codable>(
        _ request: URLRequest,
        responseType: T.Type,
        retriesLeft: Int
    ) async throws -> T {
        do {
            let (data, response) = try await session.data(for: request)

            guard let http = response as? HTTPURLResponse else {
                throw WhitewaterError.serverError("Invalid HTTP response")
            }

            switch http.statusCode {
            case 200...299:
                return try decodeResponse(data, as: responseType)
            case 401:
                throw WhitewaterError.unauthorized
            case 404:
                throw WhitewaterError.notFound
            default:
                let msg = (try? decoder.decode(APIResponse<String>.self, from: data))?.message
                    ?? HTTPURLResponse.localizedString(forStatusCode: http.statusCode)
                throw WhitewaterError.serverError(msg)
            }
        } catch let error as WhitewaterError {
            throw error   // do not retry on known HTTP/app errors
        } catch {
            guard retriesLeft > 0 else { throw WhitewaterError.networkError(error) }
            try await Task.sleep(for: .seconds(1))
            return try await performRequest(request, responseType: responseType, retriesLeft: retriesLeft - 1)
        }
    }

    // MARK: - Decoding helper

    private func decodeResponse<T: Codable>(_ data: Data, as type: T.Type) throws -> T {
        // Prefer unwrapping from APIResponse envelope; fall back to direct decode.
        if let wrapped = try? decoder.decode(APIResponse<T>.self, from: data),
           let value = wrapped.data {
            return value
        }
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw WhitewaterError.decodingError(error)
        }
    }

    // MARK: - Convenience methods

    func get<T: Codable>(_ endpoint: String, responseType: T.Type) async throws -> T {
        try await request(endpoint, method: "GET", responseType: responseType)
    }

    func post<T: Codable>(
        _ endpoint: String,
        body: (any Encodable)? = nil,
        responseType: T.Type
    ) async throws -> T {
        try await request(endpoint, method: "POST", body: body, responseType: responseType)
    }

    func put<T: Codable>(
        _ endpoint: String,
        body: (any Encodable)? = nil,
        responseType: T.Type
    ) async throws -> T {
        try await request(endpoint, method: "PUT", body: body, responseType: responseType)
    }

    func delete<T: Codable>(_ endpoint: String, responseType: T.Type) async throws -> T {
        try await request(endpoint, method: "DELETE", responseType: responseType)
    }

    // MARK: - Push Notifications

    func sendPushToken(_ token: String) async {
        struct Body: Encodable { let deviceToken: String; let platform: String }
        struct Empty: Codable {}
        do {
            _ = try await post(
                "/users/push-token",
                body: Body(deviceToken: token, platform: "ios"),
                responseType: Empty.self
            )
        } catch {
            // Non-fatal: log and continue
            print("WhitewaterApp: failed to register push token — \(error.localizedDescription)")
        }
    }
}

// MARK: - Type-erased Encodable wrapper

private struct AnyEncodable: Encodable {
    private let encodeFunc: (Encoder) throws -> Void

    init(_ encodable: any Encodable) {
        encodeFunc = { encoder in try encodable.encode(to: encoder) }
    }

    func encode(to encoder: Encoder) throws {
        try encodeFunc(encoder)
    }
}
