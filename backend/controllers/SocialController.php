<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

require_once __DIR__ . '/../models/Comment.php';

class SocialController extends BaseController {

    public function getFeed(?array $auth, array $params): void {
        $page    = max(1, (int) ($params['page']     ?? 1));
        $perPage = min((int) ($params['per_page'] ?? 20), 50);
        $offset  = ($page - 1) * $perPage;

        $stmt = $this->db->prepare(
            'SELECT p.*, u.username, u.display_name, u.avatar_url,
                    (SELECT COUNT(*) FROM post_likes pl WHERE pl.post_id = p.id) AS like_count,
                    (SELECT COUNT(*) FROM comments c WHERE c.post_id = p.id) AS comment_count
             FROM posts p
             JOIN users u ON u.id = p.user_id
             WHERE p.is_public = 1
             ORDER BY p.created_at DESC
             LIMIT :lim OFFSET :off'
        );
        $stmt->bindValue(':lim', $perPage, PDO::PARAM_INT);
        $stmt->bindValue(':off', $offset, PDO::PARAM_INT);
        $stmt->execute();
        $posts = $stmt->fetchAll();

        $countStmt = $this->db->prepare('SELECT COUNT(*) AS cnt FROM posts WHERE is_public = 1');
        $countStmt->execute();
        $total = (int) ($countStmt->fetch()['cnt'] ?? 0);

        Response::paginated($posts, $total, $page, $perPage);
    }

    public function getCrewFeed(?array $auth, array $params): void {
        if (!$auth) {
            Response::error('Unauthorized', 401);
        }

        $page    = max(1, (int) ($params['page']     ?? 1));
        $perPage = min((int) ($params['per_page'] ?? 20), 50);
        $offset  = ($page - 1) * $perPage;
        $userId  = (int) $auth['user_id'];

        $stmt = $this->db->prepare(
            'SELECT p.*, u.username, u.display_name, u.avatar_url,
                    (SELECT COUNT(*) FROM post_likes pl WHERE pl.post_id = p.id) AS like_count,
                    (SELECT COUNT(*) FROM comments c WHERE c.post_id = p.id) AS comment_count
             FROM posts p
             JOIN users u ON u.id = p.user_id
             WHERE p.user_id IN (
                 SELECT IF(c.user_id = :uid, c.crew_member_id, c.user_id)
                 FROM crew c
                 WHERE (c.user_id = :uid2 OR c.crew_member_id = :uid3) AND c.status = :st
             )
             ORDER BY p.created_at DESC
             LIMIT :lim OFFSET :off'
        );
        $stmt->bindValue(':uid',  $userId, PDO::PARAM_INT);
        $stmt->bindValue(':uid2', $userId, PDO::PARAM_INT);
        $stmt->bindValue(':uid3', $userId, PDO::PARAM_INT);
        $stmt->bindValue(':st',   'accepted', PDO::PARAM_STR);
        $stmt->bindValue(':lim',  $perPage, PDO::PARAM_INT);
        $stmt->bindValue(':off',  $offset, PDO::PARAM_INT);
        $stmt->execute();
        $posts = $stmt->fetchAll();

        Response::paginated($posts, count($posts) + $offset, $page, $perPage);
    }

    public function addComment(int $postId, array $body, array $auth): void {
        $missing = Validator::required($body, ['body']);
        if ($missing) {
            Response::error('Comment body is required', 400);
        }

        $id = Comment::create($this->db, [
            'post_id' => $postId,
            'user_id' => (int) $auth['user_id'],
            'body'    => Validator::sanitizeString($body['body']),
        ]);
        Response::success(['id' => $id], 'Comment added', 201);
    }

    public function likePost(int $postId, array $auth): void {
        $userId = (int) $auth['user_id'];

        $check = $this->db->prepare(
            'SELECT id FROM post_likes WHERE post_id = :pid AND user_id = :uid LIMIT 1'
        );
        $check->execute([':pid' => $postId, ':uid' => $userId]);

        if ($check->fetch()) {
            // Toggle off
            $this->db->prepare('DELETE FROM post_likes WHERE post_id = :pid AND user_id = :uid')
                     ->execute([':pid' => $postId, ':uid' => $userId]);
            Response::success(['liked' => false], 'Like removed');
        } else {
            $this->db->prepare('INSERT INTO post_likes (post_id, user_id, created_at) VALUES (:pid, :uid, NOW())')
                     ->execute([':pid' => $postId, ':uid' => $userId]);
            Response::success(['liked' => true], 'Post liked');
        }
    }

    public function getComments(int $postId): void {
        $comments = Comment::findByPostId($this->db, $postId);
        Response::success($comments);
    }
}
