<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

class Message {
    /** Latest message per conversation partner. */
    public static function getConversations(PDO $db, int $userId): array {
        $sql = 'SELECT m.*,
                    u.username, u.display_name, u.avatar_url,
                    (SELECT COUNT(*) FROM messages m2
                     WHERE m2.recipient_id = :uid AND m2.sender_id = m.sender_id AND m2.is_read = 0) AS unread_count
                FROM messages m
                JOIN users u ON u.id = IF(m.sender_id = :uid2, m.recipient_id, m.sender_id)
                WHERE m.id IN (
                    SELECT MAX(id)
                    FROM messages
                    WHERE sender_id = :uid3 OR recipient_id = :uid4
                    GROUP BY LEAST(sender_id, recipient_id), GREATEST(sender_id, recipient_id)
                )
                ORDER BY m.created_at DESC';
        $stmt = $db->prepare($sql);
        $stmt->execute([':uid' => $userId, ':uid2' => $userId, ':uid3' => $userId, ':uid4' => $userId]);
        return $stmt->fetchAll();
    }

    public static function getMessages(PDO $db, int $userId1, int $userId2, int $page = 1): array {
        $perPage = 30;
        $offset  = ($page - 1) * $perPage;
        $stmt    = $db->prepare(
            'SELECT m.*, u.username, u.avatar_url
             FROM messages m
             JOIN users u ON u.id = m.sender_id
             WHERE (m.sender_id = :uid1 AND m.recipient_id = :uid2)
                OR (m.sender_id = :uid3 AND m.recipient_id = :uid4)
             ORDER BY m.created_at DESC
             LIMIT :lim OFFSET :off'
        );
        $stmt->bindValue(':uid1', $userId1, PDO::PARAM_INT);
        $stmt->bindValue(':uid2', $userId2, PDO::PARAM_INT);
        $stmt->bindValue(':uid3', $userId2, PDO::PARAM_INT);
        $stmt->bindValue(':uid4', $userId1, PDO::PARAM_INT);
        $stmt->bindValue(':lim', $perPage, PDO::PARAM_INT);
        $stmt->bindValue(':off', $offset, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll();
    }

    public static function create(PDO $db, array $data): int {
        $sql  = 'INSERT INTO messages (sender_id, recipient_id, body, is_read, created_at)
                 VALUES (:sender_id, :recipient_id, :body, 0, NOW())';
        $stmt = $db->prepare($sql);
        $stmt->execute([
            ':sender_id'    => $data['sender_id'],
            ':recipient_id' => $data['recipient_id'],
            ':body'         => $data['body'],
        ]);
        return (int) $db->lastInsertId();
    }

    public static function markRead(PDO $db, int $userId, int $senderId): void {
        $stmt = $db->prepare(
            'UPDATE messages SET is_read = 1
             WHERE recipient_id = :uid AND sender_id = :sid AND is_read = 0'
        );
        $stmt->execute([':uid' => $userId, ':sid' => $senderId]);
    }
}
