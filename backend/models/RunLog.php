<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

class RunLog {
    use BaseModel;
    const TABLE = 'run_logs';

    public static function create(PDO $db, array $data): int {
        $sql = 'INSERT INTO run_logs
                    (user_id, river_id, section_id, vessel_id, start_time, end_time,
                     distance_miles, duration_seconds, calories_burned, privacy,
                     start_gauge_level, end_gauge_level, gps_track, notes, created_at)
                VALUES
                    (:user_id, :river_id, :section_id, :vessel_id, :start_time, :end_time,
                     :distance_miles, :duration_seconds, :calories_burned, :privacy,
                     :start_gauge_level, :end_gauge_level, :gps_track, :notes, NOW())';
        $stmt = $db->prepare($sql);
        $stmt->execute([
            ':user_id'            => $data['user_id'],
            ':river_id'           => $data['river_id']           ?? null,
            ':section_id'         => $data['section_id']         ?? null,
            ':vessel_id'          => $data['vessel_id']          ?? null,
            ':start_time'         => $data['start_time']         ?? null,
            ':end_time'           => $data['end_time']           ?? null,
            ':distance_miles'     => $data['distance_miles']     ?? 0,
            ':duration_seconds'   => $data['duration_seconds']   ?? 0,
            ':calories_burned'    => $data['calories_burned']    ?? null,
            ':privacy'            => $data['privacy']            ?? 'public',
            ':start_gauge_level'  => $data['start_gauge_level']  ?? null,
            ':end_gauge_level'    => $data['end_gauge_level']    ?? null,
            ':gps_track'          => isset($data['gps_track']) ? json_encode($data['gps_track']) : null,
            ':notes'              => $data['notes']              ?? null,
        ]);
        return (int) $db->lastInsertId();
    }

    public static function findById(PDO $db, int $id): ?array {
        $stmt = $db->prepare(
            'SELECT rl.*, r.name AS river_name, v.name AS vessel_name, rs.name AS section_name
             FROM run_logs rl
             LEFT JOIN rivers r ON r.id = rl.river_id
             LEFT JOIN vessels v ON v.id = rl.vessel_id
             LEFT JOIN river_sections rs ON rs.id = rl.section_id
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
             ORDER BY rl.start_time DESC, rl.created_at DESC
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
             WHERE rl.river_id = :rid AND rl.privacy = :privacy
             ORDER BY rl.start_time DESC
             LIMIT :lim'
        );
        $stmt->bindValue(':rid', $riverId, PDO::PARAM_INT);
        $stmt->bindValue(':privacy', 'public', PDO::PARAM_STR);
        $stmt->bindValue(':lim', $limit, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll();
    }

    public static function update(PDO $db, int $id, int $userId, array $data): bool {
        $allowed = ['notes', 'privacy', 'distance_miles', 'duration_seconds', 'calories_burned',
                    'start_gauge_level', 'end_gauge_level', 'vessel_id', 'end_time'];
        return self::dynamicUpdate($db, $id, $data, $allowed, ['user_id' => $userId]);
    }
}
