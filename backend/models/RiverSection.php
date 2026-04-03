<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

class RiverSection {
    public static function findById(PDO $db, int $id): ?array {
        $stmt = $db->prepare('SELECT * FROM river_sections WHERE id = :id LIMIT 1');
        $stmt->execute([':id' => $id]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    public static function findByRiverId(PDO $db, int $riverId): array {
        $stmt = $db->prepare(
            'SELECT * FROM river_sections WHERE river_id = :rid ORDER BY sort_order, name'
        );
        $stmt->execute([':rid' => $riverId]);
        return $stmt->fetchAll();
    }

    /**
     * Haversine-based proximity search for sections.
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
            $where[]              = 'rs.aw_rating = :aw_rating';
            $params[':aw_rating'] = $filters['aw_rating'];
        }

        if (isset($filters['runnable'])) {
            $where[]             = 'rs.is_runnable = :runnable';
            $params[':runnable'] = $filters['runnable'] ? 1 : 0;
        }

        $whereClause = implode(' AND ', $where);

        $sql = "SELECT rs.*, r.name AS river_name, r.state, r.region,
                    (3958.8 * ACOS(
                        COS(RADIANS(:lat1)) * COS(RADIANS(rs.put_in_lat)) *
                        COS(RADIANS(rs.put_in_lng) - RADIANS(:lng1)) +
                        SIN(RADIANS(:lat2)) * SIN(RADIANS(rs.put_in_lat))
                    )) AS distance_miles
                FROM river_sections rs
                JOIN rivers r ON r.id = rs.river_id
                WHERE $whereClause
                HAVING distance_miles <= :r
                ORDER BY distance_miles
                LIMIT 50";

        $stmt = $db->prepare($sql);
        $stmt->execute($params);
        return $stmt->fetchAll();
    }

    /**
     * Check whether a river has any sections defined.
     */
    public static function riverHasSections(PDO $db, int $riverId): bool {
        $stmt = $db->prepare('SELECT COUNT(*) FROM river_sections WHERE river_id = :rid');
        $stmt->execute([':rid' => $riverId]);
        return (int) $stmt->fetchColumn() > 0;
    }
}
