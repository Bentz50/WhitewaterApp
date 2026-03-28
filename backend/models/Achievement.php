<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

class Achievement {
    public static function findAll(PDO $db): array {
        $stmt = $db->prepare('SELECT * FROM achievements ORDER BY sort_order ASC, id ASC');
        $stmt->execute();
        return $stmt->fetchAll();
    }

    public static function findUnlocked(PDO $db, int $userId): array {
        $stmt = $db->prepare(
            'SELECT a.*, ua.unlocked_at, ua.data AS unlock_data
             FROM achievements a
             JOIN user_achievements ua ON ua.achievement_id = a.id
             WHERE ua.user_id = :uid
             ORDER BY ua.unlocked_at DESC'
        );
        $stmt->execute([':uid' => $userId]);
        return $stmt->fetchAll();
    }

    public static function unlock(PDO $db, int $userId, int $achievementId, array $data = []): bool {
        // Check if already unlocked
        $check = $db->prepare(
            'SELECT id FROM user_achievements WHERE user_id = :uid AND achievement_id = :aid LIMIT 1'
        );
        $check->execute([':uid' => $userId, ':aid' => $achievementId]);
        if ($check->fetch()) {
            return false; // Already unlocked
        }

        $stmt = $db->prepare(
            'INSERT INTO user_achievements (user_id, achievement_id, data, unlocked_at)
             VALUES (:uid, :aid, :data, NOW())'
        );
        $stmt->execute([
            ':uid'  => $userId,
            ':aid'  => $achievementId,
            ':data' => $data ? json_encode($data) : null,
        ]);
        return $stmt->rowCount() > 0;
    }

    /** Check progress and unlock any newly earned achievements. Returns array of newly unlocked. */
    public static function checkAndUnlock(PDO $db, int $userId): array {
        $newlyUnlocked = [];

        // ── Total runs milestones ─────────────────────────────────────
        $runsRow = $db->prepare('SELECT COUNT(*) AS cnt FROM run_logs WHERE user_id = :uid');
        $runsRow->execute([':uid' => $userId]);
        $totalRuns = (int) ($runsRow->fetch()['cnt'] ?? 0);

        $runMilestones = [
            1   => 'first_run',
            10  => 'ten_runs',
            50  => 'fifty_runs',
            100 => 'hundred_runs',
        ];
        foreach ($runMilestones as $count => $key) {
            if ($totalRuns >= $count) {
                $ach = self::getByKey($db, $key);
                if ($ach && self::unlock($db, $userId, $ach['id'], ['runs' => $totalRuns])) {
                    $newlyUnlocked[] = $ach;
                }
            }
        }

        // ── Total distance milestones ─────────────────────────────────
        $distRow = $db->prepare('SELECT COALESCE(SUM(distance_miles),0) AS dist FROM run_logs WHERE user_id = :uid');
        $distRow->execute([':uid' => $userId]);
        $totalDist = (float) ($distRow->fetch()['dist'] ?? 0);

        $distMilestones = [
            100  => 'hundred_miles',
            500  => 'five_hundred_miles',
            1000 => 'thousand_miles',
        ];
        foreach ($distMilestones as $miles => $key) {
            if ($totalDist >= $miles) {
                $ach = self::getByKey($db, $key);
                if ($ach && self::unlock($db, $userId, $ach['id'], ['distance' => $totalDist])) {
                    $newlyUnlocked[] = $ach;
                }
            }
        }

        // ── Local Legend: >= 10 runs on same river section ────────────
        $legendRow = $db->prepare(
            'SELECT river_id, COUNT(*) AS cnt FROM run_logs
             WHERE user_id = :uid AND river_id IS NOT NULL
             GROUP BY river_id HAVING cnt >= 10 LIMIT 1'
        );
        $legendRow->execute([':uid' => $userId]);
        if ($legendRow->fetch()) {
            $ach = self::getByKey($db, 'local_legend');
            if ($ach && self::unlock($db, $userId, $ach['id'])) {
                $newlyUnlocked[] = $ach;
            }
        }

        // ── Speed Demon: any run with avg speed > 10 mph ─────────────
        $speedRow = $db->prepare(
            'SELECT id FROM run_logs WHERE user_id = :uid AND avg_speed_mph > 10 LIMIT 1'
        );
        $speedRow->execute([':uid' => $userId]);
        if ($speedRow->fetch()) {
            $ach = self::getByKey($db, 'speed_demon');
            if ($ach && self::unlock($db, $userId, $ach['id'])) {
                $newlyUnlocked[] = $ach;
            }
        }

        return $newlyUnlocked;
    }

    private static function getByKey(PDO $db, string $key): ?array {
        $stmt = $db->prepare('SELECT * FROM achievements WHERE key_name = :key LIMIT 1');
        $stmt->execute([':key' => $key]);
        $row = $stmt->fetch();
        return $row ?: null;
    }
}
