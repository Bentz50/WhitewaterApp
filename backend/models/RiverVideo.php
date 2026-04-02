<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

class RiverVideo {
    public static function findByRiverId(PDO $db, int $riverId, ?float $level = null): array {
        if ($level !== null) {
            $stmt = $db->prepare(
                'SELECT * FROM river_videos
                 WHERE river_id = :rid
                   AND (min_level IS NULL OR min_level <= :lvl1)
                   AND (max_level IS NULL OR max_level >= :lvl2)
                 ORDER BY created_at DESC'
            );
            $stmt->execute([':rid' => $riverId, ':lvl1' => $level, ':lvl2' => $level]);
        } else {
            $stmt = $db->prepare(
                'SELECT * FROM river_videos WHERE river_id = :rid ORDER BY created_at DESC'
            );
            $stmt->execute([':rid' => $riverId]);
        }
        return $stmt->fetchAll();
    }

    public static function findBySectionId(PDO $db, int $sectionId, ?float $level = null): array {
        if ($level !== null) {
            $stmt = $db->prepare(
                'SELECT * FROM river_videos
                 WHERE section_id = :sid
                   AND (min_level IS NULL OR min_level <= :lvl1)
                   AND (max_level IS NULL OR max_level >= :lvl2)
                 ORDER BY created_at DESC'
            );
            $stmt->execute([':sid' => $sectionId, ':lvl1' => $level, ':lvl2' => $level]);
        } else {
            $stmt = $db->prepare(
                'SELECT * FROM river_videos WHERE section_id = :sid ORDER BY created_at DESC'
            );
            $stmt->execute([':sid' => $sectionId]);
        }
        return $stmt->fetchAll();
    }

    public static function create(PDO $db, array $data): int {
        $sql = 'INSERT INTO river_videos (river_id, section_id, title, url, min_level, max_level, submitted_by, created_at)
                VALUES (:river_id, :section_id, :title, :url, :min_level, :max_level, :submitted_by, NOW())';
        $stmt = $db->prepare($sql);
        $stmt->execute([
            ':river_id'     => $data['river_id'],
            ':section_id'   => $data['section_id'] ?? null,
            ':title'        => $data['title'],
            ':url'          => $data['url'],
            ':min_level'    => $data['min_level'] ?? null,
            ':max_level'    => $data['max_level'] ?? null,
            ':submitted_by' => $data['submitted_by'] ?? null,
        ]);
        return (int) $db->lastInsertId();
    }
}
