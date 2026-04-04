<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

require_once __DIR__ . '/../models/Message.php';

class MessageController extends BaseController {

    public function getConversations(array $auth): void {
        $conversations = Message::getConversations($this->db, (int) $auth['user_id']);
        Response::success($conversations);
    }

    public function getMessages(int $otherUserId, array $auth, array $params): void {
        $page     = max(1, (int) ($params['page'] ?? 1));
        $messages = Message::getMessages($this->db, (int) $auth['user_id'], $otherUserId, $page);

        // Mark incoming as read
        Message::markRead($this->db, (int) $auth['user_id'], $otherUserId);

        Response::success($messages);
    }

    public function sendMessage(int $recipientId, array $body, array $auth): void {
        $missing = Validator::required($body, ['body']);
        if ($missing) {
            Response::error('Message body is required', 400);
        }

        $senderId = (int) $auth['user_id'];
        if ($senderId === $recipientId) {
            Response::error('Cannot send a message to yourself', 400);
        }

        $id = Message::create($this->db, [
            'sender_id'    => $senderId,
            'recipient_id' => $recipientId,
            'body'         => Validator::sanitizeString($body['body']),
        ]);
        Response::success(['id' => $id], 'Message sent', 201);
    }
}
