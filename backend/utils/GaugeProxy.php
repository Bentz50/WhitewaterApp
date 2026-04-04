<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

class GaugeProxy {
    /** USGS uses this sentinel value to indicate missing/unavailable data. */
    private const USGS_MISSING_DATA = '-999999';

    public static function fetchUSGS(string $siteId): array {
        $url  = USGS_BASE_URL . '?format=json&sites=' . urlencode($siteId) . '&parameterCd=00060,00065';
        $json = self::httpGet($url);
        $data = json_decode($json, true);

        $result = [
            'streamflow_cfs'  => null,
            'gage_height_ft'  => null,
            'timestamp'       => null,
            'site_name'       => null,
        ];

        if (empty($data['value']['timeSeries'])) {
            return $result;
        }

        foreach ($data['value']['timeSeries'] as $series) {
            $varCode  = $series['variable']['variableCode'][0]['value'] ?? '';
            $values   = $series['values'][0]['value'] ?? [];
            $latest   = end($values);
            $siteName = $series['sourceInfo']['siteName'] ?? null;

            if ($result['site_name'] === null) {
                $result['site_name'] = $siteName;
            }

            // USGS uses a sentinel value for missing/unavailable data
            if (!$latest || $latest['value'] === self::USGS_MISSING_DATA) {
                continue;
            }

            if ($varCode === '00060') {
                $result['streamflow_cfs'] = (float) $latest['value'];
                $result['timestamp']      = $latest['dateTime'] ?? null;
            } elseif ($varCode === '00065') {
                $result['gage_height_ft'] = (float) $latest['value'];
                if ($result['timestamp'] === null) {
                    $result['timestamp'] = $latest['dateTime'] ?? null;
                }
            }
        }

        return $result;
    }

    public static function fetchNOAA(string $gageId): array {
        $url = NOAA_BASE_URL . '?gage=' . urlencode($gageId) . '&output=xml';
        $xml = self::httpGet($url);

        $result = [
            'flood_stage' => null,
            'observed'    => [],
            'forecast'    => [],
        ];

        try {
            $doc = new SimpleXMLElement($xml);
        } catch (Exception $e) {
            return $result;
        }

        $result['flood_stage'] = isset($doc->sigstages->flood)
            ? (float) $doc->sigstages->flood
            : null;

        foreach ($doc->observed->datum ?? [] as $datum) {
            $result['observed'][] = [
                'time'  => (string) ($datum->valid ?? ''),
                'stage' => isset($datum->primary) ? (float) $datum->primary : null,
            ];
        }

        foreach ($doc->forecast->datum ?? [] as $datum) {
            $result['forecast'][] = [
                'time'  => (string) ($datum->valid ?? ''),
                'stage' => isset($datum->primary) ? (float) $datum->primary : null,
            ];
        }

        return $result;
    }

    public static function getCached(string $siteId, string $source): ?array {
        try {
            $db  = Database::getInstance()->getConn();
            $sql = 'SELECT data, fetched_at FROM gauge_cache
                    WHERE site_id = :site_id AND source = :source
                    LIMIT 1';
            $stmt = $db->prepare($sql);
            $stmt->execute([':site_id' => $siteId, ':source' => $source]);
            $row = $stmt->fetch();

            if (!$row) {
                return null;
            }

            $age = time() - strtotime($row['fetched_at']);
            if ($age > GAUGE_CACHE_TTL) {
                return null;
            }

            return json_decode($row['data'], true);
        } catch (Exception $e) {
            Logger::warning('Gauge cache read failed', ['site_id' => $siteId, 'source' => $source, 'error' => $e->getMessage()]);
            return null;
        }
    }

    public static function setCache(string $siteId, string $source, array $data): void {
        try {
            $db  = Database::getInstance()->getConn();
            $sql = 'INSERT INTO gauge_cache (site_id, source, data, fetched_at)
                    VALUES (:site_id, :source, :data, NOW())
                    ON DUPLICATE KEY UPDATE data = VALUES(data), fetched_at = NOW()';
            $stmt = $db->prepare($sql);
            $stmt->execute([
                ':site_id' => $siteId,
                ':source'  => $source,
                ':data'    => json_encode($data),
            ]);
        } catch (Exception $e) {
            Logger::warning('Gauge cache write failed', ['site_id' => $siteId, 'source' => $source, 'error' => $e->getMessage()]);
            // Cache write failure is non-fatal
        }
    }

    private static function httpGet(string $url): string {
        if (function_exists('curl_init')) {
            $ch = curl_init($url);
            curl_setopt_array($ch, [
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_TIMEOUT        => 10,
                CURLOPT_FOLLOWLOCATION => true,
                CURLOPT_SSL_VERIFYPEER => true,
            ]);
            $body = curl_exec($ch);
            $err  = curl_error($ch);
            curl_close($ch);
            if ($body === false) {
                throw new RuntimeException('cURL error: ' . $err);
            }
            return $body;
        }
        $body = @file_get_contents($url);
        if ($body === false) {
            throw new RuntimeException('Failed to fetch URL: ' . $url);
        }
        return $body;
    }
}
