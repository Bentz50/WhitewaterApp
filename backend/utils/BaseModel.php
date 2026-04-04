<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

/**
 * Trait providing common model helpers.
 * Classes using this trait should define `const TABLE = 'table_name';`
 */
trait BaseModel {
    /**
     * Find a single record by ID.
     */
    public static function findById(PDO $db, int $id): ?array {
        $table = static::TABLE;
        $stmt  = $db->prepare("SELECT * FROM $table WHERE id = :id LIMIT 1");
        $stmt->execute([':id' => $id]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    /**
     * Build and execute a dynamic UPDATE from an allow-listed set of columns.
     *
     * @param array $extraWhere  Additional WHERE conditions, e.g. ['user_id' => 42]
     */
    public static function dynamicUpdate(PDO $db, int $id, array $data, array $allowed, array $extraWhere = []): bool {
        $sets   = [];
        $params = [':id' => $id];

        foreach ($allowed as $col) {
            if (array_key_exists($col, $data)) {
                $sets[]            = "$col = :$col";
                $params[":$col"]   = is_array($data[$col]) ? json_encode($data[$col]) : $data[$col];
            }
        }

        if (empty($sets)) {
            return false;
        }

        $table = static::TABLE;
        $where = "$table.id = :id";
        foreach ($extraWhere as $col => $val) {
            $placeholder         = ':ew_' . $col;
            $where              .= " AND $col = $placeholder";
            $params[$placeholder] = $val;
        }

        $sql  = "UPDATE $table SET " . implode(', ', $sets) . " WHERE $where";
        $stmt = $db->prepare($sql);
        $stmt->execute($params);
        return $stmt->rowCount() > 0;
    }
}
