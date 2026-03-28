<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

function requireAuth(): array {
    $header = $_SERVER['HTTP_AUTHORIZATION']
        ?? $_SERVER['REDIRECT_HTTP_AUTHORIZATION']
        ?? '';

    if (strncasecmp($header, 'Bearer ', 7) === 0) {
        $token = substr($header, 7);
    } else {
        Response::error('Unauthorized', 401);
        exit; // unreachable but satisfies static analysis
    }

    try {
        return JWT::verify($token);
    } catch (RuntimeException $e) {
        Response::error('Unauthorized', 401);
        exit;
    }
}

function optionalAuth(): ?array {
    $header = $_SERVER['HTTP_AUTHORIZATION']
        ?? $_SERVER['REDIRECT_HTTP_AUTHORIZATION']
        ?? '';

    if (strncasecmp($header, 'Bearer ', 7) !== 0) {
        return null;
    }

    $token = substr($header, 7);
    try {
        return JWT::verify($token);
    } catch (RuntimeException $e) {
        return null;
    }
}
