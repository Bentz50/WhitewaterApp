<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

class NotificationController {
    private PDO $db;

    public function __construct() {
        $this->db = Database::getInstance()->getConn();
    }

    /**
     * POST /notifications/dam-release (internal/cron trigger)
     * Finds users who ran rivers within 50 miles of a dam in the last 30 days
     * and inserts notification records. Actual APNs push is a TODO placeholder.
     */
    public function triggerDamRelease(array $body): void {
        $missing = Validator::required($body, ['dam_lat', 'dam_lng', 'dam_name']);
        if ($missing) {
            Response::error('Missing required fields', 400, $missing);
        }

        $lat     = (float) $body['dam_lat'];
        $lng     = (float) $body['dam_lng'];
        $damName = Validator::sanitizeString($body['dam_name']);
        $message = $body['message'] ?? "Dam release alert near $damName. Check flows before paddling.";

        // Find users who ran nearby rivers in the last 30 days
        $sql = "SELECT DISTINCT rl.user_id
                FROM run_logs rl
                JOIN rivers r ON r.id = rl.river_id
                WHERE rl.run_date >= DATE_SUB(NOW(), INTERVAL 30 DAY)
                  AND (3958.8 * ACOS(
                        COS(RADIANS(:lat1)) * COS(RADIANS(r.put_in_lat)) *
                        COS(RADIANS(r.put_in_lng) - RADIANS(:lng1)) +
                        SIN(RADIANS(:lat2)) * SIN(RADIANS(r.put_in_lat))
                  )) <= 50";

        $stmt = $this->db->prepare($sql);
        $stmt->execute([':lat1' => $lat, ':lng1' => $lng, ':lat2' => $lat]);
        $users = $stmt->fetchAll();

        $ins = $this->db->prepare(
            'INSERT INTO notifications (user_id, type, title, body, data, is_read, created_at)
             VALUES (:uid, :type, :title, :body, :data, 0, NOW())'
        );

        $notified = 0;
        foreach ($users as $row) {
            $ins->execute([
                ':uid'   => $row['user_id'],
                ':type'  => 'dam_release',
                ':title' => 'Dam Release Alert',
                ':body'  => $message,
                ':data'  => json_encode(['dam_name' => $damName, 'lat' => $lat, 'lng' => $lng]),
            ]);
            $notified++;
            // TODO: Send actual APNs push notification using PUSH_CERT_PATH
        }

        Response::success(['notified_users' => $notified], 'Notifications queued');
    }

    public function getNotifications(array $auth): void {
        $stmt = $this->db->prepare(
            'SELECT * FROM notifications
             WHERE user_id = :uid
             ORDER BY created_at DESC
             LIMIT 50'
        );
        $stmt->execute([':uid' => (int) $auth['user_id']]);
        Response::success($stmt->fetchAll());
    }

    public function markRead(int $id, array $auth): void {
        $stmt = $this->db->prepare(
            'UPDATE notifications SET is_read = 1
             WHERE id = :id AND user_id = :uid'
        );
        $stmt->execute([':id' => $id, ':uid' => (int) $auth['user_id']]);
        if ($stmt->rowCount() === 0) {
            Response::error('Notification not found', 404);
        }
        Response::success(null, 'Marked as read');
    }
}
