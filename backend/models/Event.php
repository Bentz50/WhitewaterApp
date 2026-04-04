<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

class Event {
    public static function findAll(PDO $db, array $params = []): array {
        $where  = ['e.event_date >= CURDATE()'];
        $bindPs = [];

        if (!empty($params['q'])) {
            $where[]    = '(e.title LIKE :q OR e.description LIKE :q2)';
            $like       = '%' . $params['q'] . '%';
            $bindPs[':q']  = $like;
            $bindPs[':q2'] = $like;
        }

        $sql  = 'SELECT e.*, u.username, u.display_name
                 FROM events e
                 JOIN users u ON u.id = e.organizer_id
                 WHERE ' . implode(' AND ', $where) . '
                 ORDER BY e.event_date ASC
                 LIMIT 50';
        $stmt = $db->prepare($sql);
        $stmt->execute($bindPs);
        return $stmt->fetchAll();
    }

    public static function findNearby(PDO $db, float $lat, float $lng, float $radiusMiles): array {
        $params    = GeoQuery::haversineParams($lat, $lng, $radiusMiles);
        $haversine = GeoQuery::haversineExpr('e.lat', 'e.lng');

        $sql = "SELECT e.*, u.username, u.display_name,
                    $haversine AS distance_miles
                FROM events e
                JOIN users u ON u.id = e.organizer_id
                WHERE e.event_date >= CURDATE()
                HAVING distance_miles <= :geo_r
                ORDER BY e.event_date ASC
                LIMIT 50";
        $stmt = $db->prepare($sql);
        $stmt->execute($params);
        return $stmt->fetchAll();
    }

    public static function create(PDO $db, array $data): int {
        $sql = 'INSERT INTO events
                    (organizer_id, title, description, event_date, lat, lng, location_name, max_attendees, created_at)
                VALUES
                    (:organizer_id, :title, :description, :event_date, :lat, :lng, :location_name, :max_attendees, NOW())';
        $stmt = $db->prepare($sql);
        $stmt->execute([
            ':organizer_id'  => $data['organizer_id'],
            ':title'         => $data['title'],
            ':description'   => $data['description']  ?? null,
            ':event_date'    => $data['event_date'],
            ':lat'           => $data['lat']           ?? null,
            ':lng'           => $data['lng']           ?? null,
            ':location_name' => $data['location_name'] ?? null,
            ':max_attendees' => $data['max_attendees'] ?? null,
        ]);
        return (int) $db->lastInsertId();
    }
}
