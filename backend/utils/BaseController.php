<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

/**
 * Base controller providing common helpers for all controllers.
 */
abstract class BaseController {
    protected PDO $db;

    public function __construct() {
        $this->db = Database::getInstance()->getConn();
    }

    /**
     * Return $result if truthy, otherwise respond with a 404 error and exit.
     */
    protected function findOrFail(mixed $result, string $label = 'Resource'): mixed {
        if (!$result) {
            Response::error("$label not found", 404);
        }
        return $result;
    }

    /**
     * Ensure the authenticated user owns the resource. Responds 403 if not.
     */
    protected function requireOwnership(array $resource, array $auth, string $field = 'user_id'): void {
        if ((int) $resource[$field] !== (int) $auth['user_id']) {
            Response::error('Access denied', 403);
        }
    }
}
