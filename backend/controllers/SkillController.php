<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

require_once __DIR__ . '/../models/Skill.php';

class SkillController extends BaseController {

    public function index(): void {
        $skills = Skill::findAll($this->db);
        Response::success($skills);
    }

    public function updateDefaults(array $body, array $auth): void {
        $skillIds = $body['skill_ids'] ?? [];
        if (!is_array($skillIds)) {
            Response::error('skill_ids must be an array', 400);
        }

        $skillIds = array_map('intval', $skillIds);
        Skill::setUserDefaults($this->db, (int) $auth['user_id'], $skillIds);
        Response::success(null, 'Default skills updated');
    }

    public function getDefaults(array $auth): void {
        $skills = Skill::getUserDefaults($this->db, (int) $auth['user_id']);
        Response::success($skills);
    }
}
