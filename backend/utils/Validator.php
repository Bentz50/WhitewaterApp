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

    /** Validates a value is between $min and $max (inclusive). */
    public static function between($val, $min, $max): bool {
        if (!is_numeric($val)) {
            return false;
        }
        $v = (float) $val;
        return $v >= $min && $v <= $max;
    }

    /** Validates a string as a well-formed URL. */
    public static function url(string $url): bool {
        return (bool) filter_var($url, FILTER_VALIDATE_URL);
    }

    /** Validates a date string against a given format (default: Y-m-d). */
    public static function dateFormat(string $str, string $format = 'Y-m-d'): bool {
        $d = \DateTime::createFromFormat($format, $str);
        return $d !== false && $d->format($format) === $str;
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

    /**
     * Validate multiple fields at once.
     *
     * Each rule is an associative array of field => rule-string.
     * Supported rules (pipe-separated): required, email, url, min:{n}, max:{n}, between:{min},{max}, date:{format}
     *
     * Returns an array of ['field' => ['error message', ...]] or empty array if valid.
     *
     * Example:
     *   Validator::validate($data, [
     *       'email'      => 'required|email',
     *       'title'      => 'required|max:255',
     *       'event_date' => 'required|date:Y-m-d',
     *       'lat'        => 'between:-90,90',
     *   ]);
     */
    public static function validate(array $data, array $rules): array {
        $errors = [];

        foreach ($rules as $field => $ruleString) {
            $fieldRules = explode('|', $ruleString);
            $value = $data[$field] ?? null;

            foreach ($fieldRules as $rule) {
                $params = [];
                if (str_contains($rule, ':')) {
                    [$rule, $paramStr] = explode(':', $rule, 2);
                    $params = explode(',', $paramStr);
                }

                $error = self::applyRule($field, $value, $rule, $params);
                if ($error !== null) {
                    $errors[$field][] = $error;
                }
            }
        }

        return $errors;
    }

    private static function applyRule(string $field, $value, string $rule, array $params): ?string {
        switch ($rule) {
            case 'required':
                if ($value === null || $value === '') {
                    return "$field is required";
                }
                break;
            case 'email':
                if ($value !== null && $value !== '' && !self::email((string) $value)) {
                    return "$field must be a valid email";
                }
                break;
            case 'url':
                if ($value !== null && $value !== '' && !self::url((string) $value)) {
                    return "$field must be a valid URL";
                }
                break;
            case 'min':
                if ($value !== null && $value !== '' && !self::minLength((string) $value, (int) $params[0])) {
                    return "$field must be at least {$params[0]} characters";
                }
                break;
            case 'max':
                if ($value !== null && $value !== '' && !self::maxLength((string) $value, (int) $params[0])) {
                    return "$field must be at most {$params[0]} characters";
                }
                break;
            case 'between':
                if ($value !== null && $value !== '' && !self::between($value, (float) $params[0], (float) $params[1])) {
                    return "$field must be between {$params[0]} and {$params[1]}";
                }
                break;
            case 'date':
                $format = $params[0] ?? 'Y-m-d';
                if ($value !== null && $value !== '' && !self::dateFormat((string) $value, $format)) {
                    return "$field must be a valid date ($format)";
                }
                break;
        }
        return null;
    }
}
