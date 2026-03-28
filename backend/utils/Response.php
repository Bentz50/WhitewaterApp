<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

class Response {
    public static function success($data = null, string $message = 'Success', int $code = 200): void {
        header('Content-Type: application/json');
        http_response_code($code);
        echo json_encode([
            'success' => true,
            'data'    => $data,
            'message' => $message,
        ]);
        exit;
    }

    public static function error(string $message, int $code = 400, $errors = null): void {
        header('Content-Type: application/json');
        http_response_code($code);
        $body = [
            'success' => false,
            'message' => $message,
        ];
        if ($errors !== null) {
            $body['errors'] = $errors;
        }
        echo json_encode($body);
        exit;
    }

    public static function paginated(array $items, int $total, int $page, int $perPage): void {
        header('Content-Type: application/json');
        http_response_code(200);
        echo json_encode([
            'success' => true,
            'data'    => $items,
            'pagination' => [
                'total'        => $total,
                'page'         => $page,
                'per_page'     => $perPage,
                'total_pages'  => (int) ceil($total / max(1, $perPage)),
                'has_more'     => ($page * $perPage) < $total,
            ],
        ]);
        exit;
    }
}
