<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

require_once __DIR__ . '/../models/User.php';

class AuthController {
    private PDO $db;

    /** Cached Apple public keys (JWK set) */
    private ?array $appleKeys = null;

    public function __construct() {
        $this->db = Database::getInstance()->getConn();
    }

    // ── Sign in with Apple ───────────────────────────────────────────

    public function apple(array $body): void {
        $missing = Validator::required($body, ['identity_token']);
        if ($missing) {
            Response::error('Missing required fields', 400, $missing);
        }

        $claims = $this->verifyAppleToken($body['identity_token']);
        if (!$claims) {
            Response::error('Invalid Apple identity token', 401);
        }

        $appleUserId = $claims['sub'] ?? null;
        if (!$appleUserId) {
            Response::error('Apple token missing subject', 401);
        }

        $email = $claims['email'] ?? ($body['email'] ?? null);
        if ($email !== null) {
            $email = strtolower(trim($email));
        }

        $fullName = $body['full_name'] ?? null;
        $displayName = null;
        if (is_array($fullName)) {
            $parts = array_filter([
                $fullName['given_name'] ?? '',
                $fullName['family_name'] ?? '',
            ]);
            $displayName = implode(' ', $parts);
        } elseif (is_string($fullName) && $fullName !== '') {
            $displayName = $fullName;
        }

        $user = User::findByAppleId($this->db, $appleUserId);

        if ($user) {
            // Returning user – update email/name if newly provided
            $updates = [];
            if ($email && empty($user['email'])) {
                $updates['email'] = $email;
            }
            if ($displayName && $user['display_name'] === $user['username']) {
                $updates['display_name'] = Validator::sanitizeString($displayName);
            }
            if ($updates) {
                User::update($this->db, (int) $user['id'], $updates);
                $user = User::findById($this->db, (int) $user['id']);
            }

            $this->issueTokens($user);
            return;
        }

        // Check if an existing account shares this email
        if ($email) {
            $existing = User::findByEmail($this->db, $email);
            if ($existing) {
                // Link Apple ID to existing account
                $stmt = $this->db->prepare(
                    'UPDATE users SET apple_id = :aid, auth_provider = :prov, updated_at = NOW() WHERE id = :id'
                );
                $stmt->execute([':aid' => $appleUserId, ':prov' => 'apple', ':id' => $existing['id']]);
                $user = User::findById($this->db, (int) $existing['id']);
                $this->issueTokens($user, true);
                return;
            }
        }

        // New user
        $username = $this->generateUsername($displayName, $email);
        $userId = User::create($this->db, [
            'username'      => $username,
            'email'         => $email,
            'display_name'  => $displayName ? Validator::sanitizeString($displayName) : $username,
            'apple_id'      => $appleUserId,
            'auth_provider' => 'apple',
        ]);

        $user = User::findById($this->db, $userId);
        $this->issueTokens($user, true, 201);
    }

    // ── Sign in with Google ──────────────────────────────────────────

    public function google(array $body): void {
        $missing = Validator::required($body, ['id_token']);
        if ($missing) {
            Response::error('Missing required fields', 400, $missing);
        }

        $claims = $this->verifyGoogleToken($body['id_token']);
        if (!$claims) {
            Response::error('Invalid Google ID token', 401);
        }

        $googleUserId = $claims['sub'] ?? null;
        if (!$googleUserId) {
            Response::error('Google token missing subject', 401);
        }

        $email = $claims['email'] ?? null;
        if ($email !== null) {
            $email = strtolower(trim($email));
        }

        $displayName = $claims['name'] ?? null;

        $user = User::findByGoogleId($this->db, $googleUserId);

        if ($user) {
            $this->issueTokens($user);
            return;
        }

        // Check if an existing account shares this email
        if ($email) {
            $existing = User::findByEmail($this->db, $email);
            if ($existing) {
                $stmt = $this->db->prepare(
                    'UPDATE users SET google_id = :gid, auth_provider = :prov, updated_at = NOW() WHERE id = :id'
                );
                $stmt->execute([':gid' => $googleUserId, ':prov' => 'google', ':id' => $existing['id']]);
                $user = User::findById($this->db, (int) $existing['id']);
                $this->issueTokens($user, true);
                return;
            }
        }

        // New user
        $username = $this->generateUsername($displayName, $email);
        $userId = User::create($this->db, [
            'username'      => $username,
            'email'         => $email,
            'display_name'  => $displayName ? Validator::sanitizeString($displayName) : $username,
            'google_id'     => $googleUserId,
            'auth_provider' => 'google',
        ]);

        $user = User::findById($this->db, $userId);
        $this->issueTokens($user, true, 201);
    }

