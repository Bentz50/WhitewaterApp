<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

class Database {
    private string $host;
    private string $db_name;
    private string $username;
    private string $password;
    private string $charset = 'utf8mb4';

    private static ?Database $instance = null;
    private ?PDO $conn = null;

    private function __construct() {
        $this->host     = getenv('DB_HOST')     ?: 'localhost';
        $this->db_name  = getenv('DB_NAME')     ?: 'whitewaterapp_db';
        $this->username = getenv('DB_USER')     ?: 'root';
        $this->password = getenv('DB_PASSWORD') ?: '';
    }

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
            Logger::error('Database connection failed', ['error' => $e->getMessage()]);
            Response::error('Database connection failed', 500);
            exit;
        }

        return $this->conn;
    }

    /** Alias for getConnection(). */
    public function getConn(): PDO {
        return $this->getConnection();
    }

    /** Begin a database transaction. */
    public function beginTransaction(): void {
        $this->getConnection()->beginTransaction();
    }

    /** Commit the current transaction. */
    public function commit(): void {
        $this->getConnection()->commit();
    }

    /** Rollback the current transaction. */
    public function rollback(): void {
        $this->getConnection()->rollBack();
    }
}
