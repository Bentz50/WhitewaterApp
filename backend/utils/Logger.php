<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

/**
 * Simple structured logger that writes to PHP's error_log.
 *
 * Usage:
 *   Logger::info('User logged in', ['user_id' => 42]);
 *   Logger::error('Failed to fetch gauge', ['site_id' => '01234567', 'error' => $e->getMessage()]);
 */
class Logger {
    private const LEVEL_DEBUG   = 'DEBUG';
    private const LEVEL_INFO    = 'INFO';
    private const LEVEL_WARNING = 'WARNING';
    private const LEVEL_ERROR   = 'ERROR';

    public static function debug(string $message, array $context = []): void {
        self::log(self::LEVEL_DEBUG, $message, $context);
    }

    public static function info(string $message, array $context = []): void {
        self::log(self::LEVEL_INFO, $message, $context);
    }

    public static function warning(string $message, array $context = []): void {
        self::log(self::LEVEL_WARNING, $message, $context);
    }

    public static function error(string $message, array $context = []): void {
        self::log(self::LEVEL_ERROR, $message, $context);
    }

    private static function log(string $level, string $message, array $context): void {
        $entry = sprintf(
            '[%s] [%s] %s%s',
            date('Y-m-d H:i:s'),
            $level,
            $message,
            $context ? ' ' . json_encode($context, JSON_UNESCAPED_SLASHES) : ''
        );
        error_log($entry);
    }
}
