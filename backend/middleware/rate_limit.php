<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

function checkRateLimit(string $identifier): void {
    $key    = 'rate_limit_' . md5($identifier);
    $window = RATE_LIMIT_WINDOW;
    $limit  = RATE_LIMIT_REQUESTS;

    if (function_exists('apcu_fetch')) {
        $current = apcu_fetch($key, $success);
        if (!$success) {
            apcu_store($key, 1, $window);
            return;
        }
        if ((int) $current >= $limit) {
            Response::error('Rate limit exceeded', 429);
            exit;
        }
        apcu_inc($key);
        return;
    }

    // File-based fallback
    $dir  = __DIR__ . '/../rate_limit_data/';
    if (!is_dir($dir)) {
        mkdir($dir, 0700, true);
    }
    $file = $dir . $key . '.json';

    $data = ['count' => 0, 'reset_at' => time() + $window];
    if (file_exists($file)) {
        $stored = json_decode(file_get_contents($file), true);
        if (is_array($stored) && $stored['reset_at'] > time()) {
            $data = $stored;
        }
    }

    if ($data['count'] >= $limit) {
        Response::error('Rate limit exceeded', 429);
        exit;
    }

    $data['count']++;
    file_put_contents($file, json_encode($data), LOCK_EX);
}
