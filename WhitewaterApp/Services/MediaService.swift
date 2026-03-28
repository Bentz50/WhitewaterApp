// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation
import UIKit

@MainActor
final class MediaService: ObservableObject {

    static let shared = MediaService()

    @Published private(set) var uploadProgress: Double = 0

    private let api = APIService.shared
    private let maxImageDimension: CGFloat = 1_920
    private let jpegQuality:       CGFloat = 0.80

    private init() {}

    // MARK: - Upload

    func uploadMedia(
        data: Data,
        type: MediaType,
        runLogId: Int,
        privacy: MediaPrivacy
    ) async throws -> MediaItem {

        let payload = type == .photo
            ? compressImage(data)
            : data

        guard let url = URL(string: APIConfig.baseURL + "/media") else {
            throw WhitewaterError.serverError("Invalid media upload URL")
        }

        let boundary = UUID().uuidString
        var request  = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        if let token = api.authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let body = buildMultipartBody(
            fileData: payload,
            mediaType: type,
            runLogId: runLogId,
            privacy: privacy,
            boundary: boundary
        )

        uploadProgress = 0

        // URLSession upload task (async/await)
        let (responseData, response) = try await URLSession.shared.upload(for: request, from: body)

        uploadProgress = 1.0

        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw WhitewaterError.serverError("Media upload failed")
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601

        if let wrapped = try? decoder.decode(APIResponse<MediaItem>.self, from: responseData),
           let item = wrapped.data {
            return item
        }
        return try decoder.decode(MediaItem.self, from: responseData)
    }

    // MARK: - Delete

    func deleteMedia(id: Int) async throws {
        struct Empty: Codable {}
        _ = try await api.delete("/media/\(id)", responseType: Empty.self)
    }

    // MARK: - Image compression

    private func compressImage(_ data: Data) -> Data {
        guard let image = UIImage(data: data) else { return data }
        let resized = resizeIfNeeded(image)
        return resized.jpegData(compressionQuality: jpegQuality) ?? data
    }

    private func resizeIfNeeded(_ image: UIImage) -> UIImage {
        let size = image.size
        guard size.width > maxImageDimension || size.height > maxImageDimension else { return image }

        let scale   = min(maxImageDimension / size.width, maxImageDimension / size.height)
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)

        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }

    // MARK: - Multipart builder

    private func buildMultipartBody(
        fileData: Data,
        mediaType: MediaType,
        runLogId: Int,
        privacy: MediaPrivacy,
        boundary: String
    ) -> Data {
        var body = Data()
        let crlf = "\r\n"

        let mimeType = mediaType == .photo ? "image/jpeg" : "video/mp4"
        let filename = mediaType == .photo ? "photo.jpg"  : "video.mp4"

        // File part
        body += "--\(boundary)\(crlf)".utf8Data
        body += "Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\(crlf)".utf8Data
        body += "Content-Type: \(mimeType)\(crlf)\(crlf)".utf8Data
        body += fileData
        body += crlf.utf8Data

        // Metadata fields
        let fields: [(String, String)] = [
            ("runLogId", "\(runLogId)"),
            ("privacy",  privacy.rawValue),
            ("fileType", mediaType.rawValue)
        ]
        for (name, value) in fields {
            body += "--\(boundary)\(crlf)".utf8Data
            body += "Content-Disposition: form-data; name=\"\(name)\"\(crlf)\(crlf)".utf8Data
            body += "\(value)\(crlf)".utf8Data
        }

        body += "--\(boundary)--\(crlf)".utf8Data
        return body
    }
}

// MARK: - String → Data helper

private extension String {
    var utf8Data: Data { Data(utf8) }
}
