<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

class Database {
    private string $host     = 'localhost';
    private string $db_name  = 'whitewaterapp_db';
    private string $username = 'YOUR_DB_USER';     // TODO: replace with real credentials
    private string $password = 'YOUR_DB_PASSWORD'; // TODO: replace
    private string $charset  = 'utf8mb4';

    private static ?Database $instance = null;
    private ?PDO $conn = null;

    private function __construct() {}

    public static function getInstance(): self {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    public function getConnection(): PDO {
        if ($this->conn !== null) {
            return $this->conn;
        }

        $dsn = "mysql:host={$this->host};dbname={$this->db_name};charset={$this->charset}";
        $options = [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ];

        try {
            $this->conn = new PDO($dsn, $this->username, $this->password, $options);
        } catch (PDOException $e) {
            error_log('Database connection failed: ' . $e->getMessage());
            Response::error('Database connection failed', 500);
            exit;
        }

        return $this->conn;
    }

    /** Alias for getConnection(). */
    public function getConn(): PDO {
        return $this->getConnection();
    }
}
