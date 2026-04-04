<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

/**
 * Check rate limit for a request.
 *
 * @param string $identifier  Unique caller identifier (e.g. IP address).
 * @param string $endpoint    Optional endpoint category for per-route limits.
 * @param int|null $authUserId Authenticated user ID (used to scope limits per-user when available).
 */
function checkRateLimit(string $identifier, string $endpoint = 'default', ?int $authUserId = null): void {
    // Build a key scoped to user when available, falling back to IP.
    $scope = $authUserId !== null ? "user_{$authUserId}" : "ip_{$identifier}";
    $key   = 'rate_limit_' . md5($scope . ':' . $endpoint);

    // Per-endpoint limits
    $limits = [
        'auth'    => ['requests' => RATE_LIMIT_AUTH,     'window' => RATE_LIMIT_WINDOW],
        'default' => ['requests' => RATE_LIMIT_REQUESTS, 'window' => RATE_LIMIT_WINDOW],
    ];
    $config = $limits[$endpoint] ?? $limits['default'];
    $window = $config['window'];
    $limit  = $config['requests'];

    if (function_exists('apcu_fetch')) {
        $current = apcu_fetch($key, $success);
        if (!$success) {
            apcu_store($key, 1, $window);
            return;
        }
        if ((int) $current >= $limit) {
            header("Retry-After: $window");
            Response::error('Rate limit exceeded', 429);
            exit;
        }
        apcu_inc($key);
        return;
    }

    // File-based fallback (with LOCK_EX to reduce race conditions)
    $dir = sys_get_temp_dir() . '/wwa_rate_limit/';
    if (!is_dir($dir) && !mkdir($dir, 0700, true)) {
        return; // cannot enforce — fail open
    }
    $file = $dir . $key . '.json';

    $data = ['count' => 0, 'reset_at' => time() + $window];
    if (file_exists($file)) {
        $stored = json_decode((string) file_get_contents($file), true);
        if (is_array($stored) && ($stored['reset_at'] ?? 0) > time()) {
            $data = $stored;
        }
    }

    if ($data['count'] >= $limit) {
        header("Retry-After: " . max(0, $data['reset_at'] - time()));
        Response::error('Rate limit exceeded', 429);
        exit;
    }

    $data['count']++;
    file_put_contents($file, json_encode($data), LOCK_EX);
}
