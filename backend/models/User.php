<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

class User {
    public static function findById(PDO $db, int $id): ?array {
        $stmt = $db->prepare('SELECT * FROM users WHERE id = :id LIMIT 1');
        $stmt->execute([':id' => $id]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    public static function findByEmail(PDO $db, string $email): ?array {
        $stmt = $db->prepare('SELECT * FROM users WHERE email = :email LIMIT 1');
        $stmt->execute([':email' => $email]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    public static function create(PDO $db, array $data): int {
        $sql = 'INSERT INTO users
                    (username, email, password_hash, display_name, created_at, updated_at)
                VALUES
                    (:username, :email, :password_hash, :display_name, NOW(), NOW())';
        $stmt = $db->prepare($sql);
        $stmt->execute([
            ':username'      => $data['username'],
            ':email'         => $data['email'],
            ':password_hash' => $data['password_hash'],
            ':display_name'  => $data['display_name'] ?? $data['username'],
        ]);
        return (int) $db->lastInsertId();
    }

    public static function update(PDO $db, int $id, array $data): bool {
        $allowed = ['display_name', 'preferred_difficulty', 'water_experiences', 'interests', 'avatar_url', 'bio'];
        $sets    = [];
        $params  = [':id' => $id];

        foreach ($allowed as $col) {
            if (array_key_exists($col, $data)) {
                $sets[]         = "$col = :$col";
                $params[":$col"] = is_array($data[$col]) ? json_encode($data[$col]) : $data[$col];
            }
        }

        if (empty($sets)) {
            return false;
        }

        $sets[] = 'updated_at = NOW()';
        $sql    = 'UPDATE users SET ' . implode(', ', $sets) . ' WHERE id = :id';
        $stmt   = $db->prepare($sql);
        $stmt->execute($params);
        return $stmt->rowCount() > 0;
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
