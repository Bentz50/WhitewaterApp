<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

require_once __DIR__ . '/../models/River.php';
require_once __DIR__ . '/../models/RiverSection.php';
require_once __DIR__ . '/../models/Hazard.php';
require_once __DIR__ . '/../models/RunLog.php';
require_once __DIR__ . '/../models/RiverVideo.php';

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
        $river = River::findByIdWithSections($this->db, $id);
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

    public function getFeed(int $id, ?array $auth, array $params = []): void {
        $river = River::findById($this->db, $id);
        if (!$river) {
            Response::error('River not found', 404);
        }

        $scope  = Validator::sanitizeString($params['scope'] ?? '');
        $userId = $auth['user_id'] ?? null;

        if ($scope === 'crew' && $userId) {
            // Crew-only: posts from crew members on this river
            $stmt = $this->db->prepare(
                'SELECT p.*, u.username, u.display_name, u.avatar_url, 1 AS is_crew
                 FROM posts p
                 JOIN users u ON u.id = p.user_id
                 WHERE p.river_id = :rid
                   AND p.user_id IN (
                       SELECT friend_id FROM crew WHERE user_id = :uid1 AND status = \'accepted\'
                       UNION
                       SELECT user_id FROM crew WHERE friend_id = :uid2 AND status = \'accepted\'
                   )
                 ORDER BY p.created_at DESC
                 LIMIT 30'
            );
            $stmt->execute([':rid' => $id, ':uid1' => $userId, ':uid2' => $userId]);
        } elseif ($userId) {
            // Authenticated: public posts + crew-visible posts from crew members
            $stmt = $this->db->prepare(
                'SELECT p.*, u.username, u.display_name, u.avatar_url,
                        CASE WHEN c.id IS NOT NULL THEN 1 ELSE 0 END AS is_crew
                 FROM posts p
                 JOIN users u ON u.id = p.user_id
                 LEFT JOIN run_logs rl ON rl.id = p.run_log_id
                 LEFT JOIN (
                     SELECT friend_id AS crew_uid, id FROM crew WHERE user_id = :uid1 AND status = \'accepted\'
                     UNION
                     SELECT user_id AS crew_uid, id FROM crew WHERE friend_id = :uid2 AND status = \'accepted\'
                 ) c ON c.crew_uid = p.user_id
                 WHERE p.river_id = :rid
                   AND (
                       rl.privacy IS NULL
                       OR rl.privacy = \'public\'
                       OR (rl.privacy = \'crew\' AND c.id IS NOT NULL)
                       OR p.user_id = :uid3
                   )
                 ORDER BY p.created_at DESC
                 LIMIT 30'
            );
            $stmt->execute([
                ':rid'  => $id,
                ':uid1' => $userId,
                ':uid2' => $userId,
                ':uid3' => $userId,
            ]);
        } else {
            // Unauthenticated: only public posts
            $stmt = $this->db->prepare(
                'SELECT p.*, u.username, u.display_name, u.avatar_url, 0 AS is_crew
                 FROM posts p
                 JOIN users u ON u.id = p.user_id
                 LEFT JOIN run_logs rl ON rl.id = p.run_log_id
                 WHERE p.river_id = :rid
                   AND (rl.privacy IS NULL OR rl.privacy = \'public\')
                 ORDER BY p.created_at DESC
                 LIMIT 30'
            );
            $stmt->execute([':rid' => $id]);
        }

        Response::success($stmt->fetchAll());
    }

    public function getVideos(int $id, array $params): void {
        $river = River::findById($this->db, $id);
        if (!$river) {
            Response::error('River not found', 404);
        }

        $level = Validator::sanitizeFloat($params['level'] ?? null);
        $videos = RiverVideo::findByRiverId($this->db, $id, $level);
        Response::success($videos);
    }

    // ── Section Endpoints ────────────────────────────────────────────

    public function getSections(int $id): void {
        $river = River::findById($this->db, $id);
        if (!$river) {
            Response::error('River not found', 404);
        }
        $sections = RiverSection::findByRiverId($this->db, $id);
        Response::success($sections);
    }

    public function showSection(int $riverId, int $sectionId): void {
        $section = RiverSection::findById($this->db, $sectionId);
        if (!$section || (int) $section['river_id'] !== $riverId) {
            Response::error('Section not found', 404);
        }
        Response::success($section);
    }

    public function getSectionGauge(int $riverId, int $sectionId): void {
        $section = RiverSection::findById($this->db, $sectionId);
        if (!$section || (int) $section['river_id'] !== $riverId) {
            Response::error('Section not found', 404);
        }

        $siteId = $section['usgs_site_id'] ?? null;
        if (!$siteId) {
            // Fall back to parent river gauge
            $river = River::findById($this->db, $riverId);
            $siteId = $river['usgs_site_id'] ?? null;
        }
        if (!$siteId) {
            Response::error('No gauge configured for this section', 404);
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

    public function getSectionHazards(int $riverId, int $sectionId): void {
        $section = RiverSection::findById($this->db, $sectionId);
        if (!$section || (int) $section['river_id'] !== $riverId) {
            Response::error('Section not found', 404);
        }
        $hazards = Hazard::findBySectionId($this->db, $sectionId);
        Response::success($hazards);
    }

    public function getSectionVideos(int $riverId, int $sectionId, array $params): void {
        $section = RiverSection::findById($this->db, $sectionId);
        if (!$section || (int) $section['river_id'] !== $riverId) {
            Response::error('Section not found', 404);
        }

        $level = Validator::sanitizeFloat($params['level'] ?? null);
        $videos = RiverVideo::findBySectionId($this->db, $sectionId, $level);
        Response::success($videos);
    }
}
