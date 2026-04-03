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
│   └── database.sql             # Complete DB schema + all seed data (single file)
├── config/
│   ├── database.php             # PDO connection singleton (Database class)
│   └── config.php               # App-wide constants (JWT secret, rate limits, etc.)
├── controllers/
│   ├── AuthController.php       # Apple & Google sign-in, token refresh
│   ├── UserController.php       # Profile, search, crew management
│   ├── RiverController.php      # River listing, search, sub-resources
│   ├── RunLogController.php     # Run log CRUD, skills, media, reports
│   ├── HazardController.php     # Hazard CRUD, verify, clear
│   ├── SocialController.php     # Feed, posts, comments, likes
│   ├── MessageController.php    # Direct messaging
│   ├── EventController.php      # Community events
│   ├── GaugeController.php      # USGS/NOAA gauge data & forecasts
│   ├── AchievementController.php
│   ├── NotificationController.php
│   ├── VesselController.php     # Boats/kayaks CRUD
│   ├── ClubController.php       # Club membership
│   └── SkillController.php      # Skill definitions & user defaults
├── middleware/
│   ├── auth.php                 # JWT validation (requireAuth / optionalAuth)
│   ├── cors.php                 # CORS headers & preflight handling
│   └── rate_limit.php           # IP-based rate limiting
├── models/
│   ├── User.php
│   ├── River.php
│   ├── RunLog.php
│   ├── Hazard.php
│   ├── Event.php
│   ├── Message.php
│   ├── Achievement.php
│   ├── Vessel.php
│   ├── Skill.php
│   ├── ClubMembership.php
│   ├── Comment.php
│   ├── Media.php
│   └── RiverVideo.php
├── utils/
│   ├── JWT.php                  # Lightweight JWT encode/decode
│   ├── Response.php             # Standardised JSON responses
│   ├── Validator.php            # Input validation & sanitization
│   ├── FileUpload.php           # Photo/video upload handling
│   └── GaugeProxy.php           # USGS/NOAA API proxy with caching
├── index.php                    # Entry point / front controller & router
└── .htaccess                    # URL rewriting + HTTPS redirect
```

---

## Configuration

### `config/database.php`

The actual file uses a **singleton `Database` class** — not plain `define()` constants.  
Edit the credentials directly in the class properties:

```php
<?php
class Database {
    private string $host     = 'localhost';          // Always localhost on Hostinger shared
    private string $db_name  = 'u123456789_whitewaterapp'; // Replace with your actual DB name
    private string $username = 'u123456789_whitewaterapp_user';
    private string $password = 'YOUR_STRONG_DB_PASSWORD';  // ← Change this
    private string $charset  = 'utf8mb4';

    private static ?Database $instance = null;
    private ?PDO $conn = null;

    private function __construct() {}

