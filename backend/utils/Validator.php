<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

class Validator {
    public static function email(string $email): bool {
        return (bool) filter_var($email, FILTER_VALIDATE_EMAIL);
    }

    /** Returns list of field names that are missing or empty. */
    public static function required(array $data, array $fields): array {
        $missing = [];
        foreach ($fields as $field) {
            if (!isset($data[$field]) || $data[$field] === '' || $data[$field] === null) {
                $missing[] = $field;
            }
        }
        return $missing;
    }

    public static function minLength(string $str, int $min): bool {
        return mb_strlen($str) >= $min;
    }

    public static function maxLength(string $str, int $max): bool {
        return mb_strlen($str) <= $max;
    }

    public static function isPositiveFloat($val): bool {
        return is_numeric($val) && (float) $val > 0;
    }

    public static function sanitizeString(string $str): string {
        return htmlspecialchars(trim($str), ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
    }

    public static function sanitizeInt($val): ?int {
        $filtered = filter_var($val, FILTER_VALIDATE_INT);
        return ($filtered === false) ? null : (int) $filtered;
    }

    public static function sanitizeFloat($val): ?float {
        $filtered = filter_var($val, FILTER_VALIDATE_FLOAT);
        return ($filtered === false) ? null : (float) $filtered;
    }

    public static function inArray($val, array $allowed): bool {
        return in_array($val, $allowed, true);
    }
}