    // ── Token Refresh ────────────────────────────────────────────────

    public function refresh(array $body): void {
        if (empty($body['refresh_token'])) {
            Response::error('Refresh token required', 400);
        }

        $stmt = $this->db->prepare(
            'SELECT * FROM refresh_tokens
             WHERE token = :t AND expires_at > NOW() AND revoked = 0
             LIMIT 1'
        );
        $stmt->execute([':t' => $body['refresh_token']]);
        $row = $stmt->fetch();

        if (!$row) {
            Response::error('Invalid or expired refresh token', 401);
        }

        $user = User::findById($this->db, (int) $row['user_id']);
        if (!$user) {
            Response::error('User not found', 404);
        }

        $newToken        = JWT::encode(['user_id' => $user['id'], 'email' => $user['email']]);
        $newRefreshToken = bin2hex(random_bytes(32));

        // Revoke old token and issue new one
        $this->db->prepare('UPDATE refresh_tokens SET revoked = 1 WHERE id = :id')
                 ->execute([':id' => $row['id']]);

        $this->storeRefreshToken($user['id'], $newRefreshToken);

        Response::success([
            'token'         => $newToken,
            'refresh_token' => $newRefreshToken,
        ]);
    }

    // ── Helpers ──────────────────────────────────────────────────────

    private function issueTokens(array $user, bool $isNew = false, int $httpCode = 200): void {
        $token        = JWT::encode(['user_id' => $user['id'], 'email' => $user['email'] ?? '']);
        $refreshToken = bin2hex(random_bytes(32));

        $this->storeRefreshToken((int) $user['id'], $refreshToken);

        Response::success([
            'user'          => User::toPublicArray($user),
            'token'         => $token,
            'refresh_token' => $refreshToken,
            'is_new_user'   => $isNew,
        ], $isNew ? 'Account created' : 'Login successful', $httpCode);
    }

    private function storeRefreshToken(int $userId, string $token): void {
        $expires = date('Y-m-d H:i:s', time() + REFRESH_TOKEN_EXPIRY);
        $stmt    = $this->db->prepare(
            'INSERT INTO refresh_tokens (user_id, token, expires_at, revoked, created_at)
             VALUES (:uid, :token, :exp, 0, NOW())'
        );
        $stmt->execute([':uid' => $userId, ':token' => $token, ':exp' => $expires]);
    }

    /**
     * Generate a unique username from display name or email.
     */
    private function generateUsername(?string $displayName, ?string $email): string {
        $base = '';
        if ($displayName) {
            $base = strtolower(preg_replace('/[^a-zA-Z0-9]/', '', $displayName));
        }
        if (!$base && $email) {
            $base = strtolower(explode('@', $email)[0]);
            $base = preg_replace('/[^a-z0-9]/', '', $base);
        }
        if (!$base) {
            $base = 'paddler';
        }

        $base = substr($base, 0, 24);
        $username = $base;
        $suffix = 1;

        while (true) {
            $stmt = $this->db->prepare('SELECT id FROM users WHERE username = :u LIMIT 1');
            $stmt->execute([':u' => $username]);
            if (!$stmt->fetch()) {
                return $username;
            }
            $username = $base . $suffix;
            $suffix++;
        }
    }

    // ── Apple Token Verification ─────────────────────────────────────

