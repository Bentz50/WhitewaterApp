# WhitewaterApp — Deployment Guide

*© 2026 BentzTech LLC. All rights reserved.*

---

## Part A: Hostinger Setup

### A1. Create the MySQL Database
1. Log in to [hpanel.hostinger.com](https://hpanel.hostinger.com).
2. Go to **Hosting → Manage → Databases → MySQL Databases**.
3. Create a new database (e.g., `u123456789_whitewaterapp`), a dedicated user, and a strong password.
4. Note all three values — you'll need them in `config/database.php`.

### A2. Upload Backend Files
**Via File Manager:**
1. Go to **Hosting → Manage → File Manager**.
2. Navigate to `public_html/` and create an `api/` subdirectory.
3. Upload all files from `backend/` (excluding `migrations/`) into `public_html/api/`.

**Via SFTP:**
```bash
sftp u123456789@your-domain.com
cd public_html/api
put -r backend/* .
```

**Via SSH (Business plan+):**
```bash
ssh u123456789@your-domain.com
cd ~/public_html/api
git clone https://github.com/BentzTech/WhitewaterApp.git .
```

### A3. Set PHP Version
1. Go to **Hosting → Manage → PHP Configuration**.
2. Select **PHP 8.1** or newer.
3. Enable extensions: `pdo_mysql`, `json`, `mbstring`, `openssl`, `fileinfo`.
4. Click **Save**.

### A4. Configure the Application
Create `public_html/api/config/database.php`:
```php
<?php
define('DB_HOST', 'localhost');
define('DB_NAME', 'u123456789_whitewaterapp');
define('DB_USER', 'u123456789_whitewaterapp_user');
define('DB_PASS', 'YOUR_STRONG_DB_PASSWORD');
define('DB_CHARSET', 'utf8mb4');
```

Create `public_html/api/config/config.php`:
```php
<?php
define('JWT_SECRET', 'REPLACE_WITH_RANDOM_256BIT_SECRET');
define('JWT_EXPIRY_SECONDS', 86400 * 30);
define('APP_ENV', 'production');
define('CORS_ALLOWED_ORIGINS', ['https://your-domain.com']);
```

> **These files must NOT be committed to version control.**

### A5. Import the Database Schema (phpMyAdmin)
1. In hPanel go to **Databases → phpMyAdmin → Enter phpMyAdmin**.
2. Select your database in the left panel.
3. Click **Import → Choose File** and select `backend/migrations/001_initial_schema.sql`.
4. Set charset to `utf8mb4`, format to `SQL`, then click **Go**.
5. Verify: 25 tables, 33 skills rows, 14 achievements rows, 5 rivers rows.

### A6. Enable SSL / HTTPS
1. Go to **Hosting → Manage → SSL**.
2. Click **Install** to activate the free Let's Encrypt certificate.
3. Enable **Force HTTPS**.

### A7. Verify Deployment
```bash
curl -s https://your-domain.com/api/v1/rivers | python3 -m json.tool
```
Expected: a JSON array of river objects.

---

## Part B: iOS App Configuration

### B1. Open the Project in Xcode
```bash
open WhitewaterApp.xcodeproj
```

### B2. Set Bundle ID and Team
1. Select the `WhitewaterApp` target → **Signing & Capabilities**.
2. Set **Team** to your Apple Developer account.
3. Confirm **Bundle Identifier**: `com.bentztech.whitewaterapp`.

### B3. Set the API Base URL
Edit `WhitewaterApp/Config/APIConfig.swift`:
```swift
enum APIConfig {
    static let baseURL = "https://your-domain.com/api/v1"
}
```

### B4. Enable Required Capabilities
In **Signing & Capabilities**, add:
- **Push Notifications** — for APNs alerts
- **Background Modes** → check **Location updates** (for GPS run tracking)
- **Maps** (if using MapKit entitlements)

### B5. Configure APNs (Push Notifications)
1. In [developer.apple.com](https://developer.apple.com) → **Certificates, Identifiers & Profiles** → **Keys**, create an APNs key (`.p8`).
2. Download and upload the `.p8` file to the server at a non-public path (e.g., `~/certs/apns.p8`).
3. Note the **Key ID** and your **Team ID**.
4. Add to `config/config.php`:
   ```php
   define('APNS_KEY_PATH', '/home/u123456789/certs/apns.p8');
   define('APNS_KEY_ID',   'YOUR_KEY_ID');
   define('APNS_TEAM_ID',  'YOUR_TEAM_ID');
   define('APNS_BUNDLE_ID','com.bentztech.whitewaterapp');
   ```

### B6. Build and Test
1. Select an **iOS 17+ simulator** or a connected device.
2. Press **⌘R** to build and run.
3. Confirm the app launches, can register/login, and fetches river data.

---

## Part C: App Store Submission

### C1. App Store Connect Setup
1. Go to [appstoreconnect.apple.com](https://appstoreconnect.apple.com) → **My Apps → +** → **New App**.
2. Fill in:
   - **Name:** WhitewaterApp
   - **Bundle ID:** `com.bentztech.whitewaterapp`
   - **SKU:** `whitewaterapp-ios-001`
   - **Primary Language:** English (U.S.)

### C2. App Metadata
Complete all required fields:
- **Description** — highlight real-time gauges, GPS tracking, hazard alerts, crew features
- **Keywords** — kayaking, rafting, canoeing, whitewater, river, paddle, gauge
- **Support URL** — your support page or email
- **Privacy Policy URL** — required for location and health data
- **Age Rating** — complete the questionnaire (likely 4+)
- **Category** — Sports (primary), Navigation (secondary)

### C3. Screenshots
Prepare screenshots for all required device sizes:
| Device | Resolution |
|---|---|
| iPhone 6.9" (15 Pro Max) | 1320 × 2868 px |
| iPhone 6.5" (14 Plus) | 1284 × 2778 px |
| iPhone 5.5" (8 Plus) | 1242 × 2208 px |
| iPad Pro 13" | 2064 × 2752 px |
| iPad Pro 11" | 1668 × 2388 px |

Recommended screens: River Explorer map, Run Log tracking, Social Feed, Hazard Report, Achievement unlock.

### C4. TestFlight (Beta Testing)
1. In Xcode: **Product → Archive**.
2. In the Organizer, click **Distribute App → App Store Connect → Upload**.
3. In App Store Connect → **TestFlight**, add internal testers (up to 100).
4. For external testing, submit for Beta App Review.

### C5. App Review Submission
1. On the app version page, click **Add for Review**.
2. Provide demo account credentials in the **Notes for Reviewer** field.
3. Ensure location permission usage strings are set in `Info.plist`:
   - `NSLocationWhenInUseUsageDescription`
   - `NSLocationAlwaysAndWhenInUseUsageDescription`
4. Submit and expect 24–48 hour review time.

---

## Part D: Ongoing Maintenance

### D1. Database Backups
1. In hPanel → **Databases → phpMyAdmin**, use **Export → Quick → Go** weekly.
2. Alternatively, set up automated backups: hPanel → **Backups → Schedule**.
3. Store off-site copies (e.g., Dropbox, S3) monthly.

### D2. Server Monitoring
- Check **hPanel → Logs → Error Logs** regularly for PHP errors.
- Set up an uptime monitor (e.g., UptimeRobot free tier) pointing to `https://your-domain.com/api/v1/rivers`.
- Monitor MySQL slow query log for performance issues.

### D3. SSL Certificate Renewal
Let's Encrypt certificates auto-renew via hPanel. Verify expiry monthly under **Hosting → SSL**.

### D4. APNs Key Rotation
APNs `.p8` keys do not expire, but if compromised:
1. Revoke the old key in Apple Developer Portal.
2. Generate and upload a new `.p8` key.
3. Update `APNS_KEY_PATH` and `APNS_KEY_ID` in `config/config.php`.

### D5. JWT Secret Rotation
To rotate the JWT secret:
1. Update `JWT_SECRET` in `config/config.php`.
2. All users will be signed out on their next API call — they will need to log in again.
3. Announce maintenance downtime if needed.

### D6. App Updates
1. Increment `CFBundleShortVersionString` (marketing version) and `CFBundleVersion` (build number) in `Info.plist`.
2. Archive and upload via Xcode Organizer.
3. Create a new version in App Store Connect with release notes.
4. Run through TestFlight before submitting for review.

### D7. Analytics & Crash Reporting
Consider integrating (post-launch):
- **Firebase Crashlytics** — free crash reporting
- **App Store Connect Analytics** — downloads, sessions, crashes, retention (built-in, no SDK required)
- Custom dashboard querying the MySQL `run_logs` and `users` tables for usage metrics
