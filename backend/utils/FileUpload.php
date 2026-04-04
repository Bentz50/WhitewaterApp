<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

class FileUpload {
    /** Allowed image MIME types. */
    public const IMAGE_TYPES = ['image/jpeg', 'image/png', 'image/heic', 'image/webp'];

    /** Allowed video MIME types. */
    public const VIDEO_TYPES = ['video/mp4', 'video/quicktime'];

    /** All allowed upload types. */
    public const ALL_TYPES = [...self::IMAGE_TYPES, ...self::VIDEO_TYPES];

    /** Map of MIME type → file extension. */
    private const MIME_EXT_MAP = [
        'image/jpeg'      => 'jpg',
        'image/png'       => 'png',
        'image/heic'      => 'heic',
        'image/webp'      => 'webp',
        'video/mp4'       => 'mp4',
        'video/quicktime' => 'mov',
    ];

    public static function upload(
        array $file,
        string $subdir = '',
        array $allowedTypes = self::ALL_TYPES
    ): string {
        if ($file['error'] !== UPLOAD_ERR_OK) {
            throw new RuntimeException('Upload error: ' . self::uploadErrorMessage($file['error']));
        }

        $mimeType = mime_content_type($file['tmp_name']);
        if (!in_array($mimeType, $allowedTypes, true)) {
            throw new RuntimeException('File type not allowed: ' . $mimeType);
        }

        $ext = self::MIME_EXT_MAP[$mimeType] ?? null;
        if ($ext === null) {
            throw new RuntimeException('Unsupported MIME type: ' . $mimeType);
        }

        $isVideo = in_array($mimeType, self::VIDEO_TYPES, true);
        $maxSize = $isVideo ? MAX_VIDEO_SIZE : MAX_FILE_SIZE;

        if ($file['size'] > $maxSize) {
            throw new RuntimeException('File exceeds maximum allowed size');
        }

        $filename = self::generateSecureFilename($ext);
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

    /**
     * Generate a cryptographically secure filename to prevent collisions.
     */
    private static function generateSecureFilename(string $ext): string {
        return 'wwa_' . bin2hex(random_bytes(16)) . '.' . $ext;
    }

    /**
     * Convert a PHP upload error code to a human-readable message.
     */
    private static function uploadErrorMessage(int $code): string {
        return match ($code) {
            UPLOAD_ERR_INI_SIZE   => 'File exceeds server upload_max_filesize',
            UPLOAD_ERR_FORM_SIZE  => 'File exceeds form MAX_FILE_SIZE',
            UPLOAD_ERR_PARTIAL    => 'File was only partially uploaded',
            UPLOAD_ERR_NO_FILE    => 'No file was uploaded',
            UPLOAD_ERR_NO_TMP_DIR => 'Missing a temporary folder',
            UPLOAD_ERR_CANT_WRITE => 'Failed to write file to disk',
            UPLOAD_ERR_EXTENSION  => 'A PHP extension stopped the file upload',
            default               => "Unknown upload error (code $code)",
        };
    }
}
