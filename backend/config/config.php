<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

// Application configuration
define('JWT_SECRET', 'CHANGE_THIS_TO_A_RANDOM_SECRET_KEY_MIN_32_CHARS');
define('JWT_EXPIRY', 86400 * 7);          // 7 days
define('REFRESH_TOKEN_EXPIRY', 86400 * 30); // 30 days
define('APP_ENV', 'production');
define('MAX_FILE_SIZE', 10 * 1024 * 1024);   // 10 MB photos
define('MAX_VIDEO_SIZE', 100 * 1024 * 1024); // 100 MB video
define('UPLOAD_PATH', __DIR__ . '/../uploads/');
define('UPLOAD_URL', 'https://yourdomain.com/uploads/'); // TODO: update
define('RATE_LIMIT_REQUESTS', 100);
define('RATE_LIMIT_WINDOW', 3600); // per hour
define('USGS_BASE_URL', 'https://waterservices.usgs.gov/nwis/iv/');
define('NOAA_BASE_URL', 'https://water.weather.gov/ahps2/hydrograph_to_xml.php');
define('GAUGE_CACHE_TTL', 900);                     // 15 minutes
define('PUSH_CERT_PATH', __DIR__ . '/../certs/apns.pem');
define('APNS_TOPIC', 'com.bentztech.whitewaterapp');
