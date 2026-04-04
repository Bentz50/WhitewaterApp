<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

class Response {
    private static function send(array $body, int $code): void {
        header('Content-Type: application/json; charset=utf-8');
        http_response_code($code);
        $json = json_encode($body, JSON_UNESCAPED_SLASHES);
        if ($json === false) {
            http_response_code(500);
            echo json_encode([
                'success' => false,
                'message' => 'Internal encoding error: ' . json_last_error_msg(),
            ]);
        } else {
            echo $json;
        }
        exit;
    }

    public static function success($data = null, string $message = 'Success', int $code = 200): void {
        self::send([
            'success' => true,
            'data'    => $data,
            'message' => $message,
        ], $code);
    }

    public static function error(string $message, int $code = 400, $errors = null): void {
        $body = [
            'success' => false,
            'data'    => null,
            'message' => $message,
        ];
        if ($errors !== null) {
            $body['errors'] = $errors;
        }
        self::send($body, $code);
    }

    public static function paginated(array $items, int $total, int $page, int $perPage): void {
        self::send([
            'success' => true,
            'data'    => $items,
            'pagination' => [
                'total'        => $total,
                'page'         => $page,
                'per_page'     => $perPage,
                'total_pages'  => (int) ceil($total / max(1, $perPage)),
                'has_more'     => ($page * $perPage) < $total,
            ],
        ], 200);
    }
}
