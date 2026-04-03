<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

require_once __DIR__ . '/RiverSection.php';

class River {
    public static function findById(PDO $db, int $id): ?array {
        $stmt = $db->prepare('SELECT * FROM rivers WHERE id = :id LIMIT 1');
        $stmt->execute([':id' => $id]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    /**
     * Find a river by ID with its sections included.
     */
    public static function findByIdWithSections(PDO $db, int $id): ?array {
        $river = self::findById($db, $id);
        if (!$river) {
            return null;
        }
        $river['sections'] = RiverSection::findByRiverId($db, $id);
        return $river;
    }

    /**
     * Haversine-based proximity search with optional filters.
     * $radiusMiles – search radius in miles.
     * $filters – optional keys: aw_rating, runnable (bool)
     */
    public static function search(PDO $db, float $lat, float $lng, float $radiusMiles, array $filters = []): array {
        $params = [
            ':lat1' => $lat,
            ':lng1' => $lng,
            ':lat2' => $lat,
            ':r'    => $radiusMiles,
        ];

        $where = ['1=1'];

        if (isset($filters['aw_rating'])) {
            $where[]              = 'aw_rating = :aw_rating';
            $params[':aw_rating'] = $filters['aw_rating'];
        }

        if (isset($filters['runnable'])) {
            $where[]             = 'is_runnable = :runnable';
            $params[':runnable'] = $filters['runnable'] ? 1 : 0;
        }

        $whereClause = implode(' AND ', $where);

        $sql = "SELECT *,
                    (3958.8 * ACOS(
                        COS(RADIANS(:lat1)) * COS(RADIANS(put_in_lat)) *
                        COS(RADIANS(put_in_lng) - RADIANS(:lng1)) +
                        SIN(RADIANS(:lat2)) * SIN(RADIANS(put_in_lat))
                    )) AS distance_miles
                FROM rivers
                WHERE $whereClause
                HAVING distance_miles <= :r
                ORDER BY distance_miles
                LIMIT 50";

        $stmt = $db->prepare($sql);
        $stmt->execute($params);
        return $stmt->fetchAll();
    }

    public static function all(PDO $db, int $limit = 50, int $offset = 0): array {
        $stmt = $db->prepare('SELECT * FROM rivers ORDER BY name LIMIT :lim OFFSET :off');
        $stmt->bindValue(':lim', $limit, PDO::PARAM_INT);
        $stmt->bindValue(':off', $offset, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll();
    }
}
