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
        $pushData = ['dam_name' => $damName, 'lat' => $lat, 'lng' => $lng];

        $userIds = array_column($users, 'user_id');

        // Batch-fetch push tokens for all affected users
        $pushTokens = [];
        if (!empty($userIds)) {
            $placeholders = implode(',', array_fill(0, count($userIds), '?'));
            $tokenStmt = $this->db->prepare(
                "SELECT id, push_token FROM users WHERE id IN ({$placeholders})"
            );
            $tokenStmt->execute($userIds);
            foreach ($tokenStmt->fetchAll() as $tokenRow) {
                if (!empty($tokenRow['push_token'])) {
                    $pushTokens[$tokenRow['id']] = $tokenRow['push_token'];
                }
            }
        }

        foreach ($users as $row) {
            $ins->execute([
                ':uid'   => $row['user_id'],
                ':type'  => 'dam_release',
                ':title' => 'Dam Release Alert',
                ':body'  => $message,
                ':data'  => json_encode($pushData),
            ]);
            $notified++;

            // Send APNs push if user has a push token
            if (isset($pushTokens[$row['user_id']])) {
                $this->sendAPNsPush(
                    $pushTokens[$row['user_id']],
                    'Dam Release Alert',
                    $message,
                    $pushData
                );
            }
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

    /**
     * Send an APNs push notification via HTTP/2 using cURL.
     */
    private function sendAPNsPush(string $deviceToken, string $title, string $body, array $data = []): bool {
        $isSandbox = defined('APP_ENV') && APP_ENV !== 'production';
        $host = $isSandbox
            ? 'https://api.sandbox.push.apple.com'
            : 'https://api.push.apple.com';
        $url = "{$host}/3/device/{$deviceToken}";

        $payload = json_encode([
            'aps' => [
                'alert' => ['title' => $title, 'body' => $body],
                'sound' => 'default',
                'badge' => 1,
            ],
            'data' => $data,
        ]);

        $ch = curl_init($url);
        curl_setopt_array($ch, [
            CURLOPT_HTTP_VERSION   => CURL_HTTP_VERSION_2_0,
            CURLOPT_POST           => true,
            CURLOPT_POSTFIELDS     => $payload,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_TIMEOUT        => 10,
            CURLOPT_SSLCERT        => PUSH_CERT_PATH,
            CURLOPT_HTTPHEADER     => [
                'Content-Type: application/json',
                'apns-topic: ' . APNS_TOPIC,
                'apns-push-type: alert',
            ],
        ]);

        $response = curl_exec($ch);
        $httpCode = (int) curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $curlError = curl_error($ch);
        curl_close($ch);

        if ($curlError) {
            error_log("APNs cURL error for token {$deviceToken}: {$curlError}");
            return false;
        }

        if ($httpCode !== 200) {
            error_log("APNs HTTP {$httpCode} for token {$deviceToken}: {$response}");
            return false;
        }

        return true;
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
