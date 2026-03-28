-- Copyright © 2026 BentzTech LLC. All rights reserved.
-- WhitewaterApp Database Schema
-- Version: 1.0.0

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- Users table
CREATE TABLE users (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  username VARCHAR(50) NOT NULL UNIQUE,
  display_name VARCHAR(100) NOT NULL,
  avatar_url VARCHAR(500) NULL,
  preferred_difficulty JSON NULL COMMENT 'Array of AW/KHCC difficulty levels',
  water_experiences JSON NULL COMMENT 'Array of experience types',
  interests JSON NULL COMMENT 'Array of interest types',
  bio TEXT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  push_token VARCHAR(500) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_email (email),
  INDEX idx_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Vessels
CREATE TABLE vessels (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  type ENUM('kayak','canoe','raft') NOT NULL DEFAULT 'kayak',
  name VARCHAR(100) NOT NULL,
  brand VARCHAR(100) NULL,
  model VARCHAR(100) NULL,
  is_default TINYINT(1) NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Club Memberships
CREATE TABLE club_memberships (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  club_name VARCHAR(200) NOT NULL,
  verified TINYINT(1) NOT NULL DEFAULT 0,
  joined_at DATE NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Crew (friends)
CREATE TABLE crew (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  friend_id INT UNSIGNED NOT NULL,
  status ENUM('pending','accepted') NOT NULL DEFAULT 'pending',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (friend_id) REFERENCES users(id) ON DELETE CASCADE,
  UNIQUE KEY unique_crew (user_id, friend_id),
  INDEX idx_user_id (user_id),
  INDEX idx_friend_id (friend_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Rivers/sections
CREATE TABLE rivers (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  state VARCHAR(100) NOT NULL,
  region VARCHAR(200) NULL,
  lat DECIMAL(10,7) NOT NULL,
  lng DECIMAL(10,7) NOT NULL,
  put_in_lat DECIMAL(10,7) NULL,
  put_in_lng DECIMAL(10,7) NULL,
  take_out_lat DECIMAL(10,7) NULL,
  take_out_lng DECIMAL(10,7) NULL,
  aw_rating ENUM('I','II','III','IV','V','V+','unrated') NOT NULL DEFAULT 'unrated',
  khcc_rating VARCHAR(50) NULL,
  length_miles DECIMAL(6,2) NULL,
  description TEXT NULL,
  usgs_site_id VARCHAR(20) NULL,
  noaa_gage_id VARCHAR(20) NULL,
  tags JSON NULL COMMENT 'Array of string tags',
  is_runnable TINYINT(1) NULL COMMENT 'NULL = unknown, 1 = yes, 0 = no',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_lat_lng (lat, lng),
  INDEX idx_state (state),
  INDEX idx_aw_rating (aw_rating)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Skills
CREATE TABLE skills (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  category ENUM('rolling','surfing','strokes','safety','attainment','playboating') NOT NULL DEFAULT 'strokes',
  description TEXT NULL,
  icon VARCHAR(100) NULL,
  sort_order INT NOT NULL DEFAULT 0,
  INDEX idx_category (category)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- User default skills
CREATE TABLE user_default_skills (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  skill_id INT UNSIGNED NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (skill_id) REFERENCES skills(id) ON DELETE CASCADE,
  UNIQUE KEY unique_user_skill (user_id, skill_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Run logs
CREATE TABLE run_logs (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  river_id INT UNSIGNED NOT NULL,
  vessel_id INT UNSIGNED NULL,
  start_time TIMESTAMP NOT NULL,
  end_time TIMESTAMP NULL,
  distance_miles DECIMAL(8,3) NOT NULL DEFAULT 0,
  duration_seconds INT UNSIGNED NOT NULL DEFAULT 0,
  calories_burned INT UNSIGNED NULL,
  start_gauge_level DECIMAL(8,3) NULL,
  end_gauge_level DECIMAL(8,3) NULL,
  gps_track JSON NULL COMMENT 'Array of [lat, lng] coordinates',
  notes TEXT NULL,
  privacy ENUM('public','crew','private') NOT NULL DEFAULT 'public',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (river_id) REFERENCES rivers(id) ON DELETE CASCADE,
  FOREIGN KEY (vessel_id) REFERENCES vessels(id) ON DELETE SET NULL,
  INDEX idx_user_id (user_id),
  INDEX idx_river_id (river_id),
  INDEX idx_start_time (start_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Run skills
CREATE TABLE run_skills (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  run_log_id INT UNSIGNED NOT NULL,
  skill_id INT UNSIGNED NOT NULL,
  achieved TINYINT(1) NOT NULL DEFAULT 0,
  FOREIGN KEY (run_log_id) REFERENCES run_logs(id) ON DELETE CASCADE,
  FOREIGN KEY (skill_id) REFERENCES skills(id) ON DELETE CASCADE,
  UNIQUE KEY unique_run_skill (run_log_id, skill_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Hazards
CREATE TABLE hazards (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  river_id INT UNSIGNED NOT NULL,
  lat DECIMAL(10,7) NOT NULL,
  lng DECIMAL(10,7) NOT NULL,
  type ENUM('strainer','sieve','hydraulic','lowhead_dam','portage_required','other') NOT NULL,
  description TEXT NULL,
  reported_by INT UNSIGNED NOT NULL,
  last_observed TIMESTAMP NULL,
  status ENUM('active','cleared') NOT NULL DEFAULT 'active',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (river_id) REFERENCES rivers(id) ON DELETE CASCADE,
  FOREIGN KEY (reported_by) REFERENCES users(id),
  INDEX idx_river_id (river_id),
  INDEX idx_status (status),
  INDEX idx_lat_lng (lat, lng)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Hazard verifications
CREATE TABLE hazard_verifications (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  hazard_id INT UNSIGNED NOT NULL,
  user_id INT UNSIGNED NOT NULL,
  status ENUM('confirmed','cleared','updated') NOT NULL,
  notes TEXT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (hazard_id) REFERENCES hazards(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Injury reports
CREATE TABLE injury_reports (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  run_log_id INT UNSIGNED NOT NULL,
  user_id INT UNSIGNED NOT NULL,
  description TEXT NOT NULL,
  severity ENUM('minor','moderate','severe') NOT NULL DEFAULT 'minor',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (run_log_id) REFERENCES run_logs(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Media
CREATE TABLE media (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  run_log_id INT UNSIGNED NULL,
  user_id INT UNSIGNED NOT NULL,
  file_url VARCHAR(1000) NOT NULL,
  file_type ENUM('photo','video') NOT NULL DEFAULT 'photo',
  privacy ENUM('public','crew','private') NOT NULL DEFAULT 'public',
  tags JSON NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (run_log_id) REFERENCES run_logs(id) ON DELETE SET NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_run_log_id (run_log_id),
  INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Posts
CREATE TABLE posts (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  river_id INT UNSIGNED NULL,
  run_log_id INT UNSIGNED NULL,
  content TEXT NOT NULL,
  type ENUM('run_log','update','quote') NOT NULL DEFAULT 'update',
  like_count INT UNSIGNED NOT NULL DEFAULT 0,
  comment_count INT UNSIGNED NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (river_id) REFERENCES rivers(id) ON DELETE SET NULL,
  FOREIGN KEY (run_log_id) REFERENCES run_logs(id) ON DELETE SET NULL,
  INDEX idx_user_id (user_id),
  INDEX idx_river_id (river_id),
  INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Comments
CREATE TABLE comments (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  post_id INT UNSIGNED NOT NULL,
  user_id INT UNSIGNED NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_post_id (post_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Likes
CREATE TABLE likes (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  post_id INT UNSIGNED NOT NULL,
  user_id INT UNSIGNED NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  UNIQUE KEY unique_like (post_id, user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Messages
CREATE TABLE messages (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  sender_id INT UNSIGNED NOT NULL,
  receiver_id INT UNSIGNED NOT NULL,
  content TEXT NOT NULL,
  read_at TIMESTAMP NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_sender_receiver (sender_id, receiver_id),
  INDEX idx_receiver_sender (receiver_id, sender_id),
  INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Events
CREATE TABLE events (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  description TEXT NULL,
  type ENUM('race','festival','cleanup','safety_course','dam_release','volunteer') NOT NULL,
  lat DECIMAL(10,7) NULL,
  lng DECIMAL(10,7) NULL,
  start_date TIMESTAMP NOT NULL,
  end_date TIMESTAMP NOT NULL,
  organizer VARCHAR(200) NULL,
  url VARCHAR(500) NULL,
  created_by INT UNSIGNED NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_start_date (start_date),
  INDEX idx_type (type),
  INDEX idx_lat_lng (lat, lng)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Achievements definition
CREATE TABLE achievements (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT NOT NULL,
  icon VARCHAR(100) NOT NULL,
  category VARCHAR(50) NOT NULL,
  threshold_type VARCHAR(50) NOT NULL COMMENT 'total_runs, total_distance, local_legend, speed, etc.',
  threshold_value DECIMAL(10,2) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- User achievements
CREATE TABLE user_achievements (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  achievement_id INT UNSIGNED NOT NULL,
  unlocked_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  data JSON NULL COMMENT 'Run details, gauge data, etc.',
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (achievement_id) REFERENCES achievements(id) ON DELETE CASCADE,
  UNIQUE KEY unique_user_achievement (user_id, achievement_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Notifications
CREATE TABLE notifications (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  type VARCHAR(50) NOT NULL,
  title VARCHAR(200) NOT NULL,
  body TEXT NULL,
  data JSON NULL,
  read_at TIMESTAMP NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user_id (user_id),
  INDEX idx_read_at (read_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Gauge cache
CREATE TABLE gauge_cache (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  site_id VARCHAR(20) NOT NULL,
  source ENUM('usgs','noaa') NOT NULL,
  data JSON NOT NULL,
  cached_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY unique_site_source (site_id, source)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- River tags (user-applied tags to river sections from run logs)
CREATE TABLE river_tags (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  run_log_id INT UNSIGNED NOT NULL,
  river_id INT UNSIGNED NOT NULL,
  user_id INT UNSIGNED NOT NULL,
  tag VARCHAR(100) NOT NULL,
  FOREIGN KEY (run_log_id) REFERENCES run_logs(id) ON DELETE CASCADE,
  FOREIGN KEY (river_id) REFERENCES rivers(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_river_id (river_id),
  INDEX idx_tag (tag)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;

-- =============================================================
-- SEED DATA
-- =============================================================

-- Skills seed
INSERT INTO skills (name, category, sort_order) VALUES
  -- Rolling
  ('Combat Roll',    'rolling', 1),
  ('Back Deck Roll', 'rolling', 2),
  ('Hand Roll',      'rolling', 3),
  ('C-to-C Roll',    'rolling', 4),
  ('Eskimo Roll',    'rolling', 5),
  ('Lay Back Roll',  'rolling', 6),
  ('Shotgun Roll',   'rolling', 7),
  -- Surfing
  ('Wave Surf',      'surfing', 1),
  ('Hole Surf',      'surfing', 2),
  ('Dry Hair Day',   'surfing', 3),
  ('Spin',           'surfing', 4),
  ('Blunt',          'surfing', 5),
  -- Strokes
  ('Ferry',          'strokes', 1),
  ('Eddy Catch',     'strokes', 2),
  ('Peel Out',       'strokes', 3),
  ('Boof Stroke',    'strokes', 4),
  ('Draw Stroke',    'strokes', 5),
  ('Cross Draw',     'strokes', 6),
  ('Duffek',         'strokes', 7),
  -- Safety
  ('Throw Bag Rescue', 'safety', 1),
  ('Self Rescue',      'safety', 2),
  ('Swim Safety',      'safety', 3),
  ('Scout Rapid',      'safety', 4),
  -- Attainment
  ('Attainment',       'attainment', 1),
  ('Upstream Ferry',   'attainment', 2),
  -- Playboating
  ('Cartwheel',        'playboating', 1),
  ('Bow Stall',        'playboating', 2),
  ('Stern Squirt',     'playboating', 3),
  ('Loop',             'playboating', 4),
  ('Splitwheel',       'playboating', 5),
  ('Pistol Flip',      'playboating', 6),
  ('McNasty',          'playboating', 7),
  ('Phonix Monkey',    'playboating', 8);

-- Achievements seed
INSERT INTO achievements (name, description, icon, category, threshold_type, threshold_value) VALUES
  -- Milestone
  ('First Run',        'Complete your very first logged run.',              'trophy_first',    'milestone', 'total_runs',     1),
  ('10 Runs',          'Log 10 runs total.',                                'trophy_10',       'milestone', 'total_runs',    10),
  ('50 Runs',          'Log 50 runs total.',                                'trophy_50',       'milestone', 'total_runs',    50),
  ('100 Runs',         'Log 100 runs total.',                               'trophy_100',      'milestone', 'total_runs',   100),
  -- Distance
  ('Century Paddler',   'Paddle a cumulative 100 miles.',                   'distance_100',    'distance',  'total_distance', 100),
  ('500 Mile Club',     'Paddle a cumulative 500 miles.',                   'distance_500',    'distance',  'total_distance', 500),
  ('1000 Mile Paddler', 'Paddle a cumulative 1,000 miles.',                 'distance_1000',   'distance',  'total_distance', 1000),
  -- Social
  ('Local Legend',     'Run the same section 10 or more times.',            'legend',          'social',    'local_legend',   10),
  ('Crew Captain',     'Add 5 or more crew members.',                       'crew_captain',    'social',    'crew_members',    5),
  -- Performance
  ('Speed Demon',      'Achieve an average speed greater than 10 mph.',     'speed_demon',     'performance','avg_speed',      10),
  ('Big Drop',         'Record a single drop greater than 20 ft.',          'big_drop',        'performance','max_drop_ft',    20),
  ('Longest Run',      'Complete a single run greater than 10 miles.',      'longest_run',     'performance','single_distance',10),
  -- Skills
  ('Roll Master',      'Successfully execute 10 combat rolls.',             'roll_master',     'skills',    'combat_rolls',   10),
  ('Surf Junkie',      'Accumulate more than 2 hours at a surf wave.',      'surf_junkie',     'skills',    'surf_time_hrs',   2);

-- Sample rivers seed
INSERT INTO rivers (name, state, region, lat, lng, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, description, usgs_site_id, tags) VALUES
  (
    'New River Gorge',
    'West Virginia',
    'New River Gorge National Park',
    37.8601400, -81.0789700,
    37.8766700, -81.0780600,
    37.8120000, -81.1120000,
    'V+',
    15.50,
    'One of the premier whitewater destinations in the eastern United States. The Lower Gorge offers continuous Class III–V+ rapids through a stunning sandstone canyon. Highlight rapids include Surprise, Pinball, and the infamous Undercut Rock.',
    '03189100',
    '["gorge","classic","big water","technical","scenic"]'
  ),
  (
    'Gauley River',
    'West Virginia',
    'Gauley River National Recreation Area',
    38.2250000, -80.9720000,
    38.2270000, -80.9600000,
    38.1460000, -81.1950000,
    'V',
    25.00,
    'The Upper and Lower Gauley River offers world-class whitewater, especially during fall dam releases from Summersville Dam. The Upper Gauley alone contains five Class V rapids in its first six miles, including Insignificant, Pillow Rock, Lost Paddle, Iron Ring, and Pure Screaming Hell.',
    '03194700',
    '["dam release","world class","fall season","Class V","technical"]'
  ),
  (
    'Ocoee River',
    'Tennessee',
    'Cherokee National Forest',
    35.0780000, -84.5970000,
    35.0830000, -84.6140000,
    35.0560000, -84.5520000,
    'IV',
    5.00,
    'Site of the 1996 Olympic whitewater events, the Ocoee Middle Section is a non-stop action run through channeled bedrock rapids. Water is controlled by a TVA diversion dam, making flows consistent and predictable. A favorite for intermediate-to-advanced paddlers.',
    '03568933',
    '["olympic","dam controlled","consistent flow","bedrock","southeast"]'
  ),
  (
    'Youghiogheny River (Upper)',
    'Pennsylvania',
    'Laurel Highlands',
    39.6980000, -79.3610000,
    39.7230000, -79.4080000,
    39.6600000, -79.2900000,
    'V',
    9.50,
    'The Upper Yough is one of the most technically demanding runs in the Mid-Atlantic region, requiring expert paddlers and continuous scouting. Highlights include National Falls, Gap Falls, and Zinger. Water releases from Deep Creek Lake allow for consistent flows year-round.',
    '01598000',
    '["technical","expert","dam release","Mid-Atlantic","continuous"]'
  ),
  (
    'Chattooga River',
    'South Carolina/Georgia',
    'Sumter & Chattahoochee National Forests',
    34.8700000, -83.3100000,
    34.9410000, -83.3190000,
    34.7660000, -83.2650000,
    'V',
    13.00,
    'Made famous by the film Deliverance, the Chattooga''s Section IV is a remote, stunning wilderness run featuring Bull Sluice, Sock''em Dog, Five Falls (including Corkscrew, Crack-in-the-Rock, Jawbone, Hydroelectric, and Raven Rock), and the infamous Completion. No motor vehicles allowed within a mile of the river.',
    '02177000',
    '["wilderness","remote","classic","southeast","no motors","five falls"]'
  );
