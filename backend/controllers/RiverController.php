<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

require_once __DIR__ . '/../models/River.php';
require_once __DIR__ . '/../models/Hazard.php';
require_once __DIR__ . '/../models/RunLog.php';

class RiverController {
    private PDO $db;

    public function __construct() {
        $this->db = Database::getInstance()->getConn();
    }

    public function index(array $params): void {
        $lat    = Validator::sanitizeFloat($params['lat']    ?? null);
        $lng    = Validator::sanitizeFloat($params['lng']    ?? null);
        $radius = Validator::sanitizeFloat($params['radius'] ?? 25);

        if ($lat !== null && $lng !== null) {
            $filters = [];
            if (!empty($params['rating']))   $filters['aw_rating']  = $params['rating'];
            if (isset($params['runnable']))  $filters['runnable']   = (bool) $params['runnable'];

            $rivers = River::search($this->db, $lat, $lng, $radius, $filters);
        } else {
            $limit  = min((int) ($params['limit']  ?? 50), 100);
            $offset = (int) ($params['offset'] ?? 0);
            $rivers = River::all($this->db, $limit, $offset);
        }

        Response::success($rivers);
    }

    public function show(int $id): void {
        $river = River::findById($this->db, $id);
        if (!$river) {
            Response::error('River not found', 404);
        }
        Response::success($river);
    }

    public function search(array $params): void {
        $lat    = Validator::sanitizeFloat($params['lat']    ?? null);
        $lng    = Validator::sanitizeFloat($params['lng']    ?? null);
        $radius = Validator::sanitizeFloat($params['radius'] ?? 25);

        if ($lat === null || $lng === null) {
            Response::error('lat and lng are required for search', 400);
        }

        $filters = [];
        if (!empty($params['rating']))   $filters['aw_rating'] = $params['rating'];
        if (isset($params['runnable']))  $filters['runnable']  = (bool) $params['runnable'];

        $rivers = River::search($this->db, $lat, $lng, $radius, $filters);
        Response::success($rivers);
    }

    public function getGauge(int $id): void {
        $river = River::findById($this->db, $id);
        if (!$river) {
            Response::error('River not found', 404);
        }

        $siteId = $river['usgs_site_id'] ?? null;
        if (!$siteId) {
            Response::error('No gauge configured for this river', 404);
        }

        $cached = GaugeProxy::getCached($siteId, 'usgs');
        if ($cached) {
            Response::success($cached);
        }

        try {
            $data = GaugeProxy::fetchUSGS($siteId);
            GaugeProxy::setCache($siteId, 'usgs', $data);
            Response::success($data);
        } catch (RuntimeException $e) {
            Response::error('Failed to fetch gauge data', 503);
        }
    }

    public function getHazards(int $id): void {
        $river = River::findById($this->db, $id);
        if (!$river) {
            Response::error('River not found', 404);
        }
        $hazards = Hazard::findByRiverId($this->db, $id);
        Response::success($hazards);
    }

    public function getRuns(int $id, array $params, ?array $auth): void {
        $river = River::findById($this->db, $id);
        if (!$river) {
            Response::error('River not found', 404);
        }
        $limit = min((int) ($params['limit'] ?? 20), 50);
        $runs  = RunLog::findByRiverId($this->db, $id, $limit);
        Response::success($runs);
    }

    public function getFeed(int $id, ?array $auth): void {
        $river = River::findById($this->db, $id);
        if (!$river) {
            Response::error('River not found', 404);
        }

        $stmt = $this->db->prepare(
            'SELECT p.*, u.username, u.display_name, u.avatar_url
             FROM posts p
             JOIN users u ON u.id = p.user_id
             WHERE p.river_id = :rid
             ORDER BY p.created_at DESC
             LIMIT 30'
        );
        $stmt->execute([':rid' => $id]);
        Response::success($stmt->fetchAll());
    }
}
