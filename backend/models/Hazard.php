<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

class Hazard {
    public static function findNearby(PDO $db, float $lat, float $lng, float $radiusMiles): array {
        $sql = "SELECT *,
                    (3958.8 * ACOS(
                        COS(RADIANS(:lat1)) * COS(RADIANS(lat)) *
                        COS(RADIANS(lng) - RADIANS(:lng1)) +
                        SIN(RADIANS(:lat2)) * SIN(RADIANS(lat))
                    )) AS distance_miles
                FROM hazards
                WHERE status != 'cleared'
                HAVING distance_miles <= :r
                ORDER BY distance_miles
                LIMIT 100";
        $stmt = $db->prepare($sql);
        $stmt->execute([':lat1' => $lat, ':lng1' => $lng, ':lat2' => $lat, ':r' => $radiusMiles]);
        return $stmt->fetchAll();
    }

    public static function findByRiverId(PDO $db, int $riverId): array {
        $stmt = $db->prepare(
            "SELECT * FROM hazards WHERE river_id = :rid AND status != 'cleared' ORDER BY created_at DESC"
        );
        $stmt->execute([':rid' => $riverId]);
        return $stmt->fetchAll();
    }

    public static function findBySectionId(PDO $db, int $sectionId): array {
        $stmt = $db->prepare(
            "SELECT * FROM hazards WHERE section_id = :sid AND status != 'cleared' ORDER BY created_at DESC"
        );
        $stmt->execute([':sid' => $sectionId]);
        return $stmt->fetchAll();
    }

    public static function create(PDO $db, array $data): int {
        $sql = 'INSERT INTO hazards
                    (user_id, river_id, type, description, lat, lng, status, last_observed, created_at)
                VALUES
                    (:user_id, :river_id, :type, :description, :lat, :lng, :status, NOW(), NOW())';
        $stmt = $db->prepare($sql);
        $stmt->execute([
            ':user_id'     => $data['user_id'],
            ':river_id'    => $data['river_id']    ?? null,
            ':type'        => $data['type'],
            ':description' => $data['description'] ?? null,
            ':lat'         => $data['lat']          ?? null,
            ':lng'         => $data['lng']          ?? null,
            ':status'      => $data['status']       ?? 'active',
        ]);
        return (int) $db->lastInsertId();
    }

    public static function verify(PDO $db, int $id, int $userId, array $data): bool {
        // Log verification
        $stmt = $db->prepare(
            'INSERT INTO hazard_verifications (hazard_id, user_id, note, created_at)
             VALUES (:hid, :uid, :note, NOW())'
        );
        $stmt->execute([
            ':hid'  => $id,
            ':uid'  => $userId,
            ':note' => $data['note'] ?? null,
        ]);

        // Update last_observed
        $upd = $db->prepare('UPDATE hazards SET last_observed = NOW() WHERE id = :id');
        $upd->execute([':id' => $id]);
        return $upd->rowCount() > 0;
    }

    public static function clear(PDO $db, int $id): bool {
        $stmt = $db->prepare("UPDATE hazards SET status = 'cleared', cleared_at = NOW() WHERE id = :id");
        $stmt->execute([':id' => $id]);
        return $stmt->rowCount() > 0;
    }
}
