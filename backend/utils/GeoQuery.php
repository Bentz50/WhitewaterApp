<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

/**
 * Haversine formula helpers for geo-proximity queries.
 *
 * Usage:
 *   $sql = "SELECT *, " . GeoQuery::haversineExpr('lat', 'lng') . " AS distance_miles FROM ...";
 *   $params = GeoQuery::haversineParams($lat, $lng, $radiusMiles);
 */
class GeoQuery {
    /**
     * Return the Haversine SQL expression using named parameters :geo_lat1, :geo_lng1, :geo_lat2.
     *
     * @param string $latCol  The column holding latitude values
     * @param string $lngCol  The column holding longitude values
     */
    public static function haversineExpr(string $latCol = 'lat', string $lngCol = 'lng'): string {
        return "(3958.8 * ACOS(
            COS(RADIANS(:geo_lat1)) * COS(RADIANS($latCol)) *
            COS(RADIANS($lngCol) - RADIANS(:geo_lng1)) +
            SIN(RADIANS(:geo_lat2)) * SIN(RADIANS($latCol))
        ))";
    }

    /**
     * Return the parameter array for a Haversine query.
     */
    public static function haversineParams(float $lat, float $lng, float $radiusMiles): array {
        return [
            ':geo_lat1' => $lat,
            ':geo_lng1' => $lng,
            ':geo_lat2' => $lat,
            ':geo_r'    => $radiusMiles,
        ];
    }
}
