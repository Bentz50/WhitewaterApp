<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

require_once __DIR__ . '/../models/Event.php';

class EventController extends BaseController {

    public function index(array $params): void {
        $lat    = Validator::sanitizeFloat($params['lat']    ?? null);
        $lng    = Validator::sanitizeFloat($params['lng']    ?? null);
        $radius = Validator::sanitizeFloat($params['radius'] ?? 50);

        if ($lat !== null && $lng !== null) {
            $events = Event::findNearby($this->db, $lat, $lng, $radius);
        } else {
            $events = Event::findAll($this->db, $params);
        }

        Response::success($events);
    }

    public function create(array $body, array $auth): void {
        $missing = Validator::required($body, ['title', 'event_date']);
        if ($missing) {
            Response::error('Missing required fields', 400, $missing);
        }

        $id = Event::create($this->db, array_merge($body, ['organizer_id' => (int) $auth['user_id']]));
        Response::success(['id' => $id], 'Event created', 201);
    }
}
