<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

class User {
    use BaseModel;
    const TABLE = 'users';

    public static function findByEmail(PDO $db, string $email): ?array {
        $stmt = $db->prepare('SELECT * FROM users WHERE email = :email LIMIT 1');
        $stmt->execute([':email' => $email]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    public static function findByAppleId(PDO $db, string $appleId): ?array {
        $stmt = $db->prepare('SELECT * FROM users WHERE apple_id = :apple_id LIMIT 1');
        $stmt->execute([':apple_id' => $appleId]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    public static function findByGoogleId(PDO $db, string $googleId): ?array {
        $stmt = $db->prepare('SELECT * FROM users WHERE google_id = :google_id LIMIT 1');
        $stmt->execute([':google_id' => $googleId]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    public static function create(PDO $db, array $data): int {
        $sql = 'INSERT INTO users
                    (username, email, password_hash, display_name,
                     apple_id, google_id, auth_provider,
                     created_at, updated_at)
                VALUES
                    (:username, :email, :password_hash, :display_name,
                     :apple_id, :google_id, :auth_provider,
                     NOW(), NOW())';
        $stmt = $db->prepare($sql);
        $stmt->execute([
            ':username'      => $data['username'],
            ':email'         => $data['email'] ?? null,
            ':password_hash' => $data['password_hash'] ?? null,
            ':display_name'  => $data['display_name'] ?? $data['username'],
            ':apple_id'      => $data['apple_id'] ?? null,
            ':google_id'     => $data['google_id'] ?? null,
            ':auth_provider' => $data['auth_provider'] ?? 'apple',
        ]);
        return (int) $db->lastInsertId();
    }

    public static function update(PDO $db, int $id, array $data): bool {
        $allowed = ['display_name', 'preferred_difficulty', 'water_experiences', 'interests', 'avatar_url', 'bio'];
        $data['updated_at'] = date('Y-m-d H:i:s');
        $allowed[] = 'updated_at';
        return self::dynamicUpdate($db, $id, $data, $allowed);
    }

    public static function search(PDO $db, string $q, int $limit = 20): array {
        $like = '%' . $q . '%';
        $stmt = $db->prepare(
            'SELECT id, username, display_name, avatar_url FROM users
             WHERE username LIKE :q1 OR display_name LIKE :q2
             LIMIT :lim'
        );
        $stmt->bindValue(':q1', $like, PDO::PARAM_STR);
        $stmt->bindValue(':q2', $like, PDO::PARAM_STR);
        $stmt->bindValue(':lim', $limit, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll();
    }

    public static function toPublicArray(array $user): array {
        unset($user['password_hash']);
        return $user;
    }
}
