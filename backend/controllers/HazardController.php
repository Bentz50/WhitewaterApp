<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

require_once __DIR__ . '/../models/Hazard.php';

class HazardController {
    private PDO $db;

    public function __construct() {
        $this->db = Database::getInstance()->getConn();
    }

    public function index(array $params): void {
        $lat    = Validator::sanitizeFloat($params['lat']    ?? null);
        $lng    = Validator::sanitizeFloat($params['lng']    ?? null);
        $radius = Validator::sanitizeFloat($params['radius'] ?? 25);

        if ($lat === null || $lng === null) {
            Response::error('lat and lng are required', 400);
        }

        $hazards = Hazard::findNearby($this->db, $lat, $lng, $radius);
        Response::success($hazards);
    }

    public function create(array $body, array $auth): void {
        $missing = Validator::required($body, ['type', 'lat', 'lng']);
        if ($missing) {
            Response::error('Missing required fields', 400, $missing);
        }

        $id = Hazard::create($this->db, array_merge($body, ['user_id' => (int) $auth['user_id']]));
        Response::success(['id' => $id], 'Hazard created', 201);
    }

    public function verify(int $id, array $body, array $auth): void {
        $ok = Hazard::verify($this->db, $id, (int) $auth['user_id'], $body);
        if (!$ok) {
            Response::error('Hazard not found', 404);
        }
        Response::success(null, 'Hazard verified');
    }

    public function clear(int $id, array $body, array $auth): void {
        $ok = Hazard::clear($this->db, $id);
        if (!$ok) {
            Response::error('Hazard not found', 404);
        }
        Response::success(null, 'Hazard marked cleared');
    }
}
