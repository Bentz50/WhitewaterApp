<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

require_once __DIR__ . '/../models/Achievement.php';

class AchievementController extends BaseController {

    public function getMyAchievements(array $auth): void {
        $achievements = Achievement::findUnlocked($this->db, (int) $auth['user_id']);
        Response::success($achievements);
    }

    public function checkAchievements(array $auth): void {
        $newlyUnlocked = Achievement::checkAndUnlock($this->db, (int) $auth['user_id']);
        Response::success([
            'newly_unlocked' => $newlyUnlocked,
            'count'          => count($newlyUnlocked),
        ]);
    }
}
