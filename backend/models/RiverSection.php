<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

class RiverSection {
    use BaseModel;
    const TABLE = 'river_sections';

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
        $params = GeoQuery::haversineParams($lat, $lng, $radiusMiles);

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
        $haversine   = GeoQuery::haversineExpr('rs.put_in_lat', 'rs.put_in_lng');

        $sql = "SELECT rs.*, r.name AS river_name, r.state, r.region,
                    $haversine AS distance_miles
                FROM river_sections rs
                JOIN rivers r ON r.id = rs.river_id
                WHERE $whereClause
                HAVING distance_miles <= :geo_r
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
