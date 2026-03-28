<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

class Skill {
    public static function findAll(PDO $db): array {
        $stmt = $db->prepare('SELECT * FROM skills ORDER BY category, name');
        $stmt->execute();
        return $stmt->fetchAll();
    }

    public static function findByIds(PDO $db, array $ids): array {
        if (empty($ids)) {
            return [];
        }
        $placeholders = implode(',', array_fill(0, count($ids), '?'));
        $stmt = $db->prepare("SELECT * FROM skills WHERE id IN ($placeholders)");
        $stmt->execute(array_values($ids));
        return $stmt->fetchAll();
    }

    public static function getUserDefaults(PDO $db, int $userId): array {
        $stmt = $db->prepare(
            'SELECT s.* FROM skills s
             JOIN user_default_skills uds ON uds.skill_id = s.id
             WHERE uds.user_id = :uid
             ORDER BY s.category, s.name'
        );
        $stmt->execute([':uid' => $userId]);
        return $stmt->fetchAll();
    }

    public static function setUserDefaults(PDO $db, int $userId, array $skillIds): void {
        $db->prepare('DELETE FROM user_default_skills WHERE user_id = :uid')
           ->execute([':uid' => $userId]);

        if (empty($skillIds)) {
            return;
        }

        $stmt = $db->prepare(
            'INSERT INTO user_default_skills (user_id, skill_id) VALUES (:uid, :sid)'
        );
        foreach ($skillIds as $skillId) {
            $stmt->execute([':uid' => $userId, ':sid' => (int) $skillId]);
        }
    }
}
