<?php
// Copyright © 2026 BentzTech LLC. All rights reserved.

require_once __DIR__ . '/config/config.php';
require_once __DIR__ . '/config/database.php';
require_once __DIR__ . '/utils/Response.php';
require_once __DIR__ . '/utils/JWT.php';
require_once __DIR__ . '/utils/Validator.php';
require_once __DIR__ . '/utils/FileUpload.php';
require_once __DIR__ . '/utils/GaugeProxy.php';
require_once __DIR__ . '/middleware/cors.php';
require_once __DIR__ . '/middleware/auth.php';
require_once __DIR__ . '/middleware/rate_limit.php';

// Apply CORS headers (and exit on OPTIONS preflight)
applyCors();

// Rate-limit by IP
checkRateLimit($_SERVER['REMOTE_ADDR'] ?? '0.0.0.0');

// Parse request
$method = $_SERVER['REQUEST_METHOD'];
$uri    = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$uri    = '/' . trim($uri, '/');

// Strip base path if running in a subdirectory
$basePath = '/api/v1';
if (strpos($uri, $basePath) === 0) {
    $uri = substr($uri, strlen($basePath));
}
$uri = '/' . trim($uri, '/');

$segments = array_values(array_filter(explode('/', $uri)));
$params   = $_GET;

// Parse JSON body
$body = [];
$rawInput = file_get_contents('php://input');
if ($rawInput !== '') {
    $decoded = json_decode($rawInput, true);
    if (is_array($decoded)) {
        $body = $decoded;
    }
}

// Routes that do NOT require authentication
$publicRoutes = [
    'POST /auth/register',
    'POST /auth/login',
    'POST /auth/refresh',
    'POST /auth/forgot-password',
];

$routeKey = $method . ' /' . ($segments[0] ?? '') . '/' . ($segments[1] ?? '');

// Determine if auth is required
$requiresAuth = !in_array($method . ' /' . implode('/', array_slice($segments, 0, 2)), $publicRoutes, true)
    && !in_array($method . ' /' . implode('/', array_slice($segments, 0, 3)), $publicRoutes, true);

// Auth middleware
$auth = null;
if ($requiresAuth) {
    require_once __DIR__ . '/middleware/auth.php';
    $auth = requireAuth();
} else {
    $auth = optionalAuth();
}

// -----------------------------------------------------------------------
// Router
// -----------------------------------------------------------------------
$resource = $segments[0] ?? '';

