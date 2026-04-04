<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

require_once __DIR__ . '/../models/User.php';

class UserController extends BaseController {

    public function getMe(array $auth): void {
        $user = $this->findOrFail(User::findById($this->db, (int) $auth['user_id']), 'User');
        Response::success(User::toPublicArray($user));
    }

    public function updateMe(array $body, array $auth): void {
        $allowed = ['display_name', 'preferred_difficulty', 'water_experiences', 'interests', 'bio'];
        $data    = [];
        foreach ($allowed as $field) {
            if (array_key_exists($field, $body)) {
                $data[$field] = is_string($body[$field])
                    ? Validator::sanitizeString($body[$field])
                    : $body[$field];
            }
        }

        if (empty($data)) {
            Response::error('No updatable fields provided', 400);
        }

        User::update($this->db, (int) $auth['user_id'], $data);
        $user = User::findById($this->db, (int) $auth['user_id']);
        Response::success(User::toPublicArray($user));
    }

    public function uploadAvatar(array $auth): void {
        if (empty($_FILES['avatar'])) {
            Response::error('No file uploaded', 400);
        }

        try {
            $url = FileUpload::upload($_FILES['avatar'], 'avatars', ['image/jpeg', 'image/png', 'image/heic', 'image/webp']);
        } catch (RuntimeException $e) {
            Response::error($e->getMessage(), 400);
        }

        User::update($this->db, (int) $auth['user_id'], ['avatar_url' => $url]);
        Response::success(['avatar_url' => $url]);
    }

    public function getUser(int $userId): void {
        $user = $this->findOrFail(User::findById($this->db, $userId), 'User');
        // Return only public-safe fields
        Response::success([
            'id'           => $user['id'],
            'username'     => $user['username'],
            'display_name' => $user['display_name'],
            'avatar_url'   => $user['avatar_url'],
            'bio'          => $user['bio'] ?? null,
            'created_at'   => $user['created_at'],
        ]);
    }

    public function searchUsers(array $params): void {
        $q = trim($params['q'] ?? '');
        if (strlen($q) < 2) {
            Response::error('Query must be at least 2 characters', 400);
        }
        $users = User::search($this->db, $q);
        Response::success($users);
    }

    // ── Crew ──────────────────────────────────────────────────────────

    public function getCrew(array $auth): void {
        $stmt = $this->db->prepare(
            'SELECT u.id, u.username, u.display_name, u.avatar_url, c.status, c.created_at AS since
             FROM crew c
             JOIN users u ON u.id = IF(c.user_id = :uid, c.crew_member_id, c.user_id)
             WHERE (c.user_id = :uid2 OR c.crew_member_id = :uid3) AND c.status = :st'
        );
        $stmt->execute([
            ':uid'  => $auth['user_id'],
            ':uid2' => $auth['user_id'],
            ':uid3' => $auth['user_id'],
            ':st'   => 'accepted',
        ]);
        Response::success($stmt->fetchAll());
    }

    public function addCrew(int $targetUserId, array $auth): void {
        $myId = (int) $auth['user_id'];
        if ($myId === $targetUserId) {
            Response::error('Cannot add yourself to crew', 400);
        }

        $check = $this->db->prepare(
            'SELECT id FROM crew
             WHERE (user_id = :uid AND crew_member_id = :tid)
                OR (user_id = :tid2 AND crew_member_id = :uid2)
             LIMIT 1'
        );
        $check->execute([':uid' => $myId, ':tid' => $targetUserId, ':tid2' => $targetUserId, ':uid2' => $myId]);
        if ($check->fetch()) {
            Response::error('Crew relationship already exists', 409);
        }

        $stmt = $this->db->prepare(
            'INSERT INTO crew (user_id, crew_member_id, status, created_at)
             VALUES (:uid, :tid, :st, NOW())'
        );
        $stmt->execute([':uid' => $myId, ':tid' => $targetUserId, ':st' => 'pending']);
        Response::success(['status' => 'pending'], 'Crew request sent', 201);
    }

    public function removeCrew(int $targetUserId, array $auth): void {
        $myId = (int) $auth['user_id'];
        $stmt = $this->db->prepare(
            'DELETE FROM crew
             WHERE (user_id = :uid AND crew_member_id = :tid)
                OR (user_id = :tid2 AND crew_member_id = :uid2)'
        );
        $stmt->execute([':uid' => $myId, ':tid' => $targetUserId, ':tid2' => $targetUserId, ':uid2' => $myId]);
        Response::success(null, 'Removed from crew');
    }
}