    private function verifyAppleToken(string $identityToken): ?array {
        $parts = explode('.', $identityToken);
        if (count($parts) !== 3) {
            return null;
        }

        [$headerB64, $payloadB64, $signatureB64] = $parts;

        $header = json_decode($this->base64UrlDecode($headerB64), true);
        if (!$header || empty($header['kid']) || empty($header['alg'])) {
            return null;
        }

        $keys = $this->fetchApplePublicKeys();
        if (!$keys) {
            return null;
        }

        // Find the matching key
        $matchingKey = null;
        foreach ($keys as $key) {
            if (($key['kid'] ?? '') === $header['kid']) {
                $matchingKey = $key;
                break;
            }
        }
        if (!$matchingKey) {
            return null;
        }

        // Build the RSA public key from JWK
        $publicKey = $this->jwkToPublicKey($matchingKey);
        if (!$publicKey) {
            return null;
        }

        // Verify signature
        $data = "$headerB64.$payloadB64";
        $signature = $this->base64UrlDecode($signatureB64);

        $alg = $header['alg'] === 'RS256' ? OPENSSL_ALGO_SHA256 : OPENSSL_ALGO_SHA256;
        $valid = openssl_verify($data, $signature, $publicKey, $alg);
        if ($valid !== 1) {
            return null;
        }

        $payload = json_decode($this->base64UrlDecode($payloadB64), true);
        if (!$payload) {
            return null;
        }

        // Validate expiry
        if (isset($payload['exp']) && $payload['exp'] < time()) {
            return null;
        }

        // Validate issuer
        if (($payload['iss'] ?? '') !== 'https://appleid.apple.com') {
            return null;
        }

        return $payload;
    }

    private function fetchApplePublicKeys(): ?array {
        if ($this->appleKeys !== null) {
            return $this->appleKeys;
        }

        $ctx = stream_context_create(['http' => ['timeout' => 10]]);
        $json = @file_get_contents('https://appleid.apple.com/auth/keys', false, $ctx);
        if (!$json) {
            return null;
        }

        $data = json_decode($json, true);
        $this->appleKeys = $data['keys'] ?? null;
        return $this->appleKeys;
    }

    // ── Google Token Verification ────────────────────────────────────

    private function verifyGoogleToken(string $idToken): ?array {
        $ctx = stream_context_create(['http' => ['timeout' => 10]]);
        $url = 'https://oauth2.googleapis.com/tokeninfo?id_token=' . urlencode($idToken);
        $json = @file_get_contents($url, false, $ctx);
        if (!$json) {
            return null;
        }

        $claims = json_decode($json, true);
        if (!$claims || isset($claims['error'])) {
            return null;
        }

        // Validate expiry
        if (isset($claims['exp']) && (int) $claims['exp'] < time()) {
            return null;
        }

        return $claims;
    }

    // ── Crypto Helpers ───────────────────────────────────────────────

    private function base64UrlDecode(string $data): string {
        return base64_decode(strtr($data, '-_', '+/'));
    }

    private function jwkToPublicKey(array $jwk): mixed {
        if (empty($jwk['n']) || empty($jwk['e'])) {
            return null;
        }

        $n = $this->base64UrlDecode($jwk['n']);
        $e = $this->base64UrlDecode($jwk['e']);

        // Build DER-encoded RSA public key
        $modulus  = $this->encodeDerInteger($n);
        $exponent = $this->encodeDerInteger($e);

        $rsaPublicKey = chr(0x30) . $this->encodeDerLength(strlen($modulus) + strlen($exponent))
            . $modulus . $exponent;

        // Wrap in SubjectPublicKeyInfo
        $algorithmIdentifier = hex2bin('300d06092a864886f70d0101010500');
        $bitString = chr(0x03) . $this->encodeDerLength(strlen($rsaPublicKey) + 1) . chr(0x00) . $rsaPublicKey;

        $der = chr(0x30) . $this->encodeDerLength(strlen($algorithmIdentifier) + strlen($bitString))
            . $algorithmIdentifier . $bitString;

        $pem = "-----BEGIN PUBLIC KEY-----\n"
            . chunk_split(base64_encode($der), 64, "\n")
            . "-----END PUBLIC KEY-----";

        return openssl_pkey_get_public($pem) ?: null;
    }

    private function encodeDerLength(int $length): string {
        if ($length < 0x80) {
            return chr($length);
        }
        $bytes = '';
        $temp = $length;
        while ($temp > 0) {
            $bytes = chr($temp & 0xFF) . $bytes;
            $temp >>= 8;
        }
        return chr(0x80 | strlen($bytes)) . $bytes;
    }

    private function encodeDerInteger(string $data): string {
        // Prepend 0x00 if high bit is set (positive integer)
        if (ord($data[0]) & 0x80) {
            $data = chr(0x00) . $data;
        }
        return chr(0x02) . $this->encodeDerLength(strlen($data)) . $data;
    }
}
