<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

class Media {
    public static function create(PDO $db, array $data): int {
        $sql = 'INSERT INTO media
                    (run_log_id, user_id, url, type, thumbnail_url, caption, created_at)
                VALUES
                    (:run_log_id, :user_id, :url, :type, :thumbnail_url, :caption, NOW())';
        $stmt = $db->prepare($sql);
        $stmt->execute([
            ':run_log_id'    => $data['run_log_id'],
            ':user_id'       => $data['user_id'],
            ':url'           => $data['url'],
            ':type'          => $data['type']          ?? 'image',
            ':thumbnail_url' => $data['thumbnail_url'] ?? null,
            ':caption'       => $data['caption']       ?? null,
        ]);
        return (int) $db->lastInsertId();
    }

    public static function findByRunLogId(PDO $db, int $runLogId): array {
        $stmt = $db->prepare(
            'SELECT * FROM media WHERE run_log_id = :rid ORDER BY created_at ASC'
        );
        $stmt->execute([':rid' => $runLogId]);
        return $stmt->fetchAll();
    }

    public static function delete(PDO $db, int $id, int $userId): bool {
        $stmt = $db->prepare('DELETE FROM media WHERE id = :id AND user_id = :uid');
        $stmt->execute([':id' => $id, ':uid' => $userId]);
        return $stmt->rowCount() > 0;
    }
}
