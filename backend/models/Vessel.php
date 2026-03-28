<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

class Vessel {
    public static function findByUserId(PDO $db, int $userId): array {
        $stmt = $db->prepare(
            'SELECT * FROM vessels WHERE user_id = :uid ORDER BY is_default DESC, created_at DESC'
        );
        $stmt->execute([':uid' => $userId]);
        return $stmt->fetchAll();
    }

    public static function create(PDO $db, array $data): int {
        $sql = 'INSERT INTO vessels
                    (user_id, name, type, length_ft, width_in, material, color, notes, is_default, created_at)
                VALUES
                    (:user_id, :name, :type, :length_ft, :width_in, :material, :color, :notes, :is_default, NOW())';
        $stmt = $db->prepare($sql);
        $stmt->execute([
            ':user_id'    => $data['user_id'],
            ':name'       => $data['name'],
            ':type'       => $data['type']       ?? null,
            ':length_ft'  => $data['length_ft']  ?? null,
            ':width_in'   => $data['width_in']   ?? null,
            ':material'   => $data['material']   ?? null,
            ':color'      => $data['color']      ?? null,
            ':notes'      => $data['notes']      ?? null,
            ':is_default' => $data['is_default'] ?? 0,
        ]);
        return (int) $db->lastInsertId();
    }

    public static function update(PDO $db, int $id, int $userId, array $data): bool {
        $allowed = ['name', 'type', 'length_ft', 'width_in', 'material', 'color', 'notes'];
        $sets    = [];
        $params  = [':id' => $id, ':user_id' => $userId];

        foreach ($allowed as $col) {
            if (array_key_exists($col, $data)) {
                $sets[]         = "$col = :$col";
                $params[":$col"] = $data[$col];
            }
        }

        if (empty($sets)) {
            return false;
        }

        $sql  = 'UPDATE vessels SET ' . implode(', ', $sets) . ' WHERE id = :id AND user_id = :user_id';
        $stmt = $db->prepare($sql);
        $stmt->execute($params);
        return $stmt->rowCount() > 0;
    }

    public static function delete(PDO $db, int $id, int $userId): bool {
        $stmt = $db->prepare('DELETE FROM vessels WHERE id = :id AND user_id = :user_id');
        $stmt->execute([':id' => $id, ':user_id' => $userId]);
        return $stmt->rowCount() > 0;
    }

    public static function setDefault(PDO $db, int $id, int $userId): bool {
        $db->prepare('UPDATE vessels SET is_default = 0 WHERE user_id = :uid')
           ->execute([':uid' => $userId]);
        $stmt = $db->prepare('UPDATE vessels SET is_default = 1 WHERE id = :id AND user_id = :uid');
        $stmt->execute([':id' => $id, ':uid' => $userId]);
        return $stmt->rowCount() > 0;
    }
}
