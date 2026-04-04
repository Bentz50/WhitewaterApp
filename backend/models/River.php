<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

require_once __DIR__ . '/RiverSection.php';

class River {
    use BaseModel;
    const TABLE = 'rivers';

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
        $params = GeoQuery::haversineParams($lat, $lng, $radiusMiles);

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
        $haversine   = GeoQuery::haversineExpr('put_in_lat', 'put_in_lng');

        $sql = "SELECT *, $haversine AS distance_miles
                FROM rivers
                WHERE $whereClause
                HAVING distance_miles <= :geo_r
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
