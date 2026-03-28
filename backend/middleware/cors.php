<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

function applyCors(): void {
    // TODO: Restrict to specific trusted domains in production (e.g., your app domain / API gateway)
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With');

    if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
        http_response_code(200);
        exit;
    }
}
