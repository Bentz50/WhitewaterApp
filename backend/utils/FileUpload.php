<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

class FileUpload {
    private static array $imageTypes = ['image/jpeg', 'image/png', 'image/heic', 'image/webp'];
    private static array $videoTypes = ['video/mp4', 'video/quicktime'];

    public static function upload(
        array $file,
        string $subdir = '',
        array $allowedTypes = ['image/jpeg', 'image/png', 'image/heic', 'video/mp4']
    ): string {
        if ($file['error'] !== UPLOAD_ERR_OK) {
            throw new RuntimeException('Upload error code: ' . $file['error']);
        }

        $mimeType = mime_content_type($file['tmp_name']);
        if (!in_array($mimeType, $allowedTypes, true)) {
            throw new RuntimeException('File type not allowed: ' . $mimeType);
        }

        $isVideo = in_array($mimeType, self::$videoTypes, true);
        $maxSize = $isVideo ? MAX_VIDEO_SIZE : MAX_FILE_SIZE;

        if ($file['size'] > $maxSize) {
            throw new RuntimeException('File exceeds maximum allowed size');
        }

        $ext      = self::mimeToExtension($mimeType);
        $filename = uniqid('wwa_', true) . '.' . $ext;
        $destDir  = rtrim(UPLOAD_PATH . $subdir, '/') . '/';

        if (!is_dir($destDir) && !mkdir($destDir, 0755, true)) {
            throw new RuntimeException('Failed to create upload directory');
        }

        $destPath = $destDir . $filename;
        if (!move_uploaded_file($file['tmp_name'], $destPath)) {
            throw new RuntimeException('Failed to move uploaded file');
        }

        $urlBase = rtrim(UPLOAD_URL, '/') . ($subdir ? '/' . trim($subdir, '/') : '');
        return $urlBase . '/' . $filename;
    }

    public static function delete(string $url): bool {
        $relative = str_replace(UPLOAD_URL, '', $url);
        $path     = rtrim(UPLOAD_PATH, '/') . '/' . ltrim($relative, '/');
        if (file_exists($path)) {
            return unlink($path);
        }
        return false;
    }

    private static function mimeToExtension(string $mimeType): string {
        $map = [
            'image/jpeg'      => 'jpg',
            'image/png'       => 'png',
            'image/heic'      => 'heic',
            'image/webp'      => 'webp',
            'video/mp4'       => 'mp4',
            'video/quicktime' => 'mov',
        ];
        return $map[$mimeType] ?? 'bin';
    }
}
