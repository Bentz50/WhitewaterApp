<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

class ClubMembership {
    public static function findByUserId(PDO $db, int $userId): array {
        $stmt = $db->prepare(
            'SELECT * FROM club_memberships WHERE user_id = :uid ORDER BY joined_at DESC'
        );
        $stmt->execute([':uid' => $userId]);
        return $stmt->fetchAll();
    }

    public static function create(PDO $db, array $data): int {
        $sql = 'INSERT INTO club_memberships
                    (user_id, club_name, verified, joined_at)
                VALUES
                    (:user_id, :club_name, 0, :joined_at)';
        $stmt = $db->prepare($sql);
        $stmt->execute([
            ':user_id'    => $data['user_id'],
            ':club_name'  => $data['club_name'],
            ':joined_at'  => $data['joined_at'] ?? date('Y-m-d'),
        ]);
        return (int) $db->lastInsertId();
    }

    public static function delete(PDO $db, int $id, int $userId): bool {
        $stmt = $db->prepare('DELETE FROM club_memberships WHERE id = :id AND user_id = :user_id');
        $stmt->execute([':id' => $id, ':user_id' => $userId]);
        return $stmt->rowCount() > 0;
    }
}
