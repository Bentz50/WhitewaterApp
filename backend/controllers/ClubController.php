<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

require_once __DIR__ . '/../models/ClubMembership.php';

class ClubController extends BaseController {

    public function index(array $auth): void {
        $clubs = ClubMembership::findByUserId($this->db, (int) $auth['user_id']);
        Response::success($clubs);
    }

    public function create(array $body, array $auth): void {
        $missing = Validator::required($body, ['club_name']);
        if ($missing) {
            Response::error('Missing required fields', 400, $missing);
        }

        $data = [
            'user_id'   => (int) $auth['user_id'],
            'club_name' => Validator::sanitizeString($body['club_name']),
            'joined_at' => $body['joined_at'] ?? date('Y-m-d'),
        ];

        $id   = ClubMembership::create($this->db, $data);
        $clubs = ClubMembership::findByUserId($this->db, (int) $auth['user_id']);
        $created = array_filter($clubs, fn($c) => (int) $c['id'] === $id);
        Response::success(array_values($created)[0] ?? ['id' => $id], 'Club membership created', 201);
    }

    public function delete(int $id, array $auth): void {
        $deleted = ClubMembership::delete($this->db, $id, (int) $auth['user_id']);
        if (!$deleted) {
            Response::error('Club membership not found or access denied', 404);
        }
        Response::success(null, 'Club membership deleted');
    }
}
