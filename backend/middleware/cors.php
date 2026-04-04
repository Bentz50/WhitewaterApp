<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

function applyCors(): void {
    $allowedOrigins = array_filter(
        array_map('trim', explode(',', getenv('ALLOWED_ORIGINS') ?: '')),
        fn(string $s) => $s !== ''
    );

    $origin = $_SERVER['HTTP_ORIGIN'] ?? '';

    if ($origin !== '' && !empty($allowedOrigins)) {
        if (in_array($origin, $allowedOrigins, true)) {
            header("Access-Control-Allow-Origin: $origin");
            header('Vary: Origin');
        }
        // If the origin is not in the allowlist, omit the header entirely.
    } elseif (empty($allowedOrigins)) {
        // No allowlist configured — allow all origins (development only).
        header('Access-Control-Allow-Origin: *');
    }

    header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With');
    header('Access-Control-Max-Age: 86400');

    if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
        http_response_code(204);
        exit;
    }
}
