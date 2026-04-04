<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

class JWT {
    public static function encode(array $payload, int $expiry = null): string {
        $header = self::base64url_encode(json_encode(['alg' => 'HS256', 'typ' => 'JWT']));

        $now = time();
        $payload['iat'] = $now;
        $payload['exp'] = $now + ($expiry ?? JWT_EXPIRY);

        $body      = self::base64url_encode(json_encode($payload));
        $signature = self::base64url_encode(
            hash_hmac('sha256', "$header.$body", JWT_SECRET, true)
        );

        return "$header.$body.$signature";
    }

    /**
     * Decode a JWT token, returning null on any failure.
     */
    public static function decode(string $token): ?array {
        try {
            return self::verify($token);
        } catch (RuntimeException) {
            return null;
        }
    }

    /**
     * Verify and decode a JWT token, throwing on any failure.
     */
    public static function verify(string $token): array {
        $parts = explode('.', $token);
        if (count($parts) !== 3) {
            throw new RuntimeException('Malformed token');
        }

        [$header, $body, $signature] = $parts;

        $expectedSig = self::base64url_encode(
            hash_hmac('sha256', "$header.$body", JWT_SECRET, true)
        );

        if (!hash_equals($expectedSig, $signature)) {
            throw new RuntimeException('Invalid token signature');
        }

        $payload = json_decode(self::base64url_decode($body), true);
        if (!is_array($payload)) {
            throw new RuntimeException('Malformed token payload');
        }

        if (isset($payload['exp']) && $payload['exp'] < time()) {
            throw new RuntimeException('Token has expired');
        }

        return $payload;
    }

    private static function base64url_encode(string $data): string {
        return rtrim(strtr(base64_encode($data), '+/', '-_'), '=');
    }

    private static function base64url_decode(string $data): string {
        return base64_decode(strtr($data, '-_', '+/'));
    }
}
