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

    public static function decode(string $token): ?array {
        $parts = explode('.', $token);
        if (count($parts) !== 3) {
            return null;
        }

        [$header, $body, $signature] = $parts;

        $expectedSig = self::base64url_encode(
            hash_hmac('sha256', "$header.$body", JWT_SECRET, true)
        );

        if (!hash_equals($expectedSig, $signature)) {
            return null;
        }

        $payload = json_decode(self::base64url_decode($body), true);
        if (!is_array($payload)) {
            return null;
        }

        if (isset($payload['exp']) && $payload['exp'] < time()) {
            return null;
        }

        return $payload;
    }

    public static function verify(string $token): array {
        $payload = self::decode($token);
        if ($payload === null) {
            throw new RuntimeException('Invalid or expired token');
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
