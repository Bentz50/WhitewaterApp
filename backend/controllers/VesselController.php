<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

require_once __DIR__ . '/../models/Vessel.php';

class VesselController {
    private PDO $db;

    public function __construct() {
        $this->db = Database::getInstance()->getConn();
    }

    public function index(array $auth): void {
        $vessels = Vessel::findByUserId($this->db, (int) $auth['user_id']);
        Response::success($vessels);
    }

    public function create(array $body, array $auth): void {
        $missing = Validator::required($body, ['name']);
        if ($missing) {
            Response::error('Missing required fields', 400, $missing);
        }

        $id = Vessel::create($this->db, array_merge($body, ['user_id' => (int) $auth['user_id']]));
        $vessel = Vessel::findByUserId($this->db, (int) $auth['user_id']);
        $created = array_filter($vessel, fn($v) => (int) $v['id'] === $id);
        Response::success(array_values($created)[0] ?? ['id' => $id], 'Vessel created', 201);
    }

    public function update(int $id, array $body, array $auth): void {
        $updated = Vessel::update($this->db, $id, (int) $auth['user_id'], $body);
        if (!$updated) {
            Response::error('Vessel not found or access denied', 404);
        }
        Response::success(null, 'Vessel updated');
    }

    public function delete(int $id, array $auth): void {
        $deleted = Vessel::delete($this->db, $id, (int) $auth['user_id']);
        if (!$deleted) {
            Response::error('Vessel not found or access denied', 404);
        }
        Response::success(null, 'Vessel deleted');
    }

    public function setDefault(int $id, array $auth): void {
        $ok = Vessel::setDefault($this->db, $id, (int) $auth['user_id']);
        if (!$ok) {
            Response::error('Vessel not found or access denied', 404);
        }
        Response::success(null, 'Default vessel updated');
    }
}