switch ($resource) {

    // ── Auth ──────────────────────────────────────────────────────────
    case 'auth':
        require_once __DIR__ . '/controllers/AuthController.php';
        $controller = new AuthController();
        $action     = $segments[1] ?? '';
        switch ($action) {
            case 'register':      $controller->register($body); break;
            case 'login':         $controller->login($body); break;
            case 'refresh':       $controller->refresh($body); break;
            case 'forgot-password': $controller->forgotPassword($body); break;
            default:              Response::error('Not found', 404);
        }
        break;

    // ── Users ─────────────────────────────────────────────────────────
    case 'users':
        require_once __DIR__ . '/controllers/UserController.php';
        $controller = new UserController();
        $sub        = $segments[1] ?? '';
        $sub2       = $segments[2] ?? '';
        if ($sub === 'me') {
            if ($sub2 === 'avatar' && $method === 'POST') {
                $controller->uploadAvatar($auth);
            } elseif ($method === 'GET') {
                $controller->getMe($auth);
            } elseif ($method === 'PUT') {
                $controller->updateMe($body, $auth);
            } else {
                Response::error('Method not allowed', 405);
            }
        } elseif ($sub === 'search') {
            $controller->searchUsers($params);
        } elseif ($sub !== '') {
            $controller->getUser((int) $sub);
        } else {
            Response::error('Not found', 404);
        }
        break;

    // ── Vessels ───────────────────────────────────────────────────────
    case 'vessels':
        require_once __DIR__ . '/controllers/VesselController.php';
        $controller = new VesselController();
        $id  = isset($segments[1]) ? (int) $segments[1] : null;
        $sub = $segments[2] ?? '';
        if ($id === null) {
            if ($method === 'GET')  $controller->index($auth);
            elseif ($method === 'POST') $controller->create($body, $auth);
            else Response::error('Method not allowed', 405);
        } elseif ($sub === 'default' && $method === 'PUT') {
            $controller->setDefault($id, $auth);
        } elseif ($method === 'PUT') {
            $controller->update($id, $body, $auth);
        } elseif ($method === 'DELETE') {
            $controller->delete($id, $auth);
        } else {
            Response::error('Not found', 404);
        }
        break;

    // ── Rivers ────────────────────────────────────────────────────────
    case 'rivers':
        require_once __DIR__ . '/controllers/RiverController.php';
        $controller = new RiverController();
        $id  = isset($segments[1]) && $segments[1] !== 'search' ? (int) $segments[1] : null;
        $sub = $segments[2] ?? '';
        if ($segments[1] === 'search') {
            $controller->search($params);
        } elseif ($id === null) {
            $controller->index($params);
        } elseif ($sub === 'gauge')   { $controller->getGauge($id); }
        elseif ($sub === 'hazards')   { $controller->getHazards($id); }
        elseif ($sub === 'runs')      { $controller->getRuns($id, $params, $auth); }
        elseif ($sub === 'feed')      { $controller->getFeed($id, $auth); }
        else                          { $controller->show($id); }
        break;

    // ── Runs ──────────────────────────────────────────────────────────
    case 'runs':
        require_once __DIR__ . '/controllers/RunLogController.php';
        $controller = new RunLogController();
        $id  = isset($segments[1]) && $segments[1] !== 'me' ? (int) $segments[1] : null;
        $sub = $segments[2] ?? '';
        if ($segments[1] === 'me') {
            $controller->myRuns($auth, $params);
        } elseif ($id === null) {
            if ($method === 'POST') $controller->create($body, $auth);
            else Response::error('Not found', 404);
        } elseif ($sub === 'skills' && $method === 'POST')  { $controller->addSkills($id, $body, $auth); }
        elseif ($sub === 'media' && $method === 'POST')     { $controller->addMedia($id, $auth); }
        elseif ($sub === 'hazard-report' && $method === 'POST') { $controller->hazardReport($id, $body, $auth); }
        elseif ($sub === 'injury-report' && $method === 'POST') { $controller->injuryReport($id, $body, $auth); }
        elseif ($method === 'GET')    { $controller->show($id, $auth); }
        elseif ($method === 'PUT')    { $controller->update($id, $body, $auth); }
        else Response::error('Not found', 404);
        break;

    // ── Hazards ───────────────────────────────────────────────────────
    case 'hazards':
        require_once __DIR__ . '/controllers/HazardController.php';
        $controller = new HazardController();
        $id  = isset($segments[1]) ? (int) $segments[1] : null;
        $sub = $segments[2] ?? '';
        if ($id === null) {
            if ($method === 'GET')  $controller->index($params);
            elseif ($method === 'POST') $controller->create($body, $auth);
            else Response::error('Method not allowed', 405);
        } elseif ($sub === 'verify' && $method === 'PUT') { $controller->verify($id, $body, $auth); }
        elseif ($sub === 'clear'  && $method === 'PUT')   { $controller->clear($id, $body, $auth); }
        else Response::error('Not found', 404);
        break;

    // ── Feed / Posts ──────────────────────────────────────────────────
    case 'feed':
        require_once __DIR__ . '/controllers/SocialController.php';
        $controller = new SocialController();
        $sub = $segments[1] ?? '';
        if ($sub === 'crew') $controller->getCrewFeed($auth, $params);
        else                 $controller->getFeed($auth, $params);
        break;

    case 'posts':
        require_once __DIR__ . '/controllers/SocialController.php';
        $controller = new SocialController();
        $postId = isset($segments[1]) ? (int) $segments[1] : null;
        $sub    = $segments[2] ?? '';
        if ($postId === null) {
            Response::error('Not found', 404);
        } elseif ($sub === 'comments' && $method === 'POST') {
            $controller->addComment($postId, $body, $auth);
        } elseif ($sub === 'comments' && $method === 'GET') {
            $controller->getComments($postId);
        } elseif ($sub === 'like' && $method === 'POST') {
            $controller->likePost($postId, $auth);
        } else {
            Response::error('Not found', 404);
        }
        break;

    // ── Messages ──────────────────────────────────────────────────────
    case 'messages':
        require_once __DIR__ . '/controllers/MessageController.php';
        $controller = new MessageController();
        $userId = isset($segments[1]) ? (int) $segments[1] : null;
        if ($userId === null) {
            $controller->getConversations($auth);
        } elseif ($method === 'GET') {
            $controller->getMessages($userId, $auth, $params);
        } elseif ($method === 'POST') {
            $controller->sendMessage($userId, $body, $auth);
        } else {
            Response::error('Method not allowed', 405);
        }
        break;

    // ── Events ────────────────────────────────────────────────────────
    case 'events':
        require_once __DIR__ . '/controllers/EventController.php';
        $controller = new EventController();
        if ($method === 'GET')  $controller->index($params);
        elseif ($method === 'POST') $controller->create($body, $auth);
        else Response::error('Method not allowed', 405);
        break;

    // ── Achievements ──────────────────────────────────────────────────
    case 'achievements':
        require_once __DIR__ . '/controllers/AchievementController.php';
        $controller = new AchievementController();
        $sub = $segments[1] ?? '';
        if ($sub === 'me')    $controller->getMyAchievements($auth);
        elseif ($sub === 'check') $controller->checkAchievements($auth);
        else Response::error('Not found', 404);
        break;

    // ── Gauges ────────────────────────────────────────────────────────
    case 'gauges':
        require_once __DIR__ . '/controllers/GaugeController.php';
        $controller = new GaugeController();
        $siteId = $segments[1] ?? null;
        $sub    = $segments[2] ?? '';
        if ($siteId === null) Response::error('Not found', 404);
        elseif ($sub === 'forecast') $controller->getForecast($siteId);
        else $controller->getGauge($siteId);
        break;

    // ── Crew (delegated to UserController) ────────────────────────────
    case 'crew':
        require_once __DIR__ . '/controllers/UserController.php';
        $controller = new UserController();
        $userId = isset($segments[1]) ? (int) $segments[1] : null;
        if ($userId === null) {
            $controller->getCrew($auth);
        } elseif ($method === 'POST') {
            $controller->addCrew($userId, $auth);
        } elseif ($method === 'DELETE') {
            $controller->removeCrew($userId, $auth);
        } else {
            Response::error('Method not allowed', 405);
        }
        break;

    // ── Skills ────────────────────────────────────────────────────────
    case 'skills':
        require_once __DIR__ . '/controllers/SkillController.php';
        $controller = new SkillController();
        $sub = $segments[1] ?? '';
        if ($sub === 'defaults') {
            if ($method === 'GET')  $controller->getDefaults($auth);
            elseif ($method === 'PUT') $controller->updateDefaults($body, $auth);
            else Response::error('Method not allowed', 405);
        } else {
            $controller->index();
        }
        break;

    // ── Notifications ─────────────────────────────────────────────────
    case 'notifications':
        require_once __DIR__ . '/controllers/NotificationController.php';
        $controller = new NotificationController();
        $id  = isset($segments[1]) && $segments[1] !== 'dam-release' ? (int) $segments[1] : null;
        $sub = $segments[2] ?? '';
        if ($segments[1] === 'dam-release' && $method === 'POST') {
            $controller->triggerDamRelease($body);
        } elseif ($id !== null && $sub === 'read' && $method === 'PUT') {
            $controller->markRead($id, $auth);
        } else {
            $controller->getNotifications($auth);
        }
        break;

    default:
        Response::error('Not found', 404);
}
