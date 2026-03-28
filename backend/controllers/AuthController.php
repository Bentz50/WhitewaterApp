<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

require_once __DIR__ . '/../models/User.php';

class AuthController {
    private PDO $db;

    public function __construct() {
        $this->db = Database::getInstance()->getConn();
    }

    public function register(array $body): void {
        $missing = Validator::required($body, ['username', 'email', 'password']);
        if ($missing) {
            Response::error('Missing required fields', 400, $missing);
        }

        if (!Validator::email($body['email'])) {
            Response::error('Invalid email address', 400);
        }

        if (!Validator::minLength($body['password'], 8)) {
            Response::error('Password must be at least 8 characters', 400);
        }

        if (!Validator::maxLength($body['username'], 30)) {
            Response::error('Username must be 30 characters or fewer', 400);
        }

        if (User::findByEmail($this->db, $body['email'])) {
            Response::error('Email already in use', 409);
        }

        $existing = $this->db->prepare('SELECT id FROM users WHERE username = :u LIMIT 1');
        $existing->execute([':u' => $body['username']]);
        if ($existing->fetch()) {
            Response::error('Username already taken', 409);
        }

        $userId = User::create($this->db, [
            'username'      => Validator::sanitizeString($body['username']),
            'email'         => strtolower(trim($body['email'])),
            'password_hash' => password_hash($body['password'], PASSWORD_BCRYPT),
            'display_name'  => $body['display_name'] ?? $body['username'],
        ]);

        $token        = JWT::encode(['user_id' => $userId, 'email' => strtolower(trim($body['email']))]);
        $refreshToken = bin2hex(random_bytes(32));

        $this->storeRefreshToken($userId, $refreshToken);

        $user = User::toPublicArray(User::findById($this->db, $userId));
        Response::success([
            'user'          => $user,
            'token'         => $token,
            'refresh_token' => $refreshToken,
        ], 'Registration successful', 201);
    }

    public function login(array $body): void {
        $missing = Validator::required($body, ['email', 'password']);
        if ($missing) {
            Response::error('Missing required fields', 400, $missing);
        }

        $user = User::findByEmail($this->db, strtolower(trim($body['email'])));
        if (!$user || !password_verify($body['password'], $user['password_hash'])) {
            Response::error('Invalid email or password', 401);
        }

        $token        = JWT::encode(['user_id' => $user['id'], 'email' => $user['email']]);
        $refreshToken = bin2hex(random_bytes(32));

        $this->storeRefreshToken($user['id'], $refreshToken);

        Response::success([
            'user'          => User::toPublicArray($user),
            'token'         => $token,
            'refresh_token' => $refreshToken,
        ]);
    }

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

    public function forgotPassword(array $body): void {
        // Placeholder – always return a generic success to prevent email enumeration
        Response::success(null, 'If that email exists, a reset link has been sent');
    }

    private function storeRefreshToken(int $userId, string $token): void {
        $expires = date('Y-m-d H:i:s', time() + REFRESH_TOKEN_EXPIRY);
        $stmt    = $this->db->prepare(
            'INSERT INTO refresh_tokens (user_id, token, expires_at, revoked, created_at)
             VALUES (:uid, :token, :exp, 0, NOW())'
        );
        $stmt->execute([':uid' => $userId, ':token' => $token, ':exp' => $expires]);
    }
}
