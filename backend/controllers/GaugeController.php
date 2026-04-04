<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

class GaugeController extends BaseController {
    public function getGauge(string $siteId): void {
        $cached = GaugeProxy::getCached($siteId, 'usgs');
        if ($cached) {
            Response::success($cached);
        }

        try {
            $data = GaugeProxy::fetchUSGS($siteId);
            GaugeProxy::setCache($siteId, 'usgs', $data);
            Response::success($data);
        } catch (RuntimeException $e) {
            Response::error('Failed to fetch gauge data: ' . $e->getMessage(), 503);
        }
    }

    public function getForecast(string $siteId): void {
        $cached = GaugeProxy::getCached($siteId, 'noaa_forecast');
        if ($cached) {
            Response::success($cached);
        }

        try {
            $data = GaugeProxy::fetchNOAA($siteId);
            GaugeProxy::setCache($siteId, 'noaa_forecast', $data);
            Response::success($data);
        } catch (RuntimeException $e) {
            Response::error('Failed to fetch forecast data: ' . $e->getMessage(), 503);
        }
    }
}
