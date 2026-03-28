<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

require_once __DIR__ . '/../models/RunLog.php';
require_once __DIR__ . '/../models/Hazard.php';
require_once __DIR__ . '/../models/Media.php';
require_once __DIR__ . '/../models/Skill.php';

class RunLogController {
    private PDO $db;

    public function __construct() {
        $this->db = Database::getInstance()->getConn();
    }

    public function create(array $body, array $auth): void {
        $missing = Validator::required($body, ['run_date']);
        if ($missing) {
            Response::error('Missing required fields', 400, $missing);
        }

        $id  = RunLog::create($this->db, array_merge($body, ['user_id' => (int) $auth['user_id']]));
        $run = RunLog::findById($this->db, $id);
        Response::success($run, 'Run logged', 201);
    }

    public function show(int $id, array $auth): void {
        $run = RunLog::findById($this->db, $id);
        if (!$run) {
            Response::error('Run not found', 404);
        }
        if (!$run['is_public'] && (int) $run['user_id'] !== (int) $auth['user_id']) {
            Response::error('Access denied', 403);
        }
        $run['media'] = Media::findByRunLogId($this->db, $id);
        Response::success($run);
    }

    public function myRuns(array $auth, array $params): void {
        $page    = max(1, (int) ($params['page']     ?? 1));
        $perPage = min((int) ($params['per_page'] ?? 20), 50);
        $userId  = (int) $auth['user_id'];

        $runs = RunLog::findByUserId($this->db, $userId, $page, $perPage);

        $countStmt = $this->db->prepare('SELECT COUNT(*) AS cnt FROM run_logs WHERE user_id = :uid');
        $countStmt->execute([':uid' => $userId]);
        $total = (int) ($countStmt->fetch()['cnt'] ?? 0);

        Response::paginated($runs, $total, $page, $perPage);
    }

    public function update(int $id, array $body, array $auth): void {
        $updated = RunLog::update($this->db, $id, (int) $auth['user_id'], $body);
        if (!$updated) {
            Response::error('Run not found or access denied', 404);
        }
        Response::success(null, 'Run updated');
    }

    public function addSkills(int $runId, array $body, array $auth): void {
        $run = RunLog::findById($this->db, $runId);
        if (!$run || (int) $run['user_id'] !== (int) $auth['user_id']) {
            Response::error('Run not found or access denied', 404);
        }

        $skillIds = $body['skill_ids'] ?? [];
        if (empty($skillIds) || !is_array($skillIds)) {
            Response::error('skill_ids array required', 400);
        }

        $stmt = $this->db->prepare(
            'INSERT IGNORE INTO run_log_skills (run_log_id, skill_id) VALUES (:rid, :sid)'
        );
        foreach ($skillIds as $skillId) {
            $stmt->execute([':rid' => $runId, ':sid' => (int) $skillId]);
        }
        Response::success(null, 'Skills added');
    }

    public function addMedia(int $runId, array $auth): void {
        $run = RunLog::findById($this->db, $runId);
        if (!$run || (int) $run['user_id'] !== (int) $auth['user_id']) {
            Response::error('Run not found or access denied', 404);
        }

        if (empty($_FILES['file'])) {
            Response::error('No file provided', 400);
        }

        try {
            $url  = FileUpload::upload($_FILES['file'], 'runs/' . $runId);
            $type = strpos($_FILES['file']['type'], 'video') !== false ? 'video' : 'image';
            $id   = Media::create($this->db, [
                'run_log_id' => $runId,
                'user_id'    => (int) $auth['user_id'],
                'url'        => $url,
                'type'       => $type,
            ]);
            Response::success(['id' => $id, 'url' => $url], 'Media uploaded', 201);
        } catch (RuntimeException $e) {
            Response::error($e->getMessage(), 400);
        }
    }

    public function hazardReport(int $runId, array $body, array $auth): void {
        $run = RunLog::findById($this->db, $runId);
        if (!$run || (int) $run['user_id'] !== (int) $auth['user_id']) {
            Response::error('Run not found or access denied', 404);
        }

        $missing = Validator::required($body, ['type']);
        if ($missing) {
            Response::error('Missing required fields', 400, $missing);
        }

        $id = Hazard::create($this->db, array_merge($body, [
            'user_id'  => (int) $auth['user_id'],
            'river_id' => $run['river_id'] ?? null,
        ]));
        Response::success(['hazard_id' => $id], 'Hazard reported', 201);
    }

    public function injuryReport(int $runId, array $body, array $auth): void {
        $run = RunLog::findById($this->db, $runId);
        if (!$run || (int) $run['user_id'] !== (int) $auth['user_id']) {
            Response::error('Run not found or access denied', 404);
        }

        $stmt = $this->db->prepare(
            'INSERT INTO injury_reports
                 (run_log_id, user_id, description, severity, body_part, treatment, created_at)
             VALUES
                 (:rid, :uid, :desc, :sev, :bp, :treat, NOW())'
        );
        $stmt->execute([
            ':rid'   => $runId,
            ':uid'   => (int) $auth['user_id'],
            ':desc'  => $body['description'] ?? null,
            ':sev'   => $body['severity']    ?? null,
            ':bp'    => $body['body_part']   ?? null,
            ':treat' => $body['treatment']   ?? null,
        ]);
        Response::success(['id' => (int) $this->db->lastInsertId()], 'Injury reported', 201);
    }
}
