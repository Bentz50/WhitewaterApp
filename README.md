# WhitewaterApp

> **The ultimate iOS app for whitewater kayaking, canoeing, and rafting**

*© 2026 BentzTech LLC. All rights reserved.*

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         iOS Client                              │
│                    (SwiftUI · iOS 17+)                          │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────────┐   │
│  │  River   │  │  Run Log │  │  Social  │  │    Safety    │   │
│  │ Explorer │  │ Tracker  │  │   Feed   │  │  & Hazards   │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────────┘   │
│                       URLSession / REST                         │
└─────────────────────────────┬───────────────────────────────────┘
                              │ HTTPS / JSON
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Hostinger Server                           │
│                   (PHP 8.1+ · Apache)                           │
│   index.php → Router → Middleware → Controllers → Models        │
│                    PDO (prepared statements)                    │
│                    ┌───────────────────┐                        │
│                    │   MySQL 8.0+      │                        │
│                    │ InnoDB · utf8mb4  │                        │
│                    └───────────────────┘                        │
└──────────────────────────┬──────────────────────────────────────┘
              ┌────────────┼────────────┐
              ▼            ▼            ▼
       USGS Water      NOAA Gauges  Apple APNs
       Services API    (NWS API)    Push Notifications
```

---

## Features

- 🚣 **River Explorer** — Browse US whitewater sections with AW/KHCC ratings, real-time USGS/NOAA gauge data, runnable status, and GPS put-in/take-out coordinates
- 📍 **Run Log & GPS Tracking** — Live GPS track, distance, duration, calories, gauge levels at start/end, vessel & skills logging
- 🎯 **Skills Tracking** — 33 skills across 6 categories (Rolling, Surfing, Strokes, Safety, Attainment, Playboating)
- ⚠️ **Hazard Reporting** — Community-reported strainers, sieves, hydraulics, low-head dams with geo-pins and verification
- 🏆 **Achievements** — 14 unlockable achievements across Milestone, Distance, Social, Performance, and Skills categories
- 👥 **Crew & Social Feed** — Friend system, run log posts, likes, comments, direct messaging, privacy controls
- 📸 **Media** — Photo/video uploads per run with per-item privacy settings
- 📅 **Events** — Community calendar for races, festivals, dam releases, cleanups, and safety courses
- 🔔 **Push Notifications** — APNs alerts for crew requests, likes, comments, hazards, and achievements

---

## Tech Stack

| Layer | Technology |
|---|---|
| Mobile | SwiftUI, iOS 17+, Xcode 15+ |
| Networking | URLSession (async/await), Codable |
| Maps | MapKit, CoreLocation |
| Backend | PHP 8.1+, Apache |
| Database | MySQL 8.0+, InnoDB, utf8mb4 |
| Hosting | Hostinger (Business/Cloud) |
| Auth | Sign in with Apple / Google + JWT Bearer tokens |
| Push | Apple Push Notification Service (APNs HTTP/2) |
| Gauge Data | USGS Water Services API, NOAA NWS API |

---

## Project Structure

```
WhitewaterApp/
├── WhitewaterApp/                  # iOS Xcode project source
│   ├── App/
│   ├── Components/                 # Reusable SwiftUI components
│   ├── Config/
│   │   └── APIConfig.swift         # Base URL & JWT storage
│   ├── Extensions/                 # Swift extensions
│   ├── Models/                     # Codable data models
│   ├── Resources/                  # Asset catalogs & resources
│   ├── Views/                      # SwiftUI views & screens
│   ├── ViewModels/                 # ObservableObject view models
│   └── Services/                   # API service layer
├── WhitewaterApp.xcodeproj/
├── backend/
│   ├── migrations/                 # SQL migration files
│   ├── config/                     # DB + app config (not committed)
│   ├── controllers/                # Request handlers
│   ├── middleware/                  # Auth, CORS, rate limiting
│   ├── models/                     # Database models
│   ├── utils/                      # JWT, Response, Validator, etc.
│   ├── index.php                   # Entry point & router
│   ├── .htaccess
│   └── README.md                   # Backend setup guide
├── README.md
├── DEPLOYMENT.md                   # Full deployment guide
├── LICENSE
└── .gitignore
```

---

## Quick Start

### iOS

```bash
git clone https://github.com/BentzTech/WhitewaterApp.git
open WhitewaterApp.xcodeproj
```

Edit `WhitewaterApp/Config/APIConfig.swift` and set `baseURL` to match your deployment:
```swift
// If your backend is deployed at public_html/api/ (as described in DEPLOYMENT.md):
static let baseURL = "https://your-domain.com/api/v1"

// Or if using a subdomain that points directly to the backend:
// static let baseURL = "https://api.your-domain.com/v1"
```

Set your Apple Developer Team and Bundle ID (`com.bentztech.whitewaterapp`) in Xcode Signing & Capabilities, then run on iOS 17+ simulator or device.

### Backend

See **[backend/README.md](backend/README.md)** for the full Hostinger walkthrough.  
For end-to-end deployment see **[DEPLOYMENT.md](DEPLOYMENT.md)**.

---

## API Documentation

REST API versioned at `/api/v1`. Full endpoint reference in [backend/README.md](backend/README.md#api-endpoint-reference).

All authenticated requests require:
```
Authorization: Bearer <jwt_token>
Content-Type: application/json
```

---

## Prerequisites

| Requirement | Details |
|---|---|
| macOS | Ventura 13.5+ (Sonoma recommended) |
| Xcode | 15+ |
| iOS target | 17+ |
| Apple Developer | Required for device & App Store |
| PHP | 8.1+ (`pdo_mysql`, `json`, `mbstring`, `openssl`) |
| MySQL | 8.0+ |
| Hosting | Hostinger Business plan or above |

---

## License

Copyright © 2026 BentzTech LLC. All rights reserved.  
See [LICENSE](LICENSE) for details.  
WhitewaterApp™ is a trademark of BentzTech LLC.
