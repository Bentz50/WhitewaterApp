# WhitewaterApp — Backend

> PHP 8.1+ REST API hosted on Hostinger, backed by MySQL 8.0+

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Hostinger Setup (hPanel)](#hostinger-setup-hpanel)
3. [Directory Structure](#directory-structure)
4. [Configuration](#configuration)
5. [Database Migration (phpMyAdmin)](#database-migration-phpmyadmin)
6. [API Endpoint Reference](#api-endpoint-reference)
7. [Security Checklist](#security-checklist)
8. [Troubleshooting](#troubleshooting)

---

## Prerequisites

| Requirement | Minimum Version | Notes |
|---|---|---|
| PHP | 8.1 | Extensions: `pdo_mysql`, `json`, `mbstring`, `openssl` |
| MySQL | 8.0 | InnoDB engine, utf8mb4 charset |
| Hostinger plan | Business or above | Required for SSH access |
| Composer | 2.x | Dependency manager (optional for vanilla setup) |

---

## Hostinger Setup (hPanel)

### 1. Log in to hPanel

Navigate to [hpanel.hostinger.com](https://hpanel.hostinger.com) and log in with your credentials.

### 2. Create the MySQL Database

1. In the sidebar, go to **Hosting → Manage → Databases → MySQL Databases**.
2. Under **Create New Database**, enter:
   - **Database name:** `whitewaterapp` (Hostinger prepends your account prefix automatically)
   - **Username:** `whitewaterapp_user`
   - **Password:** Use a strong password (≥ 20 chars, mixed case, numbers, symbols)
3. Click **Create**. Note the full database name (e.g., `u123456789_whitewaterapp`), the username, and password.

### 3. Set the PHP Version

1. Go to **Hosting → Manage → PHP Configuration**.
2. Select **PHP 8.1** (or 8.2+) from the version dropdown.
3. Ensure the following extensions are enabled:
   - `pdo_mysql`
   - `json`
   - `mbstring`
   - `openssl`
   - `fileinfo`
4. Click **Save**.

### 4. Upload Backend Files

**Option A — File Manager:**
1. Go to **Hosting → Manage → File Manager**.
2. Navigate to `public_html/` (or create a subdirectory such as `public_html/api/`).
3. Upload the contents of the `backend/` directory (excluding `migrations/`).

**Option B — FTP/SFTP:**
1. Go to **Hosting → Manage → FTP Accounts** to get your FTP credentials.
2. Connect with FileZilla or your preferred client.
3. Upload `backend/` contents to `public_html/api/`.

**Option C — SSH (Business plan+):**
```bash
ssh u123456789@your-domain.com
cd public_html
mkdir api && cd api
# then SCP or git clone
scp -r ./backend/* u123456789@your-domain.com:~/public_html/api/
```

### 5. Enable SSL (HTTPS)

1. Go to **Hosting → Manage → SSL**.
2. Click **Install** next to your domain to enable the free Let's Encrypt certificate.
3. Enable **Force HTTPS** to redirect all HTTP traffic to HTTPS.

### 6. Configure `.htaccess` (if not already present)

Place the following in `public_html/api/.htaccess` to route all requests through `index.php`:

```apache
Options -Indexes
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ index.php [QSA,L]

# Force HTTPS
RewriteCond %{HTTPS} off
RewriteRule ^ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
```

---

## Directory Structure

```
backend/
├── migrations/
│   └── 001_initial_schema.sql   # Full DB schema + seed data
├── config/
│   ├── database.php             # PDO connection singleton
│   └── config.php               # App-wide constants (JWT secret, CORS, etc.)
├── controllers/
│   ├── AuthController.php
│   ├── UserController.php
│   ├── RiverController.php
│   ├── RunLogController.php
│   ├── HazardController.php
│   ├── PostController.php
│   ├── MessageController.php
│   ├── EventController.php
│   └── GaugeController.php
├── middleware/
│   ├── AuthMiddleware.php       # JWT validation
│   └── CorsMiddleware.php
├── models/
│   ├── User.php
│   ├── River.php
│   ├── RunLog.php
│   └── ...
├── helpers/
│   ├── JWT.php                  # Lightweight JWT encode/decode
│   ├── Response.php             # Standardised JSON responses
│   └── Validator.php
├── routes/
│   └── api.php                  # Route definitions
├── index.php                    # Entry point / front controller
└── .htaccess                    # URL rewriting + HTTPS redirect
```

---

## Configuration

### `config/database.php`

```php
<?php
define('DB_HOST', 'localhost');          // Always localhost on Hostinger shared
define('DB_NAME', 'u123456789_whitewaterapp'); // Replace with your actual DB name
define('DB_USER', 'u123456789_whitewaterapp_user');
define('DB_PASS', 'YOUR_STRONG_DB_PASSWORD');  // ← Change this
define('DB_CHARSET', 'utf8mb4');

function getDB(): PDO {
    static $pdo = null;
    if ($pdo === null) {
        $dsn = 'mysql:host=' . DB_HOST . ';dbname=' . DB_NAME . ';charset=' . DB_CHARSET;
        $pdo = new PDO($dsn, DB_USER, DB_PASS, [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ]);
    }
    return $pdo;
}
```

### `config/config.php`

```php
<?php
define('JWT_SECRET', 'REPLACE_WITH_RANDOM_256BIT_SECRET'); // ← Change this
define('JWT_EXPIRY_SECONDS', 86400 * 30);                  // 30 days
define('APP_ENV', 'production');                            // 'development' | 'production'
define('CORS_ALLOWED_ORIGINS', ['https://your-domain.com']);
define('UPLOAD_MAX_MB', 20);
define('API_VERSION', '1.0.0');
```

> **Never commit `config/database.php` or `config/config.php` with real credentials.**  
> Add them to `.gitignore` and set values directly on the server.

---

## Database Migration (phpMyAdmin)

1. In hPanel, go to **Hosting → Manage → Databases → phpMyAdmin** and click **Enter phpMyAdmin**.
2. In the left panel, select your database (e.g., `u123456789_whitewaterapp`).
3. Click the **Import** tab at the top.
4. Under **File to Import**, click **Choose File** and select `backend/migrations/001_initial_schema.sql`.
5. Ensure:
   - **Character set of the file:** `utf8mb4`
   - **Format:** SQL
6. Click **Go** at the bottom.
7. Verify all 25 tables appear in the left panel.
8. Confirm seed data by running:
   ```sql
   SELECT COUNT(*) FROM skills;       -- should be 33
   SELECT COUNT(*) FROM achievements; -- should be 14
   SELECT COUNT(*) FROM rivers;       -- should be 5
   ```

---

## API Endpoint Reference

All endpoints are prefixed with `/api/v1`.  
Authentication uses **Bearer JWT** in the `Authorization` header unless marked `[public]`.

### Auth

| Method | Endpoint | Description |
|---|---|---|
| POST | `/auth/register` | Register new user `[public]` |
| POST | `/auth/login` | Login, returns JWT `[public]` |
| POST | `/auth/logout` | Invalidate token |
| POST | `/auth/refresh` | Refresh JWT |
| POST | `/auth/forgot-password` | Send reset email `[public]` |
| POST | `/auth/reset-password` | Reset with token `[public]` |

### Users

| Method | Endpoint | Description |
|---|---|---|
| GET | `/users/me` | Get current user profile |
| PUT | `/users/me` | Update profile |
| POST | `/users/me/avatar` | Upload avatar |
| GET | `/users/{id}` | Get public profile |
| GET | `/users/search?q=` | Search users |
| POST | `/users/me/push-token` | Register APNs push token |

### Crew (Friends)

| Method | Endpoint | Description |
|---|---|---|
| GET | `/crew` | List crew members |
| POST | `/crew/request` | Send crew request |
| PUT | `/crew/{id}/accept` | Accept crew request |
| DELETE | `/crew/{id}` | Remove crew member |

### Rivers

| Method | Endpoint | Description |
|---|---|---|
| GET | `/rivers` | List/search rivers `[public]` |
| GET | `/rivers/{id}` | Get river detail `[public]` |
| GET | `/rivers/nearby?lat=&lng=&radius=` | Rivers near coordinates `[public]` |
| POST | `/rivers` | Create river (admin) |
| PUT | `/rivers/{id}` | Update river (admin) |

### Run Logs

| Method | Endpoint | Description |
|---|---|---|
| GET | `/run-logs` | List current user's runs |
| POST | `/run-logs` | Create run log |
| GET | `/run-logs/{id}` | Get run log detail |
| PUT | `/run-logs/{id}` | Update run log |
| DELETE | `/run-logs/{id}` | Delete run log |
| POST | `/run-logs/{id}/skills` | Update skills for run |

### Hazards

| Method | Endpoint | Description |
|---|---|---|
| GET | `/hazards?river_id=` | List hazards for river `[public]` |
| POST | `/hazards` | Report new hazard |
| POST | `/hazards/{id}/verify` | Verify/update hazard status |

### Posts & Social

| Method | Endpoint | Description |
|---|---|---|
| GET | `/feed` | Social feed (crew + public) |
| POST | `/posts` | Create post |
| GET | `/posts/{id}` | Get post |
| DELETE | `/posts/{id}` | Delete post |
| POST | `/posts/{id}/like` | Like post |
| DELETE | `/posts/{id}/like` | Unlike post |
| GET | `/posts/{id}/comments` | List comments |
| POST | `/posts/{id}/comments` | Add comment |
| DELETE | `/comments/{id}` | Delete comment |

### Messages

| Method | Endpoint | Description |
|---|---|---|
| GET | `/messages` | List conversations |
| GET | `/messages/{user_id}` | Get thread with user |
| POST | `/messages` | Send message |
| PUT | `/messages/{id}/read` | Mark as read |

### Events

| Method | Endpoint | Description |
|---|---|---|
| GET | `/events` | List upcoming events `[public]` |
| GET | `/events/{id}` | Get event detail `[public]` |
| POST | `/events` | Create event |

### Gauge Data

| Method | Endpoint | Description |
|---|---|---|
| GET | `/gauge/{site_id}?source=usgs` | Get gauge reading `[public]` |
| GET | `/rivers/{id}/gauge` | Get gauge for river `[public]` |

### Achievements & Notifications

| Method | Endpoint | Description |
|---|---|---|
| GET | `/achievements` | List all achievements `[public]` |
| GET | `/users/me/achievements` | Current user's unlocked achievements |
| GET | `/notifications` | List notifications |
| PUT | `/notifications/{id}/read` | Mark notification read |
| PUT | `/notifications/read-all` | Mark all read |

---

## Security Checklist

- [ ] **Change JWT secret** — set a random 256-bit value in `config/config.php`; never use the placeholder
- [ ] **Change DB password** — use a strong, unique password; do not reuse credentials
- [ ] **Restrict CORS** — update `CORS_ALLOWED_ORIGINS` to only your iOS app's domain / bundle ID origin
- [ ] **Force HTTPS** — enable in hPanel SSL settings and in `.htaccess`
- [ ] **Disable directory listing** — `Options -Indexes` in `.htaccess`
- [ ] **Remove `migrations/` from `public_html`** — never expose SQL files publicly
- [ ] **Use prepared statements** — all database queries must use PDO with bound parameters (no raw interpolation)
- [ ] **Validate & sanitize all inputs** — check types, lengths, and enum values on every endpoint
- [ ] **Rate-limit `/auth/login`** — prevent brute-force attacks (e.g., 10 attempts / minute per IP)
- [ ] **Set `APP_ENV=production`** — disables verbose error output
- [ ] **Rotate JWT secret periodically** — all active sessions will require re-login after rotation
- [ ] **Enable MySQL SSL** — if Hostinger plan supports remote DB connections with TLS

---

## Troubleshooting

### `500 Internal Server Error` on all requests
- Check PHP version is 8.1+ in hPanel → PHP Configuration.
- Verify `.htaccess` is present and `mod_rewrite` is enabled.
- Check PHP error log: hPanel → **Logs → Error Logs**.

### `SQLSTATE[HY000] [2002] Connection refused`
- Confirm `DB_HOST` is `localhost` (not `127.0.0.1`) for shared hosting.
- Verify database name, username, and password match exactly what was created in hPanel.

### `SQLSTATE[42000]: Syntax error` on import
- Ensure the SQL file is saved in **UTF-8 without BOM**.
- Confirm phpMyAdmin character set is set to `utf8mb4`.

### JWT `401 Unauthorized` on every request
- Confirm the iOS app is sending the header: `Authorization: Bearer <token>`.
- Check that `JWT_SECRET` in `config.php` matches the value used to sign tokens.
- Tokens expire after `JWT_EXPIRY_SECONDS`; call `/auth/refresh` to renew.

### Images/videos not uploading
- Check `upload_max_filesize` and `post_max_size` in PHP configuration (hPanel → PHP Configuration → Additional settings).
- Ensure the `uploads/` directory exists and is **writable** (`chmod 755`).
- Confirm `UPLOAD_MAX_MB` in `config.php` matches the PHP limits.

### APNs push notifications not delivering
- Verify the `.p8` APNs key is uploaded to the server and the path is correct in config.
- Confirm `push_token` is being saved when the iOS app registers on launch.
- Check Apple's [APNs documentation](https://developer.apple.com/documentation/usernotifications) for token format requirements.
