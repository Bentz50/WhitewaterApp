<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

class RunLog {
    public static function create(PDO $db, array $data): int {
        $sql = 'INSERT INTO run_logs
                    (user_id, river_id, vessel_id, run_date, start_time, end_time,
                     distance_miles, duration_minutes, avg_speed_mph, is_public,
                     gauge_reading_cfs, gauge_height_ft, notes, created_at)
                VALUES
                    (:user_id, :river_id, :vessel_id, :run_date, :start_time, :end_time,
                     :distance_miles, :duration_minutes, :avg_speed_mph, :is_public,
                     :gauge_reading_cfs, :gauge_height_ft, :notes, NOW())';
        $stmt = $db->prepare($sql);
        $stmt->execute([
            ':user_id'           => $data['user_id'],
            ':river_id'          => $data['river_id']          ?? null,
            ':vessel_id'         => $data['vessel_id']         ?? null,
            ':run_date'          => $data['run_date']          ?? null,
            ':start_time'        => $data['start_time']        ?? null,
            ':end_time'          => $data['end_time']          ?? null,
            ':distance_miles'    => $data['distance_miles']    ?? null,
            ':duration_minutes'  => $data['duration_minutes']  ?? null,
            ':avg_speed_mph'     => $data['avg_speed_mph']     ?? null,
            ':is_public'         => $data['is_public']         ?? 1,
            ':gauge_reading_cfs' => $data['gauge_reading_cfs'] ?? null,
            ':gauge_height_ft'   => $data['gauge_height_ft']   ?? null,
            ':notes'             => $data['notes']             ?? null,
        ]);
        return (int) $db->lastInsertId();
    }

    public static function findById(PDO $db, int $id): ?array {
        $stmt = $db->prepare(
            'SELECT rl.*, r.name AS river_name, v.name AS vessel_name
             FROM run_logs rl
             LEFT JOIN rivers r ON r.id = rl.river_id
             LEFT JOIN vessels v ON v.id = rl.vessel_id
             WHERE rl.id = :id LIMIT 1'
        );
        $stmt->execute([':id' => $id]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    public static function findByUserId(PDO $db, int $userId, int $page = 1, int $perPage = 20): array {
        $offset = ($page - 1) * $perPage;
        $stmt   = $db->prepare(
            'SELECT rl.*, r.name AS river_name FROM run_logs rl
             LEFT JOIN rivers r ON r.id = rl.river_id
             WHERE rl.user_id = :uid
             ORDER BY rl.run_date DESC, rl.created_at DESC
             LIMIT :lim OFFSET :off'
        );
        $stmt->bindValue(':uid', $userId, PDO::PARAM_INT);
        $stmt->bindValue(':lim', $perPage, PDO::PARAM_INT);
        $stmt->bindValue(':off', $offset, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll();
    }

    public static function findByRiverId(PDO $db, int $riverId, int $limit = 20): array {
        $stmt = $db->prepare(
            'SELECT rl.*, u.username, u.display_name, u.avatar_url
             FROM run_logs rl
             JOIN users u ON u.id = rl.user_id
             WHERE rl.river_id = :rid AND rl.is_public = 1
             ORDER BY rl.run_date DESC
             LIMIT :lim'
        );
        $stmt->bindValue(':rid', $riverId, PDO::PARAM_INT);
        $stmt->bindValue(':lim', $limit, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll();
    }

    public static function update(PDO $db, int $id, int $userId, array $data): bool {
        $allowed = ['notes', 'is_public', 'distance_miles', 'duration_minutes', 'avg_speed_mph',
                    'gauge_reading_cfs', 'gauge_height_ft', 'vessel_id'];
        $sets   = [];
        $params = [':id' => $id, ':user_id' => $userId];

        foreach ($allowed as $col) {
            if (array_key_exists($col, $data)) {
                $sets[]         = "$col = :$col";
                $params[":$col"] = $data[$col];
            }
        }

        if (empty($sets)) {
            return false;
        }

        $sql  = 'UPDATE run_logs SET ' . implode(', ', $sets) . ' WHERE id = :id AND user_id = :user_id';
        $stmt = $db->prepare($sql);
        $stmt->execute($params);
        return $stmt->rowCount() > 0;
    }
}
