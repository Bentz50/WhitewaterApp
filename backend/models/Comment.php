<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

class Comment {
    public static function findByPostId(PDO $db, int $postId): array {
        $stmt = $db->prepare(
            'SELECT c.*, u.username, u.display_name, u.avatar_url
             FROM comments c
             JOIN users u ON u.id = c.user_id
             WHERE c.post_id = :pid
             ORDER BY c.created_at ASC'
        );
        $stmt->execute([':pid' => $postId]);
        return $stmt->fetchAll();
    }

    public static function create(PDO $db, array $data): int {
        $sql = 'INSERT INTO comments (post_id, user_id, content, created_at)
                VALUES (:post_id, :user_id, :content, NOW())';
        $stmt = $db->prepare($sql);
        $stmt->execute([
            ':post_id' => $data['post_id'],
            ':user_id' => $data['user_id'],
            ':content' => $data['content'],
        ]);
        return (int) $db->lastInsertId();
    }
}