    public static function getInstance(): self {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    public function getConnection(): PDO {
        if ($this->conn !== null) {
            return $this->conn;
        }
        $dsn = "mysql:host={$this->host};dbname={$this->db_name};charset={$this->charset}";
        $options = [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ];
        try {
            $this->conn = new PDO($dsn, $this->username, $this->password, $options);
        } catch (PDOException $e) {
            error_log('Database connection failed: ' . $e->getMessage());
            Response::error('Database connection failed', 500);
            exit;
        }
        return $this->conn;
    }

    public function getConn(): PDO {
        return $this->getConnection();
    }
}
```

Controllers access the database via:
```php
$this->db = Database::getInstance()->getConn();
```

### `config/config.php`

```php
<?php
define('JWT_SECRET', 'CHANGE_THIS_TO_A_RANDOM_SECRET_KEY_MIN_32_CHARS'); // ← Change this
define('JWT_EXPIRY', 86400 * 7);               // Access token: 7 days
define('REFRESH_TOKEN_EXPIRY', 86400 * 30);    // Refresh token: 30 days
define('APP_ENV', 'production');                // 'development' | 'production'
define('MAX_FILE_SIZE', 10 * 1024 * 1024);     // 10 MB photos
define('MAX_VIDEO_SIZE', 100 * 1024 * 1024);   // 100 MB video
define('UPLOAD_PATH', __DIR__ . '/../uploads/');
define('UPLOAD_URL', 'https://your-domain.com/uploads/');  // ← Change this
define('RATE_LIMIT_REQUESTS', 100);
define('RATE_LIMIT_WINDOW', 3600);             // Per hour
define('USGS_BASE_URL', 'https://waterservices.usgs.gov/nwis/iv/');
define('NOAA_BASE_URL', 'https://water.weather.gov/ahps2/hydrograph_to_xml.php');
define('GAUGE_CACHE_TTL', 900);                // 15 minutes
define('PUSH_CERT_PATH', __DIR__ . '/../certs/apns.pem');
define('APNS_TOPIC', 'com.bentztech.whitewaterapp');
```

> **Never commit `config/database.php` or `config/config.php` with real credentials.**  
> Add them to `.gitignore` and set values directly on the server.

---

## Database Migration (phpMyAdmin)

1. In hPanel, go to **Hosting → Manage → Databases → phpMyAdmin** and click **Enter phpMyAdmin**.
2. In the left panel, select your database (e.g., `u123456789_whitewaterapp`).
3. Click the **Import** tab at the top.
4. Under **File to Import**, click **Choose File** and select `backend/migrations/database.sql`.
5. Ensure:
   - **Character set of the file:** `utf8mb4`
   - **Format:** SQL
6. Click **Go** at the bottom.
7. Verify all 25 tables appear in the left panel.
8. Confirm seed data by running:
   ```sql
   SELECT COUNT(*) FROM skills;       -- should be 33
   SELECT COUNT(*) FROM achievements; -- should be 14
   SELECT COUNT(*) FROM rivers;       -- should be 110
   ```

---

## API Endpoint Reference

All endpoints are prefixed with `/api/v1`.  
Authentication uses **Bearer JWT** in the `Authorization` header unless marked `[public]`.

> **Note:** This app uses **Sign in with Apple** and **Sign in with Google** — there is no email/password registration or login.

### Auth

| Method | Endpoint | Description |
|---|---|---|
| POST | `/auth/apple` | Sign in / register with Apple identity token `[public]` |
| POST | `/auth/google` | Sign in / register with Google ID token `[public]` |
| POST | `/auth/refresh` | Refresh JWT using a refresh token `[public]` |

### Users

| Method | Endpoint | Description |
|---|---|---|
| GET | `/users/me` | Get current user profile |
| PUT | `/users/me` | Update profile |
| POST | `/users/me/avatar` | Upload avatar image |
| GET | `/users/{id}` | Get public profile |
| GET | `/users/search?q=` | Search users by name/username |

### Crew (Friends)

| Method | Endpoint | Description |
|---|---|---|
| GET | `/crew` | List current user's crew members |
| POST | `/crew/{user_id}` | Send / accept crew request |
| DELETE | `/crew/{user_id}` | Remove crew member |

### Vessels (Boats)

| Method | Endpoint | Description |
|---|---|---|
| GET | `/vessels` | List current user's vessels |
| POST | `/vessels` | Create a new vessel |
| PUT | `/vessels/{id}` | Update vessel details |
| PUT | `/vessels/{id}/default` | Set vessel as default |
| DELETE | `/vessels/{id}` | Delete vessel |

### Clubs

| Method | Endpoint | Description |
|---|---|---|
| GET | `/clubs` | List clubs |
| POST | `/clubs` | Create a club |
| DELETE | `/clubs/{id}` | Delete a club |

### Rivers

| Method | Endpoint | Description |
|---|---|---|
| GET | `/rivers` | List rivers |
| GET | `/rivers/search?q=` | Search rivers |
| GET | `/rivers/{id}` | Get river detail |
| GET | `/rivers/{id}/gauge` | Get gauge data for a river |
| GET | `/rivers/{id}/hazards` | Get hazards on a river |
| GET | `/rivers/{id}/runs` | Get run logs for a river |
| GET | `/rivers/{id}/feed` | Get social feed for a river |
| GET | `/rivers/{id}/videos` | Get videos for a river |

### Runs (Run Logs)

| Method | Endpoint | Description |
|---|---|---|
| GET | `/runs/me` | List current user's runs |
| POST | `/runs` | Create a run log |
| GET | `/runs/{id}` | Get run log detail |
| PUT | `/runs/{id}` | Update run log |
| POST | `/runs/{id}/skills` | Log skills for a run |
| POST | `/runs/{id}/media` | Upload photo/video for a run |
| POST | `/runs/{id}/hazard-report` | Submit hazard report from a run |
| POST | `/runs/{id}/injury-report` | Submit injury report from a run |

### Hazards

| Method | Endpoint | Description |
|---|---|---|
| GET | `/hazards` | List hazards (filterable by query params) |
| POST | `/hazards` | Report a new hazard |
| PUT | `/hazards/{id}/verify` | Verify/confirm a hazard |
| PUT | `/hazards/{id}/clear` | Mark a hazard as cleared |

### Feed & Posts (Social)

| Method | Endpoint | Description |
|---|---|---|
| GET | `/feed` | Social feed (public + crew) |
| GET | `/feed/crew` | Crew-only feed |
| GET | `/posts/{id}/comments` | List comments on a post |
| POST | `/posts/{id}/comments` | Add a comment |
| POST | `/posts/{id}/like` | Like a post |

### Messages

| Method | Endpoint | Description |
|---|---|---|
| GET | `/messages` | List conversations |
| GET | `/messages/{user_id}` | Get message thread with a user |
| POST | `/messages/{user_id}` | Send a message to a user |

### Events

| Method | Endpoint | Description |
|---|---|---|
| GET | `/events` | List upcoming events |
| POST | `/events` | Create an event |

### Skills

| Method | Endpoint | Description |
|---|---|---|
| GET | `/skills` | List all skill definitions |
| GET | `/skills/defaults` | Get current user's default skills |
| PUT | `/skills/defaults` | Update current user's default skills |

### Gauges

| Method | Endpoint | Description |
|---|---|---|
| GET | `/gauges/{site_id}` | Get gauge reading by site ID |
| GET | `/gauges/{site_id}/forecast` | Get gauge forecast |

### Achievements

| Method | Endpoint | Description |
|---|---|---|
| GET | `/achievements/me` | Current user's unlocked achievements |
| GET | `/achievements/check` | Check for newly earned achievements |

### Notifications

| Method | Endpoint | Description |
|---|---|---|
| GET | `/notifications` | List notifications |
| PUT | `/notifications/{id}/read` | Mark notification as read |
| POST | `/notifications/dam-release` | Trigger dam-release notification |

---

## Security Checklist

- [ ] **Change JWT secret** — set a random 256-bit value in `config/config.php`; never use the placeholder
- [ ] **Change DB credentials** — update `$username` and `$password` in `config/database.php` with strong, unique values
- [ ] **Force HTTPS** — enable in hPanel SSL settings and in `.htaccess`
- [ ] **Disable directory listing** — `Options -Indexes` in `.htaccess`
- [ ] **Remove `migrations/` from `public_html`** — never expose SQL files publicly
- [ ] **Use prepared statements** — all database queries must use PDO with bound parameters (no raw interpolation)
- [ ] **Validate & sanitize all inputs** — check types, lengths, and enum values on every endpoint
- [ ] **Rate limiting is enabled by default** — configured via `RATE_LIMIT_REQUESTS` and `RATE_LIMIT_WINDOW` in `config.php`
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
- Confirm `$host` is `'localhost'` (not `'127.0.0.1'`) in `config/database.php` for shared hosting.
- Verify `$db_name`, `$username`, and `$password` match exactly what was created in hPanel.

### `SQLSTATE[42000]: Syntax error` on import
- Ensure the SQL file is saved in **UTF-8 without BOM**.
- Confirm phpMyAdmin character set is set to `utf8mb4`.

### JWT `401 Unauthorized` on every request
- Confirm the iOS app is sending the header: `Authorization: Bearer <token>`.
- Check that `JWT_SECRET` in `config/config.php` matches the value used to sign tokens.
- Access tokens expire after `JWT_EXPIRY` (7 days by default); call `/auth/refresh` to renew.

### Images/videos not uploading
- Check `upload_max_filesize` and `post_max_size` in PHP configuration (hPanel → PHP Configuration → Additional settings).
- Ensure the `uploads/` directory exists and is **writable** (`chmod 755`).
- Confirm `MAX_FILE_SIZE` and `MAX_VIDEO_SIZE` in `config/config.php` match the PHP limits.

### APNs push notifications not delivering
- Verify the `.p8` APNs key is uploaded to the server and the path is correct in config.
- Confirm `push_token` is being saved when the iOS app registers on launch.
- Check Apple's [APNs documentation](https://developer.apple.com/documentation/usernotifications) for token format requirements.
