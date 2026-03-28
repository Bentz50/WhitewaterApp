// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation

enum APIConfig {
    // TODO: Update with actual Hostinger domain
    static let baseURL      = "https://api.yourdomain.com/v1"
    static let usgBaseURL   = "https://waterservices.usgs.gov/nwis/iv/"
    static let noaaBaseURL  = "https://water.weather.gov/ahps2/hydrograph_to_xml.php"

    static let timeout: TimeInterval = 30.0
    static let maxRetries            = 2

    static let jwtStorageKey  = "ww_jwt_token"
    static let userStorageKey = "ww_current_user"

    /// Returns the Authorization header value using the current token from AuthService.
    /// Returns "Bearer " (with empty token) when no token is stored.
    static var authorizationHeader: String {
        "Bearer \(AuthService.shared.token ?? "")"
    }
}
