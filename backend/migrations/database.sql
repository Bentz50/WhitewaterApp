-- Copyright © 2026 BentzTech LLC. All rights reserved.
-- WhitewaterApp Complete Database Schema & Seed Data
-- Consolidated from individual migration files
-- Source: American Whitewater National Whitewater Inventory (americanwhitewater.org)
-- Version: 2.0.0

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- Users table
CREATE TABLE users (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  apple_id VARCHAR(255) NULL UNIQUE,
  google_id VARCHAR(255) NULL UNIQUE,
  auth_provider ENUM('apple', 'google') NOT NULL DEFAULT 'apple',
  email VARCHAR(255) NULL UNIQUE,
  password_hash VARCHAR(255) NULL,
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
  INDEX idx_username (username),
  INDEX idx_apple_id (apple_id),
  INDEX idx_google_id (google_id)
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

-- River sections
CREATE TABLE river_sections (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  river_id INT UNSIGNED NOT NULL,
  name VARCHAR(200) NOT NULL COMMENT 'Section display name, e.g. Upper Gauley',
  section_label VARCHAR(100) NULL COMMENT 'Short label, e.g. Upper, Middle, Lower',
  description TEXT NULL,
  put_in_lat DECIMAL(10,7) NULL,
  put_in_lng DECIMAL(10,7) NULL,
  take_out_lat DECIMAL(10,7) NULL,
  take_out_lng DECIMAL(10,7) NULL,
  aw_rating ENUM('I','II','III','IV','V','V+','unrated') NOT NULL DEFAULT 'unrated',
  khcc_rating VARCHAR(50) NULL,
  length_miles DECIMAL(6,2) NULL,
  usgs_site_id VARCHAR(20) NULL,
  noaa_gage_id VARCHAR(20) NULL,
  tags JSON NULL COMMENT 'Array of string tags',
  is_runnable TINYINT(1) NULL COMMENT 'NULL = unknown, 1 = yes, 0 = no',
  sort_order INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (river_id) REFERENCES rivers(id) ON DELETE CASCADE,
  INDEX idx_river_id (river_id),
  INDEX idx_aw_rating (aw_rating),
  INDEX idx_sort_order (sort_order)
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
  section_id INT UNSIGNED NULL,
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
  FOREIGN KEY (section_id) REFERENCES river_sections(id) ON DELETE SET NULL,
  INDEX idx_user_id (user_id),
  INDEX idx_river_id (river_id),
  INDEX idx_section_id (section_id),
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
  section_id INT UNSIGNED NULL,
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
  FOREIGN KEY (section_id) REFERENCES river_sections(id) ON DELETE SET NULL,
  INDEX idx_river_id (river_id),
  INDEX idx_hazards_section_id (section_id),
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
  section_id INT UNSIGNED NULL,
  run_log_id INT UNSIGNED NULL,
  content TEXT NOT NULL,
  type ENUM('run_log','update','quote') NOT NULL DEFAULT 'update',
  like_count INT UNSIGNED NOT NULL DEFAULT 0,
  comment_count INT UNSIGNED NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (river_id) REFERENCES rivers(id) ON DELETE SET NULL,
  FOREIGN KEY (run_log_id) REFERENCES run_logs(id) ON DELETE SET NULL,
  FOREIGN KEY (section_id) REFERENCES river_sections(id) ON DELETE SET NULL,
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
  section_id INT UNSIGNED NULL,
  user_id INT UNSIGNED NOT NULL,
  tag VARCHAR(100) NOT NULL,
  FOREIGN KEY (run_log_id) REFERENCES run_logs(id) ON DELETE CASCADE,
  FOREIGN KEY (river_id) REFERENCES rivers(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (section_id) REFERENCES river_sections(id) ON DELETE SET NULL,
  INDEX idx_river_id (river_id),
  INDEX idx_tag (tag)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- River videos (YouTube links with water level ranges)
CREATE TABLE river_videos (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  river_id INT UNSIGNED NOT NULL,
  section_id INT UNSIGNED NULL,
  title VARCHAR(300) NOT NULL,
  url VARCHAR(500) NOT NULL,
  min_level DECIMAL(8,2) NULL COMMENT 'Min gauge height (ft) where video is relevant',
  max_level DECIMAL(8,2) NULL COMMENT 'Max gauge height (ft) where video is relevant',
  submitted_by INT UNSIGNED NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (river_id) REFERENCES rivers(id) ON DELETE CASCADE,
  FOREIGN KEY (submitted_by) REFERENCES users(id) ON DELETE SET NULL,
  FOREIGN KEY (section_id) REFERENCES river_sections(id) ON DELETE SET NULL,
  INDEX idx_river_id (river_id),
  INDEX idx_river_videos_section_id (section_id),
  INDEX idx_levels (min_level, max_level)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


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

-- =============================================================
-- SEED DATA: Gauley River sections (Upper, Middle, Lower)
-- Assumes Gauley River is id=2 from 001_initial_schema.sql
-- =============================================================

INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    2,
    'Upper Gauley',
    'Upper',
    'The Upper Gauley is a world-class Class V run featuring five major rapids in the first six miles: Insignificant, Pillow Rock, Lost Paddle, Iron Ring, and Sweet''s Falls. Best during fall dam releases from Summersville Dam (late September through mid-October). 10.5 miles of continuous whitewater through a remote gorge.',
    38.2270000, -80.9600000,
    38.1840000, -81.0860000,
    'V',
    10.50,
    '03194700',
    '["dam release","world class","Class V","technical","fall season","big drops"]',
    1,
    1
  ),
  (
    2,
    'Middle Gauley',
    'Middle',
    'The Middle Gauley offers a slightly mellower but still exciting Class III-IV run between the Upper and Lower sections. Features continuous rapids with technical moves through Koontz Flume and other named rapids. A great step-up run before tackling the Upper.',
    38.1840000, -81.0860000,
    38.1620000, -81.1420000,
    'IV',
    5.50,
    '03194700',
    '["dam release","intermediate","fall season","continuous"]',
    1,
    2
  ),
  (
    2,
    'Lower Gauley',
    'Lower',
    'The Lower Gauley delivers 13 miles of Class III-V whitewater with highlights including Pure Screaming Hell, Heaven Help You, Upper and Lower Mash, and the Koontz Flume. More pool-drop character than the Upper, with recovery time between major rapids.',
    38.1620000, -81.1420000,
    38.1460000, -81.1950000,
    'V',
    9.00,
    '03194700',
    '["dam release","world class","Class V","pool drop","fall season"]',
    1,
    3
  );

-- Ocoee River sections (Upper, Middle, Lower)
-- Assumes Ocoee River is id=3 from 001_initial_schema.sql
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    3,
    'Upper Ocoee (Olympic Section)',
    'Upper',
    'The Olympic Section of the Ocoee was the venue for the 1996 Atlanta Olympic whitewater events. A short but intense run with man-made features and natural rapids. Releases are limited to scheduled weekends.',
    35.0930000, -84.6350000,
    35.0830000, -84.6140000,
    'IV',
    1.80,
    '03568933',
    '["olympic","dam controlled","man-made features","weekend releases"]',
    NULL,
    1
  ),
  (
    3,
    'Middle Ocoee',
    'Middle',
    'The most popular section of the Ocoee, site of the 1996 Olympic whitewater events venue approach. Non-stop action through channeled bedrock rapids with consistent TVA-controlled flows. A favorite for intermediate-to-advanced paddlers.',
    35.0830000, -84.6140000,
    35.0560000, -84.5520000,
    'IV',
    5.00,
    '03568933',
    '["olympic","dam controlled","consistent flow","bedrock","southeast","popular"]',
    1,
    2
  );

-- Chattooga River sections (Sections III and IV)
-- Assumes Chattooga River is id=5 from 001_initial_schema.sql
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    5,
    'Chattooga Section III',
    'Section III',
    'A classic intermediate wilderness run featuring Bull Sluice, the most famous rapid on the river. Beautiful scenery through remote forest with Class II-III rapids building to the Class IV Bull Sluice at the end.',
    34.9410000, -83.3190000,
    34.8180000, -83.2860000,
    'III',
    7.00,
    '02177000',
    '["wilderness","remote","classic","southeast","no motors","bull sluice"]',
    1,
    1
  ),
  (
    5,
    'Chattooga Section IV',
    'Section IV',
    'Made famous by the film Deliverance, Section IV is a remote, stunning wilderness run featuring the Five Falls sequence: Entrance, Corkscrew, Crack-in-the-Rock, Jawbone, and Sock''em Dog. Expert-only section with significant consequences.',
    34.8180000, -83.2860000,
    34.7660000, -83.2650000,
    'V',
    6.00,
    '02177000',
    '["wilderness","remote","classic","southeast","no motors","five falls","expert"]',
    1,
    2
  );

-- =============================================================
-- American Whitewater Core Rivers (from 003_aw_seed_data.sql)
-- =============================================================

-- =============================================================
-- STEP 1: Clear existing seed data (sections first due to FK)
-- =============================================================

-- =============================================================
-- STEP 2: Reinsert corrected rivers with American Whitewater data
-- =============================================================
INSERT INTO rivers (id, name, state, region, lat, lng, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, description, usgs_site_id, tags, is_runnable) VALUES
  -- 1. New River Gorge — AW: Multiple sections from Prince to Fayette Station
  (
    1,
    'New River Gorge',
    'West Virginia',
    'New River Gorge National Park',
    37.9576000, -81.0784000,
    37.8217000, -81.0141000,
    38.0670000, -81.0816000,
    'IV',
    28.50,
    'One of America''s premier whitewater destinations in the heart of New River Gorge National Park. The gorge features sections ranging from Class I–III (Upper New, Prince to Thurmond) to Class III–V (Lower New, Cunard to Fayette Station) and the elusive Class IV–V Dries section below Hawks Nest Dam. Key rapids in the Lower Gorge include The Keeneys, Double Z, Greyhound Bus Stopper, and Miller''s Folly. The river cuts through a spectacular sandstone canyon with rich history.',
    '03185400',
    '["gorge","national park","classic","big water","scenic","Appalachian","multi-section"]',
    1
  ),
  -- 2. Gauley River — AW: Upper/Middle/Lower from Summersville Dam to Swiss
  (
    2,
    'Gauley River',
    'West Virginia',
    'Gauley River National Recreation Area',
    38.2031000, -80.8823000,
    38.2031000, -80.8823000,
    38.2616000, -81.0210000,
    'V',
    26.00,
    'Widely regarded as one of the best whitewater rivers in the world. The Gauley flows through the Gauley River National Recreation Area, offering Upper (Class IV–V), Middle (Class III–IV), and Lower (Class III–V) sections. The annual "Gauley Season" fall dam releases from Summersville Dam (late September through mid-October) draw thousands of paddlers. The Upper features the legendary "Big Five" Class V rapids: Insignificant, Pillow Rock, Lost Paddle, Iron Ring, and Sweet''s Falls.',
    '03188500',
    '["dam release","world class","fall season","Class V","technical","NRA","gauley season"]',
    1
  ),
  -- 3. Ocoee River — AW: Upper/Middle/Lower, 1996 Olympics, TVA controlled
  (
    3,
    'Ocoee River',
    'Tennessee',
    'Cherokee National Forest',
    35.1070000, -84.5552000,
    35.0862000, -84.5211000,
    35.1712000, -84.7369000,
    'IV',
    18.00,
    'Home to the 1996 Olympic whitewater slalom events. The Ocoee features three distinct sections: the Upper (Olympic section, Class III–IV with man-made features), the Middle (Class III–IV, the most popular continuous whitewater section with TVA dam-controlled flows), and the Lower (Class I–II, gentle float). The Middle section is one of the most commercially rafted rivers in America, with reliable scheduled releases making it a favorite for paddlers of all levels.',
    '03566000',
    '["olympic","dam controlled","consistent flow","bedrock","southeast","TVA","popular"]',
    1
  ),
  -- 4. Youghiogheny River — AW: Top/Upper/Middle/Lower Yough
  (
    4,
    'Youghiogheny River',
    'Maryland/Pennsylvania',
    'Ohiopyle State Park / Garrett County',
    39.8700000, -79.4940000,
    39.4847000, -79.4105000,
    39.8910000, -79.5630000,
    'IV',
    30.00,
    'One of the most paddled rivers in the eastern United States. The Youghiogheny ("Yock") offers four distinct sections ranging from beginner to expert: the Top Yough (Class V–VI, extreme), Upper Yough (Class IV–V, expert), Middle Yough (Class I–II, family-friendly), and Lower Yough (Class III–IV, the most popular section in Ohiopyle State Park). Water releases from Deep Creek Lake provide consistent flows on the Upper section year-round.',
    '03081500',
    '["classic","multi-section","Appalachian","state park","dam release","popular","eastern US"]',
    1
  ),
  -- 5. Chattooga River — AW: Sections I–IV, Wild & Scenic River
  (
    5,
    'Chattooga River',
    'South Carolina/Georgia',
    'Sumter & Chattahoochee National Forests',
    34.8437000, -83.2503000,
    34.9880000, -83.1916000,
    34.6705000, -83.2836000,
    'IV',
    28.00,
    'A federally designated Wild and Scenic River forming the border between South Carolina and Georgia. Made famous by the 1972 film "Deliverance." The Chattooga features four distinct sections: Section I (Class I, scenic float), Section II (Class II, beginner-friendly), Section III (Class II–III with the iconic Bull Sluice rapid at the end), and Section IV (Class IV–V, expert-only, featuring the legendary Five Falls sequence: Entrance, Corkscrew, Crack-in-the-Rock, Jawbone, and Sock''em Dog). Free self-registration permits required at all put-ins.',
    '02177000',
    '["wilderness","remote","classic","wild and scenic","southeast","no motors","five falls","Deliverance"]',
    1
  ),
  -- 6. Nantahala River — AW: Gorge and Cascades sections
  (
    6,
    'Nantahala River',
    'North Carolina',
    'Nantahala National Forest',
    35.2693000, -83.6499000,
    35.2023000, -83.7080000,
    35.3362000, -83.5918000,
    'III',
    8.00,
    'The Nantahala is one of the most popular whitewater rivers in the Southeast, flowing through the spectacular Nantahala Gorge in western North Carolina. Dam-controlled releases from Nantahala Lake provide reliable flows from March through October. The main gorge run is approximately 8 miles of Class II–III whitewater, making it ideal for beginners and families. The highlight rapid is Nantahala Falls (Class III) at the take-out by the Nantahala Outdoor Center (NOC). Advanced paddlers can also tackle the expert-level Cascades section upstream.',
    '03505550',
    '["dam controlled","beginner friendly","family","gorge","southeast","NOC","popular"]',
    1
  ),
  -- 7. Arkansas River — AW: The Numbers, Browns Canyon, Royal Gorge
  (
    7,
    'Arkansas River',
    'Colorado',
    'Arkansas Headwaters Recreation Area',
    38.7498000, -106.1467000,
    39.2076000, -106.0493000,
    38.4396000, -105.2361000,
    'IV',
    60.00,
    'Colorado''s most commercially rafted river and one of America''s premier multi-day whitewater destinations. The Arkansas flows through the Arkansas Headwaters Recreation Area, offering diverse sections from The Numbers (Class IV–IV+, steep and technical), Browns Canyon National Monument (Class III, the most popular section), to the Royal Gorge (Class IV–V, dramatic canyon beneath the iconic bridge). Snowmelt-fed flows peak May through July, with the entire corridor managed cooperatively by Colorado Parks & Wildlife and the BLM.',
    '07091200',
    '["snowmelt","multi-section","national monument","Royal Gorge","Rocky Mountain","popular","commercial"]',
    1
  ),
  -- 8. Tuolumne River — AW: Main Tuolumne (Merals Pool to Wards Ferry)
  (
    8,
    'Tuolumne River',
    'California',
    'Stanislaus National Forest',
    37.8628000, -120.2409000,
    37.8502000, -120.0989000,
    37.8754000, -120.3828000,
    'IV',
    18.00,
    'The Tuolumne is one of California''s premier wilderness whitewater runs, flowing through a remote Sierra Nevada canyon in Stanislaus National Forest. The main run from Meral''s Pool to Ward''s Ferry features 18 miles of nearly continuous Class IV whitewater with highlights including Clavey Falls, Rock Garden, Nemesis, and the powerful Sunderland''s Chute. Flows are released from Hetch Hetchy Reservoir, providing reliable summer boating. Free permits are mandatory May 1 through October 15. Often run as a 2–3 day wilderness trip with excellent camping.',
    '11285500',
    '["wilderness","Sierra Nevada","Class IV","multi-day","permit required","Hetch Hetchy","camping"]',
    1
  ),
  -- 9. South Fork American River — AW: Chili Bar and The Gorge
  (
    9,
    'South Fork American River',
    'California',
    'El Dorado National Forest / Gold Country',
    38.8131000, -120.6839000,
    38.8131000, -120.6839000,
    38.6867000, -121.0197000,
    'III',
    21.00,
    'The most popular whitewater river in California and one of the most rafted rivers in the country. Flowing through historic Gold Country, the South Fork American offers accessible Class III whitewater with warm summer water temperatures. The two main sections—Chili Bar (Class III, 11 miles) and The Gorge (Class III+, 10 miles)—provide continuous fun rapids perfect for intermediate paddlers and commercial trips. The river''s proximity to Sacramento makes it a premier weekend destination.',
    '11446500',
    '["Gold Country","popular","beginner friendly","warm water","commercial","Sacramento","California"]',
    1
  ),
  -- 10. Deerfield River — AW: Fife Brook and Dryway sections
  (
    10,
    'Deerfield River',
    'Massachusetts',
    'Berkshire Mountains',
    42.6660000, -72.9652000,
    42.6936000, -72.9833000,
    42.6521000, -72.9540000,
    'III',
    9.00,
    'The premier whitewater destination in New England. The Deerfield River offers two main whitewater sections: the Fife Brook section (Class II–III, 5.7 miles) culminating in Zoar Gap, and the Dryway (Class III–IV, 3–4 miles of continuous technical whitewater). Both sections operate on scheduled dam releases, providing reliable whitewater from spring through fall. The Fife Brook section is one of the most popular commercial rafting runs in the Northeast.',
    '01168500',
    '["dam release","New England","scheduled releases","Berkshires","Zoar Gap","popular","northeast"]',
    1
  ),
  -- 11. Kennebec River — AW: Harris Station Gorge
  (
    11,
    'Kennebec River',
    'Maine',
    'Kennebec Gorge / The Forks',
    45.4407000, -69.8883000,
    45.4611000, -69.8700000,
    45.4213000, -69.9065000,
    'IV',
    12.00,
    'One of the great big-water whitewater runs in the eastern United States. The Kennebec Gorge below Harris Station Dam features powerful Class III–IV rapids with reliable scheduled dam releases providing big, exciting waves and hydraulics. The gorge run is approximately 12 miles to West Forks, with the first 3.5 miles being the most intense whitewater through the narrow gorge. American Whitewater played a key role in negotiating scheduled recreational releases. A popular commercial rafting destination in northern Maine.',
    '01042500',
    '["big water","dam release","gorge","northern Maine","commercial","scheduled releases","The Forks"]',
    1
  ),
  -- 12. French Broad River — AW: Sections through Hot Springs and Asheville
  (
    12,
    'French Broad River',
    'North Carolina',
    'Pisgah National Forest / Asheville',
    35.8924000, -82.8241000,
    35.8010000, -82.7440000,
    35.5924000, -82.5778000,
    'III',
    32.00,
    'One of the oldest rivers in the world, flowing northward through the Blue Ridge Mountains of western North Carolina. The French Broad offers varied whitewater sections, with Section 9 (Frank Bell''s to Stackhouse, Class III–IV, 8.6 miles) being the premier whitewater run. The river passes through the charming town of Hot Springs and near Asheville, offering a mix of exciting rapids and beautiful Appalachian scenery. Popular for both private paddling and commercial rafting throughout the warmer months.',
    '03451500',
    '["Appalachian","ancient river","scenic","Hot Springs","Asheville","blue ridge","multi-section"]',
    1
  ),
  -- 13. Colorado River (Grand Canyon) — AW: Lees Ferry to Diamond Creek
  (
    13,
    'Colorado River (Grand Canyon)',
    'Arizona',
    'Grand Canyon National Park',
    36.3280000, -112.4980000,
    36.8652000, -111.5860000,
    35.7936000, -113.4115000,
    'IV',
    225.00,
    'The ultimate American multi-day whitewater expedition. The Colorado River through the Grand Canyon is a 225-mile journey from Lees Ferry to Diamond Creek, featuring world-famous rapids including Lava Falls (Class V at certain flows), Crystal, Hermit, and Hance. The trip takes 12–25 days through one of Earth''s most spectacular landscapes, with side canyon hikes, ancient ruins, and unmatched geological history. Highly competitive permit lottery required for private trips. One of the most iconic river journeys in the world.',
    '09380000',
    '["Grand Canyon","multi-day","expedition","permit lottery","iconic","Class V","desert","bucket list"]',
    1
  ),
  -- 14. Middle Fork Salmon River — AW: Boundary Creek to Cache Bar
  (
    14,
    'Middle Fork Salmon River',
    'Idaho',
    'Frank Church River of No Return Wilderness',
    44.8480000, -114.6071000,
    44.5147000, -115.2587000,
    45.1813000, -113.9554000,
    'IV',
    100.00,
    'One of the original Wild and Scenic Rivers and America''s premier wilderness multi-day whitewater trip. The Middle Fork flows 100 miles through the largest contiguous wilderness area in the lower 48 states—the Frank Church River of No Return Wilderness. Features over 100 rapids, natural hot springs, Native American pictographs, and spectacular mountain scenery. Unregulated snowmelt flows peak in late spring and early summer. Highly competitive USFS permit lottery for the limited launch dates during the control season (late May through mid-September).',
    '13309220',
    '["wilderness","multi-day","wild and scenic","permit lottery","hot springs","expedition","Idaho","backcountry"]',
    1
  ),
  -- 15. Main Salmon River — AW: Corn Creek to Vinegar Creek
  (
    15,
    'Main Salmon River',
    'Idaho',
    'Frank Church River of No Return Wilderness',
    45.5011000, -115.3946000,
    45.3870000, -114.6762000,
    45.6151000, -116.1330000,
    'IV',
    79.00,
    'Known as the "River of No Return," the Main Salmon is one of America''s longest undammed rivers and a premier multi-day wilderness rafting trip. The 79-mile journey from Corn Creek to Vinegar Creek features Class III–IV whitewater through the second-deepest gorge in North America, with large sandy beaches for camping, excellent fishing, and rich mining-era history. The river offers a mix of big water rapids and calmer stretches, making it more accessible than the Middle Fork for families and intermediate paddlers. USFS permit required during the control season.',
    '13317000',
    '["River of No Return","wilderness","multi-day","big water","sandy beaches","fishing","permit required","Idaho"]',
    1
  );

-- =============================================================
-- STEP 3: River sections with American Whitewater data
-- =============================================================

-- ── New River Gorge sections (river_id=1) ─────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    1,
    'Upper New River',
    'Upper (Prince to Thurmond)',
    'A scenic Class I–III section from Prince to Thurmond through the upper gorge. Mostly gentle rapids and wide pools, suitable for families and beginners. Great scenery with historical sites from the New River Gorge coal mining era. Typically paddled in inflatable kayaks, canoes, or rafts for a relaxing experience.',
    37.8217000, -81.0141000,
    37.9576000, -81.0784000,
    'III',
    15.00,
    '03185400',
    '["beginner","scenic","family","national park","historical"]',
    1,
    1
  ),
  (
    1,
    'Lower New River (The Gorge)',
    'Lower (Cunard to Fayette Station)',
    'The premier whitewater section of the New River, featuring big-volume Class III–IV rapids through a dramatic sandstone gorge. Key rapids include The Keeneys (a series of three), Double Z, Greyhound Bus Stopper, Miller''s Folly, and Fayette Station Rapid directly beneath the iconic New River Gorge Bridge. One of the most famous commercial rafting runs in the eastern US. Strong intermediates and up.',
    37.9996000, -81.0221000,
    38.0670000, -81.0816000,
    'IV',
    8.00,
    '03185400',
    '["big water","gorge","classic","commercial","bridge","advanced"]',
    1,
    2
  ),
  (
    1,
    'The Dries',
    'The Dries (Hawks Nest to Gauley Bridge)',
    'A steep, challenging Class IV–V section below Hawks Nest Dam, runnable only when the power plant is not diverting water. When running, the Dries offers powerful, technical rapids in a tight canyon. Often dry—hence the name—but during outages or high water, it transforms into a serious expert-only run. Take-out is at the confluence of the New and Gauley Rivers at Gauley Bridge.',
    38.1363000, -81.1092000,
    38.1673000, -81.1947000,
    'V',
    5.50,
    NULL,
    '["expert","rare flows","steep","Hawks Nest","canyon","seasonal"]',
    NULL,
    3
  );

-- ── Gauley River sections (river_id=2) ────────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    2,
    'Upper Gauley',
    'Upper',
    'One of the most celebrated whitewater runs in the world. The Upper Gauley features the legendary "Big Five" Class V rapids in the first six miles: Insignificant, Pillow Rock, Lost Paddle, Iron Ring, and Sweet''s Falls. Twelve miles of continuous Class IV–V whitewater through a remote gorge below Summersville Dam. Best during the annual "Gauley Season" fall dam releases (22 days of scheduled releases from late September through mid-October). Requires expert-level skills. Put-in immediately below Summersville Dam.',
    38.2031000, -80.8823000,
    38.2575000, -80.9066000,
    'V',
    12.00,
    '03188500',
    '["dam release","world class","Class V","technical","Big Five","gauley season","expert"]',
    1,
    1
  ),
  (
    2,
    'Middle Gauley',
    'Middle',
    'A transitional Class III+–IV section between the Upper and Lower Gauley, often included as part of the Gauley "Marathon" run. Features continuous rapids with technical moves and a slightly mellower character than the Upper. A good progression run for intermediates building toward the Upper, or a satisfying run in its own right. Popular during Gauley Season dam releases.',
    38.2575000, -80.9066000,
    38.2605000, -80.9310000,
    'IV',
    4.00,
    '03188500',
    '["dam release","intermediate","fall season","continuous","progression"]',
    1,
    2
  ),
  (
    2,
    'Lower Gauley',
    'Lower',
    'Twelve miles of Class III–V whitewater with a more pool-drop character than the Upper, providing recovery time between major rapids. Highlights include Pure Screaming Hell, Heaven Help You, Upper and Lower Mash, Canyon Doors, and Koontz Flume. While slightly less intense than the Upper, the Lower still contains serious Class V rapids and should not be underestimated. More accessible for advanced-intermediate paddlers.',
    38.2605000, -80.9310000,
    38.2616000, -81.0210000,
    'V',
    12.00,
    '03188500',
    '["dam release","world class","Class V","pool drop","fall season","big rapids"]',
    1,
    3
  );

-- ── Ocoee River sections (river_id=3) ─────────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    3,
    'Upper Ocoee (Olympic Section)',
    'Upper',
    'Site of the 1996 Atlanta Olympic whitewater slalom events. This challenging Class III–IV section features both natural and man-made whitewater features created for the Olympics. Key rapids include Mikey''s Ledge, Let''s Make a Deal, Callihan''s, Godzilla, Humongous, and Edge of the World. Releases are limited to scheduled weekends (May through Labor Day) plus a few extra days in May and September. A bucket-list run for intermediate-to-advanced paddlers.',
    35.0862000, -84.5211000,
    35.1070000, -84.5552000,
    'IV',
    5.00,
    '03566000',
    '["olympic","dam controlled","man-made features","weekend releases","Class IV","bucket list"]',
    1,
    1
  ),
  (
    3,
    'Middle Ocoee',
    'Middle',
    'The most popular and commercially rafted section of the Ocoee, featuring non-stop Class III–IV action through channeled bedrock rapids. TVA-controlled dam releases provide consistent, predictable flows from March through October. Key rapids include Grumpy''s, Broken Nose, Double Suck, Double Trouble, and Table Saw. A favorite for intermediate-to-advanced paddlers and one of the most commercially rafted sections in the Southeast.',
    35.1070000, -84.5552000,
    35.0997000, -84.5954000,
    'IV',
    5.00,
    '03568933',
    '["dam controlled","consistent flow","bedrock","commercial","popular","southeast","TVA"]',
    1,
    2
  ),
  (
    3,
    'Lower Ocoee',
    'Lower',
    'A gentle Class I–II section from the Sugarloaf Mountain Day Use Area to Nancy Ward Boat Access. Best for tubing, fishing, and flatwater kayaking. Not a whitewater run—this section is for relaxed floating and family recreation. No commercial whitewater releases on this section.',
    35.1192000, -84.6826000,
    35.1712000, -84.7369000,
    'II',
    8.00,
    '03568933',
    '["family","flatwater","tubing","fishing","relaxed","beginner"]',
    1,
    3
  );

-- ── Youghiogheny River sections (river_id=4) ──────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    4,
    'Top Yough',
    'Top',
    'An extremely difficult Class V–VI section below Swallow Falls State Park, suitable only for expert kayakers with strong rescue skills. Very steep and technical with continuous big rapids and limited rescue access. The gradient is among the steepest of any commonly run section in the Mid-Atlantic. Not commercially rafted.',
    39.4847000, -79.4105000,
    39.6131000, -79.3840000,
    'V+',
    3.00,
    '03077000',
    '["extreme","expert only","steep","continuous","Class V+","Maryland"]',
    1,
    1
  ),
  (
    4,
    'Upper Yough',
    'Upper',
    'One of the most technically demanding Class IV–V runs in the eastern US, from Sang Run to Friendsville, Maryland. Continuous challenging rapids and drops require strong skills and teamwork. Highlights include National Falls, Gap Falls, Zinger, and Charlie''s Choice. Water releases from Deep Creek Lake provide consistent flows year-round. Commercial guided trips are available for skilled rafters. A true test piece for eastern paddlers.',
    39.6131000, -79.3840000,
    39.6611000, -79.4086000,
    'V',
    9.00,
    '03077000',
    '["technical","expert","dam release","Mid-Atlantic","continuous","test piece"]',
    1,
    2
  ),
  (
    4,
    'Middle Yough',
    'Middle',
    'A gentle Class I–II section from Ramcat Launch near Confluence, PA to Ohiopyle. Eleven miles of easy paddling through beautiful Laurel Highlands scenery, ideal for families, beginners, and youth groups. Great for canoes, inflatable kayaks, and SUPs. A perfect introduction to river paddling before stepping up to the Lower Yough.',
    39.8169000, -79.3574000,
    39.8700000, -79.4940000,
    'II',
    11.00,
    '03081500',
    '["beginner","family","scenic","Laurel Highlands","flatwater","introduction"]',
    1,
    3
  ),
  (
    4,
    'Lower Yough',
    'Lower',
    'The most popular whitewater run in the eastern United States, flowing through the heart of Ohiopyle State Park. Seven miles of exciting Class III–IV rapids including Entrance, Cucumber, Railroad, Dimple, Swimmers, and River''s End. Put-in is just below the spectacular Ohiopyle Falls. A permit system manages the large number of private boaters. Excellent for experienced intermediates and a rite-of-passage run for Mid-Atlantic paddlers.',
    39.8700000, -79.4940000,
    39.8910000, -79.5630000,
    'IV',
    7.50,
    '03081500',
    '["classic","popular","state park","permit required","eastern US","rite of passage"]',
    1,
    4
  );

-- ── Chattooga River sections (river_id=5) ─────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    5,
    'Chattooga Section I',
    'Section I',
    'A scenic Class I flatwater float from Overflow Creek Road Bridge to the Highway 28 Bridge. Seven miles of gentle river through pristine wilderness, ideal for canoeing, fishing, and wildlife watching. The easiest section of the Chattooga with minimal whitewater, offering a peaceful introduction to this Wild and Scenic River.',
    34.9880000, -83.1916000,
    34.8437000, -83.2503000,
    'I',
    7.00,
    '02177000',
    '["flatwater","scenic","wilderness","fishing","canoe","beginner","wild and scenic"]',
    1,
    1
  ),
  (
    5,
    'Chattooga Section II',
    'Section II',
    'A beginner-friendly Class II section from Highway 28 Bridge to Earl''s Ford. Seven miles of mild whitewater through beautiful wilderness, with Big Shoals being the highlight rapid. Great for families, fishing, and overnight camping. A wonderful step-up from Section I with easy rapids in a remote, scenic setting.',
    34.8437000, -83.2503000,
    34.7840000, -83.2917000,
    'II',
    7.00,
    '02177000',
    '["beginner","wilderness","family","fishing","camping","scenic","mild whitewater"]',
    1,
    2
  ),
  (
    5,
    'Chattooga Section III',
    'Section III',
    'A classic intermediate wilderness run from Earl''s Ford to the Route 76 Bridge. Thirteen miles of Class II–III whitewater building to the iconic Bull Sluice (Class IV at high water) at the take-out. Notable rapids include Dick''s Creek Ledge, The Narrows, Eye of the Needle, Second Ledge, and Rock Garden. The most popular intermediate paddling section on the Chattooga, combining exciting whitewater with stunning remote scenery.',
    34.7840000, -83.2917000,
    34.8032000, -83.3079000,
    'III',
    13.00,
    '02177000',
    '["wilderness","remote","classic","Bull Sluice","intermediate","scenic","popular"]',
    1,
    3
  ),
  (
    5,
    'Chattooga Section IV',
    'Section IV',
    'An expert-only Class IV–V wilderness run from Route 76 Bridge to Tugaloo Lake, featuring the legendary Five Falls sequence: Entrance, Corkscrew, Crack-in-the-Rock, Jawbone, and Sock''em Dog. Made famous by the 1972 film "Deliverance." Eight miles of serious whitewater (including a 2.5-mile paddle-out on Lake Tugaloo) through one of the most remote and beautiful gorges in the Southeast. Other notable rapids include Raven''s Chute, Long Creek Falls, and Shoulderbone. Significant consequences for mistakes.',
    34.8032000, -83.3079000,
    34.6705000, -83.2836000,
    'V',
    8.00,
    '02177000',
    '["wilderness","remote","expert","five falls","Deliverance","Class V","consequences","classic"]',
    1,
    4
  );

-- ── Nantahala River sections (river_id=6) ─────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    6,
    'Nantahala Gorge',
    'Gorge (Main Run)',
    'The classic Nantahala Gorge run from the Duke Energy power plant to the Nantahala Outdoor Center (NOC). Eight miles of fun, splashy Class II–III whitewater with dam-controlled releases providing reliable flows from March through October. Perfect for beginners and families. The highlight is Nantahala Falls (Class III), a short but exciting rapid at the take-out by the NOC. One of the most commercially rafted runs in the Southeast with over 200,000 visitors annually.',
    35.2023000, -83.7080000,
    35.3362000, -83.5918000,
    'III',
    8.00,
    '03505550',
    '["dam controlled","beginner friendly","family","NOC","popular","commercial","Nantahala Falls"]',
    1,
    1
  ),
  (
    6,
    'Nantahala Cascades',
    'Cascades',
    'A short but intense expert-level Class IV–V section above the main Gorge run. Less than a mile of steep, technical whitewater dropping through a series of cascades with limited eddies. Requires precise boat control and strong whitewater skills. Not commercially run—this is a dedicated kayaker''s run for experienced paddlers only.',
    35.1918000, -83.7210000,
    35.1726000, -83.7065000,
    'V',
    0.85,
    '03504000',
    '["expert","steep","technical","cascades","kayaker only","short","intense"]',
    1,
    2
  );

-- ── Arkansas River sections (river_id=7) ──────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    7,
    'The Numbers',
    'The Numbers',
    'One of Colorado''s classic advanced whitewater runs. Seven to nine miles of continuous, steep, technical Class IV–IV+ rapids through a narrow canyon with a gradient of about 50 feet per mile. The rapids are named by number (1 through 7), each offering unique challenges. Located about 11 miles north of Buena Vista. Requires strong swimming skills and solid Class IV experience. Not typically commercially rafted due to difficulty.',
    39.2076000, -106.0493000,
    38.8392000, -106.1275000,
    'IV',
    9.00,
    '07091200',
    '["steep","technical","Class IV","continuous","numbered rapids","expert","Colorado classic"]',
    1,
    1
  ),
  (
    7,
    'Browns Canyon',
    'Browns Canyon',
    'The most popular whitewater section on the Arkansas River and one of the most commercially rafted runs in America. Ten to fourteen miles of fun, splashy Class III rapids through Browns Canyon National Monument with beautiful granite walls and wilderness scenery. Famous rapids include Zoom Flume, Pinball, Squeeze Play, Big Drop, and Staircase. Ideal for families and first-time rafters. Snowmelt-fed flows peak May through July.',
    38.7498000, -106.1467000,
    38.6515000, -106.1208000,
    'III',
    14.00,
    '07091200',
    '["national monument","popular","commercial","family","Class III","granite canyon","scenic"]',
    1,
    2
  ),
  (
    7,
    'Royal Gorge',
    'Royal Gorge',
    'A dramatic Class IV–V section through the narrow, towering Royal Gorge canyon beneath the iconic Royal Gorge Bridge. Approximately 10 miles of continuous, powerful whitewater including the famous Sunshine Falls and Sledgehammer rapids. The canyon walls reach over 1,000 feet high in places. Requires solid advanced-to-expert skills. Commercial trips are available for experienced rafters. One of the most scenic and adrenaline-pumping runs in Colorado.',
    38.4603000, -105.3852000,
    38.4396000, -105.2361000,
    'V',
    10.00,
    '07094500',
    '["gorge","Class V","dramatic canyon","Royal Gorge Bridge","advanced","powerful","scenic"]',
    1,
    3
  );

-- ── Tuolumne River section (river_id=8) ───────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    8,
    'Main Tuolumne',
    'Merals Pool to Wards Ferry',
    'A premier California wilderness whitewater run from Meral''s Pool to Ward''s Ferry Bridge. Eighteen miles of nearly continuous Class IV whitewater through a remote Sierra Nevada canyon. Notable rapids include Rock Garden, Nemesis, Sunderland''s Chute, Hackamack Hole, Ram''s Head, and the iconic Clavey Falls (optional portage). Flows released from Hetch Hetchy Reservoir provide reliable summer boating (ideal 1,000–5,000 cfs). Free permits mandatory May 1–October 15. Often run as a 2–3 day wilderness trip with excellent camping at riverside sites.',
    37.8502000, -120.0989000,
    37.8754000, -120.3828000,
    'IV',
    18.00,
    '11285500',
    '["wilderness","multi-day","Clavey Falls","Sierra Nevada","permit required","camping","classic"]',
    1,
    1
  );

-- ── South Fork American River sections (river_id=9) ───────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    9,
    'Chili Bar',
    'Chili Bar',
    'The upper section of the South Fork American, from Chili Bar to Camp Lotus. Eleven miles of continuous Class III whitewater through scenic Gold Country canyons with warm summer water. Popular rapids include Meatgrinder, Racehorse Bend, Triple Threat, and Troublemaker. One of the most popular commercial and private whitewater runs in California. Excellent for intermediate paddlers and first-time rafters.',
    38.8131000, -120.6839000,
    38.7950000, -120.8900000,
    'III',
    11.00,
    '11446500',
    '["Gold Country","popular","commercial","warm water","intermediate","California","fun"]',
    1,
    1
  ),
  (
    9,
    'The Gorge',
    'The Gorge',
    'The lower section of the South Fork American, from Camp Lotus to Salmon Falls. Ten miles of Class III+ whitewater through a deeper, more dramatic gorge. Slightly more challenging than Chili Bar with bigger rapids including Satan''s Cesspool, Hospital Bar, and Recoveryroom. The canyon scenery is spectacular, with steep rock walls and warm swimming holes. A great step-up from the Chili Bar section.',
    38.7950000, -120.8900000,
    38.6867000, -121.0197000,
    'III',
    10.00,
    '11446500',
    '["gorge","Class III+","warm water","scenic canyon","swimming holes","step-up"]',
    1,
    2
  );

-- ── Deerfield River sections (river_id=10) ────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    10,
    'Dryway',
    'Dryway (Monroe Bridge to Fife Brook)',
    'An advanced Class III–IV section from Monroe Bridge to Fife Brook Dam. Three to four miles of continuous, technical whitewater with fast-paced rapids. Operates on scheduled dam releases (900–1,100 cfs typical). A significant step-up from the Fife Brook section requiring solid Class III–IV skills. Not commercially rafted—this is a dedicated paddler''s run.',
    42.6936000, -72.9833000,
    42.6799000, -72.9763000,
    'IV',
    3.50,
    '01168500',
    '["dam release","advanced","technical","continuous","scheduled releases","New England"]',
    1,
    1
  ),
  (
    10,
    'Fife Brook',
    'Fife Brook (Zoar Gap)',
    'The most popular whitewater section on the Deerfield, from Fife Brook Dam to below Zoar Gap. 5.7 miles of Class II–III whitewater culminating in the exciting Zoar Gap rapid (Class III). Operates on scheduled dam releases (700–5,000 cfs runnable). A favorite for intermediate paddlers and commercial rafting trips. One of the premier whitewater runs in New England.',
    42.6799000, -72.9763000,
    42.6521000, -72.9540000,
    'III',
    5.70,
    '01168500',
    '["dam release","Zoar Gap","popular","commercial","intermediate","New England","scheduled releases"]',
    1,
    2
  );

-- ── Kennebec River sections (river_id=11) ─────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    11,
    'Kennebec Gorge',
    'Gorge (Harris Station to Carry Brook)',
    'A powerful Class IV big-water gorge run below Harris Station Dam. Three and a half miles of exciting, large-volume rapids through a narrow gorge with scheduled dam releases providing reliable flows. One of the premier big-water whitewater experiences in the eastern United States. American Whitewater was instrumental in negotiating these recreational releases. Popular for both commercial rafting and private paddling.',
    45.4611000, -69.8700000,
    45.4213000, -69.9065000,
    'IV',
    3.50,
    '01042500',
    '["big water","gorge","dam release","scheduled releases","Class IV","powerful","Maine"]',
    1,
    1
  ),
  (
    11,
    'Kennebec River (Gorge to West Forks)',
    'Gorge to West Forks',
    'Continuation of the Kennebec below the main gorge section. Approximately 8.5 miles of Class II–III whitewater from Carry Brook to West Forks. A more relaxed pace than the gorge with fun intermediate rapids and beautiful northern Maine forest scenery. Often combined with the gorge section for a full 12-mile day trip.',
    45.4213000, -69.9065000,
    45.3700000, -69.9600000,
    'III',
    8.50,
    '01042500',
    '["intermediate","scenic","northern Maine","continuation","relaxed","forest"]',
    1,
    2
  );

-- ── French Broad River sections (river_id=12) ─────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    12,
    'French Broad Section 9',
    'Section 9 (Frank Bell''s to Stackhouse)',
    'The premier whitewater section of the French Broad River. 8.6 miles of exciting Class III–IV rapids through the Blue Ridge Mountains near Hot Springs, NC. Features a variety of fun, challenging rapids interspersed with scenic mountain views. Popular for both commercial rafting and private paddling. A classic North Carolina whitewater run that''s accessible yet exciting.',
    35.8010000, -82.7440000,
    35.8924000, -82.8241000,
    'IV',
    8.60,
    '03451500',
    '["Class III-IV","Blue Ridge","Hot Springs","classic","commercial","scenic","North Carolina"]',
    1,
    1
  ),
  (
    12,
    'French Broad (Hot Springs to Asheville)',
    'Hot Springs to Asheville',
    'A longer scenic section from Hot Springs through to the Asheville area. Approximately 23 miles of Class I–II+ with some mild rapids and long flatwater sections. Beautiful Appalachian scenery along one of the world''s oldest rivers. Perfect for canoes, recreational kayaks, and SUPs. Great multi-day paddling or leisurely day floats.',
    35.8924000, -82.8241000,
    35.5924000, -82.5778000,
    'II',
    23.00,
    '03451500',
    '["scenic","flatwater","Asheville","canoe","multi-day","ancient river","relaxed"]',
    1,
    2
  );

-- ── Colorado River sections (river_id=13) ─────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    13,
    'Grand Canyon (Lees Ferry to Phantom Ranch)',
    'Upper Canyon',
    'The upper half of the Grand Canyon river journey, from Lees Ferry (River Mile 0) to Phantom Ranch (River Mile 88). Features iconic rapids including Badger Creek, House Rock, Hance, Sockdolager, and Grapevine. Stunning geological formations spanning nearly 2 billion years of Earth''s history. Side hikes to waterfalls, ancient ruins, and slot canyons. Typically takes 6–10 days.',
    36.8652000, -111.5860000,
    36.0976000, -111.8445000,
    'IV',
    88.00,
    '09380000',
    '["Grand Canyon","multi-day","expedition","geological","Phantom Ranch","ancient history"]',
    1,
    1
  ),
  (
    13,
    'Grand Canyon (Phantom Ranch to Diamond Creek)',
    'Lower Canyon',
    'The lower half of the Grand Canyon journey, from Phantom Ranch (River Mile 88) to Diamond Creek (River Mile 225). Features the biggest rapids on the river including Crystal (Class V at high water), Hermit, Granite, Deubendorff, Upset, and the legendary Lava Falls (Class V, often considered the most famous rapid in North America). Also includes the spectacular Havasu Creek side canyon with its turquoise waterfalls. Typically 7–14 days.',
    36.0976000, -111.8445000,
    35.7936000, -113.4115000,
    'V',
    137.00,
    '09380000',
    '["Grand Canyon","multi-day","Lava Falls","Crystal","Havasu Creek","Class V","legendary"]',
    1,
    2
  );

-- ── Middle Fork Salmon River section (river_id=14) ────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    14,
    'Middle Fork Salmon (Boundary Creek to Cache Bar)',
    'Full Run',
    'The complete 100-mile Middle Fork Salmon wilderness expedition from Boundary Creek (near Dagger Falls) to the confluence with the Main Salmon at Cache Bar. Features over 100 rapids including Dagger Falls, Velvet Falls, Pistol Creek, Tappan Falls, Haystack, and Rubber. Natural hot springs at Loon Creek, Sunflower Flat, and other locations. Ancient Sheepeater Native American pictographs. Pristine wilderness camping on white sand beaches. Typically a 5–7 day journey. USFS permit lottery required for control season (late May through mid-September).',
    44.5147000, -115.2587000,
    45.1813000, -113.9554000,
    'IV',
    100.00,
    '13309220',
    '["wilderness","multi-day","expedition","hot springs","permit lottery","white sand","backcountry","Idaho classic"]',
    1,
    1
  );

-- ── Main Salmon River section (river_id=15) ───────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    15,
    'Main Salmon (Corn Creek to Vinegar Creek)',
    'Full Run',
    'The complete 79-mile Main Salmon "River of No Return" wilderness expedition from Corn Creek to Vinegar Creek. Big water Class III–IV rapids through the second-deepest gorge in North America. Large sandy beaches provide excellent camping. Rich mining-era and Native American history along the corridor. More accessible than the Middle Fork for families and intermediate paddlers, while still offering a true wilderness multi-day experience. Notable rapids include Salmon Falls, Black Creek, Big Mallard, Elkhorn, Growler, and Ludwig. Typically a 4–6 day journey. USFS permit required during the control season.',
    45.3870000, -114.6762000,
    45.6151000, -116.1330000,
    'IV',
    79.00,
    '13317000',
    '["River of No Return","multi-day","big water","sandy beaches","wilderness","fishing","family friendly","Idaho"]',
    1,
    1
  );

-- =============================================================
-- Ohio Rivers (from 004_ohio_seed_data.sql)
-- =============================================================

-- =============================================================
-- Ohio Rivers (IDs 16–22)
-- =============================================================
INSERT INTO rivers (id, name, state, region, lat, lng, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, description, usgs_site_id, tags, is_runnable) VALUES
  -- 16. Cuyahoga River — AW: Multiple sections from Kent through the Gorge
  (
    16,
    'Cuyahoga River',
    'Ohio',
    'Cuyahoga Valley National Park / Summit County',
    41.1477000, -81.3679000,
    41.1477000, -81.3679000,
    41.1190000, -81.5170000,
    'III',
    15.00,
    'Ohio''s most well-known river and a symbol of environmental restoration. The Cuyahoga flows through Cuyahoga Valley National Park and offers diverse paddling from the short Class II–III whitewater section at Kent to Munroe Falls, to the dramatic Gorge section near Cuyahoga Falls featuring Class III–IV rapids. American Whitewater is actively involved in the Cuyahoga Restoration project, working to restore whitewater access as the Ohio Edison Gorge Dam is removed. The river also offers scenic flatwater sections through the national park.',
    '04208000',
    '["national park","dam removal","restoration","Ohio","urban","gorge","Keel-Haulers","American Whitewater"]',
    1
  ),
  -- 17. Little Miami River — AW: Clifton Gorge and scenic sections
  (
    17,
    'Little Miami River',
    'Ohio',
    'Clifton Gorge State Nature Preserve / John Bryan State Park',
    39.7987000, -83.8260000,
    39.7987000, -83.8260000,
    39.7620000, -83.8700000,
    'III',
    1.30,
    'A federally designated Wild and Scenic River and National Scenic River. The Little Miami''s Clifton Gorge section is Ohio''s most challenging whitewater—a dramatic 1.3-mile stretch of Class II–IV rapids through a narrow dolomite gorge carved by glacial meltwater. The gorge features steep drops, ledges, holes, and narrow chutes that come alive after heavy rains. Due to its location within Clifton Gorge State Nature Preserve, paddling access may be restricted—always check current ODNR regulations before running. Outside the gorge, the Little Miami offers over 100 miles of scenic Class I flatwater paddling.',
    '03241500',
    '["wild and scenic","gorge","glacial","technical","rain dependent","Ohio","dolomite","state park"]',
    NULL
  ),
  -- 18. Clear Fork Mohican River — AW: Scenic Class II through Mohican State Park
  (
    18,
    'Clear Fork Mohican River',
    'Ohio',
    'Mohican State Park / Clear Fork Gorge',
    40.6067000, -82.2592000,
    40.6067000, -82.2592000,
    40.6200000, -82.2325000,
    'II',
    4.90,
    'A scenic Class II run through the beautiful Clear Fork Gorge near Mohican State Park. The river flows from below Pleasant Hill Dam through a lush, forested valley reminiscent of Appalachian wilderness—one of Ohio''s most scenic paddling experiences. Best in spring when dam releases and rainfall provide adequate flows. The run features easy-to-moderate rapids with riffles and small drops, making it perfect for beginners and families. Adjacent to Mohican State Park with extensive camping and recreation facilities.',
    '03126800',
    '["scenic","state park","gorge","beginner friendly","family","spring","Ohio","camping"]',
    1
  ),
  -- 19. Mad River — AW: Spring-fed Class I–II from Urbana to Springfield
  (
    19,
    'Mad River',
    'Ohio',
    'Clark & Champaign Counties / Springfield',
    39.9240000, -83.8235000,
    40.1081000, -83.7571000,
    39.8985000, -83.8724000,
    'II',
    16.00,
    'One of Ohio''s best paddling rivers, known for its exceptionally clear, spring-fed waters. The Mad River flows from near Urbana through Springfield, offering approximately 16 miles of Class I–II whitewater with riffles, small waves, and occasional play spots. The Snyder Park section in Springfield features an engineered whitewater play spot. A favorite among Dayton-area paddlers, the Mad River is suitable for beginners through intermediates. Local outfitter Mad River Adventures provides rentals and shuttles. Always portage low-head dams.',
    '03269500',
    '["spring fed","clear water","beginner friendly","play spot","Ohio","Springfield","scenic"]',
    1
  ),
  -- 20. Kokosing River — AW: Ohio Scenic River Water Trail
  (
    20,
    'Kokosing River',
    'Ohio',
    'Knox County / Mount Vernon',
    40.3822000, -82.3472000,
    40.3822000, -82.3472000,
    40.3934000, -82.1858000,
    'I',
    28.00,
    'Ohio''s first officially designated State Scenic River Water Trail. The Kokosing winds 28 miles through the rolling hills of Knox County, offering peaceful Class I paddling with deep pools, riffles, and beautiful sandstone bluffs. The Gambier to Millwood section is the most popular, passing through pastoral farmland and forests teeming with wildlife. Factory Rapids near Millwood can approach Class III in high water. Well-maintained access points with parking, kiosks, and seasonal facilities at multiple locations along the water trail.',
    '03137000',
    '["scenic river","water trail","beginner friendly","family","wildlife","Ohio","first water trail"]',
    1
  ),
  -- 21. Big Darby Creek — AW: Ohio Scenic River, nationally significant biodiversity
  (
    21,
    'Big Darby Creek',
    'Ohio',
    'Pickaway & Franklin Counties / Darbyville',
    39.7006000, -83.1102000,
    39.8450000, -83.2050000,
    39.5950000, -83.0500000,
    'II',
    30.00,
    'Designated as both a State and National Scenic River, Big Darby Creek is one of the highest-quality warm-water streams in the Midwest and supports over 100 fish species and 40 mussel species—exceptional biodiversity for its size. The creek offers approximately 30 miles of Class I–II paddling through rural central Ohio, with gentle riffles, gravel bars, and scenic bluffs. Best paddled in spring and early summer when water levels are adequate. A hidden gem for Ohio paddlers seeking a peaceful, natural experience close to Columbus.',
    '03230500',
    '["scenic river","national scenic river","biodiversity","Ohio","Columbus area","wildlife","clean water","hidden gem"]',
    1
  ),
  -- 22. Tinkers Creek — AW: Class IV–V steep creek through Bedford Reservation
  (
    22,
    'Tinkers Creek',
    'Ohio',
    'Bedford Reservation / Cuyahoga Valley National Park',
    41.3910000, -81.5375000,
    41.3910000, -81.5375000,
    41.3750000, -81.5758000,
    'V',
    4.50,
    'Northeast Ohio''s premier steep creek and one of the most challenging whitewater runs in the state. Tinkers Creek drops through a dramatic gorge in the Cleveland Metroparks Bedford Reservation before flowing into the Cuyahoga Valley National Park. The "meat" section averages an incredible 165 feet per mile of gradient over its steepest stretch, featuring slides, drops, a 20-foot waterfall, and a tunnel section. The creek is entirely rain-dependent and flashy—rising and falling quickly after storms. Best run in fall through spring when significant rainfall pushes flows above 250 CFS. Popular with advanced paddlers from the Keel-Haulers Canoe Club and the broader Northeast Ohio creek boating community. Expert skills required.',
    '04207200',
    '["steep creek","expert","waterfall","Class V","rain dependent","gorge","Bedford Reservation","Keel-Haulers","Cleveland","flashy"]',
    NULL
  );

-- =============================================================
-- Ohio River Sections
-- =============================================================

-- ── Cuyahoga River sections (river_id=16) ─────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    16,
    'Kent to Munroe Falls',
    'Kent to Munroe Falls',
    'A short but fun Class II–III whitewater section featuring a dam chute, surfable holes, and swift current when levels are right. Best when the Cuyahoga is running above 700 CFS, with surfable features forming around 1,100 CFS. After the dam chute, stay river right to avoid strainers on river left. Put-in near John Brown Tannery Park in Kent. A quick after-work run popular with local paddlers from the Keel-Haulers Canoe Club.',
    41.1477000, -81.3679000,
    41.1389000, -81.4333000,
    'III',
    3.00,
    '04208000',
    '["dam chute","surf waves","short run","Ohio","urban","Keel-Haulers"]',
    1,
    1
  ),
  (
    16,
    'Cuyahoga Gorge',
    'Gorge (Ohio Edison Dam area)',
    'The most dramatic section of the Cuyahoga—a steep gorge with Class III–IV rapids below the former Ohio Edison Dam site near Cuyahoga Falls. American Whitewater is actively involved in the Cuyahoga Restoration project as this 60-foot dam is being removed, which will restore historic whitewater and free-flowing conditions. When accessible, this approximately 1-mile section features continuous steep drops and technical rapids. Expert paddlers only. Check current status of dam removal and access restrictions before attempting.',
    41.1340000, -81.4890000,
    41.1190000, -81.5170000,
    'IV',
    1.00,
    '04208000',
    '["gorge","dam removal","expert","American Whitewater project","restoration","steep"]',
    NULL,
    2
  ),
  (
    16,
    'Cuyahoga Valley National Park',
    'National Park (Route 303 to Canal Road)',
    'A scenic flatwater paddle through Cuyahoga Valley National Park. Gentle Class I water with occasional riffles, passing through beautiful forests and alongside the Ohio & Erie Canal Towpath Trail. Great for beginners, families, and nature lovers. Multiple access points within the park. Opportunities to spot bald eagles, great blue herons, and other wildlife.',
    41.1953000, -81.5583000,
    41.3860000, -81.6080000,
    'I',
    15.00,
    '04208000',
    '["national park","flatwater","scenic","family","wildlife","towpath trail","beginner"]',
    1,
    3
  );

-- ── Little Miami River sections (river_id=17) ─────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    17,
    'Clifton Gorge',
    'Clifton Gorge',
    'Ohio''s most challenging whitewater—a 1.3-mile stretch of Class II–IV rapids through a narrow, dramatic dolomite gorge shaped by glacial meltwater. Features steep drops, ledges, powerful holes, and narrow chutes that demand advanced paddling skills. Located within Clifton Gorge State Nature Preserve and John Bryan State Park. Extremely rain-dependent—runnable only after heavy precipitation. Access may be restricted by ODNR for conservation and safety; always verify current regulations. Hazards include undercut rocks, strainers, and foot entrapment at higher flows.',
    39.7987000, -83.8260000,
    39.7800000, -83.8500000,
    'IV',
    1.30,
    '03241500',
    '["gorge","technical","rain dependent","advanced","dolomite","glacial","state park","restricted access"]',
    NULL,
    1
  ),
  (
    17,
    'Little Miami Scenic (Corwin to Morrow)',
    'Scenic Section (Corwin to Morrow)',
    'A peaceful Class I scenic float through the Little Miami River Valley, part of the National Wild and Scenic River system. Approximately 15 miles of gentle paddling through wooded corridors and past limestone bluffs. Perfect for canoes, recreational kayaks, and family outings. Multiple livery services operate along this stretch. The adjacent Little Miami Scenic Trail (paved bike path) makes for easy shuttle options.',
    39.5200000, -84.0630000,
    39.3550000, -84.1260000,
    'I',
    15.00,
    '03241500',
    '["wild and scenic","scenic","family","flatwater","bike trail","livery","Ohio"]',
    1,
    2
  );

-- ── Clear Fork Mohican River section (river_id=18) ────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    18,
    'Pleasant Hill Dam to Black Fork',
    'Clear Fork Gorge Run',
    'The main paddling section of the Clear Fork, from below Pleasant Hill Dam to the confluence with the Black Fork Mohican River near Loudonville. 4.9 miles of Class II whitewater through the scenic Clear Fork Gorge, adjacent to Mohican State Park and Clear Fork Gorge State Nature Preserve. The run features riffles, small rapids, and occasional drops through a lush forested valley. Best in spring when flows from the dam are highest. Watch for downed trees and low bridges. Livery services available in Loudonville.',
    40.6067000, -82.2592000,
    40.6200000, -82.2325000,
    'II',
    4.90,
    '03126800',
    '["gorge","state park","scenic","spring","beginner","livery","Ohio"]',
    1,
    1
  );

-- ── Mad River sections (river_id=19) ──────────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    19,
    'Urbana to Tremont City',
    'Upper (Urbana to Tremont City)',
    'A gentle Class I–II section of clear, spring-fed water from Urbana to Tremont City. Approximately 9 miles of easy riffles and small waves through open scenery and rural Ohio. Ideal for beginner-to-intermediate paddlers. The exceptionally clear water is fed by underground springs, providing better visibility than most Ohio rivers.',
    40.1081000, -83.7571000,
    39.9702000, -83.8194000,
    'II',
    9.00,
    '03269500',
    '["spring fed","clear water","beginner","rural","Ohio","easy"]',
    1,
    1
  ),
  (
    19,
    'Tremont City to Springfield (Snyder Park)',
    'Lower (Tremont City to Springfield)',
    'Seven miles of Class I–II+ whitewater from Tremont City to Snyder Park in Springfield. Features occasional riffles, small waves, and more developed play features near Snyder Park. The Snyder Park section includes an engineered whitewater play spot popular with local kayakers. Always portage low-head dams in this section. Local outfitter Mad River Adventures provides rentals and shuttle service.',
    39.9702000, -83.8194000,
    39.9244000, -83.8235000,
    'II',
    7.00,
    '03269500',
    '["play spot","Snyder Park","Springfield","outfitter","Ohio","riffles"]',
    1,
    2
  );

-- ── Kokosing River section (river_id=20) ──────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    20,
    'Gambier to Millwood',
    'Water Trail (Gambier to Millwood)',
    'The most popular section of Ohio''s first State Scenic River Water Trail. Approximately 15 miles of Class I paddling from Lower Gambier Road canoe access to Millwood. Deep pools, riffles, and beautiful sandstone bluffs line the route through Knox County. Factory Rapids near Millwood can approach Class III in high water—stay river left or portage right if conditions are too strong. Well-maintained access points with parking and seasonal facilities. Ideal paddling flows are 100–200 CFS. Kayak and canoe rentals available from Kokosing River Outfitters.',
    40.3822000, -82.3472000,
    40.3934000, -82.1858000,
    'I',
    15.00,
    '03137000',
    '["water trail","scenic","family","Factory Rapids","Knox County","Ohio","outfitter"]',
    1,
    1
  );

-- ── Big Darby Creek section (river_id=21) ─────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    21,
    'Big Darby Creek (Plain City to Darbyville)',
    'Main Run (Plain City to Darbyville)',
    'The premier paddling section of Big Darby Creek, one of the highest-quality warm-water streams in the Midwest. Approximately 20 miles of Class I–II paddling through rural central Ohio. Gentle riffles, gravel bars, and scenic bluffs characterize this peaceful run. Exceptional biodiversity—home to over 100 fish species and 40 mussel species, making it one of the most ecologically significant streams in the eastern United States. Best in spring and early summer when water levels support comfortable paddling. A hidden gem less than an hour from Columbus.',
    39.8450000, -83.2050000,
    39.7006000, -83.1102000,
    'II',
    20.00,
    '03230500',
    '["scenic river","biodiversity","Columbus area","spring","clean water","wildlife","hidden gem","Ohio"]',
    1,
    1
  );

-- ── Tinkers Creek sections (river_id=22) ──────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    22,
    'Tinkers Creek Gorge (Broadway to Dunham Road)',
    'Gorge Run (Broadway to Dunham)',
    'The full Tinkers Creek gorge run from Broadway Trailhead to Dunham Road in Bedford Reservation. Approximately 4.5 miles of Class IV–V steep creek through a dramatic wooded gorge. Features include the "meat" section with a gradient of 165 feet per mile, a 20-foot waterfall (runnable at appropriate flows with proper scouting), slides, ledge drops, and a unique tunnel section. The creek is entirely rain-dependent and flashy—check the USGS gauge (04207200) before heading out, with a minimum of 250 CFS recommended for the meat section and 450–1,000 CFS for the full run. Expert paddlers only. Hazards include strainers, undercut rocks, and the waterfall. Put-in at Broadway Trailhead (Cleveland Metroparks), take-out at Dunham Road bridge near Hemlock Creek Picnic Area.',
    41.3910000, -81.5375000,
    41.3750000, -81.5758000,
    'V',
    4.50,
    '04207200',
    '["steep creek","gorge","waterfall","expert","rain dependent","slides","tunnel","Class V","Cleveland"]',
    NULL,
    1
  );

-- =============================================================
-- Pennsylvania Rivers (from 005_pa_seed_data.sql)
-- =============================================================

-- =============================================================
-- Pennsylvania Rivers (IDs 23–41)
-- =============================================================
INSERT INTO rivers (id, name, state, region, lat, lng, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, description, usgs_site_id, tags, is_runnable) VALUES
  -- 23. Lehigh River — AW: Gorge run through Lehigh Gorge State Park
  (
    23,
    'Lehigh River',
    'Pennsylvania',
    'Lehigh Gorge State Park / Carbon & Luzerne Counties',
    40.9565000, -75.7651000,
    41.0551000, -75.7706000,
    40.8578000, -75.7596000,
    'III',
    21.00,
    'One of Pennsylvania''s premier whitewater rivers and a cornerstone of the Mid-Atlantic paddling scene. The Lehigh flows through the spectacular Lehigh Gorge State Park, offering approximately 21 miles of Class II–III whitewater from White Haven to Jim Thorpe. Dam-controlled releases from the Francis E. Walter Reservoir provide reliable flows from spring through fall, making this one of the most consistently runnable rivers in the region. The gorge features continuous rapids, beautiful fall foliage, and the historic Lehigh Valley Railroad corridor. American Whitewater has been actively involved in the Lehigh River flow advocacy project to ensure recreational releases. The river is extremely popular for commercial rafting, kayaking, and canoeing.',
    '01447800',
    '["gorge","dam release","state park","popular","commercial","fall foliage","Lehigh Valley","American Whitewater","consistent flow"]',
    1
  ),
  -- 24. Loyalsock Creek — AW: Rain-dependent creek through Worlds End State Park
  (
    24,
    'Loyalsock Creek',
    'Pennsylvania',
    'Worlds End State Park / Sullivan County',
    41.4557000, -76.4454000,
    41.4557000, -76.4454000,
    41.4914000, -76.6033000,
    'III',
    13.00,
    'A beautiful and challenging rain-dependent creek flowing through the rugged mountains of Sullivan County near Worlds End State Park. Loyalsock Creek offers approximately 13 miles of Class II–IV whitewater from Hillsgrove to Forksville, with continuous rapids that intensify in high water. The creek is a favorite among Pennsylvania kayakers for its remote, scenic character—flowing through deep hemlock-lined gorges and past dramatic rock formations. Best run during spring snowmelt or after significant rainfall, as the creek rises and falls quickly. The name "Loyalsock" derives from the Lenape word "Lawi-sahquick" meaning "middle creek." Advanced skills recommended at higher flows.',
    '01550000',
    '["rain dependent","creek","state park","scenic","gorge","snowmelt","advanced","Worlds End","remote","Pennsylvania"]',
    NULL
  ),
  -- 25. Pine Creek — AW: Grand Canyon of Pennsylvania
  (
    25,
    'Pine Creek',
    'Pennsylvania',
    'Pine Creek Gorge (PA Grand Canyon) / Tioga State Forest',
    41.6500000, -77.4050000,
    41.7456000, -77.4283000,
    41.5562000, -77.3820000,
    'III',
    17.00,
    'Known as the "Grand Canyon of Pennsylvania," Pine Creek Gorge is one of the most spectacular natural areas in the eastern United States. The gorge stretches 47 miles with walls up to 1,450 feet deep, and the classic paddling run from Ansonia to Blackwell covers approximately 17 miles of Class II–III whitewater through pristine wilderness. Pine Creek is snowmelt and rain-dependent—best run in March through early May when spring flows are highest. The creek features continuous riffles and rapids, excellent primitive camping, and outstanding scenery through old-growth hemlock and hardwood forests. A designated Pennsylvania Scenic River and part of the Pine Creek Rail Trail corridor.',
    '01549760',
    '["Grand Canyon","gorge","wilderness","scenic river","snowmelt","spring","camping","rail trail","Pennsylvania","spectacular"]',
    NULL
  ),
  -- 26. Slippery Rock Creek — AW: Technical gorge through McConnells Mill State Park
  (
    26,
    'Slippery Rock Creek',
    'Pennsylvania',
    'McConnells Mill State Park / Lawrence County',
    40.9568000, -80.1693000,
    40.9568000, -80.1693000,
    40.9122000, -80.1623000,
    'IV',
    6.00,
    'A technical Class II–IV gorge run through the dramatic McConnells Mill State Park in western Pennsylvania. Slippery Rock Creek carves through a deep, boulder-strewn gorge featuring ledges, drops, fast chutes, and tight technical moves. The classic run from Rose Point (US 422 bridge) through the gorge to Harris Bridge covers approximately 6 miles, with a mandatory portage around the historic McConnells Mill gristmill dam. Best run in spring and after heavy fall rains when water levels are up. The gorge is a National Natural Landmark, featuring stunning geology with exposed Homewood Sandstone and ancient glacial features. A favorite run for Pittsburgh-area paddlers.',
    '03106500',
    '["gorge","technical","state park","National Natural Landmark","boulder","glacial","Pittsburgh","spring","Ohio River watershed"]',
    NULL
  ),
  -- 27. Tohickon Creek — AW: Biannual dam release event through Ralph Stover State Park
  (
    27,
    'Tohickon Creek',
    'Pennsylvania',
    'Ralph Stover State Park / Bucks County',
    40.4346000, -75.0977000,
    40.4346000, -75.0977000,
    40.3897000, -75.0581000,
    'IV',
    4.00,
    'A short but action-packed Class III–IV whitewater run through Ralph Stover State Park in Bucks County. Tohickon Creek is famous for its biannual dam releases from Lake Nockamixon—typically the third weekend in March and the first weekend in November—which draw hundreds of paddlers from across the Mid-Atlantic for an intense day of whitewater. The 4-mile run from Ralph Stover State Park to Point Pleasant features steep, boulder-strewn rapids, ledge drops, and the well-known "Race Course" rapid. The highlight is the dramatic High Rocks section where 200-foot cliffs tower above the creek. Outside of dam releases, the creek is only runnable after heavy rainfall. Advanced to expert skills recommended.',
    '01460000',
    '["dam release","event","state park","biannual","High Rocks","technical","Bucks County","Philadelphia area","advanced","boulder"]',
    NULL
  ),
  -- 28. Stonycreek River — AW: Class III–IV Canyon section near Johnstown
  (
    28,
    'Stonycreek River',
    'Pennsylvania',
    'Stonycreek Canyon / Somerset & Cambria Counties',
    40.0325000, -78.9236000,
    40.0325000, -78.9236000,
    40.0744000, -78.9445000,
    'IV',
    4.00,
    'One of Pennsylvania''s premier whitewater runs, the Stonycreek Canyon features approximately 4 miles of continuous Class III–IV rapids through a dramatic gorge near Johnstown. The canyon section from Foustwell to Mostoller/Greenhouse Park includes over 15 named rapids such as Showers, Surf Lab, The Wall, Three Sisters, Scout, Beast, Pipeline, and Hermit. Pipeline rapid is known for its strong hydraulic and should be scouted. Border Dam must be portaged on river left. Water releases from Quemahoning Reservoir help supplement flows, and the annual Stonycreek Rendezvous paddling event draws paddlers from across the region. Best run when the Ferndale gauge reads 3.0–5.0 feet; expert-only above 6.5 feet.',
    '03040000',
    '["canyon","continuous","dam release","event","Johnstown","Pittsburgh area","technical","gorge","Rendezvous","Pennsylvania"]',
    NULL
  ),
  -- 29. Casselman River — AW: Classic spring whitewater, southwestern PA
  (
    29,
    'Casselman River',
    'Pennsylvania',
    'Laurel Highlands / Somerset County',
    39.8597000, -79.2278000,
    39.8597000, -79.2278000,
    39.8900000, -79.3200000,
    'III',
    6.20,
    'A classic southwestern Pennsylvania spring whitewater river flowing through the Laurel Highlands. The popular Markleton to Harnedsville section offers 6.2 miles of continuous Class II–III rapids—an excellent intermediate run. The longer Salisbury to Markleton stretch adds 27 miles of easier Class I–II water upstream. The Casselman is a tributary of the Youghiogheny and is best run during spring snowmelt and after heavy rains. The river features riffles, small ledges, and playful wave trains through scenic rural countryside. A favorite training ground for paddlers before stepping up to the harder Yough sections.',
    '03079000',
    '["spring","Laurel Highlands","intermediate","Youghiogheny tributary","scenic","rural","training run","Pennsylvania"]',
    NULL
  ),
  -- 30. Muddy Creek — AW: Steep gorge run, Class III–IV, York County
  (
    30,
    'Muddy Creek',
    'Pennsylvania',
    'York County / Mason-Dixon Border Region',
    39.7730000, -76.3160000,
    39.7730000, -76.3160000,
    39.7794000, -76.2885000,
    'IV',
    5.00,
    'A hidden gem of southeastern Pennsylvania whitewater, Muddy Creek carves through a beautiful gorge near the Maryland border in York County. The 5-mile run from Paper Mill Road to Cold Cabin Park features mostly Class II–III rapids with the notable "Muddy Falls" gorge section—a Class IV drop that demands scouting or portage. The creek flows through stunning geology with exposed rock walls, wildlife habitat, and a remote feel despite its proximity to Lancaster and York. Snap Falls, a clean 4-foot drop, is another highlight. The run finishes with 1.5 miles of flatwater above the Susquehanna River confluence. Rain-dependent and best run after significant precipitation.',
    '01577500',
    '["gorge","rain dependent","hidden gem","York County","technical","scenic","Susquehanna tributary","southeastern PA","Pennsylvania"]',
    NULL
  ),
  -- 31. Brodhead Creek — AW: Pocono Mountains Class III creek
  (
    31,
    'Brodhead Creek',
    'Pennsylvania',
    'Pocono Mountains / Monroe County',
    41.1918000, -75.2535000,
    41.1918000, -75.2535000,
    41.0681000, -75.2198000,
    'III',
    21.20,
    'A beautiful Pocono Mountains creek offering Class II–III whitewater from Canadensis to the mouth near Stroudsburg. The upper section features the exciting "Miracle Mile" with its initial drop (best run on river left), followed by the "Typewriter" rapid with excellent eddy practice, a big slide with boof options, and the notable "Triple Drop" with retentive holes. The creek flows through lush mountain forest and is best run after heavy rainfall or during spring snowmelt. Cell coverage is spotty; Route 447 parallels much of the run for emergency access. A popular day trip for Philadelphia and New York area paddlers visiting the Poconos.',
    '01440400',
    '["Pocono Mountains","creek","rain dependent","technical","Philadelphia area","New York area","scenic","spring","Pennsylvania"]',
    NULL
  ),
  -- 32. Connoquenessing Creek — AW: Western PA boulder creek
  (
    32,
    'Connoquenessing Creek',
    'Pennsylvania',
    'Lawrence & Butler Counties / Zelienople area',
    40.8520000, -80.2761000,
    40.8520000, -80.2761000,
    40.8641000, -80.2794000,
    'III',
    6.00,
    'A fun and technical Class II–III boulder creek in western Pennsylvania, popular with Pittsburgh-area paddlers. The approximately 6-mile run features volume-dependent play and technical moves through boulder gardens and drops. Difficulty increases significantly at higher water levels, potentially reaching Class IV. Best run in spring and after heavy fall rains when water levels are elevated. The creek is a tributary of the Beaver River and flows through rural Lawrence and Butler Counties. A solid intermediate-to-advanced run that rewards good boat control and reading water.',
    '03106000',
    '["boulder","technical","Pittsburgh area","rain dependent","spring","intermediate","western PA","Pennsylvania"]',
    NULL
  ),
  -- 33. Lackawaxen River — AW: Scenic Class II–III in the Poconos/Wayne County
  (
    33,
    'Lackawaxen River',
    'Pennsylvania',
    'Wayne & Pike Counties / Pocono Region',
    41.4887000, -75.0579000,
    41.4887000, -75.0579000,
    41.4838000, -74.9880000,
    'III',
    5.00,
    'A scenic Class II–III river flowing through the Pocono region of northeastern Pennsylvania. The popular section above the Delaware River confluence near Kimbles covers approximately 5 miles with an average gradient of 15 feet per mile. The Lackawaxen is dam-controlled via releases from Lake Wallenpaupack, which can cause rapid flow changes. The river features Class II–III rapids with small waves, ledges, and playful drops through forested valleys. Named after the Lenape word for "swift waters," the Lackawaxen provides reliable paddling when dam releases are scheduled. A favorite for intermediate paddlers seeking a scenic Pocono experience.',
    '01432110',
    '["Pocono","dam controlled","scenic","Lenape","Delaware tributary","intermediate","Wayne County","Pennsylvania"]',
    NULL
  ),
  -- 34. Meadow Run — AW: Expert steep creek near Ohiopyle
  (
    34,
    'Meadow Run',
    'Pennsylvania',
    'Ohiopyle State Park / Fayette County',
    39.8541000, -79.4975000,
    39.8541000, -79.4975000,
    39.8530000, -79.4950000,
    'V',
    7.00,
    'A challenging Class IV–V steep creek within Ohiopyle State Park, Meadow Run is a favorite among advanced and expert paddlers in the Laurel Highlands region. The run from Route 381 to the confluence with the Youghiogheny River features steep, forested terrain with ledgy drops, slides, and the iconic "Cascades"—a highly technical section that some paddlers choose to portage. Rain-dependent and flashy, the creek rises and falls quickly after storms. When Meadow Run is running, nearby Indian Creek is likely also at good levels. Expert skills, a reliable roll, and proper safety gear are essential. Located within the same park as the famous Lower Yough.',
    '03081600',
    '["steep creek","expert","Ohiopyle","state park","Cascades","rain dependent","Laurel Highlands","Youghiogheny tributary","Pennsylvania"]',
    NULL
  ),
  -- 35. Delaware River (Water Gap) — AW: Scenic Class I–II through National Recreation Area
  (
    35,
    'Delaware River (Water Gap)',
    'Pennsylvania',
    'Delaware Water Gap National Recreation Area / Pike & Monroe Counties',
    41.2264000, -74.8728000,
    41.2264000, -74.8728000,
    41.0110000, -75.1260000,
    'II',
    25.00,
    'The Delaware River through the Delaware Water Gap National Recreation Area offers approximately 25 miles of scenic Class I–II paddling through one of the most beautiful river corridors in the eastern United States. The river features gentle riffles, occasional Class II wave trains at higher flows, and spectacular views of the Water Gap—where the river cuts through the Kittatinny Ridge. Well-maintained NPS access points at Dingmans Ferry, Bushkill, Smithfield Beach, and Eshback make trip planning easy. Optimal flows are when the Montague gauge reads 5–8 feet. Popular for families, multi-day canoe camping trips, and recreational kayaking. A designated National Wild and Scenic River.',
    '01439000',
    '["national recreation area","wild and scenic","scenic","family","camping","Water Gap","NPS","Delaware","beginner friendly","Pennsylvania"]',
    1
  ),
  -- 36. Black Moshannon Creek — AW: Wilderness Class II–III through state forest
  (
    36,
    'Black Moshannon Creek',
    'Pennsylvania',
    'Black Moshannon State Park / Centre County',
    40.9148000, -78.0567000,
    40.9148000, -78.0567000,
    41.0356000, -78.0567000,
    'III',
    17.20,
    'A scenic wilderness Class II–III creek flowing from Black Moshannon State Park through the Moshannon State Forest in Centre County. The 17.2-mile run from the lake outlet to the village of Moshannon features continuous riffles and rapids through wild, remote terrain—one of the most pristine paddling experiences in central Pennsylvania. The tea-colored water (stained by natural tannins from the surrounding bog) gives the creek its distinctive character. Best run in spring or after heavy rain when flows are adequate. The creek winds through dense hemlock and hardwood forest with excellent wildlife viewing. Adjacent to Black Moshannon State Park with camping facilities.',
    '01542400',
    '["wilderness","state park","spring","rain dependent","scenic","tannin water","Centre County","camping","remote","Pennsylvania"]',
    NULL
  ),
  -- 37. Indian Creek — AW: Advanced steep creek near Ohiopyle
  (
    37,
    'Indian Creek',
    'Pennsylvania',
    'Indian Creek Valley / Fayette County',
    39.9681000, -79.5128000,
    39.9681000, -79.5128000,
    39.9700000, -79.5300000,
    'IV',
    4.90,
    'A classic Appalachian steep creek in Fayette County, Indian Creek offers approximately 4.9 miles of Class III–IV(V) whitewater from Route 381 to Camp Carmel. The creek features steep, forested valley terrain with ledgy drops, boulder gardens, and continuous technical action. Located near Ohiopyle and the Youghiogheny River, Indian Creek is a popular step-up run for paddlers looking beyond the Lower Yough. Rain-dependent and flashy—the creek rises quickly after storms and drops fast. Flows can be checked at the USGS Coffman gauge. Strainers and wood are common hazards that change frequently. Advanced to expert skills required.',
    '03082105',
    '["steep creek","advanced","Ohiopyle area","rain dependent","technical","Youghiogheny tributary","Laurel Highlands","Fayette County","Pennsylvania"]',
    NULL
  ),
  -- 38. Wills Creek — AW: Gentle Class I–II in Bedford County
  (
    38,
    'Wills Creek',
    'Pennsylvania',
    'Bedford County / Hyndman area',
    39.8120000, -78.7164000,
    39.8120000, -78.7164000,
    39.7800000, -78.7600000,
    'II',
    10.00,
    'A gentle Class I–II creek flowing through the mountains of Bedford County near Hyndman. Wills Creek offers approximately 10 miles of easy paddling suitable for novice to intermediate paddlers, with mild riffles and gentle rapids through scenic rural countryside. The creek is best run during elevated flows in spring or after rainfall, as it can become shallow in dry weather. A tributary of the Potomac River, Wills Creek provides a peaceful paddling experience in one of Pennsylvania''s less-visited areas. Good for beginners looking for a relaxed introduction to moving water.',
    '01601000',
    '["beginner friendly","gentle","rural","Bedford County","Potomac tributary","scenic","spring","Pennsylvania"]',
    1
  ),
  -- 39. Nesquehoning Creek — AW: Class II–III near Jim Thorpe
  (
    39,
    'Nesquehoning Creek',
    'Pennsylvania',
    'Carbon County / Jim Thorpe area',
    40.8754000, -75.7627000,
    40.8754000, -75.7627000,
    40.8578000, -75.7596000,
    'III',
    5.60,
    'A fun Class II–III creek that flows into the Lehigh River at Jim Thorpe in Carbon County. The 5.6-mile run from the confluence with Broad Run to the mouth at the Lehigh features continuous moderate rapids suitable for intermediate paddlers. Nesquehoning Creek is a great complement to the nearby Lehigh Gorge runs, offering a different character—more intimate and creek-like. Best run after rainfall when water levels are up. The take-out at Jim Thorpe provides easy access to the charming Victorian-era town with restaurants, shops, and outfitters. A good warm-up or alternative when the Lehigh is too crowded.',
    '01448901',
    '["creek","Jim Thorpe","Lehigh tributary","intermediate","rain dependent","Carbon County","convenient","Pennsylvania"]',
    NULL
  ),
  -- 40. Oil Creek — AW: Scenic Class I–II through historic Oil Creek State Park
  (
    40,
    'Oil Creek',
    'Pennsylvania',
    'Oil Creek State Park / Venango & Crawford Counties',
    41.6234000, -79.6731000,
    41.6234000, -79.6731000,
    41.4300000, -79.7100000,
    'II',
    16.00,
    'One of Pennsylvania''s most scenic paddling experiences, Oil Creek flows through the 6,250-acre Oil Creek State Park between Titusville and Oil City. The approximately 16-mile run features Class I–II rapids with gentle riffles, passing through lush forested valleys, historic petroleum-era ghost towns, and the remnants of the world''s first oil industry. Adjacent to the Drake Well Museum—site of the first successful oil well in 1859. Best paddled March through early June when water levels are adequate; minimum 2.75 feet for kayaking, 3.0 feet for canoeing. The park offers camping, the 36-mile Gerard Hiking Trail, and interpretive programs about the region''s unique history.',
    '03020431',
    '["scenic","state park","historic","oil heritage","beginner friendly","family","camping","Drake Well","Titusville","Pennsylvania"]',
    1
  ),
  -- 41. Clarion River — AW: Scenic Class I–II through Cook Forest, National Wild & Scenic
  (
    41,
    'Clarion River',
    'Pennsylvania',
    'Cook Forest State Park / Jefferson & Clarion Counties',
    41.3306000, -79.2092000,
    41.3306000, -79.2092000,
    41.1800000, -79.2400000,
    'II',
    28.00,
    'A beautiful and nationally recognized river flowing through and alongside Cook Forest State Park—home to some of the finest old-growth forest in the eastern United States. The popular Portland Mills to Cooksburg section and beyond offers approximately 28 miles of Class I–II paddling with gentle riffles, small waves, and outstanding scenery. Designated as a National Wild and Scenic River in upstream sections, the Clarion features exceptionally clear water, hemlock and pine-lined banks, and abundant wildlife including bald eagles, river otters, and great blue herons. Ideal for multi-day canoe camping trips, family outings, and recreational kayaking. Well-maintained public access points throughout.',
    '03029500',
    '["wild and scenic","scenic","Cook Forest","old growth","family","camping","multi-day","beginner friendly","wildlife","National Wild and Scenic","Pennsylvania"]',
    1
  );

-- =============================================================
-- Pennsylvania River Sections
-- =============================================================

-- ── Lehigh River sections (river_id=23) ───────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    23,
    'Upper Lehigh Gorge (White Haven to Rockport)',
    'Upper Gorge (White Haven to Rockport)',
    'The upper 9-mile section of the Lehigh Gorge from the White Haven access to Rockport. Features continuous Class II–III rapids with a few more challenging drops at higher flows. The put-in is just below the Francis E. Walter Dam, providing reliable scheduled releases. Beautiful gorge scenery with towering hemlock-covered walls. A popular half-day trip and the more technical of the two gorge sections. Flows of 250–1,000 CFS provide the best paddling conditions.',
    41.0551000, -75.7706000,
    40.9565000, -75.7651000,
    'III',
    9.00,
    '01447800',
    '["gorge","dam release","continuous","popular","half day","Lehigh Valley","Pennsylvania"]',
    1,
    1
  ),
  (
    23,
    'Lower Lehigh Gorge (Rockport to Jim Thorpe)',
    'Lower Gorge (Rockport to Jim Thorpe)',
    'The lower 12.5-mile section from Rockport to Glen Onoko/Jim Thorpe. Slightly easier Class II rapids with more pool-drop character than the Upper Gorge. Spectacular scenery through the deepest part of Lehigh Gorge State Park, passing waterfalls, wildlife, and the remnants of the historic Lehigh Valley Railroad. A full-day trip that can be combined with the Upper Gorge for an epic 21-mile run. The take-out at Glen Onoko is adjacent to the charming town of Jim Thorpe.',
    40.9565000, -75.7651000,
    40.8578000, -75.7596000,
    'II',
    12.50,
    '01447800',
    '["gorge","scenic","historic","full day","Jim Thorpe","pool drop","waterfalls","Pennsylvania"]',
    1,
    2
  );

-- ── Loyalsock Creek section (river_id=24) ─────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    24,
    'Hillsgrove to Forksville',
    'Main Run (Hillsgrove to Forksville)',
    'The classic 13-mile Loyalsock Creek run from the US 220 access near Hillsgrove (adjacent to Worlds End State Park) to Forksville. Features continuous Class II–III rapids with several Class IV drops at higher flows. The creek winds through a deep, scenic gorge lined with hemlock and rhododendron, passing dramatic rock formations and small waterfalls. Water levels change rapidly—check the USGS gauge at Forksville (01550000) before heading out. Minimum runnable flow is approximately 2.5 feet on the gauge; optimal is 3.0–4.5 feet. Creeking skills and a reliable roll are recommended. No open canoes—whitewater kayaks only at higher flows.',
    41.4557000, -76.4454000,
    41.4914000, -76.6033000,
    'III',
    13.00,
    '01550000',
    '["creek","rain dependent","gorge","scenic","continuous","advanced","spring","Worlds End","Pennsylvania"]',
    NULL,
    1
  );

-- ── Pine Creek sections (river_id=25) ─────────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    25,
    'Ansonia to Blackwell (Grand Canyon Run)',
    'Grand Canyon (Ansonia to Blackwell)',
    'The classic 17-mile run through the heart of the PA Grand Canyon, from Big Meadows canoe access at Ansonia to Blackwell. Class II–III rapids with continuous riffles, small waves, and occasional bigger drops. The gorge walls rise up to 1,450 feet on both sides, creating one of the most dramatic paddling landscapes in the eastern US. Best run in March through early May when spring snowmelt provides adequate flows. Check the USGS gauge at Cedar Run (01549760)—ideal flows are 2.0–3.5 feet. Primitive camping is available at Tiadaghton and other forest campgrounds along the route. A PA Fish & Boat Commission launch permit is required.',
    41.7456000, -77.4283000,
    41.5562000, -77.3820000,
    'III',
    17.00,
    '01549760',
    '["Grand Canyon","gorge","wilderness","spring","camping","scenic","permit required","water trail","Pennsylvania"]',
    NULL,
    1
  );

-- ── Slippery Rock Creek sections (river_id=26) ────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    26,
    'McConnells Mill Gorge (Rose Point to Eckert Bridge)',
    'Upper Gorge (Rose Point to Eckert Bridge)',
    'The premier 2.5-mile gorge section from Rose Point (US 422 bridge) through the heart of McConnells Mill State Park to Eckert Bridge. Features Class III–IV rapids with boulder gardens, ledges, and tight technical moves through a stunning National Natural Landmark gorge. Mandatory portage around the historic McConnells Mill gristmill dam—it is illegal and dangerous to run the dam. Best at moderate flows; at high water, rapids become pushy and more consequential. The gorge features dramatic exposed Homewood Sandstone walls and glacial erratics. Short but intense—most paddlers lap this section multiple times.',
    40.9568000, -80.1693000,
    40.9350000, -80.1695000,
    'IV',
    2.50,
    '03106500',
    '["gorge","technical","boulder","dam portage","National Natural Landmark","short run","Pittsburgh","Pennsylvania"]',
    NULL,
    1
  ),
  (
    26,
    'Eckert Bridge to Harris Bridge',
    'Lower (Eckert Bridge to Harris Bridge)',
    'A 3.5-mile extension below the main gorge from Eckert Bridge to Harris Bridge. Slightly easier Class II–III water with a more relaxed gradient, though still featuring technical boulder gardens and scenic gorge scenery. A good warm-up or cool-down complement to the upper gorge section. Can be combined with the upper section for a full 6-mile run.',
    40.9350000, -80.1695000,
    40.9122000, -80.1623000,
    'III',
    3.50,
    '03106500',
    '["gorge","scenic","intermediate","boulder","extension","Pennsylvania"]',
    NULL,
    2
  );

-- ── Tohickon Creek section (river_id=27) ──────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    27,
    'Ralph Stover to Point Pleasant',
    'Dam Release Run (Ralph Stover to Point Pleasant)',
    'The classic 4-mile Tohickon Creek run from Ralph Stover State Park to Point Pleasant, near the confluence with the Delaware River. Features steep, boulder-strewn Class III–IV rapids, ledge drops, and the well-known "Race Course" rapid through a dramatic gorge. The highlight is the High Rocks section where 200-foot cliffs tower above the creek. Primarily paddled during biannual dam releases from Lake Nockamixon (third weekend in March, first weekend in November), which bring flows to approximately 800 CFS—ideal for exciting whitewater. Expect crowds during release weekends as this is a major Mid-Atlantic paddling event. A $10 parking fee at the take-out supports local emergency services. Advanced to expert skills required; helmets, PFDs, and cold-water gear are mandatory.',
    40.4346000, -75.0977000,
    40.3897000, -75.0581000,
    'IV',
    4.00,
    '01460000',
    '["dam release","event","High Rocks","gorge","technical","biannual","advanced","Bucks County","Philadelphia area","Pennsylvania"]',
    NULL,
    1
  );

-- ── Stonycreek River sections (river_id=28) ───────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    28,
    'Stonycreek Canyon (Foustwell to Greenhouse Park)',
    'Canyon (Foustwell to Greenhouse Park)',
    'The premier whitewater section of the Stonycreek—approximately 4 miles of continuous Class III–IV rapids through a dramatic canyon. Features over 15 named rapids including Showers, Surf Lab, The Wall, Three Sisters, Scout, Beast, Pipeline, and Hermit. Pipeline rapid has a strong hydraulic and should be scouted by all paddlers. Border Dam must be portaged on river left—it is dangerous to run. Best when the Ferndale gauge (USGS 03040000) reads 3.0–5.0 feet; at 4.5+ feet the run becomes significantly more challenging, and expert-only above 6.5 feet. The Stonycreek Rendezvous paddling event held here draws paddlers from across the Mid-Atlantic annually.',
    40.0325000, -78.9236000,
    40.0744000, -78.9445000,
    'IV',
    4.00,
    '03040000',
    '["canyon","continuous","technical","event","Rendezvous","dam portage","Johnstown","Pennsylvania"]',
    NULL,
    1
  );

-- ── Casselman River sections (river_id=29) ────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    29,
    'Markleton to Harnedsville',
    'Whitewater Section (Markleton to Harnedsville)',
    'The classic intermediate whitewater section of the Casselman River—6.2 miles of continuous Class II–III rapids from the Markleton bridge to Harnedsville. Features riffles, small ledges, and playful wave trains through scenic Laurel Highlands countryside. Best run during spring snowmelt or after heavy rains. The USGS gauge at Markleton (03079000) provides real-time flow data. A great training run for paddlers preparing for harder sections of the nearby Youghiogheny. Shuttle logistics are straightforward with road access at both ends.',
    39.8597000, -79.2278000,
    39.8900000, -79.3200000,
    'III',
    6.20,
    '03079000',
    '["spring","intermediate","Laurel Highlands","training run","continuous","wave trains","Pennsylvania"]',
    NULL,
    1
  ),
  (
    29,
    'Salisbury to Markleton',
    'Upper (Salisbury to Markleton)',
    'A long, gentle 27-mile Class I–II section of the Casselman from Salisbury to Markleton. Ideal for multi-day canoe trips, family outings, and beginner paddlers looking for a relaxed float through rural Somerset County. Features gentle riffles, deep pools, and beautiful pastoral scenery. Can be broken into shorter segments using intermediate access points. Best in spring when flows are adequate.',
    39.7500000, -79.0800000,
    39.8597000, -79.2278000,
    'II',
    27.10,
    '03079000',
    '["beginner","family","multi-day","rural","gentle","canoe","scenic","Pennsylvania"]',
    1,
    2
  );

-- ── Muddy Creek section (river_id=30) ─────────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    30,
    'Paper Mill Road to Cold Cabin Park',
    'Gorge Run (Paper Mill to Cold Cabin)',
    'The classic 5-mile Muddy Creek run from Paper Mill Road bridge to Cold Cabin Park/Susquehanna confluence. Features mostly Class II–III rapids with the notable "Muddy Falls" gorge section (Class IV—scout or portage) and Snap Falls, a clean 4-foot drop. The run finishes with 1.5 miles of flatwater above the Susquehanna River—save energy for the wind-exposed paddle at the end. Limited parking at the Paper Mill Road put-in; porta-potty available at Cold Cabin Road take-out. Check the USGS gauge at Castle Fin (01577500) for runnable flows. Rain-dependent—only runnable after significant precipitation.',
    39.7730000, -76.3160000,
    39.7794000, -76.2885000,
    'IV',
    5.00,
    '01577500',
    '["gorge","rain dependent","Muddy Falls","Snap Falls","York County","Susquehanna tributary","technical","Pennsylvania"]',
    NULL,
    1
  );

-- ── Brodhead Creek section (river_id=31) ──────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    31,
    'Canadensis to Analomink',
    'Upper (Canadensis to Analomink)',
    'The upper section of Brodhead Creek from Canadensis to near Analomink—approximately 12 miles of Class II–III whitewater through the Pocono Mountains. Features the exciting "Miracle Mile" opening section, the "Typewriter" rapid with excellent eddy practice, a big slide with boof options, and the notable "Triple Drop" with retentive holes that should be scouted. Route 447 parallels much of the run for emergency access, though cell coverage is spotty. Best after heavy rain or during spring snowmelt. Check the USGS gauge at Analomink (01440400) for optimal flows of 2–6 feet.',
    41.1918000, -75.2535000,
    41.0681000, -75.2198000,
    'III',
    12.00,
    '01440400',
    '["Pocono Mountains","creek","technical","Miracle Mile","Triple Drop","rain dependent","spring","Pennsylvania"]',
    NULL,
    1
  );

-- ── Connoquenessing Creek section (river_id=32) ───────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    32,
    'Calgon to Treatment Plant',
    'Main Run (Calgon to Treatment Plant)',
    'The most popular whitewater section of Connoquenessing Creek—approximately 6 miles of Class II–III boulder play from near Calgon to the 2nd Treatment Plant area. Features fun volume-dependent play and technical moves through boulder gardens at moderate to high flows. Difficulty increases at higher water, potentially reaching Class IV. Best run in spring and after heavy fall rains. Check the USGS gauge near Zelienople (03106000) for current conditions. A solid intermediate run popular with Pittsburgh-area paddlers.',
    40.8520000, -80.2761000,
    40.8641000, -80.2794000,
    'III',
    6.00,
    '03106000',
    '["boulder","intermediate","Pittsburgh area","spring","rain dependent","volume","Pennsylvania"]',
    NULL,
    1
  );

-- ── Lackawaxen River section (river_id=33) ────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    33,
    'Above Delaware Confluence (Kimbles)',
    'Main Run (Above Delaware Confluence)',
    'The popular 5-mile section of the Lackawaxen above its confluence with the Delaware River near Kimbles. Features Class II–III rapids with an average gradient of 15 feet per mile, small waves, ledges, and playful drops through forested Pocono valleys. Optimum flows are 800–2,000 CFS at the Rowland gauge (USGS 01432110). The river is dam-controlled via releases from Lake Wallenpaupack, so flows can change rapidly. A scenic and accessible intermediate run in the heart of the Pocono region.',
    41.4887000, -75.0579000,
    41.4838000, -74.9880000,
    'III',
    5.00,
    '01432110',
    '["Pocono","dam controlled","intermediate","Delaware tributary","scenic","Kimbles","Pennsylvania"]',
    NULL,
    1
  );

-- ── Meadow Run section (river_id=34) ──────────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    34,
    'Route 381 to Youghiogheny Confluence',
    'Steep Creek Run (Rt 381 to Yough)',
    'The full Meadow Run steep creek run from the Route 381 bridge to the confluence with the Youghiogheny River in Ohiopyle State Park. Approximately 7 miles of intense Class IV–V(+) whitewater featuring slides, ledge drops, and the iconic "Cascades"—a highly technical section that many paddlers choose to scout or portage. The creek is entirely rain-dependent and flashy, rising and falling quickly after storms. Check the USGS gauge at Ohiopyle (03081600) before heading out. When Meadow Run is running, nearby Indian Creek is likely also at good levels. Expert skills, a reliable roll, and proper safety gear are mandatory.',
    39.8541000, -79.4975000,
    39.8530000, -79.4950000,
    'V',
    7.00,
    '03081600',
    '["steep creek","expert","Cascades","Ohiopyle","rain dependent","state park","Laurel Highlands","Pennsylvania"]',
    NULL,
    1
  );

-- ── Delaware River (Water Gap) section (river_id=35) ──────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    35,
    'Dingmans Ferry to Bushkill',
    'Upper Water Gap (Dingmans to Bushkill)',
    'A scenic 12-mile section of the Delaware River through the upper portion of the Delaware Water Gap National Recreation Area. Gentle Class I–II water with occasional swift chutes and wave trains at higher flows. Well-maintained NPS access at both Dingmans Ferry and Bushkill. Optimal paddling when the Montague gauge reads 5–8 feet. Outstanding scenery with forested hillsides, wildlife, and the dramatic Water Gap cliffs in the distance. Perfect for families, beginners, and multi-day camping trips.',
    41.2264000, -74.8728000,
    41.1140000, -74.9850000,
    'II',
    12.00,
    '01439000',
    '["national recreation area","NPS","family","scenic","camping","beginner","Delaware","Pennsylvania"]',
    1,
    1
  ),
  (
    35,
    'Bushkill to Water Gap',
    'Lower Water Gap (Bushkill to Gap)',
    'The lower 13-mile section through the most dramatic part of the Delaware Water Gap, where the river cuts through Kittatinny Ridge. Class I–II rapids with more defined wave trains and riffles than the upper section, especially at higher flows. Spectacular scenery including the iconic Water Gap views, exposed cliff faces, and diverse wildlife. Access at Bushkill, Smithfield Beach, and Eshback. A classic paddle that can be combined with the upper section for a full 25-mile trip.',
    41.1140000, -74.9850000,
    41.0110000, -75.1260000,
    'II',
    13.00,
    '01439000',
    '["Water Gap","scenic","National Recreation Area","Kittatinny Ridge","family","wildlife","Pennsylvania"]',
    1,
    2
  );

-- ── Black Moshannon Creek section (river_id=36) ───────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    36,
    'Black Moshannon State Park to Moshannon',
    'Full Run (State Park to Moshannon)',
    'The full 17.2-mile run from the outlet of Black Moshannon Lake in Black Moshannon State Park to the village of Moshannon. Features continuous Class II–III rapids through pristine wilderness with the creek''s distinctive tea-colored, tannin-stained water. Dense hemlock and hardwood forest lines both banks, providing a remote, wild feel despite relative accessibility. Best run in spring or after heavy rain. Check the USGS gauge at Moshannon (01542400) for flow conditions. Camping available at Black Moshannon State Park. A true wilderness paddling gem in central Pennsylvania.',
    40.9148000, -78.0567000,
    41.0356000, -78.0567000,
    'III',
    17.20,
    '01542400',
    '["wilderness","state park","tannin water","spring","rain dependent","camping","Centre County","scenic","Pennsylvania"]',
    NULL,
    1
  );

-- ── Indian Creek section (river_id=37) ────────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    37,
    'Route 381 to Camp Carmel',
    'Main Run (Rt 381 to Camp Carmel)',
    'The classic 4.9-mile Indian Creek run from Route 381 to Camp Carmel near the Youghiogheny River confluence. Features steep, forested valley terrain with Class III–IV(V) rapids including ledgy drops, boulder gardens, and continuous technical action through an Appalachian gorge. Rain-dependent and flashy—check the USGS Coffman gauge (03082105) before heading out. Strainers and wood are common hazards that change frequently with storms. A popular advanced/expert run for Ohiopyle-area paddlers looking for a step up from the Lower Yough.',
    39.9681000, -79.5128000,
    39.9700000, -79.5300000,
    'IV',
    4.90,
    '03082105',
    '["steep creek","advanced","Ohiopyle area","rain dependent","technical","boulder","Youghiogheny tributary","Pennsylvania"]',
    NULL,
    1
  );

-- ── Wills Creek section (river_id=38) ─────────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    38,
    'Hyndman Area Float',
    'Main Run (Hyndman area)',
    'An approximately 10-mile Class I–II float through the mountains of Bedford County near Hyndman. Gentle riffles and mild rapids through scenic rural countryside, ideal for beginners, families, and canoeists. The creek can become shallow in dry weather; best run in spring or after rainfall. USGS gauge at Hyndman (01601000) provides flow data. A relaxed introduction to moving water in one of Pennsylvania''s quieter paddling destinations.',
    39.8120000, -78.7164000,
    39.7800000, -78.7600000,
    'II',
    10.00,
    '01601000',
    '["beginner","family","gentle","rural","Bedford County","scenic","spring","Pennsylvania"]',
    1,
    1
  );

-- ── Nesquehoning Creek section (river_id=39) ──────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    39,
    'Broad Run Confluence to Lehigh River',
    'Main Run (Broad Run to Lehigh)',
    'The 5.6-mile Nesquehoning Creek run from the confluence with Broad Run to the mouth at the Lehigh River in Jim Thorpe. Features continuous Class II–III rapids through a scenic Carbon County valley. A great complement to the nearby Lehigh Gorge runs, offering a more intimate creek-like experience. Best after rainfall when water levels are up. The take-out at Jim Thorpe provides easy access to restaurants, shops, and the Lehigh Gorge outfitters. Check the USGS gauge at Jim Thorpe (01448901) for flow conditions.',
    40.8754000, -75.7627000,
    40.8578000, -75.7596000,
    'III',
    5.60,
    '01448901',
    '["creek","Jim Thorpe","Lehigh tributary","intermediate","rain dependent","Carbon County","Pennsylvania"]',
    NULL,
    1
  );

-- ── Oil Creek section (river_id=40) ───────────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    40,
    'Titusville to Oil City',
    'State Park Run (Titusville to Oil City)',
    'The full 16-mile scenic paddle through Oil Creek State Park from Titusville to Oil City. Features Class I–II rapids with gentle riffles, passing through lush forested valleys, historic petroleum-era ghost towns, and the remnants of the world''s first oil industry. Adjacent to the Drake Well Museum. Best paddled March through early June; minimum 2.75 feet for kayaking, 3.0 feet for canoeing on the USGS gauge at Titusville (03020431). The park offers camping, the Gerard Hiking Trail, and interpretive programs. One of the most scenic and historically significant paddles in Pennsylvania.',
    41.6234000, -79.6731000,
    41.4300000, -79.7100000,
    'II',
    16.00,
    '03020431',
    '["scenic","state park","historic","oil heritage","beginner friendly","Drake Well","Titusville","family","Pennsylvania"]',
    1,
    1
  );

-- ── Clarion River section (river_id=41) ───────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    41,
    'Portland Mills to Cooksburg (Cook Forest)',
    'Middle Clarion (Portland Mills to Cooksburg)',
    'The most popular section of the Clarion River—approximately 15 miles of Class I–II paddling from Portland Mills through Cook Forest State Park to Cooksburg. Features gentle riffles, small waves, and outstanding scenery through one of the finest old-growth forests in the eastern United States. The river''s exceptionally clear water, hemlock and pine-lined banks, and abundant wildlife (bald eagles, river otters, great blue herons) make this one of the premier scenic paddles in Pennsylvania. Well-maintained public launches at Portland Mills, Clear Creek, Cook Forest, and Cooksburg. Check the USGS gauge at Cooksburg (03029500) for optimal flows.',
    41.2050000, -79.2350000,
    41.3306000, -79.2092000,
    'II',
    15.00,
    '03029500',
    '["scenic","Cook Forest","old growth","family","wildlife","Wild and Scenic","beginner friendly","Pennsylvania"]',
    1,
    1
  ),
  (
    41,
    'Cooksburg to Clarion',
    'Lower Clarion (Cooksburg to Clarion)',
    'A scenic 13-mile extension of the Clarion River from Cooksburg downstream toward the town of Clarion. Class I with occasional Class II riffles—even gentler than the upper section. Beautiful rural scenery with farmland, forests, and the river''s characteristic clear water. Excellent for multi-day canoe camping trips and extended family outings. Can be combined with the Portland Mills to Cooksburg section for a full 28-mile experience.',
    41.3306000, -79.2092000,
    41.1800000, -79.2400000,
    'I',
    13.00,
    '03029500',
    '["scenic","gentle","family","multi-day","camping","canoe","rural","clear water","Pennsylvania"]',
    1,
    2
  );

-- =============================================================
-- Maryland Rivers (from 006_md_seed_data.sql)
-- =============================================================

-- =============================================================
-- Maryland Rivers (IDs 42–52)
-- =============================================================
INSERT INTO rivers (id, name, state, region, lat, lng, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, description, usgs_site_id, tags, is_runnable) VALUES
  -- 42. Savage River — AW: Dam-release Class III–IV, 1989 World Championships
  (
    42,
    'Savage River',
    'Maryland',
    'Garrett County / Savage River State Forest',
    39.5075000, -79.1344000,
    39.5075000, -79.1344000,
    39.4618000, -79.1577000,
    'IV',
    5.00,
    'One of Maryland''s premier whitewater runs and a nationally significant river that hosted the 1989 ICF Canoe Slalom World Championships. The Savage features approximately 5 miles of continuous Class III–IV rapids from below the Savage River Dam to the Savage River Road bridge. The river is dam-release dependent—scheduled recreational releases from Savage River Reservoir provide reliable flows for paddling, typically coordinated by the Upper Potomac River Commission and the Army Corps of Engineers. The run is technical and continuous with powerful hydraulics, tight boulder gardens, and several notable drops. Popular with intermediate-to-advanced kayakers seeking a challenging but manageable step up from Class III water. The surrounding Savage River State Forest provides stunning scenery, especially during fall foliage season.',
    '03076000',
    '["dam release","world championships","continuous","technical","state forest","fall foliage","Garrett County","advanced","Maryland"]',
    NULL
  ),
  -- 43. Potomac River (Great Falls) — AW: Class II–V at Great Falls and Mather Gorge
  (
    43,
    'Potomac River (Great Falls)',
    'Maryland',
    'Great Falls / Mather Gorge / Montgomery County',
    38.9957000, -77.2530000,
    39.0000000, -77.2500000,
    38.9650000, -77.2400000,
    'V',
    6.50,
    'One of the most iconic whitewater destinations in the eastern United States, located just minutes from Washington, DC. The Potomac at Great Falls features the dramatic Maryland Lines—a series of Class V to V+ drops as the river plunges approximately 38 feet through narrow, constricted channels. Below the falls, Mather Gorge offers Class II–III (up to IV at higher flows) rapids through a spectacular, cliff-lined corridor. The Maryland Lines are expert-only and should only be run by highly experienced paddlers with local knowledge—multiple fatalities have occurred here. Mather Gorge and the sections below are popular with intermediate-to-advanced paddlers. Key rapids include O-Deck, Fishladder, and S-Turn. American Whitewater monitors flows via the Little Falls Pump Station gauge. The surrounding Great Falls Park provides hiking trails and world-class views of the falls.',
    '01646500',
    '["Great Falls","expert","Class V","Mather Gorge","DC area","national park","iconic","dangerous","scenic","Maryland"]',
    1
  ),
  -- 44. North Branch Potomac River — AW: Dam-release Class II–III, Barnum to Bloomington
  (
    44,
    'North Branch Potomac River',
    'Maryland',
    'Garrett & Allegany Counties / Jennings Randolph Lake',
    39.4700000, -79.0800000,
    39.4300000, -79.0500000,
    39.5100000, -79.0600000,
    'III',
    6.50,
    'A classic dam-release whitewater run in western Maryland, flowing from below Jennings Randolph Lake (Bloomington Dam) through a scenic mountain valley. The popular Barnum to Bloomington section offers approximately 6.5 miles of continuous Class II–III rapids with fun wave trains, boulder gardens, and playful drops. Dam releases are coordinated for recreational whitewater, primarily in late spring and summer, making this one of the most reliably runnable rivers in the region during release season. The longer Kitzmiller section above Barnum features more challenging Class III–V water for advanced paddlers. Commercial rafting trips are available through local outfitters. The river corridor is surrounded by beautiful Appalachian mountain scenery.',
    '01595500',
    '["dam release","Appalachian","intermediate","commercial","Kitzmiller","Barnum","Bloomington","scenic","western Maryland","Maryland"]',
    NULL
  ),
  -- 45. Gunpowder Falls — AW: Baltimore-area Class I–III creek
  (
    45,
    'Gunpowder Falls',
    'Maryland',
    'Baltimore & Harford Counties / Gunpowder Falls State Park',
    39.5497000, -76.6361000,
    39.5700000, -76.6500000,
    39.5200000, -76.6200000,
    'III',
    12.00,
    'The most popular whitewater run in the Baltimore metropolitan area, flowing through Gunpowder Falls State Park. The river offers approximately 12 miles of Class I–III whitewater from the Hereford area to Monkton. The most exciting stretch is between Falls Road and York Road, featuring continuous Class II–III rapids with small ledges, boulder gardens, and playful wave trains. Below Prettyboy Dam, the river is cold and clear year-round due to bottom-release flows. The Gunpowder is rain-dependent below the dam for optimal whitewater levels, though the tailwater section maintains base flows. Extremely popular with local paddlers—the proximity to Baltimore makes this a quick after-work run. American Whitewater monitors flows via the Glencoe gauge.',
    '01582500',
    '["Baltimore","state park","after-work run","cold water","dam tailwater","popular","suburban","rain dependent","Maryland"]',
    NULL
  ),
  -- 46. Antietam Creek — AW: Scenic Class I–II through Civil War battlefield
  (
    46,
    'Antietam Creek',
    'Maryland',
    'Washington County / Antietam National Battlefield',
    39.4570000, -77.7300000,
    39.4900000, -77.7500000,
    39.4200000, -77.7100000,
    'II',
    7.90,
    'A scenic and historic Class I–II creek flowing through Washington County and past the famous Antietam National Battlefield. The popular 7.9-mile section from Devil''s Backbone Park (MD 68) to MD 34 features gentle rapids, riffles, and moving water through pastoral farmland and wooded corridors. The route passes under Burnside Bridge—a pivotal Civil War landmark from the Battle of Antietam. Suitable for practiced novice and intermediate paddlers, though fallen trees (strainers) require constant vigilance. Antietam Creek is spring-fed, holding water longer than many local streams and is among the first to thaw in spring. Check the USGS gauge near Sharpsburg for recommended flows of 2.5 feet minimum; optimal paddling at 3.0+ feet.',
    '01619500',
    '["historic","Civil War","scenic","Burnside Bridge","beginner friendly","spring fed","pastoral","family","Sharpsburg","Maryland"]',
    1
  ),
  -- 47. Bear Creek — AW: Technical Class IV creek near Friendsville
  (
    47,
    'Bear Creek',
    'Maryland',
    'Garrett County / Friendsville area',
    39.6561000, -79.3942000,
    39.6800000, -79.4200000,
    39.6561000, -79.3942000,
    'IV',
    7.00,
    'A challenging Class IV creek in Garrett County that flows into the Youghiogheny River at Friendsville—one of Maryland''s premier whitewater destinations. The approximately 7-mile run from US 219 to the Youghiogheny confluence features continuous action with numerous rapids, technical moves, and powerful water features. Bear Creek is a favorite among advanced paddlers who often combine it with runs on the nearby Upper Yough or Savage River for a full weekend of western Maryland whitewater. The creek is rain-dependent and rises quickly after storms, providing a flashy but exciting ride through scenic Garrett County forest. Check the USGS gauge at Friendsville for current flow conditions.',
    '03076600',
    '["advanced","technical","Friendsville","Youghiogheny tributary","rain dependent","Garrett County","steep creek","western Maryland","Maryland"]',
    NULL
  ),
  -- 48. Patapsco River — AW: Central Maryland Class I–III through state park
  (
    48,
    'Patapsco River',
    'Maryland',
    'Patapsco Valley State Park / Howard & Baltimore Counties',
    39.3313000, -76.8710000,
    39.3313000, -76.8710000,
    39.2174000, -76.7056000,
    'III',
    17.50,
    'A popular central Maryland river flowing through Patapsco Valley State Park between Woodstock and Ellicott City. The approximately 17.5-mile run offers Class I–III whitewater with a mix of easy riffles and moderate rapids through a scenic valley. The most exciting whitewater stretch runs from Woodstock Road to Daniels, covering about 4.7 miles of continuous fun rapids at higher flows. The river passes through lush forest, historic mill ruins, and the picturesque Patapsco Valley. Note: Bloede Dam was removed in 2019, improving safety and fish passage, but flash floods in recent years have altered rapid character—always scout after major flood events. The Doughnut Rapid near Ellicott City is a notable feature. Very accessible from Baltimore and the DC suburbs.',
    '01586000',
    '["state park","Baltimore","DC suburbs","accessible","Ellicott City","scenic","historic","intermediate","rain dependent","Maryland"]',
    NULL
  ),
  -- 49. Deer Creek — AW: Class I–III through Rocks State Park
  (
    49,
    'Deer Creek',
    'Maryland',
    'Harford County / Rocks State Park',
    39.6382000, -76.3964000,
    39.6660000, -76.4342000,
    39.6100000, -76.3700000,
    'III',
    43.50,
    'A long and scenic Class I–III creek flowing through Harford County and the dramatic Rocks State Park—home to the iconic King and Queen Seat rock formation towering 190 feet above the creek. The full run from Bond Road to the Susquehanna River covers 43.5 miles, but the most popular whitewater section runs from Eden Mill Park to Rocks State Park, offering approximately 7 miles of Class II rapids with some Class III drops at higher water. The creek features a mix of riffles, ledges, and boulder gardens through wooded gorge scenery. Caution: there is a fall-line chute with a significant drop just downstream of the typical take-out—avoid if not experienced. A low-head dam upstream from Route 161 should be portaged. Best run after rainfall or during spring.',
    '01580000',
    '["state park","Rocks","King and Queen Seat","scenic","gorge","rain dependent","ledges","Harford County","Susquehanna","Maryland"]',
    NULL
  ),
  -- 50. Sideling Hill Creek — AW: Steep Class III–IV creek, Washington County
  (
    50,
    'Sideling Hill Creek',
    'Maryland',
    'Washington County / Appalachian Ridge',
    39.6497000, -78.3441000,
    39.6800000, -78.3600000,
    39.6497000, -78.3441000,
    'IV',
    8.00,
    'A challenging steep creek in the Appalachian Ridge region of Washington County, offering approximately 8 miles of Class III–IV whitewater for advanced paddlers. Sideling Hill Creek features technical rapids with drops, tight boulder moves, and swift currents through a remote, wooded gorge. The creek is highly rain-dependent and flashy—rising and falling quickly after storms. When running, it provides an exciting and committing steep-creek experience in western Maryland. The USGS gauge near Bellegrove (01610155) provides real-time flow data. Scout all major rapids and be prepared for wood hazards that change frequently with storms. A hidden gem for experienced creek boaters.',
    '01610155',
    '["steep creek","advanced","technical","rain dependent","remote","gorge","Appalachian","Washington County","hidden gem","Maryland"]',
    NULL
  ),
  -- 51. Crabtree Creek — AW: Class III–IV steep run in Garrett County
  (
    51,
    'Crabtree Creek',
    'Maryland',
    'Garrett County / Savage River State Forest',
    39.5200000, -79.1700000,
    39.5400000, -79.1900000,
    39.5075000, -79.1344000,
    'IV',
    6.00,
    'A challenging Class III–IV+ steep creek run in Garrett County flowing from near Swanton to the Savage River Reservoir. Approximately 6 miles of continuous, technical whitewater through the forested mountains of western Maryland. Crabtree Creek is a tributary of the Savage River and offers a similar character—tight, technical rapids with boulder gardens, ledges, and drops. The creek is highly rain-dependent and only runnable after significant precipitation. When it''s up, Crabtree provides one of the best steep-creek experiences in Maryland. Often paddled in combination with the nearby Savage River when both are running. Advanced to expert skills required. The surrounding Savage River State Forest is stunning, particularly in fall.',
    '03076000',
    '["steep creek","advanced","technical","rain dependent","Garrett County","Savage tributary","state forest","fall foliage","expert","Maryland"]',
    NULL
  ),
  -- 52. Monocacy River — AW: Scenic Class I–II water trail near Frederick
  (
    52,
    'Monocacy River',
    'Maryland',
    'Frederick County / Monocacy Scenic Water Trail',
    39.3600000, -77.3900000,
    39.4100000, -77.4100000,
    39.3100000, -77.3700000,
    'II',
    30.00,
    'The largest Maryland tributary of the Potomac River, offering approximately 30 miles of scenic Class I–II paddling along the established Monocacy Scenic Water Trail near Frederick. The river is divided into three principal sections: Rocky Ridge to Devilbiss (remote, calm), Devilbiss to Gambrill Mill (accessible, moving water), and Gambrill Mill to the Monocacy Boat Ramp (gentle current). The only significant whitewater is Greenfield Rapid between Buckeystown Park and Park Mills Road—a fun Class II rapid with small drops, boulders, and bedrock outcroppings. At higher flows (5+ feet at the Buckeystown gauge), the rapids become more exciting. Ideal for beginners, families, and those seeking scenic floats through pastoral Frederick County farmland. The water trail passes near the Monocacy National Battlefield, another Civil War site.',
    '01643000',
    '["water trail","scenic","beginner friendly","family","Frederick","pastoral","Civil War","Monocacy Battlefield","gentle","Maryland"]',
    1
  );

-- =============================================================
-- Maryland River Sections
-- =============================================================

-- ── Savage River sections (river_id=42) ───────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    42,
    'Savage River Dam to Savage River Road Bridge',
    'Main Run (Dam to Road Bridge)',
    'The classic 5-mile Savage River run from below the dam to the Savage River Road bridge. Continuous Class III–IV rapids through a forested gorge. The river hosted the 1989 ICF Canoe Slalom World Championships, cementing its reputation as one of the East''s finest whitewater runs. Dam releases from Savage River Reservoir provide scheduled flows—check release schedules from the Upper Potomac River Commission before planning your trip. The run features tight boulder gardens, powerful hydraulics, and several must-scout rapids. Intermediate-to-advanced skills required; at higher release flows, the run becomes significantly more challenging.',
    39.5075000, -79.1344000,
    39.4618000, -79.1577000,
    'IV',
    5.00,
    '03076000',
    '["dam release","world championships","continuous","gorge","technical","advanced","Garrett County","Maryland"]',
    NULL,
    1
  );

-- ── Potomac River (Great Falls) sections (river_id=43) ────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    43,
    'Great Falls – Maryland Lines',
    'Maryland Lines (Class V)',
    'The legendary Maryland Lines at Great Falls of the Potomac—expert-only Class V to V+ whitewater where the river drops approximately 38 feet through narrow, constricted channels over less than a mile. The lines begin at the diversion dam and end just below the Fish Ladder. Hazards include powerful hydraulics, sieves, undercuts, and the risk of entrapment. Multiple fatalities have occurred here. Only run by highly experienced Class V paddlers with detailed local knowledge. Scout extensively before attempting. Best run at 2.0–3.4 feet on the AW gauge (approximately 2,850 CFS at 3.0 feet). Above optimal flows, the consequences become extreme.',
    39.0000000, -77.2500000,
    38.9900000, -77.2480000,
    'V+',
    0.90,
    '01646500',
    '["Great Falls","expert only","Class V","dangerous","iconic","DC area","Maryland Lines","Maryland"]',
    1,
    1
  ),
  (
    43,
    'Mather Gorge',
    'Mather Gorge (Below Great Falls)',
    'The spectacular Mather Gorge section immediately below Great Falls, offering 2–6.5 miles of Class II–III (up to IV at higher flows) rapids through a dramatic cliff-lined corridor. Key rapids include O-Deck, Fishladder, and S-Turn. Suitable for intermediate-to-advanced paddlers, with the difficulty increasing significantly at higher water levels. The gorge is extremely scenic with towering rock walls on both sides. Popular take-outs include Angler''s Inn and Lock 10 on the C&O Canal towpath. Runnable from about 2.0 to 7.0+ feet on the Little Falls gauge. A favorite after-work destination for DC-area paddlers.',
    38.9900000, -77.2480000,
    38.9650000, -77.2400000,
    'III',
    6.50,
    '01646500',
    '["Mather Gorge","scenic","cliffs","intermediate","DC area","after-work","C&O Canal","Maryland"]',
    1,
    2
  );

-- ── North Branch Potomac sections (river_id=44) ──────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    44,
    'Barnum to Bloomington (Dam Release)',
    'Barnum to Bloomington (Class II–III)',
    'The classic 6.5-mile dam-release section of the North Branch Potomac from Barnum (WV) to Bloomington (MD). Continuous Class II–III rapids with fun wave trains, boulder gardens, and playful drops through a scenic mountain valley. Dam releases from Jennings Randolph Lake are scheduled for recreational whitewater, typically in late spring and summer. Check the USGS Kitzmiller gauge (01595500) for flow information—800 to 1,500 CFS is generally ideal. Commercial rafting trips are available through local outfitters. A great intermediate run with reliable flows during release season.',
    39.4300000, -79.0500000,
    39.5100000, -79.0600000,
    'III',
    6.50,
    '01595500',
    '["dam release","intermediate","commercial","Barnum","Bloomington","wave trains","scenic","Maryland"]',
    NULL,
    1
  ),
  (
    44,
    'Kitzmiller Section',
    'Upper (Kitzmiller – Class III–V)',
    'The more challenging upper section above Barnum, featuring Class III–V rapids with a steeper gradient and more powerful, technical water. This stretch is appropriate for advanced-to-expert paddlers and offers a significant step up from the Barnum to Bloomington run. The section begins near Kitzmiller, MD and runs downstream to Barnum. Best during higher dam releases or after significant rainfall. Scout unfamiliar rapids and be prepared for pushy water with consequential hydraulics.',
    39.3900000, -79.0200000,
    39.4300000, -79.0500000,
    'V',
    4.00,
    '01595500',
    '["advanced","steep","technical","Kitzmiller","expert","powerful","upper section","Maryland"]',
    NULL,
    2
  );

-- ── Gunpowder Falls sections (river_id=45) ───────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    45,
    'Hereford to Monkton (Falls Road to York Road)',
    'Main Whitewater (Hereford to Monkton)',
    'The most popular whitewater section on Gunpowder Falls, from the Hereford area to Monkton through Gunpowder Falls State Park. Approximately 6 miles of Class II–III rapids with small ledges, boulder gardens, and playful wave trains. Below Prettyboy Dam, the water is cold and clear year-round. The toughest stretch is between Falls Road and York Road. Rain-dependent for optimal whitewater levels above base tailwater flows. A favorite after-work run for Baltimore-area paddlers. Check the USGS Glencoe gauge (01582500) for current conditions—ideal levels are 2.5–5.0 feet.',
    39.5700000, -76.6500000,
    39.5200000, -76.6200000,
    'III',
    6.00,
    '01582500',
    '["state park","Baltimore","after-work","cold water","dam tailwater","popular","ledges","Maryland"]',
    NULL,
    1
  ),
  (
    45,
    'Monkton to Sparks (Lower)',
    'Lower (Monkton to Sparks)',
    'A gentler 6-mile extension below the main whitewater section, featuring Class I–II water with easier rapids and a more relaxed gradient. Flows through scenic Gunpowder Falls State Park with beautiful forest scenery. Suitable for beginners and intermediate paddlers, or as a cool-down after the upper section. Popular for canoes and recreational kayaks at moderate flows.',
    39.5200000, -76.6200000,
    39.4900000, -76.6100000,
    'II',
    6.00,
    '01582500',
    '["state park","gentle","beginner friendly","scenic","canoe","family","Baltimore","Maryland"]',
    1,
    2
  );

-- ── Antietam Creek section (river_id=46) ──────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    46,
    'Devil''s Backbone Park to MD 34',
    'Main Run (Devil''s Backbone to MD 34)',
    'The classic 7.9-mile Antietam Creek run from Devil''s Backbone Park (MD 68) to MD 34. Features gentle Class I–II rapids, riffles, and moving water through pastoral farmland, wooded corridors, and past the historic Antietam National Battlefield. The route passes under Burnside Bridge—a pivotal Civil War landmark. Watch for fallen trees (strainers), especially after storms. Put-in has good parking, restrooms, and picnic facilities. Take-out parking at MD 34 is limited. The creek is spring-fed and holds water well; minimum recommended flow is 2.5 feet at the USGS Sharpsburg gauge (01619500); optimal at 3.0+ feet. Above 7.0 feet is too high for safe recreational paddling. Trip takes approximately 4 hours.',
    39.4900000, -77.7500000,
    39.4200000, -77.7100000,
    'II',
    7.90,
    '01619500',
    '["historic","Civil War","Burnside Bridge","beginner","pastoral","scenic","spring fed","Sharpsburg","Maryland"]',
    1,
    1
  );

-- ── Bear Creek section (river_id=47) ──────────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    47,
    'US 219 to Youghiogheny at Friendsville',
    'Main Run (US 219 to Friendsville)',
    'The full 7-mile Bear Creek run from US 219 to the confluence with the Youghiogheny River at Friendsville. Continuous Class IV action with numerous rapids featuring technical moves and powerful water features. The creek is rain-dependent and rises quickly after storms. Often combined with the Upper Yough or Savage River for a full weekend of western Maryland whitewater. The take-out at the Youghiogheny in Friendsville makes logistics convenient for those also running the Upper Yough. Check the USGS Bear Creek at Friendsville gauge (03076600) for real-time conditions. Advanced paddling skills and a reliable roll are essential.',
    39.6800000, -79.4200000,
    39.6561000, -79.3942000,
    'IV',
    7.00,
    '03076600',
    '["advanced","technical","Friendsville","Youghiogheny tributary","rain dependent","continuous","Garrett County","Maryland"]',
    NULL,
    1
  );

-- ── Patapsco River sections (river_id=48) ─────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    48,
    'Woodstock to Daniels',
    'Upper (Woodstock to Daniels)',
    'The best whitewater section of the Patapsco—approximately 4.7 miles from Woodstock Road to Daniels through Patapsco Valley State Park. Features continuous Class II–III rapids at higher flows with a mix of boulder gardens, ledges, and wave trains. The valley scenery is beautiful with lush forest and historic mill ruins. Be aware that flash floods in recent years have altered rapid character, including the Doughnut Rapid near Ellicott City. Always scout after major flood events. The USGS Hollofield gauge (01586000) provides flow data; ideal whitewater levels are 2.0–5.0 feet.',
    39.3313000, -76.8710000,
    39.2900000, -76.8200000,
    'III',
    4.70,
    '01586000',
    '["state park","Baltimore","whitewater","Woodstock","Daniels","scenic","historic","rain dependent","Maryland"]',
    NULL,
    1
  ),
  (
    48,
    'Daniels to Ellicott City/Elkridge',
    'Lower (Daniels to Ellicott City)',
    'The lower 12.8-mile section from Daniels to Elkridge, passing through Ellicott City. Easier Class I–II water with gentle riffles and moving water through Patapsco Valley State Park. Scenic paddling past historic sites, mill ruins, and wooded valley. Suitable for beginners and intermediate paddlers at moderate flows. Can be combined with the upper section for a full 17.5-mile day trip.',
    39.2900000, -76.8200000,
    39.2174000, -76.7056000,
    'II',
    12.80,
    '01586000',
    '["state park","scenic","beginner friendly","historic","Ellicott City","family","gentle","Maryland"]',
    1,
    2
  );

-- ── Deer Creek section (river_id=49) ──────────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    49,
    'Eden Mill Park to Rocks State Park',
    'Main Whitewater (Eden Mill to Rocks)',
    'The most popular whitewater section of Deer Creek—approximately 7 miles from Eden Mill Park to Rocks State Park (Route 24). Features Class II rapids with some Class III drops at higher water, flowing through a scenic gorge beneath the iconic King and Queen Seat rock formation. The take-out is at the parking area under the King and Queen Seats off Route 24. Caution: directly downstream of the typical take-out, there is a fall-line chute with a significant drop—exit the river before reaching it. A low-head dam upstream from Route 161 should be portaged. Best run after rainfall or during spring. Check gauge conditions via American Whitewater before heading out.',
    39.6660000, -76.4342000,
    39.6382000, -76.3964000,
    'II',
    7.00,
    '01580000',
    '["state park","Rocks","King and Queen Seat","gorge","scenic","rain dependent","ledges","Maryland"]',
    NULL,
    1
  );

-- ── Sideling Hill Creek section (river_id=50) ─────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    50,
    'Upper Section to Bellegrove',
    'Main Run (Upper to Bellegrove)',
    'Approximately 8 miles of Class III–IV steep creek through a remote, wooded Appalachian gorge. Features technical rapids with drops, tight boulder moves, and swift currents. Highly rain-dependent and flashy—the creek rises and falls quickly after storms. When running, it provides one of the best steep-creek experiences in western Maryland. The USGS gauge near Bellegrove (01610155) on Pearre Road bridge provides real-time flow data. Scout all major rapids and be prepared for wood hazards that change frequently with storms. A hidden gem for experienced creek boaters—advanced to expert skills required.',
    39.6800000, -78.3600000,
    39.6497000, -78.3441000,
    'IV',
    8.00,
    '01610155',
    '["steep creek","advanced","technical","rain dependent","remote","gorge","Appalachian","Maryland"]',
    NULL,
    1
  );

-- ── Crabtree Creek section (river_id=51) ──────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    51,
    'Swanton to Savage Reservoir',
    'Main Run (Swanton to Savage Reservoir)',
    'Approximately 6 miles of continuous Class III–IV+ steep creek from near Swanton to Savage River Reservoir. Technical rapids with boulder gardens, ledges, and drops through the forested mountains of Garrett County. Highly rain-dependent—only runnable after significant precipitation. When running, one of Maryland''s best steep-creek experiences. Often paddled in combination with the nearby Savage River when both have adequate flows. The surrounding Savage River State Forest provides stunning scenery, especially during fall foliage. Advanced to expert skills required.',
    39.5400000, -79.1900000,
    39.5075000, -79.1344000,
    'IV',
    6.00,
    '03076000',
    '["steep creek","advanced","technical","rain dependent","Garrett County","Savage tributary","fall foliage","Maryland"]',
    NULL,
    1
  );

-- ── Monocacy River section (river_id=52) ──────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    52,
    'Buckeystown Park to Park Mills Road',
    'Whitewater Section (Buckeystown to Park Mills)',
    'The only significant whitewater section on the Monocacy River, from Buckeystown Park to Park Mills Road. Features the fun Greenfield Rapid—a Class II rapid with small drops, boulders, and bedrock outcroppings. At higher flows (5+ feet at the Buckeystown gauge), the rapids become more exciting with standing waves and faster current. Below optimal flows, expect more boulder dodging and shallow riffles. The stretch is approximately 5 miles and can be paddled in 2–3 hours. Great for beginners looking for their first taste of whitewater.',
    39.3400000, -77.4000000,
    39.3100000, -77.3700000,
    'II',
    5.00,
    '01643000',
    '["Greenfield Rapid","beginner","family","Frederick","water trail","scenic","pastoral","Maryland"]',
    1,
    1
  ),
  (
    52,
    'Rocky Ridge to Monocacy Boat Ramp (Full Water Trail)',
    'Scenic Water Trail (Full Run)',
    'The full 30-mile Monocacy Scenic Water Trail from Rocky Ridge to the Monocacy Boat Ramp near the Potomac River. Mostly Class I moving water with gentle riffles and flat sections, divided into three segments. Ideal for multi-day canoe camping trips, family outings, and scenic floats through pastoral Frederick County. The trail passes near the Monocacy National Battlefield. Check the USGS gauge at Buckeystown (01643000) for water levels; minimum 2 feet for comfortable paddling.',
    39.4100000, -77.4100000,
    39.2700000, -77.3500000,
    'I',
    30.00,
    '01643000',
    '["water trail","scenic","family","multi-day","camping","canoe","Frederick","gentle","Civil War","Maryland"]',
    1,
    2
  );

-- =============================================================
-- Tennessee Rivers (from 007_tn_seed_data.sql)
-- =============================================================

-- =============================================================
-- Tennessee Rivers (IDs 53–62)
-- Note: Ocoee River already exists as ID 3 in 003_aw_seed_data.sql
-- =============================================================
INSERT INTO rivers (id, name, state, region, lat, lng, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, description, usgs_site_id, tags, is_runnable) VALUES
  -- 53. Hiwassee River — AW: Dam-controlled Class II family run near Reliance
  (
    53,
    'Hiwassee River',
    'Tennessee',
    'Cherokee National Forest / Polk County',
    35.1860000, -84.5006000,
    35.1669000, -84.2961000,
    35.2323000, -84.5505000,
    'II',
    16.00,
    'A beautiful and accessible Class II river flowing through the Cherokee National Forest near Reliance, Tennessee. The Hiwassee is one of the Southeast''s most popular beginner and family-friendly whitewater runs, with dam-controlled flows from Appalachia Powerhouse providing reliable water levels throughout the paddling season. The 16-mile stretch from the powerhouse to the Gee Creek take-out features gentle but entertaining Class II rapids, crystal-clear water, and stunning valley scenery. Multiple access points allow trips of varying lengths. Popular with commercial rafting outfitters, recreational kayakers, canoeists, and tubers. The river corridor is part of the Cherokee National Forest and offers excellent wildlife viewing. TVA dam releases make this one of the most consistently runnable rivers in Tennessee.',
    '03557000',
    '["dam controlled","family","beginner friendly","Cherokee National Forest","TVA","popular","commercial","scenic","Reliance","Tennessee"]',
    1
  ),
  -- 54. Nolichucky River — AW: Class III–IV gorge, Poplar NC to Erwin TN
  (
    54,
    'Nolichucky River',
    'Tennessee',
    'Nolichucky Gorge / Unicoi County',
    36.1026000, -82.4475000,
    36.0789000, -82.3475000,
    36.1026000, -82.4475000,
    'IV',
    9.00,
    'One of the premier whitewater gorge runs in the Southeast, the Nolichucky flows through a dramatic, remote wilderness gorge from Poplar, North Carolina to the Chestoa Recreation Area near Erwin, Tennessee. The approximately 9-mile run features continuous Class III–IV rapids with big water, powerful hydraulics, and stunning scenery—sheer canyon walls rise hundreds of feet on both sides. The gorge is roadless and remote, making rescue difficult and self-sufficiency essential. Commercial rafting trips are available from local outfitters. The river is rain-dependent and can rise quickly after storms. Key rapids include Quarter Mile, On The Rocks, and Jaws. The Chestoa take-out is operated by the U.S. Forest Service. A classic must-do for intermediate-to-advanced paddlers visiting the southern Appalachians.',
    '03464650',
    '["gorge","wilderness","remote","big water","commercial","Appalachian","classic","Cherokee National Forest","Erwin","Tennessee"]',
    1
  ),
  -- 55. Pigeon River — AW: Class II–III near Great Smoky Mountains
  (
    55,
    'Pigeon River',
    'Tennessee',
    'Great Smoky Mountains / Cocke County',
    35.8125000, -83.1450000,
    35.7749000, -83.0998000,
    35.8125000, -83.1450000,
    'III',
    4.30,
    'A popular and scenic whitewater river near the Great Smoky Mountains, offering approximately 4.3 miles of Class II–III rapids from Walters Power Plant at Waterville to the bridge at Hartford, Tennessee. The Upper Pigeon section features fun, continuous rapids with waves, ledges, and playful hydraulics—perfect for intermediate paddlers looking for action close to Gatlinburg and the national park. One of the busiest commercially rafted rivers in Tennessee due to its proximity to major tourist destinations. Recreational dam releases create reliable flows during the summer paddling season. The Lower Pigeon section downstream of Hartford offers gentler Class I–II water suitable for beginners and families.',
    '03461000',
    '["Great Smoky Mountains","commercial","popular","dam release","tourist area","Gatlinburg","Hartford","scenic","Tennessee"]',
    1
  ),
  -- 56. Obed River — AW: National Wild & Scenic River, Class II–IV
  (
    56,
    'Obed River',
    'Tennessee',
    'Obed Wild & Scenic River / Morgan & Cumberland Counties',
    36.0789000, -84.7661000,
    36.0892000, -84.8289000,
    36.0678000, -84.6608000,
    'IV',
    12.00,
    'Tennessee''s only federally designated National Wild and Scenic River, the Obed system includes the Obed River, Clear Creek, Daddy''s Creek, and the Emory River—offering some of the finest wilderness whitewater in the Southeast. Designated in 1976 and managed by the National Park Service, the system features Class II–IV rapids flowing through spectacular sandstone gorges and pristine forest. The Obed proper (Potter''s Ford to Obed Junction) and Clear Creek (Lilly Bridge to Nemo Bridge) are the most popular whitewater runs. The river is entirely rain-dependent with no dam releases, so paddling opportunities are limited to rainy seasons (typically winter through spring). When running, the Obed offers a true wilderness creek experience with technical boulder gardens, pool-drop rapids, and dramatic canyon walls. A bucket-list destination for southeastern paddlers.',
    '03539800',
    '["wild and scenic","national park","wilderness","rain dependent","canyon","sandstone","NPS","Obed","Clear Creek","Tennessee"]',
    NULL
  ),
  -- 57. Watauga River — AW: Dam-release Class II–III, Wilbur Dam to Elizabethton
  (
    57,
    'Watauga River',
    'Tennessee',
    'Carter County / Elizabethton',
    36.3415000, -82.1265000,
    36.3415000, -82.1265000,
    36.3559000, -82.2235000,
    'III',
    7.00,
    'A scenic and reliable dam-release whitewater run in northeast Tennessee, flowing from below Wilbur Dam to Elizabethton. The approximately 7-mile stretch features Class II–III rapids with fun waves, ledges, and technical moves through a beautiful mountain valley. TVA water releases from Wilbur Dam create excellent paddling conditions, though flows can be unpredictable—check release schedules before heading out. The highlight is the Bee Cliff Rapids section shortly after the put-in. Popular with intermediate kayakers and commercial rafting outfitters. The river flows through scenic Carter County countryside before reaching Elizabethton, where it eventually joins Boone Lake. A solid intermediate run with reliable flows when TVA is generating.',
    '03486000',
    '["dam release","TVA","intermediate","Bee Cliff","Wilbur Dam","Elizabethton","northeast Tennessee","scenic","Tennessee"]',
    NULL
  ),
  -- 58. Big South Fork of the Cumberland — AW: Class III–IV gorge, National River
  (
    58,
    'Big South Fork of the Cumberland',
    'Tennessee',
    'Big South Fork National River & Recreation Area / Scott County',
    36.4792000, -84.6672000,
    36.3878000, -84.6353000,
    36.4792000, -84.6672000,
    'IV',
    14.00,
    'A premier wilderness whitewater river flowing through the Big South Fork National River and Recreation Area, managed by the National Park Service. The classic Burnt Mill Bridge to Leatherwood Ford run covers approximately 14 miles of Class III–IV rapids through a deep, scenic gorge with an average gradient of 20 feet per mile. Key rapids include Angel Falls and Devil''s Jump—both Class IV drops that most paddlers portage. The gorge is remote, roadless, and stunningly beautiful with towering sandstone cliffs, natural arches, and rich biodiversity. The river is rain-dependent and best run during winter and spring high water. Self-sufficiency is critical as rescue access is extremely limited. One of Tennessee''s most dramatic and challenging wilderness whitewater experiences.',
    '03410210',
    '["national river","NPS","wilderness","gorge","remote","sandstone","Angel Falls","Class IV","rain dependent","Tennessee"]',
    NULL
  ),
  -- 59. Doe River — AW: Class II–III gorge run, Hampton to Elizabethton
  (
    59,
    'Doe River',
    'Tennessee',
    'Doe River Gorge / Carter County',
    36.2631000, -82.1607000,
    36.2736000, -82.1806000,
    36.3489000, -82.2136000,
    'III',
    8.50,
    'A scenic 8.5-mile creek run through the beautiful Doe River Gorge in Carter County, Tennessee. The Hampton to Elizabethton section features Class II–III rapids flowing through a narrow, dramatic gorge with towering rock walls and lush forest. The gorge section is the highlight—tight, technical rapids through stunning geology before the river opens up toward Elizabethton. Rain-dependent and best run after storms or during spring snowmelt. Access has been improved through conservation efforts, with put-in at Hershel Julian Landing in Hampton and take-out options at Green Bridge Landing or downstream in Elizabethton. A hidden gem for intermediate paddlers visiting northeast Tennessee.',
    '03485500',
    '["gorge","scenic","rain dependent","intermediate","creek","Carter County","Hampton","Elizabethton","hidden gem","Tennessee"]',
    NULL
  ),
  -- 60. Tellico River — AW: Class III–IV, Cherokee National Forest
  (
    60,
    'Tellico River',
    'Tennessee',
    'Cherokee National Forest / Monroe County',
    35.3619000, -84.2792000,
    35.3200000, -84.2200000,
    35.3619000, -84.2792000,
    'IV',
    10.00,
    'A beloved southeastern whitewater classic flowing through the Cherokee National Forest near Tellico Plains, Tennessee. The Tellico offers multiple sections ranging from Class II to Class IV, with the Upper Tellico ("The Ledges") being the signature run—approximately 2 miles of splashy drops, technical boulder gardens, and pool-drop rapids rated Class III–IV. The Middle Tellico continues downstream with solid Class II–III rapids through beautiful forest scenery. The full run from the upper put-in to Tellico Plains covers roughly 10 miles. Rain-dependent and best run during winter and spring; the river rises and falls quickly with storms. Baby Pratt Falls is a popular rapid and play spot. The Tellico is also a gateway to nearby Bald River, one of Tennessee''s premier Class IV creek runs.',
    '03518500',
    '["Cherokee National Forest","creek","rain dependent","Ledges","Baby Pratt","Tellico Plains","classic","southeast","Tennessee"]',
    NULL
  ),
  -- 61. Caney Fork River — AW: Class II–IV, Rock Island State Park
  (
    61,
    'Caney Fork River',
    'Tennessee',
    'Rock Island State Park / Warren & White Counties',
    35.8085000, -85.6330000,
    35.8100000, -85.6350000,
    35.8060000, -85.6300000,
    'IV',
    1.00,
    'A unique whitewater destination at Rock Island State Park in middle Tennessee, where the Caney Fork River plunges through a dramatic gorge below Center Hill Dam. The short but intense 1-mile gorge run features Class II–IV rapids (with some Class V drops at high flows) in a spectacular setting of waterfalls and exposed rock. The famous Blue Hole play spot just below the dam is a world-class playboating feature that has hosted international freestyle kayaking competitions. The run is entirely dependent on dam generation schedules—check TVA/Army Corps release schedules before visiting. Paddlers often take multiple laps by walking back upstream. Crystal-clear tailwater makes this one of the most scenic short runs in the state. Note: the gorge may be closed during certain release conditions for safety.',
    '03422500',
    '["state park","dam release","playboating","Blue Hole","freestyle","gorge","short run","TVA","Rock Island","Tennessee"]',
    NULL
  ),
  -- 62. French Broad River — AW: Scenic Class I–II through east Tennessee
  (
    62,
    'French Broad River',
    'Tennessee',
    'Cocke & Jefferson Counties / East Tennessee',
    35.9815000, -83.1612000,
    35.8500000, -82.9500000,
    36.0000000, -83.2000000,
    'II',
    17.50,
    'A large-volume scenic river flowing through east Tennessee, offering approximately 17.5 miles of Class I–II paddling along the popular Section 10 from the Tennessee/North Carolina border through Paint Rock to the Wolf Creek/Del Rio area. The French Broad is one of the oldest rivers in the world and features gentle rapids, fun ledges, and beautiful Appalachian mountain scenery. Ideal for beginners, families, and those seeking a relaxed day on the water. The river is large enough to be paddleable year-round in most conditions. Multiple access points allow flexible trip planning. The corridor passes through scenic farmland and mountain valleys with excellent wildlife viewing opportunities. A perfect warm-up or cool-down run when visiting the many harder rivers nearby.',
    '03455000',
    '["scenic","beginner friendly","family","large river","Appalachian","Section 10","year-round","ancient river","east Tennessee","Tennessee"]',
    1
  );

-- =============================================================
-- Tennessee River Sections
-- =============================================================

-- ── Hiwassee River sections (river_id=53) ─────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    53,
    'Appalachia Powerhouse to Reliance Bridge',
    'Upper (Powerhouse to Reliance)',
    'The classic 12-mile upper section from the Appalachia Powerhouse to the bridge at Reliance. Continuous Class II rapids with fun waves, small hydraulics, and beautiful clear water flowing through Cherokee National Forest. Dam-controlled releases from TVA''s Appalachia Powerhouse provide consistent, reliable flows throughout the paddling season. Multiple access points at Towee Creek and other landings allow shorter trips. Extremely popular with commercial rafting outfitters and families. A quintessential beginner-to-intermediate southeastern whitewater experience.',
    35.1669000, -84.2961000,
    35.1858000, -84.5006000,
    'II',
    12.00,
    '03557000',
    '["dam controlled","family","beginner","TVA","Cherokee National Forest","Reliance","clear water","Tennessee"]',
    1,
    1
  ),
  (
    53,
    'Reliance Bridge to Gee Creek',
    'Lower (Reliance to Gee Creek)',
    'A gentle 4-mile extension below Reliance Bridge to the Gee Creek take-out. Easier Class I–II water with a more relaxed character, ideal for families, fishing, and scenic floating. Beautiful forest scenery and excellent wildlife habitat. Can be combined with the upper section for a full 16-mile day trip.',
    35.1858000, -84.5006000,
    35.2323000, -84.5505000,
    'I',
    4.00,
    '03557000',
    '["family","gentle","scenic","fishing","wildlife","extension","Tennessee"]',
    1,
    2
  );

-- ── Nolichucky River section (river_id=54) ────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    54,
    'Nolichucky Gorge (Poplar to Chestoa)',
    'Gorge (Poplar to Chestoa)',
    'The classic 9-mile Nolichucky Gorge run from Poplar, NC to Chestoa Recreation Area near Erwin, TN. Continuous Class III–IV rapids through a dramatic, roadless wilderness gorge with sheer canyon walls rising hundreds of feet. The gorge is one of the deepest east of the Mississippi. Key rapids include Quarter Mile (a long, continuous Class III+ rapid), On The Rocks, and Jaws. Self-sufficiency is critical—there is no road access once you enter the gorge. Commercial rafting trips available. The Chestoa take-out is maintained by the U.S. Forest Service. Best after rain; the river rises quickly with storms. Intermediate-to-advanced skills required.',
    36.0789000, -82.3475000,
    36.1026000, -82.4475000,
    'IV',
    9.00,
    '03464650',
    '["gorge","wilderness","continuous","big water","commercial","Chestoa","Poplar","advanced","Tennessee"]',
    1,
    1
  );

-- ── Pigeon River sections (river_id=55) ───────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    55,
    'Upper Pigeon (Waterville to Hartford)',
    'Upper (Waterville to Hartford)',
    'The popular 4.3-mile Upper Pigeon section from Walters Power Plant at Waterville to the bridge at Hartford. Continuous Class II–III rapids with fun waves, ledges, and playful features. One of the busiest commercially rafted stretches in Tennessee, thanks to its proximity to Gatlinburg and the Great Smoky Mountains. Dam releases provide reliable summer flows. A great intermediate run with consistent action.',
    35.7749000, -83.0998000,
    35.8125000, -83.1450000,
    'III',
    4.30,
    '03461000',
    '["commercial","popular","dam release","Great Smoky Mountains","Gatlinburg","Hartford","intermediate","Tennessee"]',
    1,
    1
  ),
  (
    55,
    'Lower Pigeon (Hartford to Newport)',
    'Lower (Hartford to Newport)',
    'A gentler 8-mile section below Hartford offering Class I–II water suitable for beginners and families. The Lower Pigeon meanders through scenic agricultural valleys and Appalachian foothills. A relaxed float with occasional riffles and small rapids. Popular for tubing, canoeing, and recreational kayaking. A nice complement to the more exciting Upper Pigeon section.',
    35.8125000, -83.1450000,
    35.9500000, -83.1900000,
    'II',
    8.00,
    '03461000',
    '["beginner","family","scenic","gentle","tubing","canoe","Lower Pigeon","Tennessee"]',
    1,
    2
  );

-- ── Obed River sections (river_id=56) ─────────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    56,
    'Clear Creek (Lilly Bridge to Nemo Bridge)',
    'Clear Creek (Lilly to Nemo)',
    'The most popular run in the Obed system—approximately 7.5 miles of Class II–IV whitewater from Lilly Bridge to Nemo Bridge. The run features technical boulder gardens, pool-drop rapids, and stunning sandstone canyon walls within the Obed Wild and Scenic River. Clear Creek is slightly more accessible than the Obed proper and sees the most paddler traffic. Rain-dependent with no dam releases. When running, it offers a true wilderness creek experience in a National Park Service unit. Intermediate-to-advanced skills required.',
    36.1042000, -84.7158000,
    36.0678000, -84.6608000,
    'IV',
    7.50,
    '03539800',
    '["wild and scenic","NPS","canyon","technical","rain dependent","wilderness","Clear Creek","Tennessee"]',
    NULL,
    1
  ),
  (
    56,
    'Obed River (Potter''s Ford to Obed Junction)',
    'Obed (Potter''s Ford to Junction)',
    'The Obed River proper from Potter''s Ford to Obed Junction—approximately 5 miles of Class III–IV whitewater through a spectacular, remote sandstone gorge. More difficult and committing than Clear Creek, with bigger drops, more powerful hydraulics, and very limited rescue access. The gorge walls are dramatic and the wilderness setting is pristine. Rain-dependent and rarely running at optimal levels. When it''s on, this is one of the finest wilderness gorge runs in the eastern US. Advanced-to-expert skills required.',
    36.0892000, -84.8289000,
    36.0789000, -84.7661000,
    'IV',
    5.00,
    '03539800',
    '["wild and scenic","NPS","gorge","advanced","remote","wilderness","sandstone","rain dependent","Tennessee"]',
    NULL,
    2
  ),
  (
    56,
    'Daddy''s Creek (Antioch Bridge to Devil''s Breakfast Table)',
    'Daddy''s Creek (Antioch to Devil''s Breakfast Table)',
    'A challenging 6.8-mile tributary run within the Obed system, from Antioch Bridge to Devil''s Breakfast Table Bridge. Class III–IV rapids with an average gradient of 37 feet per mile—the most intense whitewater is concentrated in a dramatic 2-mile canyon section. Notable rapids include Spike, Fang of the Rattlesnake, and Rocking Chair. The creek is rain-dependent and can rise dangerously fast. Access restrictions may apply during hunting season in the Catoosa Wildlife Management Area. Advanced skills and creek-boating experience essential.',
    36.0592000, -84.7908000,
    35.9989000, -84.8225000,
    'IV',
    6.80,
    '03539600',
    '["creek","steep","technical","canyon","rain dependent","advanced","Obed system","Catoosa","Tennessee"]',
    NULL,
    3
  );

-- ── Watauga River section (river_id=57) ───────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    57,
    'Wilbur Dam to Elizabethton',
    'Main Run (Wilbur Dam to Elizabethton)',
    'The classic 7-mile Watauga run from below Wilbur Dam to Elizabethton. Class II–III rapids with fun waves, ledges, and the notable Bee Cliff Rapids section shortly after the put-in. TVA dam releases create paddling conditions, though flow schedules can vary. The run passes through scenic Carter County mountain scenery. Popular with intermediate kayakers and local paddling clubs. Check TVA generation schedules before planning your trip—when they''re generating, this is one of northeast Tennessee''s most reliable intermediate runs.',
    36.3415000, -82.1265000,
    36.3559000, -82.2235000,
    'III',
    7.00,
    '03486000',
    '["dam release","TVA","Wilbur Dam","Bee Cliff","intermediate","Elizabethton","northeast Tennessee","Tennessee"]',
    NULL,
    1
  );

-- ── Big South Fork of the Cumberland section (river_id=58) ────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    58,
    'Burnt Mill Bridge to Leatherwood Ford',
    'Canyon Run (Burnt Mill to Leatherwood)',
    'The classic 14-mile Big South Fork canyon run from Burnt Mill Bridge to Leatherwood Ford. Class III–IV rapids through a deep, remote gorge with an average gradient of 20 feet per mile. The run passes through spectacular sandstone canyon scenery with towering cliffs, natural arches, and pristine forest. Key rapids include Angel Falls (Class IV, commonly portaged) and Devil''s Jump (Class IV). The gorge is roadless—once you commit, there is no easy exit until Leatherwood Ford. Rain-dependent and best during winter/spring high water. Check the USGS gauge at Leatherwood Ford (03410210) for current levels. Advanced self-rescue skills essential.',
    36.3878000, -84.6353000,
    36.4792000, -84.6672000,
    'IV',
    14.00,
    '03410210',
    '["gorge","wilderness","NPS","Angel Falls","sandstone","rain dependent","remote","advanced","Tennessee"]',
    NULL,
    1
  );

-- ── Doe River section (river_id=59) ───────────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    59,
    'Hampton to Elizabethton (Doe River Gorge)',
    'Gorge Run (Hampton to Elizabethton)',
    'The full 8.5-mile Doe River run from Hershel Julian Landing in Hampton through the scenic Doe River Gorge to Elizabethton. The gorge section features tight, technical Class II–III rapids through narrow rock walls and lush forest—the highlight of the run. Below the gorge, the river opens up with easier Class II water as it approaches Elizabethton. Rain-dependent and best after storms or during spring flows. Access improvements at Hershel Julian Landing and Green Bridge Landing have made logistics easier. Check the USGS gauge at Elizabethton (03485500) for flow information. A scenic, hidden gem in northeast Tennessee.',
    36.2736000, -82.1806000,
    36.3489000, -82.2136000,
    'III',
    8.50,
    '03485500',
    '["gorge","scenic","rain dependent","creek","intermediate","Hampton","Elizabethton","hidden gem","Tennessee"]',
    NULL,
    1
  );

-- ── Tellico River sections (river_id=60) ──────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    60,
    'Upper Tellico (The Ledges)',
    'Upper (The Ledges)',
    'The signature 2-mile Upper Tellico run known as "The Ledges"—a classic southeastern Class III–IV stretch with splashy drops, technical boulder gardens, and pool-drop rapids. Features Baby Pratt Falls and other beloved rapids. Best run during winter and spring when rainfall provides adequate flows. The Tellico rises and falls quickly with storms. A favorite among experienced southeastern paddlers. Check the USGS Tellico Plains gauge (03518500) for levels.',
    35.3200000, -84.2200000,
    35.3400000, -84.2500000,
    'IV',
    2.00,
    '03518500',
    '["Ledges","Baby Pratt","technical","pool-drop","rain dependent","classic","Cherokee National Forest","Tennessee"]',
    NULL,
    1
  ),
  (
    60,
    'Middle Tellico',
    'Middle',
    'A solid 4-mile Class II–III section below the Upper Tellico, featuring continuous rapids, playful waves, and technical moves through beautiful Cherokee National Forest scenery. Ideal for intermediate paddlers looking for classic southeastern whitewater. Can be combined with the Upper section for a longer run. Rain-dependent.',
    35.3400000, -84.2500000,
    35.3600000, -84.2700000,
    'III',
    4.00,
    '03518500',
    '["intermediate","continuous","Cherokee National Forest","rain dependent","scenic","Tennessee"]',
    NULL,
    2
  ),
  (
    60,
    'Ranger Station to Tellico Plains',
    'Lower (Ranger Station to Tellico Plains)',
    'A 4.2-mile lower section from the Ranger Station to Tellico Plains. Class I–III water that is more beginner-friendly than the upper sections, though still offering solid rapids at the right flows. Beautiful forest scenery and a good introduction to Tellico River whitewater before stepping up to the more challenging upstream sections.',
    35.3600000, -84.2700000,
    35.3619000, -84.2792000,
    'III',
    4.20,
    '03518500',
    '["beginner friendly","scenic","Tellico Plains","introduction","rain dependent","Tennessee"]',
    NULL,
    3
  );

-- ── Caney Fork River section (river_id=61) ────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    61,
    'Rock Island Gorge (Blue Hole Run)',
    'Gorge (Blue Hole)',
    'The short but intense 1-mile gorge run at Rock Island State Park, featuring Class II–IV rapids and the famous Blue Hole play spot. The gorge is carved below Center Hill Dam with crystal-clear tailwater, waterfalls, and dramatic exposed rock. A world-class playboating destination that has hosted international freestyle kayaking competitions. Entirely dependent on dam generation schedules—check TVA/Army Corps release schedules before visiting. Most paddlers take multiple laps. The gorge may be closed during high releases for safety. A unique and photogenic paddling experience.',
    35.8100000, -85.6350000,
    35.8060000, -85.6300000,
    'IV',
    1.00,
    '03422500',
    '["state park","dam release","playboating","Blue Hole","freestyle","gorge","short run","TVA","Tennessee"]',
    NULL,
    1
  );

-- ── French Broad River section (river_id=62) ──────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    62,
    'Section 10 (Paint Rock to Wolf Creek)',
    'Section 10 (Paint Rock to Wolf Creek)',
    'The popular 17.5-mile Section 10 of the French Broad River from the Tennessee/North Carolina border at Paint Rock to Wolf Creek/Del Rio. Class I–II rapids with fun ledges and moving water through beautiful Appalachian mountain scenery. The French Broad is one of the oldest rivers in the world and carries significant volume year-round. Multiple access points allow trips of varying length. Ideal for beginners, families, and those seeking a relaxed day trip. Recommended minimum flow is approximately 1,000 CFS with enjoyable paddling above 2,000 CFS at the Newport gauge.',
    35.8500000, -82.9500000,
    36.0000000, -83.2000000,
    'II',
    17.50,
    '03455000',
    '["scenic","beginner","family","Section 10","year-round","ancient river","Appalachian","large volume","Tennessee"]',
    1,
    1
  );

-- =============================================================
-- Kentucky Rivers (from 008_ky_seed_data.sql)
-- =============================================================

-- =============================================================
-- Kentucky Rivers (IDs 63–71)
-- Note: Big South Fork of the Cumberland already exists as ID 58
--       in 007_tn_seed_data.sql (Tennessee)
-- =============================================================
INSERT INTO rivers (id, name, state, region, lat, lng, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, description, usgs_site_id, tags, is_runnable) VALUES
  -- 63. Elkhorn Creek — AW: Class II–III gorge near Frankfort
  (
    63,
    'Elkhorn Creek',
    'Kentucky',
    'Franklin County / Frankfort',
    38.2681000, -84.8144000,
    38.2681000, -84.8144000,
    38.3131000, -84.8469000,
    'III',
    6.70,
    'One of the most popular whitewater runs in Kentucky, Elkhorn Creek flows through a scenic gorge near the state capital of Frankfort. The classic 6.7-mile Knight''s Bridge to US 127 section features continuous Class II–III rapids (reaching III+ in high water) with fun playspots, ledges, and dynamic hydraulics. Elkhorn Creek serves as a whitewater "classroom" for central Kentucky paddlers, with reliable flows during rainy seasons and a strong local paddling community. The gorge section near Peaks Mill offers the best whitewater with limestone walls and wooded scenery. Multiple access points allow flexible trip lengths. A great introduction to Kentucky whitewater and a favorite after-work run for Frankfort and Lexington paddlers.',
    '03289500',
    '["gorge","popular","playspots","Frankfort","intermediate","limestone","rain dependent","central Kentucky","Kentucky"]',
    NULL
  ),
  -- 64. Russell Fork — AW: Class V gorge, Elkhorn City, dam release
  (
    64,
    'Russell Fork',
    'Kentucky',
    'Pike County / Breaks Interstate Park',
    37.2976000, -82.3231000,
    37.2976000, -82.3231000,
    37.3007000, -82.3545000,
    'V',
    4.00,
    'One of the most famous and feared Class V whitewater runs in the eastern United States. The Russell Fork Gorge carves through Breaks Interstate Park—the "Grand Canyon of the South"—with a gradient averaging 69 feet per mile and reaching 99 feet per mile through the steepest section. Legendary rapids include Triple Drop, El Horrendo, and Climax, featuring massive drops, complex hydraulics, and serious consequences. Scheduled dam releases from John W. Flannagan Reservoir in October draw expert paddlers from across the country for "Russell Fork Weekend." The gorge is roadless and remote, requiring self-sufficiency and advanced rescue skills. Outside of release weekends, the run is dependent on rainfall and can rise quickly. Not for beginners—this is one of the premier expert-level runs in the Southeast.',
    '03209300',
    '["Class V","gorge","expert","dam release","October","El Horrendo","Triple Drop","Breaks Interstate Park","famous","Kentucky"]',
    NULL
  ),
  -- 65. Cumberland River (Below Cumberland Falls) — AW: Class II–III+ scenic gorge
  (
    65,
    'Cumberland River (Below Cumberland Falls)',
    'Kentucky',
    'Cumberland Falls State Resort Park / Whitley & McCreary Counties',
    36.8370000, -84.3408000,
    36.8370000, -84.3408000,
    36.9426000, -84.2836000,
    'III',
    10.50,
    'A beautiful and challenging 10.5-mile whitewater run below the "Niagara of the South"—Cumberland Falls, one of the largest waterfalls in the eastern U.S. The run from the sandy beach below the falls to the Mouth of Laurel Boat Ramp features continuous Class II–III rapids (with Class IV at high water) through a scenic, wooded gorge in the Daniel Boone National Forest. Notable rapids include Initiation, Center Rock, Pinball, Screaming Right, Stairsteps, and Last Drop. The run is best during Lake Cumberland drawdown periods (late summer/early autumn) when natural flows supplement dam releases. Intermediate-to-advanced skills recommended. The take-out at Mouth of Laurel involves a flat-water paddle across the backwaters of Lake Cumberland—plan accordingly. A stunning, must-do Kentucky river experience.',
    '03404500',
    '["state park","waterfall","gorge","Daniel Boone National Forest","scenic","intermediate","Cumberland Falls","Niagara of the South","Kentucky"]',
    NULL
  ),
  -- 66. Rockcastle River — AW: Class III gorge, KY 80 to Bee Rock
  (
    66,
    'Rockcastle River',
    'Kentucky',
    'Daniel Boone National Forest / Laurel & Pulaski Counties',
    37.1470000, -84.2928000,
    37.1470000, -84.2928000,
    37.0277000, -84.3213000,
    'III',
    11.00,
    'A scenic and challenging Class III whitewater river flowing through the Daniel Boone National Forest in south-central Kentucky. The classic KY 80 to Bee Rock Boat Ramp section covers approximately 11 miles of technical whitewater with boulder gardens, ledges, and house-sized rocks creating complex rapids. The river corridor is wild and remote, with towering cliffs and dense forest. The Rockcastle is rain-dependent and rises quickly after storms. Below the Old Howard Place access point, the difficulty increases significantly with more technical and challenging rapids. A favorite among experienced Kentucky paddlers seeking wilderness solitude and quality whitewater. The Bee Rock Boat Ramp take-out is well-maintained and easy to find.',
    '03406500',
    '["wilderness","boulder gardens","Daniel Boone National Forest","rain dependent","Bee Rock","remote","intermediate","technical","Kentucky"]',
    NULL
  ),
  -- 67. Red River (Red River Gorge) — AW: Class II–III, scenic gorge paddling
  (
    67,
    'Red River',
    'Kentucky',
    'Red River Gorge / Wolfe & Powell Counties',
    37.8269000, -83.5972000,
    37.8269000, -83.5972000,
    37.8173000, -83.6097000,
    'III',
    6.00,
    'A scenic and popular whitewater run through the Red River Gorge Geological Area in the Daniel Boone National Forest, one of Kentucky''s most beloved natural areas. The Middle Fork and main Red River sections offer approximately 6 miles of Class II–III rapids (reaching IV at high flows) through stunning sandstone gorges, natural arches, and dense hardwood forest. The river is entirely rain-dependent and best run during spring or after heavy rainfall. When conditions are right, the Red River Gorge offers a unique combination of quality whitewater and spectacular scenery—towering cliffs, overhangs, and rock shelters line the river corridor. Popular with both paddlers and climbers, who flock to the gorge year-round. Check the USGS gauge at Hazel Green for flow information.',
    '03282500',
    '["gorge","scenic","rain dependent","sandstone","natural arches","Daniel Boone National Forest","climbing area","Red River Gorge","Kentucky"]',
    NULL
  ),
  -- 68. Laurel River (Below Laurel River Lake) — AW: Class III dam-release run
  (
    68,
    'Laurel River',
    'Kentucky',
    'Daniel Boone National Forest / Laurel County',
    36.9481000, -84.0963000,
    36.9500000, -84.0950000,
    36.9460000, -84.1000000,
    'III',
    2.00,
    'A short but intense Class III whitewater run below the Laurel River Lake dam in the Daniel Boone National Forest near London, Kentucky. The approximately 2-mile stretch below the dam features fun, fast-moving Class II–III rapids (reaching IV at high release flows) in a scenic gorge setting. The run is entirely dependent on dam releases—when the dam is generating, the run comes alive with powerful hydraulics and standing waves. The cold tailwater (released from the bottom of the lake) requires appropriate cold-water gear even in summer. Paddlers often do multiple laps on this short, action-packed section. A great intermediate-to-advanced run when dam releases coincide with your schedule.',
    '03405000',
    '["dam release","gorge","short run","Daniel Boone National Forest","cold water","London","intermediate","multiple laps","Kentucky"]',
    NULL
  ),
  -- 69. Benson Creek — AW: Class II–III near Frankfort
  (
    69,
    'Benson Creek',
    'Kentucky',
    'Franklin County / Near Frankfort',
    38.2081000, -84.9371000,
    38.2081000, -84.9371000,
    38.2123000, -84.8993000,
    'III',
    3.00,
    'A fun and accessible Class II–III creek run near Frankfort, Kentucky. The 3-mile KY 1005 to Benson Falls section offers entertaining whitewater with vertical ledges, play waves, and small drops through a scenic wooded corridor. Best after heavy rainfall, when the creek transforms from a trickle to an exciting ride. The highlight is Benson Falls near the take-out—a scenic waterfall that marks the end of the whitewater section. A longer 5.1-mile option continues downstream to the Kentucky River. Popular with local paddlers as a quick after-rain creek run. Rain-dependent and rises/falls quickly, so timing is essential. A great complement to nearby Elkhorn Creek.',
    '03287545',
    '["creek","rain dependent","waterfall","Frankfort","ledges","play waves","quick run","Kentucky"]',
    NULL
  ),
  -- 70. Stoner Creek — AW: Class II, Paris KY
  (
    70,
    'Stoner Creek',
    'Kentucky',
    'Bourbon County / Paris',
    38.2292000, -84.2561000,
    38.2400000, -84.2600000,
    38.2100000, -84.2500000,
    'II',
    5.00,
    'A gentle Class II whitewater creek flowing through the scenic Bluegrass region near Paris, Kentucky. Stoner Creek offers approximately 5 miles of fun, beginner-friendly paddling with small rapids, riffles, and easy drops. The creek flows through pastoral Bourbon County horse farm country, offering a uniquely Kentucky paddling experience with scenic rolling hills and historic stone fences lining the banks. Best paddled during or after rain when water levels are sufficient. A great introduction to creek boating for beginners and a pleasant paddle for experienced paddlers seeking a relaxed run. The proximity to Paris and Lexington makes this an easy day trip.',
    '03252000',
    '["beginner","Bluegrass","horse country","Paris","scenic","rain dependent","creek","relaxed","Kentucky"]',
    1
  ),
  -- 71. Kentucky River (Palisades) — AW: Class I–II scenic paddle
  (
    71,
    'Kentucky River (Palisades)',
    'Kentucky',
    'Jessamine & Mercer Counties / Central Kentucky',
    37.7812000, -84.5991000,
    37.7812000, -84.5991000,
    37.7976000, -84.7225000,
    'II',
    10.00,
    'The Kentucky River Palisades is one of the most spectacular scenic paddling destinations in the state, featuring approximately 10 miles of gentle Class I–II water flanked by towering 250–300-foot limestone cliffs. The classic Camp Nelson to High Bridge section winds through a dramatic gorge with stunning geology, waterfalls cascading from side canyons, caves, and abundant wildlife including great blue herons, kingfishers, and bald eagles. The river carries enough volume to be paddleable most of the year, making it one of Kentucky''s most reliable runs. Multiple access points at Shaker Village at Pleasant Hill, Camp Nelson, and High Bridge allow flexible trip planning. The historic High Bridge—a landmark cantilevered railroad bridge—towers above the take-out. Ideal for beginners, families, fishing, and nature photography. A quintessential central Kentucky river experience.',
    '03287500',
    '["palisades","scenic","limestone cliffs","beginner friendly","family","wildlife","High Bridge","Camp Nelson","year-round","central Kentucky","Kentucky"]',
    1
  );

-- =============================================================
-- Kentucky River Sections
-- =============================================================

-- ── Elkhorn Creek sections (river_id=63) ──────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    63,
    'Forks of Elkhorn to Knight''s Bridge',
    'Upper (Forks to Knight''s Bridge)',
    'A 3-mile warm-up section from the Forks of Elkhorn to Knight''s Bridge. Gentle Class I–II water with occasional small rapids, suitable for beginners and those looking for a mellow float. Scenic wooded corridor near Frankfort.',
    38.2150000, -84.7983000,
    38.2681000, -84.8144000,
    'II',
    3.00,
    '03289500',
    '["beginner","warm-up","scenic","Frankfort","Kentucky"]',
    NULL,
    1
  ),
  (
    63,
    'Knight''s Bridge to Peaks Mill',
    'Gorge (Knight''s Bridge to Peaks Mill)',
    'The heart of the Elkhorn Creek whitewater experience—a 4-mile Class II–III gorge run from Knight''s Bridge through the scenic Peaks Mill area. Continuous rapids with playspots, ledges, and fun hydraulics. The best whitewater on Elkhorn Creek. Popular with intermediate paddlers and the local paddling community. Limestone gorge walls and wooded hillsides provide beautiful scenery.',
    38.2681000, -84.8144000,
    38.3075000, -84.8150000,
    'III',
    4.00,
    '03289500',
    '["gorge","playspots","intermediate","Peaks Mill","limestone","popular","Kentucky"]',
    NULL,
    2
  ),
  (
    63,
    'Peaks Mill to US 127',
    'Lower (Peaks Mill to US 127)',
    'The final 2.7 miles from Peaks Mill to the US 127 bridge near the confluence with the Kentucky River. Class II water that gradually eases as the creek approaches the Kentucky River. A nice cool-down section after the gorge run.',
    38.3075000, -84.8150000,
    38.3131000, -84.8469000,
    'II',
    2.70,
    '03289500',
    '["cool-down","Kentucky River","confluence","easy","Kentucky"]',
    NULL,
    3
  );

-- ── Russell Fork sections (river_id=64) ───────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    64,
    'Russell Fork Gorge (Garden Hole to Elkhorn City)',
    'Gorge (Garden Hole to Elkhorn City)',
    'The legendary 4-mile Russell Fork Gorge run from Garden Hole (also known as Golden Hole) in Virginia to Elkhorn City, Kentucky. This is one of the premier Class V runs in the eastern United States, with a gradient averaging 69 feet per mile and reaching 99 feet per mile through the steepest 1.4-mile section. Iconic rapids include Triple Drop (three distinct Class IV–V drops in quick succession), El Horrendo (a massive, chaotic Class V rapid with powerful hydraulics), and Climax (the grand finale). The gorge is roadless and completely committed—once you enter, there is no easy exit. Scheduled dam releases from Flannagan Reservoir in October provide the most reliable flows and draw hundreds of expert paddlers. Outside of release season, the run is dependent on heavy rainfall. Expert skills, solid rescue capabilities, and intimate knowledge of the run are essential.',
    37.2976000, -82.3231000,
    37.3007000, -82.3545000,
    'V',
    4.00,
    '03209300',
    '["Class V","expert","gorge","dam release","October","El Horrendo","Triple Drop","Climax","committed","famous","Kentucky"]',
    NULL,
    1
  );

-- ── Cumberland River (Below Cumberland Falls) section (river_id=65) ──
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    65,
    'Cumberland Falls to Mouth of Laurel',
    'Main Run (Falls to Mouth of Laurel)',
    'The classic 10.5-mile Cumberland River run from the sandy beach below Cumberland Falls to the Mouth of Laurel Boat Ramp. Continuous Class II–III rapids (with Class III+/IV at higher flows) through a beautiful, wooded gorge in the Daniel Boone National Forest. Notable rapids include Initiation (II), Center Rock (III), Misery (II+), Pinball (III), Screaming Right (III+), Stairsteps (III), and Last Drop (III+/IV at high water). The run is best during Lake Cumberland drawdown periods when natural flows supplement dam releases. Be prepared for a flat-water paddle at the end as you cross the backwaters of Lake Cumberland to reach the Mouth of Laurel Boat Ramp. Walk-in access to the put-in requires carrying your boat down from the Cumberland Falls State Park parking area. Life jacket and helmet required.',
    36.8370000, -84.3408000,
    36.9426000, -84.2836000,
    'III',
    10.50,
    '03404500',
    '["gorge","state park","Cumberland Falls","Daniel Boone National Forest","intermediate","scenic","continuous","Kentucky"]',
    NULL,
    1
  );

-- ── Rockcastle River section (river_id=66) ────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    66,
    'KY 80 to Bee Rock Boat Ramp',
    'Main Run (KY 80 to Bee Rock)',
    'The classic 11-mile Rockcastle River run from the KY 80 bridge to the Bee Rock Boat Ramp. Class III whitewater through a wild, scenic gorge in the Daniel Boone National Forest with boulder gardens, technical rapids, and house-sized rocks. The river corridor features towering cliffs, dense forest, and a genuine wilderness feel. Rain-dependent—check the USGS gauge at Billows (03406500) before heading out. Below the Old Howard Place access point, difficulty increases with more technical rapids. Self-sufficiency recommended due to the remote nature of the gorge. The Bee Rock take-out is a well-maintained boat ramp with parking.',
    37.1470000, -84.2928000,
    37.0277000, -84.3213000,
    'III',
    11.00,
    '03406500',
    '["wilderness","boulder gardens","Daniel Boone National Forest","rain dependent","Bee Rock","remote","technical","Kentucky"]',
    NULL,
    1
  );

-- ── Red River sections (river_id=67) ──────────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    67,
    'Middle Fork (Red River Gorge)',
    'Middle Fork (Gorge)',
    'A scenic 6-mile Class II–III run through the heart of the Red River Gorge Geological Area. The Middle Fork section features technical rapids, small ledges, and continuous moving water framed by spectacular sandstone cliffs, natural arches, and lush forest. The gorge is one of Kentucky''s premier natural areas and is also famous as a world-class rock-climbing destination. Rain-dependent—best run during spring or after heavy storms. At higher flows, difficulty can reach Class IV. Check the USGS gauge at Hazel Green (03282500) for conditions.',
    37.8269000, -83.5972000,
    37.8173000, -83.6097000,
    'III',
    6.00,
    '03282500',
    '["gorge","sandstone","natural arches","rain dependent","climbing area","scenic","Daniel Boone National Forest","Kentucky"]',
    NULL,
    1
  );

-- ── Laurel River section (river_id=68) ────────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    68,
    'Below Laurel River Lake Dam',
    'Dam Release Run',
    'A short, intense 2-mile Class III whitewater run below the Laurel River Lake dam. When the dam is generating, the run features powerful, fun Class II–III rapids (reaching IV at high releases) with standing waves, hydraulics, and fast-moving water. The cold tailwater requires appropriate cold-water gear. Paddlers often run multiple laps due to the short length and easy shuttle. Check dam generation schedules before planning—no release means no water. The gorge setting in the Daniel Boone National Forest provides scenic surroundings for a compact whitewater experience.',
    36.9500000, -84.0950000,
    36.9460000, -84.1000000,
    'III',
    2.00,
    '03405000',
    '["dam release","cold water","short run","multiple laps","Daniel Boone National Forest","London","Kentucky"]',
    NULL,
    1
  );

-- ── Benson Creek section (river_id=69) ────────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    69,
    'KY 1005 to Benson Falls',
    'Main Run (KY 1005 to Falls)',
    'A fun 3-mile creek run from the KY 1005 bridge to Benson Falls. Class II–III rapids with vertical ledges, small drops, and play waves through a scenic wooded corridor near Frankfort. The highlight is Benson Falls near the take-out—a beautiful waterfall and a memorable way to finish the run. Best after heavy rainfall when the creek has sufficient flow. Rises and falls quickly, so timing is critical. A longer 5.1-mile option continues past the falls to the Kentucky River confluence.',
    38.2081000, -84.9371000,
    38.2123000, -84.8993000,
    'III',
    3.00,
    '03287545',
    '["creek","waterfall","rain dependent","ledges","Frankfort","quick run","Kentucky"]',
    NULL,
    1
  );

-- ── Stoner Creek section (river_id=70) ────────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    70,
    'Stoner Creek (Paris)',
    'Main Run (Paris)',
    'A gentle 5-mile Class II creek run through the scenic Bluegrass region near Paris, Kentucky. Small rapids, riffles, and easy drops provide a pleasant paddle through pastoral Bourbon County horse farm country. Scenic rolling hills, stone fences, and lush pastures make this a uniquely Kentucky experience. Best paddled after rain when water levels are adequate. A great beginner run and a relaxed option for experienced paddlers looking for an easy day on the water.',
    38.2400000, -84.2600000,
    38.2100000, -84.2500000,
    'II',
    5.00,
    '03252000',
    '["beginner","Bluegrass","horse country","Paris","scenic","rain dependent","gentle","Kentucky"]',
    1,
    1
  );

-- ── Kentucky River (Palisades) section (river_id=71) ──────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    71,
    'Camp Nelson to High Bridge',
    'Palisades (Camp Nelson to High Bridge)',
    'The classic 10-mile Palisades paddle from Camp Nelson State Park to the High Bridge Boat Ramp. Gentle Class I–II water flanked by towering 250–300-foot limestone cliffs—some of the tallest palisades in Kentucky. The corridor features waterfalls cascading from side canyons, caves, and abundant wildlife including great blue herons, kingfishers, and bald eagles. Multiple access points at Shaker Village at Pleasant Hill allow flexible trip planning. The take-out at High Bridge offers views of the iconic cantilevered railroad bridge towering overhead. Suitable for all skill levels—beginners, families, anglers, and nature photographers will all find this run rewarding. The river carries enough volume to be paddleable most of the year.',
    37.7812000, -84.5991000,
    37.7976000, -84.7225000,
    'II',
    10.00,
    '03287500',
    '["palisades","scenic","limestone cliffs","family","wildlife","High Bridge","Camp Nelson","year-round","Kentucky"]',
    1,
    1
  );

-- =============================================================
-- North Carolina Rivers (from 009_nc_seed_data.sql)
-- =============================================================

-- =============================================================
-- North Carolina Rivers (IDs 72–81)
-- Note: Nantahala River already exists as ID 6 in 003_aw_seed_data.sql
--       French Broad River already exists as ID 12 in 003_aw_seed_data.sql
--       Nolichucky River already exists as ID 54 in 007_tn_seed_data.sql
--       Watauga River already exists as ID 57 in 007_tn_seed_data.sql
-- =============================================================
INSERT INTO rivers (id, name, state, region, lat, lng, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, description, usgs_site_id, tags, is_runnable) VALUES
  -- 72. Green River — AW: Class V Narrows, Class II–III Upper/Lower
  (
    72,
    'Green River',
    'North Carolina',
    'Henderson & Polk Counties',
    35.2907000, -82.3592000,
    35.3200000, -82.3700000,
    35.2641000, -82.3246000,
    'V',
    10.00,
    'Home to one of the most famous Class V steep creek runs in the Southeast, the Green River in western North Carolina offers three distinct sections for every skill level. The legendary Narrows section features a 4-mile, 500-foot descent through a tight, boulder-choked gorge with continuous Class V drops—a rite of passage for expert paddlers and host of the annual Green River Race. The Upper Green (Class II–III) above the Narrows provides an excellent intermediate run with playful rapids and beautiful scenery. The Lower Green (Class II) below Fish Top offers mellow flatwater and easy rapids. Dam-controlled flows from the Green River Reservoir provide reliable water levels, and the Green River Access Fund manages access through a key system for the Narrows.',
    '02151500',
    '["steep creek","Class V","Narrows","expert","dam controlled","Green River Race","famous","access fund","western North Carolina","North Carolina"]',
    1
  ),
  -- 73. Cheoah River — AW: Class IV–V dam-release run
  (
    73,
    'Cheoah River',
    'North Carolina',
    'Graham County / Nantahala National Forest',
    35.4479000, -83.8602000,
    35.4479000, -83.8602000,
    35.3960000, -83.7960000,
    'V',
    9.25,
    'One of the Southeast''s most coveted dam-release runs, the Cheoah River flows 9.25 miles from Santeetlah Dam to Calderwood Lake through a stunning gorge in the Nantahala National Forest. The river was dewatered for decades before American Whitewater and paddling advocates successfully negotiated scheduled recreational releases. When running at 1,000 CFS, the Cheoah delivers continuous, powerful Class IV–V whitewater with large volume rapids, big hydraulics, and an incredible wilderness setting. Releases are scheduled on select dates throughout the year (typically February through November). The limited release schedule creates a festival atmosphere, drawing expert paddlers from across the region. Advanced skills and solid rescue capabilities are essential.',
    '0351706800',
    '["dam release","Class V","expert","Nantahala National Forest","gorge","limited schedule","advocacy","wilderness","Graham County","North Carolina"]',
    NULL
  ),
  -- 74. Tuckasegee River — AW: Class II–III family-friendly
  (
    74,
    'Tuckasegee River',
    'North Carolina',
    'Jackson & Swain Counties / Smoky Mountains',
    35.3674000, -83.2523000,
    35.3674000, -83.2523000,
    35.3892000, -83.2951000,
    'III',
    6.00,
    'A favorite family-friendly whitewater river flowing through the Smoky Mountains of western North Carolina. The Tuckasegee ("Tuck") offers approximately 6 miles of fun Class II–III rapids between Dillsboro and Barkers Creek, with playful waves, small ledges, and gentle hydraulics perfect for beginners and intermediate paddlers. The river passes through the charming mountain towns of Dillsboro and Bryson City, with easy access from multiple bridges and parks. Dam releases from Thorpe Reservoir provide reliable flows, and several commercial outfitters offer guided trips. The Tuck Gorge section below Dillsboro features the best whitewater. A great introduction to western NC paddling and a perfect complement to the nearby Nantahala.',
    '03510500',
    '["family","beginner friendly","Smoky Mountains","Bryson City","Dillsboro","dam release","commercial","popular","western North Carolina","North Carolina"]',
    1
  ),
  -- 75. Linville River — AW: Class IV–V wilderness gorge
  (
    75,
    'Linville River',
    'North Carolina',
    'Linville Gorge Wilderness / Burke County',
    35.9638000, -81.9298000,
    35.9638000, -81.9298000,
    35.8646000, -81.9088000,
    'V',
    12.00,
    'One of the most challenging and remote wilderness whitewater runs in the eastern United States. The Linville River drops through the dramatic Linville Gorge—the "Grand Canyon of the East"—a federally designated Wilderness Area with towering cliffs, old-growth forest, and virtually no road access. The approximately 12-mile run from below Linville Falls to the Lake James backwaters features continuous Class IV–V rapids with mandatory portages around several dangerous drops and sieves. Access requires a strenuous hike in via the Babel Tower Trail. The gorge is committed—once you enter, there is no easy exit. Rain-dependent and best run in winter and spring. Only for experienced, self-sufficient expert paddlers with solid group rescue skills. A bucket-list run for southeastern creek boaters.',
    '02138500',
    '["wilderness","gorge","Class V","expert","committed","remote","Babel Tower","Linville Falls","mandatory portages","rain dependent","North Carolina"]',
    NULL
  ),
  -- 76. Wilson Creek — AW: Class IV steep creek
  (
    76,
    'Wilson Creek',
    'North Carolina',
    'Caldwell County / Pisgah National Forest',
    35.9697000, -81.7903000,
    35.9697000, -81.7903000,
    35.9403000, -81.7772000,
    'IV',
    4.00,
    'A classic southeastern steep creek and one of the most popular advanced runs in western North Carolina. Wilson Creek drops through a scenic gorge in the Pisgah National Forest near Mortimer, featuring approximately 4 miles of continuous Class IV rapids (with some Class V drops at higher flows) including boulder gardens, ledges, slides, and several significant waterfalls. The creek is rain-dependent and rises quickly after storms—timing is critical. The Brown Mountain Beach Road bridge serves as the standard put-in, with the take-out at the Wilson Creek Visitor Center downstream. A federally designated Wild and Scenic River, Wilson Creek offers stunning scenery alongside quality whitewater. Popular with intermediate-to-advanced creek boaters from across the Southeast.',
    '02140510',
    '["steep creek","boulder gardens","wild and scenic","Pisgah National Forest","Mortimer","rain dependent","advanced","waterfalls","western North Carolina","North Carolina"]',
    NULL
  ),
  -- 77. New River (North Carolina) — AW: Class II scenic paddle
  (
    77,
    'New River (North Carolina)',
    'North Carolina',
    'Watauga & Ashe Counties / High Country',
    36.3083000, -81.6101000,
    36.3083000, -81.6101000,
    36.2216000, -81.6544000,
    'II',
    12.00,
    'One of the oldest rivers in the world, the South Fork of the New River flows through the scenic High Country of northwestern North Carolina. The popular Todd to Boone section offers approximately 12 miles of gentle Class II whitewater with riffles, small ledges, and easy rapids through beautiful mountain scenery. A state-designated Natural and Scenic River, the New River corridor features pastoral farmland, forested hillsides, and abundant wildlife. Multiple access points at New River State Park allow flexible trip lengths. Ideal for beginners, families, canoeists, and anglers seeking a relaxed day on the water. The river carries reliable flows through much of the year due to its large watershed.',
    '03161000',
    '["scenic","ancient river","beginner friendly","family","New River State Park","High Country","Todd","Boone","year-round","North Carolina"]',
    1
  ),
  -- 78. Big Laurel Creek — AW: Class III–IV near Hot Springs
  (
    78,
    'Big Laurel Creek',
    'North Carolina',
    'Madison County / Hot Springs',
    35.9578000, -82.8044000,
    35.9200000, -82.7500000,
    35.8924000, -82.8200000,
    'IV',
    7.00,
    'A classic intermediate-to-advanced run flowing through Madison County to its confluence with the French Broad River at the charming Appalachian Trail town of Hot Springs. The 7-mile Hurricane to Hot Springs section features continuous Class III–IV rapids with technical boulder gardens, ledges, and powerful hydraulics. Big Laurel Creek is rain-dependent and rises quickly after storms—timing and river-reading skills are essential. The take-out at Hot Springs provides easy access to restaurants, hot springs, and the Appalachian Trail. A favorite among Asheville-area paddlers looking for a quality run close to town. The creek corridor passes through scenic hardwood forests with excellent fall color. Intermediate-to-advanced skills recommended.',
    '03454000',
    '["Appalachian Trail","Hot Springs","rain dependent","technical","boulder gardens","Asheville area","Madison County","continuous","North Carolina"]',
    NULL
  ),
  -- 79. Catawba River — AW: Class II–III near Morganton
  (
    79,
    'Catawba River',
    'North Carolina',
    'Burke County / Morganton',
    35.7494000, -81.7056000,
    35.7600000, -81.6800000,
    35.7400000, -81.7200000,
    'III',
    6.00,
    'A fun and accessible intermediate whitewater run near Morganton in the western North Carolina foothills. The Catawba River offers approximately 6 miles of Class II–III rapids between the Old Fort Road area and Rhodhiss Lake, with playful ledges, small drops, and continuous moving water. The river corridor passes through scenic piedmont-to-mountain transition terrain with wooded banks and occasional rock outcrops. A great option for paddlers looking for quality whitewater without the long drive to the deep mountains. Rain-dependent—check the USGS gauge at Morganton for flow conditions. Popular with local Burke County paddlers and those making a day trip from Charlotte or the Triad.',
    '02139282',
    '["foothills","intermediate","Morganton","accessible","rain dependent","piedmont","Burke County","day trip","North Carolina"]',
    NULL
  ),
  -- 80. South Toe River — AW: Class II–III near Black Mountains
  (
    80,
    'South Toe River',
    'North Carolina',
    'Yancey County / Black Mountains',
    35.7925000, -82.1719000,
    35.7925000, -82.1719000,
    35.8117000, -82.1872000,
    'III',
    5.00,
    'A scenic mountain creek flowing from the base of the Black Mountains—the highest peaks in eastern North America—through Yancey County. The approximately 5-mile Carolina Hemlocks to Celo section features Class II–III rapids with tight channels, boulder gardens, and beautiful mountain scenery. The South Toe is rain-dependent and best run in spring or after heavy rainfall. The Carolina Hemlocks Recreation Area provides a convenient put-in with picnic facilities and swimming access. A favorite local run for Asheville-area paddlers seeking a quick mountain creek experience with moderate difficulty. The river corridor features old-growth hemlocks, rhododendron-lined banks, and stunning views of Mt. Mitchell and the Black Mountain range.',
    '03463300',
    '["Black Mountains","mountain creek","Carolina Hemlocks","rain dependent","scenic","Mt. Mitchell","Yancey County","boulder gardens","North Carolina"]',
    NULL
  ),
  -- 81. North Toe River — AW: Class III–IV steep creek near Spruce Pine
  (
    81,
    'North Toe River',
    'North Carolina',
    'Mitchell County / Spruce Pine',
    35.9190000, -82.0776000,
    35.9300000, -82.0600000,
    35.9100000, -82.0900000,
    'IV',
    5.00,
    'A quality steep creek run in the mountain community of Spruce Pine, Mitchell County. The North Toe River features approximately 5 miles of Class III–IV whitewater with boulder gardens, ledges, and continuous gradient through a scenic Appalachian mountain valley. The river is rain-dependent and rises quickly after storms, offering short windows of excellent paddling. At optimal flows, the North Toe provides a fun, technical run with good scenery and easy shuttle. The confluence with the South Toe creates the Toe River proper, which continues downstream with additional whitewater opportunities. A favorite among regional creek boaters looking for quality steep creeking close to the Blue Ridge Parkway.',
    '03463000',
    '["steep creek","Spruce Pine","rain dependent","Mitchell County","Blue Ridge Parkway","boulder gardens","technical","Appalachian","North Carolina"]',
    NULL
  );

-- =============================================================
-- North Carolina River Sections
-- =============================================================

-- ── Green River sections (river_id=72) ────────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    72,
    'Upper Green (Green River Cove)',
    'Upper (Green River Cove)',
    'A scenic 4-mile Class II–III run above the Narrows, flowing through Green River Cove. Playful rapids, small ledges, and beautiful mountain scenery make this an excellent intermediate run. Dam releases from the Green River Reservoir provide reliable flows. A great warm-up before tackling the Narrows or a fun standalone trip for intermediate paddlers.',
    35.3200000, -82.3700000,
    35.2907000, -82.3592000,
    'III',
    4.00,
    '02151500',
    '["intermediate","scenic","dam release","warm-up","Green River Cove","playful","North Carolina"]',
    1,
    1
  ),
  (
    72,
    'Green River Narrows',
    'Narrows (Class V)',
    'The legendary Green River Narrows—one of the premier Class V steep creek runs in the Southeast. The 4-mile Narrows section drops approximately 500 feet through a tight, boulder-choked gorge with continuous Class V rapids featuring slides, waterfalls, and powerful hydraulics. The annual Green Race draws elite paddlers from around the world. Access is managed by the Green River Access Fund through a key system. The standard put-in requires a key for the private road; the Pulliam Creek Trailhead provides an alternate public access with a short hike. Expert skills, solid group rescue capabilities, and a bombproof roll are absolute prerequisites.',
    35.2907000, -82.3592000,
    35.2641000, -82.3246000,
    'V',
    4.00,
    '02151500',
    '["Class V","steep creek","expert","Green Race","famous","access fund","waterfalls","slides","committed","North Carolina"]',
    1,
    2
  ),
  (
    72,
    'Lower Green',
    'Lower (Fish Top to Fishtop Road)',
    'A mellow 2-mile Class II float below Fish Top take-out, extending downstream toward the Green River Game Lands. Easy rapids, calm pools, and scenic wooded banks provide a relaxed paddling experience. Suitable for beginners and families.',
    35.2641000, -82.3246000,
    35.2500000, -82.3100000,
    'II',
    2.00,
    '02151500',
    '["beginner","family","mellow","scenic","Green River Game Lands","North Carolina"]',
    1,
    3
  );

-- ── Cheoah River section (river_id=73) ────────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    73,
    'Santeetlah Dam to Calderwood Lake',
    'Main Run (Santeetlah to Calderwood)',
    'The full 9.25-mile Cheoah River dam-release run from Santeetlah Dam to Calderwood Lake Boat Launch. When the dam releases at 1,000 CFS, the river delivers continuous, powerful Class IV–V rapids with big volume hydraulics, powerful waves, and a stunning wilderness setting in the Nantahala National Forest. Releases are limited to scheduled dates—check the NOC or American Whitewater for the current release calendar. The festival atmosphere on release days draws expert paddlers from across the Southeast. Self-sufficiency and advanced rescue skills are critical in this remote gorge.',
    35.4479000, -83.8602000,
    35.3960000, -83.7960000,
    'V',
    9.25,
    '0351706800',
    '["dam release","Class V","expert","Nantahala National Forest","limited schedule","festival","wilderness","remote","North Carolina"]',
    NULL,
    1
  );

-- ── Tuckasegee River sections (river_id=74) ───────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    74,
    'Dillsboro to Barkers Creek (Tuck Gorge)',
    'Gorge (Dillsboro to Barkers Creek)',
    'The most popular whitewater section on the Tuckasegee—a 4-mile Class II–III run through the scenic Tuck Gorge from Dillsboro to Barkers Creek. Fun rapids, playful waves, and small ledges make this ideal for beginners and intermediate paddlers. Dam releases from Thorpe Reservoir provide consistent flows. Multiple access points near Dillsboro and Barkers Creek offer flexible trip planning. Commercial outfitters run trips through this section. A great introduction to western NC whitewater.',
    35.3674000, -83.2523000,
    35.3892000, -83.2951000,
    'III',
    4.00,
    '03510500',
    '["gorge","popular","beginner","dam release","Dillsboro","commercial","fun","North Carolina"]',
    1,
    1
  ),
  (
    74,
    'Barkers Creek to Bryson City',
    'Lower (Barkers Creek to Bryson City)',
    'A gentler 6-mile extension from Barkers Creek downstream to Bryson City. Class I–II water with occasional riffles and gentle rapids, passing through scenic mountain valley farmland. Perfect for families, fishing, and scenic floating. The take-out in Bryson City provides easy access to the charming mountain town.',
    35.3892000, -83.2951000,
    35.4275000, -83.4469000,
    'II',
    6.00,
    '03513000',
    '["family","scenic","gentle","Bryson City","fishing","mountain valley","North Carolina"]',
    1,
    2
  );

-- ── Linville River section (river_id=75) ──────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    75,
    'Linville Gorge (Babel Tower to Lake James)',
    'Gorge (Babel Tower to Lake James)',
    'The full Linville Gorge wilderness run—approximately 12 miles from the Babel Tower Trail access below Linville Falls to the Lake James backwaters. Continuous Class IV–V rapids with mandatory portages around several dangerous drops and sieves. The gorge is a federally designated Wilderness Area—no roads, no cell service, and very limited rescue access. The hike-in via Babel Tower Trail is strenuous and requires carrying your loaded boat down a steep, rocky trail. Expert skills, self-sufficiency, and solid group rescue capabilities are absolute requirements. Best run in winter and spring when rain provides sufficient flow. A true wilderness expedition and bucket-list run for eastern U.S. paddlers.',
    35.9638000, -81.9298000,
    35.8646000, -81.9088000,
    'V',
    12.00,
    '02138500',
    '["wilderness","gorge","Class V","expert","committed","Babel Tower","mandatory portages","remote","expedition","North Carolina"]',
    NULL,
    1
  );

-- ── Wilson Creek section (river_id=76) ────────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    76,
    'Wilson Creek Gorge (Brown Mountain Beach to Visitor Center)',
    'Gorge (Brown Mountain Beach to Visitor Center)',
    'The classic 4-mile Wilson Creek Gorge run from the Brown Mountain Beach Road bridge near Mortimer to the Wilson Creek Visitor Center. Continuous Class IV rapids (with some Class V drops at higher flows) including boulder gardens, ledges, slides, and several significant waterfalls through a beautiful Pisgah National Forest gorge. Rain-dependent and rises quickly after storms—timing is critical. The Wild and Scenic River corridor offers stunning scenery alongside quality whitewater. A southeastern steep creek classic popular with advanced paddlers from across the region.',
    35.9697000, -81.7903000,
    35.9403000, -81.7772000,
    'IV',
    4.00,
    '02140510',
    '["steep creek","gorge","wild and scenic","Pisgah National Forest","Mortimer","rain dependent","advanced","waterfalls","North Carolina"]',
    NULL,
    1
  );

-- ── New River (NC) section (river_id=77) ──────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    77,
    'Todd to Boone (South Fork)',
    'South Fork (Todd to Boone)',
    'The popular 12-mile scenic paddle on the South Fork of the New River from Todd to Boone. Gentle Class II rapids with riffles, small ledges, and easy drops through beautiful High Country mountain scenery. Multiple access points at New River State Park allow flexible trip lengths. The Todd General Store marks the traditional put-in. A state-designated Natural and Scenic River, ideal for beginners, families, canoeists, anglers, and anyone seeking a relaxed mountain river experience.',
    36.3083000, -81.6101000,
    36.2216000, -81.6544000,
    'II',
    12.00,
    '03161000',
    '["scenic","beginner","family","New River State Park","Todd","Boone","High Country","natural and scenic","North Carolina"]',
    1,
    1
  );

-- ── Big Laurel Creek section (river_id=78) ────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    78,
    'Hurricane to Hot Springs',
    'Main Run (Hurricane to Hot Springs)',
    'The classic 7-mile Big Laurel Creek run from the community of Hurricane to the confluence with the French Broad River at Hot Springs. Continuous Class III–IV rapids with technical boulder gardens, ledges, and powerful hydraulics through scenic hardwood forests. Rain-dependent—the creek rises and falls quickly with storms. The take-out at Hot Springs provides easy access to the charming Appalachian Trail town with restaurants, hot springs, and hiking. A favorite intermediate-to-advanced run for Asheville-area paddlers. Excellent fall color in October and November.',
    35.9200000, -82.7500000,
    35.8924000, -82.8200000,
    'IV',
    7.00,
    '03454000',
    '["Appalachian Trail","Hot Springs","rain dependent","technical","continuous","Asheville area","fall color","North Carolina"]',
    NULL,
    1
  );

-- ── Catawba River section (river_id=79) ───────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    79,
    'Morganton Run (Old Fort Road to Rhodhiss Lake)',
    'Main Run (Morganton)',
    'The popular 6-mile Catawba River run near Morganton from the Old Fort Road area to above Rhodhiss Lake. Class II–III rapids with playful ledges, small drops, and continuous moving water through scenic foothills terrain. A great option for intermediate paddlers in the Burke County area without the long drive to the deep mountains. Rain-dependent—check the USGS gauge at Morganton for flow conditions before heading out.',
    35.7600000, -81.6800000,
    35.7400000, -81.7200000,
    'III',
    6.00,
    '02139282',
    '["intermediate","foothills","Morganton","accessible","rain dependent","day trip","North Carolina"]',
    NULL,
    1
  );

-- ── South Toe River section (river_id=80) ─────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    80,
    'Carolina Hemlocks to Celo',
    'Main Run (Carolina Hemlocks to Celo)',
    'A scenic 5-mile mountain creek run from the Carolina Hemlocks Recreation Area to the bridge near Celo. Class II–III rapids with tight channels, boulder gardens, and beautiful mountain scenery at the base of the Black Mountains—the highest peaks in eastern North America. Rain-dependent and best in spring or after heavy rainfall. The Carolina Hemlocks put-in provides picnic facilities and swimming access. Views of Mt. Mitchell and the Black Mountain range add to the experience.',
    35.7925000, -82.1719000,
    35.8117000, -82.1872000,
    'III',
    5.00,
    '03463300',
    '["Black Mountains","mountain creek","Carolina Hemlocks","rain dependent","scenic","Mt. Mitchell","North Carolina"]',
    NULL,
    1
  );

-- ── North Toe River section (river_id=81) ─────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    81,
    'Spruce Pine Run',
    'Main Run (Spruce Pine)',
    'A quality 5-mile steep creek run through Spruce Pine featuring Class III–IV rapids with boulder gardens, ledges, and continuous gradient through a scenic Appalachian mountain valley. Rain-dependent and rises quickly after storms, offering short windows of excellent paddling. The confluence with the South Toe downstream creates the Toe River proper with additional whitewater opportunities. Easy shuttle along highways near Spruce Pine. Popular with regional creek boaters looking for quality steep creeking near the Blue Ridge Parkway.',
    35.9300000, -82.0600000,
    35.9100000, -82.0900000,
    'IV',
    5.00,
    '03463000',
    '["steep creek","Spruce Pine","rain dependent","Blue Ridge Parkway","boulder gardens","technical","North Carolina"]',
    NULL,
    1
  );

-- =============================================================
-- South Carolina Rivers (from 010_sc_seed_data.sql)
-- =============================================================

-- =============================================================
-- South Carolina Rivers (IDs 82–90)
-- Note: Chattooga River already exists as ID 5 in 003_aw_seed_data.sql
--       (listed as South Carolina/Georgia)
-- =============================================================
INSERT INTO rivers (id, name, state, region, lat, lng, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, description, usgs_site_id, tags, is_runnable) VALUES
  -- 82. Chauga River — AW: Class III–IV Upstate creek run
  (
    82,
    'Chauga River',
    'South Carolina',
    'Oconee County / Upstate',
    34.7871000, -83.2106000,
    34.7871000, -83.2106000,
    34.7174000, -83.1769000,
    'IV',
    9.00,
    'A classic Upstate South Carolina creek run flowing through Oconee County toward Lake Hartwell. The Chauga offers approximately 9 miles of Class III–IV whitewater on the upper section from Cassidy Bridge Road to Cobbs Bridge Road, with fun boulder gardens, ledges, and continuous rapids through a scenic Piedmont gorge. The river is rain-dependent and rises quickly after storms, offering short but exciting windows of paddling. The lower sections below Cobbs Bridge calm to Class I–II, suitable for beginners. The Chauga River Blueway covers 31 miles of the river with multiple access points. A favorite among Upstate paddlers looking for quality intermediate-to-advanced creeking close to Clemson and Seneca.',
    NULL,
    '["Upstate","Oconee County","rain dependent","boulder gardens","creek","Clemson","intermediate","advanced","blueway","South Carolina"]',
    NULL
  ),
  -- 83. Whitewater River — AW: Class III–V+ steep creek to Lake Jocassee
  (
    83,
    'Whitewater River',
    'South Carolina',
    'Oconee County / Jocassee Gorges',
    34.9764000, -82.9342000,
    35.0000000, -82.9500000,
    34.9764000, -82.9342000,
    'V',
    2.40,
    'A spectacular Class III–V+ steep creek flowing from below Upper Whitewater Falls—the tallest waterfall east of the Mississippi at 411 feet—into pristine Lake Jocassee in the Jocassee Gorges. The 2.4-mile run descends dramatically through the Blue Ridge Mountains with continuous gradient, slides, waterfalls, and powerful hydraulics. The takeout is directly into Lake Jocassee, requiring a boat shuttle across the lake. This is one of the most scenic and challenging steep creek runs in the Southeast, set in a remote wilderness with towering cliffs and old-growth forest. Expert-only with significant consequences—solid Class V skills, a bombproof roll, and group rescue capabilities are essential. Best run after heavy rain; no gauge—visual inspection at the put-in is standard practice.',
    '02184500',
    '["steep creek","Class V","expert","Jocassee Gorges","waterfalls","Lake Jocassee","wilderness","scenic","Blue Ridge","South Carolina"]',
    NULL
  ),
  -- 84. Lower Saluda River — AW: Class II–III dam-release urban run
  (
    84,
    'Lower Saluda River',
    'South Carolina',
    'Richland & Lexington Counties / Columbia',
    34.0508000, -81.2097000,
    34.0508000, -81.2097000,
    33.9960000, -81.0600000,
    'III',
    10.00,
    'One of the most reliable whitewater runs in South Carolina, the Lower Saluda flows from below Lake Murray Dam through the Columbia metropolitan area to its confluence with the Broad River. Dam releases from Lake Murray, managed by Dominion Energy for hydroelectric power, create dependable flows that produce Class II–III rapids year-round—a rarity in the Southeast. The 10-mile run from below the dam to Saluda Shoals Park features playful shoals, ledges, and standing waves that increase in difficulty with higher releases. At elevated flows (above 2,000 cfs), some features push into solid Class III. Saluda Shoals Park provides excellent access with parking, restrooms, and a riverfront trail. The cold tailwater supports a renowned trout fishery alongside the paddling. A favorite after-work run for Columbia-area paddlers.',
    '02168504',
    '["dam release","urban","reliable","Columbia","year-round","cold water","trout","Saluda Shoals","intermediate","South Carolina"]',
    1
  ),
  -- 85. Broad River — AW: Class I–III near Columbia
  (
    85,
    'Broad River',
    'South Carolina',
    'Richland County / Columbia',
    34.0454000, -81.0733000,
    34.1000000, -81.1000000,
    33.9960000, -81.0500000,
    'III',
    15.00,
    'A wide, scenic river flowing through the Columbia metropolitan area offering Class I–III whitewater on its lower reaches. The Broad River features over 30 access points and provides an approachable paddling experience with shoals, riffles, and gentle rapids suitable for intermediate paddlers. The section approaching Columbia features the most whitewater, with standing waves and rocky shoals that become more challenging at moderate to high flows. The river merges with the Saluda to form the Congaree River at the heart of Columbia. Popular for both whitewater kayaking and recreational floating, with easy access from multiple public parks and boat ramps. The Three Rivers Greenway provides scenic riverfront trails alongside the paddling. A great option for Columbia-area paddlers seeking mellow to moderate whitewater.',
    '02162035',
    '["Columbia","accessible","scenic","shoals","intermediate","Three Rivers Greenway","urban","multi-access","South Carolina"]',
    1
  ),
  -- 86. Eastatoe Creek — AW: Class IV+ steep creek, Heritage Preserve
  (
    86,
    'Eastatoe Creek',
    'South Carolina',
    'Pickens County / Jocassee Gorges',
    35.0500000, -82.8122000,
    35.0500000, -82.8122000,
    34.9960000, -82.8275000,
    'V',
    3.52,
    'One of the premier steep creek runs in the Southeast, Eastatoe Creek drops through the Eastatoe Creek Heritage Preserve in Pickens County with an astounding average gradient of 230 feet per mile. The 3.52-mile run from US 178 to Smith Creek above Lake Keowee features continuous Class IV+ rapids with technical drops, boulder gardens, slides, and small waterfalls through a remote, protected gorge. The creek is entirely rain-dependent with no gauge—paddlers rely on visual inspection at the put-in and recent rainfall data. The Heritage Preserve setting adds ecological significance with rare plant communities and pristine mountain stream habitat. Expert skills and technical creeking experience are absolute requirements. A bucket-list run for southeastern steep creek enthusiasts.',
    NULL,
    '["steep creek","Class V","expert","Heritage Preserve","rain dependent","technical","boulder gardens","slides","Pickens County","South Carolina"]',
    NULL
  ),
  -- 87. Catawba River (Great Falls) — AW: Class II–IV, dam-release whitewater
  (
    87,
    'Catawba River (Great Falls)',
    'South Carolina',
    'Chester County / Great Falls',
    34.5981000, -80.8906000,
    34.6100000, -80.8800000,
    34.5800000, -80.9000000,
    'IV',
    4.00,
    'A newly restored whitewater destination on the Catawba River at the historic town of Great Falls, Chester County. After decades of being dewatered, the Great Falls bypass channels now flow again thanks to a relicensing agreement with Duke Energy, creating two distinct whitewater runs. The Long Bypass Channel (~2 miles) offers wide, continuous Class II–III whitewater with multiple routes through a unique, recovering riverbed. The Short Bypass Channel provides a steeper, more concentrated run with Class III–IV rapids available during scheduled recreational releases. At higher flows (3,000–4,000+ cfs), features push into solid Class III–IV territory with big-water play opportunities. Check Duke Energy''s release schedule before visiting, as flows are controlled. A growing whitewater destination drawing attention across the Southeast.',
    '02147310',
    '["dam release","Great Falls","Duke Energy","restored","big water","Chester County","scheduled releases","growing destination","South Carolina"]',
    NULL
  ),
  -- 88. Thompson River — AW: Class V steep creek, Jocassee Gorges
  (
    88,
    'Thompson River',
    'South Carolina',
    'Oconee County / Jocassee Gorges',
    35.0043000, -82.9665000,
    35.0100000, -82.9600000,
    35.0000000, -82.9700000,
    'V',
    0.70,
    'An extremely steep and technical Class V creek in the Jocassee Gorges, flowing from the NC/SC border into Lake Jocassee. The Thompson River drops approximately 378 feet in just 0.7 miles from the Musterground Road culvert put-in to the lake—one of the steepest gradients of any commonly paddled run in the Southeast. The run features continuous steep slides, small waterfalls, and powerful hydraulics with no easy portage routes once committed. Access via Musterground Road requires 4WD and is only open seasonally (September 15–January 1 and March 20–May 10). The remote Jocassee Gorges setting adds wilderness character with dense forest and minimal development. Expert-only with serious consequences—advanced steep creeking skills, scouting ability, and a strong group are essential. A Southeast classic for experienced creek boaters.',
    NULL,
    '["steep creek","Class V","expert","Jocassee Gorges","slides","extreme gradient","seasonal access","wilderness","remote","South Carolina"]',
    NULL
  ),
  -- 89. Edisto River — AW: Class I blackwater scenic paddle
  (
    89,
    'Edisto River',
    'South Carolina',
    'Colleton & Dorchester Counties / Lowcountry',
    33.0474000, -80.3914000,
    33.1270000, -80.6129000,
    32.9446000, -80.3792000,
    'I',
    57.00,
    'One of the longest free-flowing blackwater rivers in North America, the Edisto River winds through the South Carolina Lowcountry offering one of the state''s most iconic paddling experiences. The 57-mile Edisto River Canoe and Kayak Trail (ERCK Trail) from Green Pond Church Landing to Lowndes Landing passes through Colleton State Park and Givhans Ferry State Park, with primitive camping, sandbars, and the famous Edisto treehouses along the way. The tea-colored blackwater, stained by tannins from decaying vegetation, flows beneath canopies of bald cypress, water tupelo, and Spanish moss-draped live oaks. Wildlife is abundant—river otters, alligators, herons, egrets, and turtles are commonly spotted. While not a whitewater run, the Edisto is South Carolina''s premier multi-day paddling destination and a must-do for scenic kayakers and canoeists. Best in spring and fall.',
    '02175000',
    '["blackwater","scenic","multi-day","camping","treehouses","Lowcountry","cypress","wildlife","ERCK Trail","family","South Carolina"]',
    1
  ),
  -- 90. Little River — AW: Class III–IV, Jocassee Gorges
  (
    90,
    'Little River',
    'South Carolina',
    'Pickens County / Jocassee Gorges',
    35.0306000, -82.8267000,
    35.0400000, -82.8200000,
    35.0200000, -82.8300000,
    'IV',
    5.00,
    'A scenic mountain creek flowing through the Jocassee Gorges in Pickens County, offering Class III–IV whitewater in a remote Blue Ridge Mountain setting. The approximately 5-mile run from Rocky Bottom downstream features technical rapids, boulder gardens, and ledges through a narrow, forested gorge. The Little River is entirely rain-dependent and rises quickly after storms, providing short windows of excellent paddling. The creek corridor passes through protected Jocassee Gorges lands with exceptional biodiversity and scenic beauty. At optimal flows, the Little River provides a fun, technical run that pairs well with nearby Eastatoe Creek or the Thompson and Whitewater rivers for a full Jocassee Gorges paddling weekend. Intermediate-to-advanced skills recommended.',
    '02186000',
    '["Jocassee Gorges","rain dependent","mountain creek","boulder gardens","technical","Blue Ridge","Pickens County","scenic","South Carolina"]',
    NULL
  );

-- =============================================================
-- South Carolina River Sections
-- =============================================================

-- ── Chauga River sections (river_id=82) ───────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    82,
    'Cassidy Bridge to Cobbs Bridge',
    'Upper (Cassidy Bridge to Cobbs Bridge)',
    'The classic Chauga whitewater run—9 miles of continuous Class III–IV rapids from Cassidy Bridge Road to Cobbs Bridge Road. Boulder gardens, ledges, and fun hydraulics through a scenic Piedmont gorge. Rain-dependent and best after significant rainfall. The most popular section among Upstate paddlers seeking intermediate-to-advanced creeking.',
    34.7871000, -83.2106000,
    34.7174000, -83.1769000,
    'IV',
    9.00,
    NULL,
    '["whitewater","intermediate","advanced","boulder gardens","rain dependent","Upstate","South Carolina"]',
    NULL,
    1
  ),
  (
    82,
    'Cobbs Bridge to Westminster',
    'Lower (Cobbs Bridge to Westminster)',
    'A mellower 6-mile Class I–II float from Cobbs Bridge Road downstream toward Westminster and Lake Hartwell. Gentle rapids, riffles, and scenic wooded banks provide a relaxed paddling experience suitable for beginners and families. A great cooldown after tackling the upper section.',
    34.7174000, -83.1769000,
    34.6625000, -83.1583000,
    'II',
    6.00,
    NULL,
    '["beginner","family","scenic","Westminster","Lake Hartwell","mellow","South Carolina"]',
    NULL,
    2
  );

-- ── Whitewater River section (river_id=83) ────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    83,
    'Base of Upper Falls to Lake Jocassee',
    'Main Run (Upper Falls to Jocassee)',
    'The full 2.4-mile Whitewater River steep creek run from below Upper Whitewater Falls to Lake Jocassee. Continuous Class III–V+ whitewater with slides, waterfalls, and powerful hydraulics descending through spectacular Blue Ridge Mountain scenery. The takeout requires paddling across Lake Jocassee to a boat ramp—plan for a boat shuttle or long flatwater paddle. Expert-only with significant commitment once on the river.',
    35.0000000, -82.9500000,
    34.9764000, -82.9342000,
    'V',
    2.40,
    '02184500',
    '["steep creek","expert","waterfalls","slides","Lake Jocassee","boat shuttle","committed","Blue Ridge","South Carolina"]',
    NULL,
    1
  );

-- ── Lower Saluda River sections (river_id=84) ─────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    84,
    'Dam to Saluda Shoals Park',
    'Upper (Dam to Saluda Shoals)',
    'The most popular section of the Lower Saluda—approximately 5 miles from below Lake Murray Dam to Saluda Shoals Park. Dam releases create reliable Class II–III rapids with playful shoals, ledges, and standing waves. Cold tailwater from the bottom of Lake Murray keeps the river cool even in summer, supporting a trout fishery alongside the paddling. Saluda Shoals Park provides excellent access with parking, restrooms, and trails. The go-to after-work run for Columbia paddlers.',
    34.0508000, -81.2097000,
    34.0300000, -81.1500000,
    'III',
    5.00,
    '02168504',
    '["dam release","popular","trout","cold water","Saluda Shoals","after-work","Columbia","South Carolina"]',
    1,
    1
  ),
  (
    84,
    'Saluda Shoals to Broad River Confluence',
    'Lower (Saluda Shoals to Confluence)',
    'The lower 5 miles from Saluda Shoals Park to the confluence with the Broad River. Class I–II water with occasional shoals and riffles, gradually flattening as the river approaches its merger with the Broad to form the Congaree. A scenic, relaxed extension of the upper section suitable for beginners and families.',
    34.0300000, -81.1500000,
    33.9960000, -81.0600000,
    'II',
    5.00,
    '02168504',
    '["scenic","beginner","family","confluence","Congaree","Columbia","South Carolina"]',
    1,
    2
  );

-- ── Broad River section (river_id=85) ─────────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    85,
    'Columbia Shoals (Peak to Riverfront)',
    'Columbia Shoals',
    'The best whitewater section on the Broad River near Columbia—approximately 8 miles of Class II–III shoals, riffles, and standing waves as the river approaches its confluence with the Saluda. Rocky shoals and ledges create fun features at moderate flows, with difficulty increasing at higher water. Multiple public access points along the Three Rivers Greenway provide flexible trip planning. Popular for recreational floating and intermediate whitewater paddling.',
    34.1000000, -81.1000000,
    33.9960000, -81.0500000,
    'III',
    8.00,
    '02162035',
    '["shoals","intermediate","Three Rivers Greenway","Columbia","accessible","South Carolina"]',
    1,
    1
  );

-- ── Eastatoe Creek section (river_id=86) ──────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    86,
    'US 178 to Smith Creek (Lake Keowee)',
    'Main Run (US 178 to Lake Keowee)',
    'The classic 3.52-mile Eastatoe Creek steep creek run from the US 178 bridge to Smith Creek above Lake Keowee. An astounding 230-foot-per-mile average gradient delivers continuous Class IV+ rapids with technical drops, boulder gardens, slides, and small waterfalls. The creek flows through the protected Eastatoe Creek Heritage Preserve, adding ecological significance to the paddling experience. Rain-dependent with no gauge—visual inspection and recent rainfall data guide timing. Expert steep creeking skills essential.',
    35.0500000, -82.8122000,
    34.9960000, -82.8275000,
    'V',
    3.52,
    NULL,
    '["steep creek","expert","Heritage Preserve","230 ft/mi","technical","boulder gardens","slides","rain dependent","South Carolina"]',
    NULL,
    1
  );

-- ── Catawba River (Great Falls) sections (river_id=87) ────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    87,
    'Long Bypass Channel',
    'Long Bypass (Class II–III)',
    'The 2-mile Long Bypass Channel at Great Falls—a wide, continuous whitewater run through a recovering riverbed that was dewatered for decades. Multiple routes through standing waves, shoals, and obstacles (including standing dead trees from the dewatering era) create a unique, big-water experience. Class II+ to III at base flows, pushing to solid III at higher releases. Check Duke Energy''s schedule for flow information.',
    34.6100000, -80.8800000,
    34.5900000, -80.8950000,
    'III',
    2.00,
    '02147310',
    '["Long Bypass","big water","Duke Energy","restored","unique","intermediate","South Carolina"]',
    NULL,
    1
  ),
  (
    87,
    'Short Bypass Channel',
    'Short Bypass (Class III–IV)',
    'The steeper, more concentrated Short Bypass Channel at Great Falls. Available only during scheduled recreational releases, this shorter run delivers Class III–IV rapids with larger drops and more powerful features than the Long Bypass. At higher flows (3,000+ cfs), the channel produces excellent big-water play. Advanced paddlers seeking more challenge should target this channel during release events.',
    34.6050000, -80.8850000,
    34.5900000, -80.8950000,
    'IV',
    1.00,
    '02147310',
    '["Short Bypass","advanced","dam release","big water","scheduled releases","Duke Energy","South Carolina"]',
    NULL,
    2
  );

-- ── Thompson River section (river_id=88) ──────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    88,
    'Musterground Road to Lake Jocassee',
    'Main Run (Musterground to Jocassee)',
    'The full 0.7-mile Thompson River steep creek descent from the Musterground Road culvert to Lake Jocassee. An astounding 378-foot drop in under a mile delivers continuous steep slides and small waterfalls with powerful hydraulics and no easy escape once committed. Access requires a 4WD vehicle and the road is only open seasonally. The takeout into Lake Jocassee requires a boat shuttle. Expert-only—one of the steepest commonly paddled runs in the Southeast.',
    35.0100000, -82.9600000,
    35.0000000, -82.9700000,
    'V',
    0.70,
    NULL,
    '["steep creek","expert","extreme gradient","378 ft drop","slides","seasonal access","Lake Jocassee","committed","South Carolina"]',
    NULL,
    1
  );

-- ── Edisto River sections (river_id=89) ───────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    89,
    'Green Pond Church to Colleton State Park',
    'Upper Trail (Green Pond to Colleton SP)',
    'The first ~15-mile segment of the ERCK Trail from Green Pond Church Landing to Colleton State Park. Classic blackwater paddling through cypress-tupelo swamp with tea-colored water, Spanish moss, and abundant wildlife. Colleton State Park provides camping, restrooms, and river access for overnight trips. A gentle Class I float suitable for all skill levels.',
    33.1270000, -80.6129000,
    33.0419000, -80.6428000,
    'I',
    15.00,
    '02175000',
    '["blackwater","ERCK Trail","camping","Colleton State Park","wildlife","family","scenic","South Carolina"]',
    1,
    1
  ),
  (
    89,
    'Colleton State Park to Givhans Ferry State Park',
    'Middle Trail (Colleton to Givhans Ferry)',
    'The classic 23-mile heart of the ERCK Trail from Colleton State Park to Givhans Ferry State Park—widely regarded as the most scenic section of the Edisto. Features the iconic Edisto treehouses for overnight camping, pristine blackwater scenery, and sandbars for swimming and relaxation. This stretch is the quintessential South Carolina multi-day paddling experience.',
    33.0419000, -80.6428000,
    33.0474000, -80.3914000,
    'I',
    23.00,
    '02175000',
    '["blackwater","treehouses","multi-day","Givhans Ferry","camping","scenic","iconic","ERCK Trail","South Carolina"]',
    1,
    2
  ),
  (
    89,
    'Givhans Ferry to Lowndes Landing',
    'Lower Trail (Givhans Ferry to Lowndes)',
    'The final ~19-mile segment of the ERCK Trail from Givhans Ferry State Park to Lowndes Landing. The river widens as it approaches the coast, with tidal influence becoming apparent in the lower reaches. Scenic Lowcountry paddling with abundant waterfowl, live oaks, and marshland transitions. A fitting conclusion to the full ERCK Trail experience.',
    33.0474000, -80.3914000,
    32.9446000, -80.3792000,
    'I',
    19.00,
    '02175000',
    '["blackwater","Lowcountry","tidal","scenic","ERCK Trail","Lowndes Landing","waterfowl","South Carolina"]',
    1,
    3
  );

-- ── Little River section (river_id=90) ────────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    90,
    'Rocky Bottom to Lake Keowee',
    'Main Run (Rocky Bottom to Keowee)',
    'The classic 5-mile Little River run from Rocky Bottom downstream toward Lake Keowee. Class III–IV whitewater with technical rapids, boulder gardens, and ledges through a scenic, forested gorge in the Jocassee Gorges. Rain-dependent and best after significant rainfall. Pairs well with nearby Eastatoe Creek for a full day of Upstate creeking.',
    35.0400000, -82.8200000,
    35.0200000, -82.8300000,
    'IV',
    5.00,
    '02186000',
    '["Jocassee Gorges","rain dependent","boulder gardens","technical","Upstate","scenic","South Carolina"]',
    NULL,
    1
  );

-- =============================================================
-- Georgia Rivers (from 011_ga_seed_data.sql)
-- =============================================================

-- =============================================================
-- Georgia Rivers (IDs 91–100)
-- Note: Chattooga River already exists as ID 5 in 003_aw_seed_data.sql
--       (listed as South Carolina/Georgia)
--       Ocoee River already exists as ID 3 in 003_aw_seed_data.sql
--       (headwaters originate in GA; main run in TN)
-- =============================================================
INSERT INTO rivers (id, name, state, region, lat, lng, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, description, usgs_site_id, tags, is_runnable) VALUES
  -- 91. Tallulah River (Gorge) — AW: Class IV–V, scheduled dam releases
  (
    91,
    'Tallulah River (Gorge)',
    'Georgia',
    'Rabun County / Tallulah Gorge State Park',
    34.7332000, -83.3935000,
    34.7388000, -83.3950000,
    34.7245000, -83.3543000,
    'V',
    2.50,
    'One of the most spectacular and challenging whitewater runs in the Southeast. The Tallulah River drops through the 1,000-foot-deep Tallulah Gorge in northeast Georgia during scheduled dam releases—typically the first two weekends in April and the first three weekends in November. Flows of 500 cfs (Saturday) and 700 cfs (Sunday) transform this normally dry gorge into a Class IV–V whitewater gauntlet featuring massive drops, powerful hydraulics, and iconic rapids including Oceana, Gauntlet, Tom''s Brain Buster, and Twisted Sister. Access requires descending approximately 600 stairs into the gorge from Tallulah Gorge State Park, and there is no easy walk-out once committed. Mandatory registration and safety checks at the park. Expert-only with serious consequences—organized by American Whitewater in partnership with Georgia Power and Georgia State Parks.',
    '02178400',
    '["gorge","Class V","expert","dam release","scheduled release","state park","1000-foot gorge","April","November","American Whitewater","Georgia"]',
    NULL
  ),
  -- 92. Chattahoochee River (Helen Section) — AW: Class I–II mountain run
  (
    92,
    'Chattahoochee River (Helen Section)',
    'Georgia',
    'White County / Helen',
    34.7008000, -83.7294000,
    34.7260000, -83.7300000,
    34.6700000, -83.7250000,
    'II',
    6.00,
    'The headwaters of the mighty Chattahoochee flow through the Alpine-themed village of Helen in the Blue Ridge Mountains of northeast Georgia, offering a scenic Class I–II mountain river experience. The approximately 6-mile run from above Helen to below town features gentle rapids, small shoals, and playful riffles—ideal for beginners, families, and tubers. During higher flows after rainfall, some features push into Class II+ with fun standing waves and surfable features. Multiple outfitters in Helen offer tube and kayak rentals, making this one of the most accessible whitewater experiences in Georgia. The cold, clear mountain water and surrounding Blue Ridge scenery create a quintessential North Georgia paddling experience.',
    '02330450',
    '["beginner","family","tubing","Helen","Blue Ridge","scenic","mountain","Chattahoochee","accessible","outfitters","Georgia"]',
    1
  ),
  -- 93. Cartecay River — AW: Class II–III, popular intermediate run near Ellijay
  (
    93,
    'Cartecay River',
    'Georgia',
    'Gilmer County / Ellijay',
    34.6841000, -84.4588000,
    34.6500000, -84.4100000,
    34.7100000, -84.4800000,
    'III',
    8.00,
    'One of the most popular intermediate whitewater runs in North Georgia, the Cartecay River flows through the apple country of Gilmer County near Ellijay. The classic 8-mile section from Lower Cartecay Road to Stegall Mill Road features continuous Class II–III rapids with fun ledges, waves, and technical boulder gardens that keep intermediate paddlers engaged. The river is rain-dependent and rises quickly after storms, offering exciting windows of paddling—at higher flows, several rapids push into solid Class III with powerful hydraulics. The Cartecay is a favorite among Atlanta-area paddlers for weekend whitewater trips, with multiple put-in and take-out options allowing flexible trip lengths. The scenic North Georgia mountain setting and proximity to the charming town of Ellijay add to the appeal.',
    '02379500',
    '["intermediate","Ellijay","rain dependent","popular","Atlanta","Class III","boulder gardens","ledges","apple country","Georgia"]',
    NULL
  ),
  -- 94. Etowah River — AW: Class I–II, scenic mountain run near Dahlonega
  (
    94,
    'Etowah River',
    'Georgia',
    'Lumpkin & Dawson Counties / Dahlonega',
    34.5197000, -84.0278000,
    34.5600000, -84.0000000,
    34.4800000, -84.0500000,
    'II',
    12.00,
    'A scenic mountain river flowing from the gold country around Dahlonega through the foothills of the Blue Ridge Mountains. The upper Etowah offers approximately 12 miles of Class I–II whitewater with gentle rapids, riffles, and small shoals through wooded mountain scenery. The sections near Dahlonega and through Dawson Forest Wildlife Management Area provide a relaxed paddling experience suitable for beginners and families. At higher flows after rainfall, some features develop into playful Class II rapids with small waves and ledges. The Etowah is one of the longest rivers originating in the Georgia mountains, eventually flowing into Lake Allatoona. A great introduction to North Georgia river paddling with easy access and beautiful scenery.',
    '02389050',
    '["beginner","family","Dahlonega","gold country","scenic","Blue Ridge","Dawson Forest","mountain","gentle","Georgia"]',
    1
  ),
  -- 95. Amicalola Creek — AW: Class II–IV, steep creek near Dawsonville
  (
    95,
    'Amicalola Creek',
    'Georgia',
    'Dawson County / Dawsonville',
    34.4256000, -84.2119000,
    34.4260000, -84.2127000,
    34.3555000, -84.2064000,
    'IV',
    8.50,
    'A quality intermediate-to-advanced creek run flowing from the Amicalola Falls area through the Dawson Forest Wildlife Management Area near Dawsonville. The approximately 8.5-mile run from Highway 53 to Kelly Bridge features Class II–IV rapids with notable drops including "The Ledge" and "Devil''s Elbow," along with continuous boulder gardens, ledges, and playful hydraulics. The creek is rain-dependent and rises quickly after storms in the Blue Ridge foothills. At optimal flows, Amicalola Creek provides an exciting progression from Class II warm-up rapids to increasingly technical Class III–IV drops through a scenic mountain creek corridor. The Dawson Forest WMA provides public access and a beautiful natural setting. Popular among Atlanta-area paddlers seeking quality creeking within easy driving distance.',
    '02390000',
    '["creek","intermediate","advanced","Dawsonville","Dawson Forest","rain dependent","ledges","drops","Atlanta","Georgia"]',
    NULL
  ),
  -- 96. Toccoa River — AW: Class I–II, scenic canoe trail near Blue Ridge
  (
    96,
    'Toccoa River',
    'Georgia',
    'Fannin County / Blue Ridge',
    34.7403000, -84.1406000,
    34.7403000, -84.1406000,
    34.7871000, -84.2387000,
    'II',
    13.80,
    'A beautiful mountain river flowing through the Blue Ridge Mountains of Fannin County, offering one of North Georgia''s premier scenic canoe and kayak trails. The classic 13.8-mile Toccoa River Canoe Trail from Deep Hole Recreation Area to Sandy Bottoms features gentle Class I–II rapids, riffles, and scenic mountain views through National Forest land. The river is popular with families, anglers, and recreational paddlers seeking a relaxed day on the water. Flows are influenced by Blue Ridge Dam upstream, managed by TVA—check the dam release schedule for optimal conditions. The Toccoa River eventually flows into Tennessee where it becomes the famous Ocoee River. Multiple campgrounds along the route offer overnight options for multi-day trips. The iconic Swinging Bridge provides a scenic midway landmark.',
    '03558000',
    '["canoe trail","scenic","family","Blue Ridge","mountain","National Forest","TVA","dam release","fishing","Swinging Bridge","Georgia"]',
    1
  ),
  -- 97. Conasauga River — AW: Class III–IV, Cohutta Wilderness
  (
    97,
    'Conasauga River',
    'Georgia',
    'Murray County / Cohutta Wilderness',
    34.8756000, -84.6256000,
    34.8220000, -84.6500000,
    34.8320000, -84.6290000,
    'IV',
    5.50,
    'One of the most remote and challenging whitewater runs in Georgia, the Conasauga River flows through the heart of the Cohutta Wilderness—the largest National Forest Wilderness area in the Southeast. The approximately 5.5-mile run from Chicken Coop Gap to East Cowpen Road features continuous Class III–IV rapids (with some Class V potential at very high flows) through a rugged wilderness gorge with boulder gardens, ledges, cliff-lined banks, and powerful hydraulics. Signature rapids include "Room of Doom" (also called "Boof or Consequences") and "Whale Tail." Access requires a significant hike-in with gear to the put-in, and there is no road access along the run—complete wilderness self-sufficiency is essential. The river is rain-dependent with no direct gauge; paddlers correlate nearby gauges and recent rainfall to estimate flows. Expert-only with significant commitment and consequences. A bucket-list run for Southeast wilderness paddlers.',
    NULL,
    '["wilderness","Cohutta","expert","Class IV","remote","hike-in","National Forest","boulder gardens","committed","Room of Doom","Georgia"]',
    NULL
  ),
  -- 98. Chestatee River — AW: Class I–III, mountain creek near Dahlonega
  (
    98,
    'Chestatee River',
    'Georgia',
    'Lumpkin County / Dahlonega',
    34.5281000, -83.9397000,
    34.5500000, -83.9200000,
    34.5000000, -83.9600000,
    'III',
    7.00,
    'A scenic North Georgia mountain river flowing through the gold-mining country of Lumpkin County near Dahlonega. The Chestatee offers approximately 7 miles of Class I–III whitewater with shoals, ledges, and playful rapids through wooded mountain scenery. The river is rain-dependent and provides its best whitewater after significant rainfall, when features push into solid Class II–III with fun waves and technical moves through boulder gardens. At lower flows, the run is a pleasant Class I–II float. The Chestatee flows through scenic countryside with limited development, eventually joining the Chattahoochee River at Lake Lanier. A quality option for intermediate paddlers visiting the Dahlonega area, pairing well with nearby Etowah River runs for a full weekend of North Georgia paddling.',
    '02333500',
    '["Dahlonega","mountain","rain dependent","intermediate","gold country","scenic","Lumpkin County","shoals","boulder gardens","Georgia"]',
    NULL
  ),
  -- 99. Broad River (Georgia) — AW: Class II–III, Watson Mill Bridge area
  (
    99,
    'Broad River (Georgia)',
    'Georgia',
    'Madison & Elbert Counties / Watson Mill Bridge',
    34.0150000, -83.0800000,
    34.0300000, -83.1000000,
    33.9900000, -83.0500000,
    'III',
    6.00,
    'A fun intermediate whitewater river flowing through the rolling Piedmont of northeast Georgia near Watson Mill Bridge State Park. The classic 6-mile run from Highway 281 (Broad River Outpost) to Highway 172 features Class II–III rapids with surfable waves, playful ledges, and lively shoals—one of the best intermediate whitewater experiences in the Georgia Piedmont. At moderate flows, the river provides continuous fun with several named rapids and excellent play spots. Nearby tributaries Skull Shoal Creek (Class III) and Big Clouds Creek (Class III) add additional options for paddlers seeking more challenge. The Broad River Outpost provides kayak and canoe rentals, shuttles, and camping, making this an accessible whitewater destination for paddlers of all backgrounds. Watson Mill Bridge State Park offers camping and the iconic covered bridge.',
    '02191743',
    '["Watson Mill Bridge","intermediate","Piedmont","outpost","rentals","surfing","ledges","state park","covered bridge","accessible","Georgia"]',
    NULL
  ),
  -- 100. Mountaintown Creek — AW: Class I–II, scenic creek near Ellijay
  (
    100,
    'Mountaintown Creek',
    'Georgia',
    'Gilmer County / Ellijay',
    34.7031000, -84.5394000,
    34.7509000, -84.5563000,
    34.6648000, -84.5649000,
    'II',
    9.00,
    'A scenic mountain creek flowing from the Cohutta Mountains through Gilmer County toward the Ellijay River. The approximately 9-mile run from Highway 52 to Highway 282 features gentle Class I–II rapids with small shoals, riffles, and occasional ledges through a beautifully wooded mountain valley. The creek is rain-dependent and provides its best paddling after significant rainfall when flows fill the narrow channel. The Mountaintown Creek corridor passes through a mix of National Forest and private land with excellent scenery and wildlife viewing. A relaxing paddle that pairs well with the nearby Cartecay River for a full day of Gilmer County creek exploration. Suitable for beginners and families at normal flows.',
    NULL,
    '["creek","beginner","family","scenic","Ellijay","Cohutta Mountains","Gilmer County","rain dependent","gentle","Georgia"]',
    NULL
  );

-- =============================================================
-- Georgia River Sections
-- =============================================================

-- ── Tallulah River (Gorge) sections (river_id=91) ────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    91,
    'Tallulah Gorge (Dam to Lake Tugaloo)',
    'Gorge Run (Dam to Tugaloo)',
    'The legendary 2.5-mile Tallulah Gorge run from below Tallulah Falls Dam to Lake Tugaloo. Class IV–V whitewater through a 1,000-foot-deep gorge featuring massive drops, powerful hydraulics, and iconic rapids including Oceana, Gauntlet, Tom''s Brain Buster, and Twisted Sister. Available only during scheduled releases—typically April and November weekends. Access via 600 stairs into the gorge from Tallulah Gorge State Park. No easy walk-out once committed. Mandatory registration and expert-only.',
    34.7388000, -83.3950000,
    34.7245000, -83.3543000,
    'V',
    2.50,
    '02178400',
    '["gorge","expert","Class V","dam release","scheduled","April","November","committed","iconic","Georgia"]',
    NULL,
    1
  );

-- ── Chattahoochee (Helen) sections (river_id=92) ─────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    92,
    'Helen to Nacoochee',
    'Helen Section (Helen to Nacoochee)',
    'The classic 6-mile Chattahoochee run through Helen and downstream toward Nacoochee Valley. Gentle Class I–II rapids with small shoals, riffles, and playful features through the scenic Alpine-themed village and into the broader valley below. Multiple outfitters offer rentals and shuttle. Perfect for families, beginners, and tubers seeking a fun mountain river experience.',
    34.7260000, -83.7300000,
    34.6700000, -83.7250000,
    'II',
    6.00,
    '02330450',
    '["Helen","beginner","family","tubing","outfitters","scenic","mountain","Nacoochee","Georgia"]',
    1,
    1
  );

-- ── Cartecay River sections (river_id=93) ─────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    93,
    'Lower Cartecay Road to Stegall Mill Road',
    'Classic Run (Lower Cartecay to Stegall Mill)',
    'The most popular Cartecay River whitewater section—approximately 8 miles of continuous Class II–III rapids from Lower Cartecay Road to Stegall Mill Road near Ellijay. Fun ledges, waves, and boulder gardens keep intermediate paddlers engaged throughout. At higher flows, several rapids push into solid Class III with powerful hydraulics. Rain-dependent—best after significant rainfall. The go-to intermediate run for Atlanta-area paddlers visiting Ellijay.',
    34.6500000, -84.4100000,
    34.7100000, -84.4800000,
    'III',
    8.00,
    '02379500',
    '["intermediate","popular","Ellijay","rain dependent","Class III","boulder gardens","Atlanta","Georgia"]',
    NULL,
    1
  );

-- ── Amicalola Creek sections (river_id=95) ────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    95,
    'Highway 53 to Kelly Bridge',
    'Main Run (Hwy 53 to Kelly Bridge)',
    'The classic 8.5-mile Amicalola Creek run from Highway 53 to Kelly Bridge near the Etowah River confluence. Class II–IV rapids including notable drops "The Ledge" and "Devil''s Elbow," plus continuous boulder gardens and ledges through the Dawson Forest WMA. The run progresses from Class II warm-up rapids to increasingly technical Class III–IV drops. Rain-dependent—rises quickly after storms. A quality creeking run within easy reach of Atlanta.',
    34.4260000, -84.2127000,
    34.3555000, -84.2064000,
    'IV',
    8.50,
    '02390000',
    '["creek","intermediate","advanced","Dawson Forest","rain dependent","The Ledge","Devil''s Elbow","Atlanta","Georgia"]',
    NULL,
    1
  );

-- ── Toccoa River sections (river_id=96) ───────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    96,
    'Deep Hole to Sandy Bottoms',
    'Canoe Trail (Deep Hole to Sandy Bottoms)',
    'The classic 13.8-mile Toccoa River Canoe Trail from Deep Hole Recreation Area to Sandy Bottoms. Gentle Class I–II rapids, scenic mountain views, and passage through National Forest land. Flows influenced by Blue Ridge Dam—check TVA release schedule. The iconic Swinging Bridge serves as a scenic midway landmark. Popular with families, anglers, and recreational paddlers. Multiple campgrounds along the route support overnight trips.',
    34.7403000, -84.1406000,
    34.7871000, -84.2387000,
    'II',
    13.80,
    '03558000',
    '["canoe trail","family","scenic","Swinging Bridge","National Forest","Blue Ridge","TVA","camping","Georgia"]',
    1,
    1
  );

-- ── Conasauga River section (river_id=97) ─────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    97,
    'Chicken Coop Gap to East Cowpen Road',
    'Wilderness Run (Chicken Coop to East Cowpen)',
    'The classic 5.5-mile Conasauga River wilderness run from Chicken Coop Gap to East Cowpen Road through the heart of the Cohutta Wilderness. Continuous Class III–IV rapids with boulder gardens, ledges, and powerful hydraulics through a rugged, roadless gorge. Signature rapids include "Room of Doom" and "Whale Tail." Requires a significant hike-in with gear to the put-in. No road access along the run—complete wilderness self-sufficiency essential. Rain-dependent with no direct gauge. Expert-only with serious commitment and consequences.',
    34.8220000, -84.6500000,
    34.8320000, -84.6290000,
    'IV',
    5.50,
    NULL,
    '["wilderness","Cohutta","expert","hike-in","Room of Doom","Whale Tail","committed","remote","rain dependent","Georgia"]',
    NULL,
    1
  );

-- ── Broad River (GA) section (river_id=99) ────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    99,
    'Outpost to Highway 172',
    'Classic Run (Hwy 281 to Hwy 172)',
    'The most popular 6-mile Broad River whitewater section from the Broad River Outpost (Highway 281) to Highway 172. Class II–III rapids with surfable waves, playful ledges, and lively shoals through the scenic Georgia Piedmont. The Broad River Outpost provides rentals, shuttles, and camping. Watson Mill Bridge State Park offers additional access and the iconic covered bridge. A fun, accessible intermediate whitewater experience.',
    34.0300000, -83.1000000,
    33.9900000, -83.0500000,
    'III',
    6.00,
    '02191743',
    '["Watson Mill Bridge","Broad River Outpost","intermediate","surfing","ledges","Piedmont","accessible","Georgia"]',
    NULL,
    1
  );

-- =============================================================
-- New York Rivers (from 012_ny_seed_data.sql)
-- =============================================================

-- =============================================================
-- New York Rivers (IDs 101–110)
-- Note: Delaware Water Gap already exists as ID 35 in 005_pa_seed_data.sql
--       (listed as Pennsylvania; the river also borders NY)
-- =============================================================
INSERT INTO rivers (id, name, state, region, lat, lng, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, description, usgs_site_id, tags, is_runnable) VALUES
  -- 101. Hudson River Gorge — AW: Class III–IV, premier Adirondack run
  (
    101,
    'Hudson River Gorge',
    'New York',
    'Essex & Warren Counties / Adirondacks',
    43.7500000, -74.1000000,
    43.8300000, -74.2700000,
    43.7009000, -73.9832000,
    'IV',
    17.00,
    'One of the most scenic and classic whitewater runs in the Northeast. The Hudson River Gorge flows 17 miles through a remote section of the Adirondack Mountains from Indian Lake to North Creek, featuring continuous Class III–IV rapids through a spectacular gorge. Key rapids include The Narrows—a quarter-mile-long Class IV canyon section—along with Blue Ledge, Harris Rift, and Ord Falls. Spring snowmelt and scheduled dam releases from Indian Lake Dam provide optimal flows from April through June. The run is a favorite among rafting companies and experienced kayakers alike, offering big water, beautiful scenery, and a true wilderness experience in the heart of the Adirondack Park. The Hudson River-Black River Regulating District manages flow releases.',
    '01315500',
    '["gorge","Adirondacks","classic","big water","scenic","dam release","wilderness","The Narrows","spring","rafting","New York"]',
    NULL
  ),
  -- 102. Black River — AW: Class II–V, Watertown big-water dam release run
  (
    102,
    'Black River',
    'New York',
    'Jefferson County / Watertown',
    43.9858000, -75.9246000,
    43.9700000, -75.9100000,
    44.0100000, -75.9500000,
    'V',
    8.00,
    'A powerful big-water river flowing through Watertown in northern New York, the Black River is one of the Northeast''s premier whitewater destinations. The main 8-mile Watertown-to-Brownville section features Class III–V rapids with powerful waves, hydraulics, and excellent play features. Dam-regulated flows from upstream reservoirs provide reliable whitewater from spring through fall, with significant diurnal fluctuations creating diverse paddling conditions. The iconic Route 3 Wave in downtown Watertown is a Class II warm-up and famous surf spot. Multiple outfitters offer guided rafting trips. The river attracts kayakers from across the region seeking big-volume Northeastern whitewater with easy urban access.',
    '04260500',
    '["big water","Watertown","dam release","urban","play","surf wave","Route 3 Wave","rafting","powerful","New York"]',
    NULL
  ),
  -- 103. Moose River — AW: Class II–V, multi-section Adirondack classic
  (
    103,
    'Moose River',
    'New York',
    'Herkimer & Lewis Counties / Adirondacks',
    43.6797000, -75.0947000,
    43.6797000, -75.0947000,
    43.6131000, -75.3367000,
    'V',
    21.00,
    'A legendary multi-section Adirondack whitewater river offering everything from family-friendly Class II to expert-only Class V. The Moose River features three distinct sections: the Middle Moose (Class II–III, McKeever to Rock Island, ~7 miles), the Lower Moose (Class III–V, Rock Island to Fowlersville, ~8 miles), and the iconic Bottom Moose (Class V, Fowlersville to Lyons Falls, ~5.7 miles). The Bottom Moose is one of the most famous Class V runs in the Northeast, featuring pool-drop rapids including Fowlersville Falls, Funnel, Knife''s Edge, Double Drop, Agers Falls, Shurform, Powerline, and Crystal. Best run during spring snowmelt or scheduled dam releases. The annual "Moose Fest" festival (October) draws expert paddlers from across the country.',
    '04254500',
    '["Adirondacks","multi-section","Class V","expert","pool-drop","Moose Fest","dam release","spring","iconic","waterfalls","New York"]',
    NULL
  ),
  -- 104. Beaver River — AW: Class III–V, dam-release steep creek sections
  (
    104,
    'Beaver River',
    'New York',
    'Lewis County / Croghan',
    43.8972000, -75.4043000,
    43.9271000, -75.3115000,
    43.8700000, -75.4500000,
    'V',
    6.50,
    'A technical dam-release creek in Lewis County featuring three distinct whitewater sections—Taylorville, Moshier, and Eagle—each offering progressively steeper and more challenging rapids. The Taylorville section (Class III–IV, ~2 miles) features six rapids including a dramatic 30-foot slide. The Moshier section (Class IV–V, ~3 miles) highlights two waterfalls and a technical Class V rapid. The Eagle section (Class V, ~1 mile) drops an astounding 475 feet per mile with four intense Class V rapids—one of the steepest commonly paddled runs in the Northeast. All sections require scheduled dam releases (~11 per year). The annual "BeaverFest" film festival and paddling event celebrates this unique river. Expert skills essential for Moshier and Eagle.',
    '04258000',
    '["steep creek","dam release","BeaverFest","expert","Taylorville","Moshier","Eagle","waterfalls","475 ft/mi","technical","New York"]',
    NULL
  ),
  -- 105. Raquette River — AW: Class IV–V, Stone Valley expert run
  (
    105,
    'Raquette River',
    'New York',
    'St. Lawrence County / Colton',
    44.5400000, -74.9300000,
    44.5400000, -74.9200000,
    44.5200000, -74.9500000,
    'V',
    2.95,
    'The Stone Valley section of the Raquette River near Colton is one of the premier Class IV–V whitewater runs in the Adirondacks. This short but intense 2.95-mile stretch drops through a steep gorge with an average gradient of 213 feet per mile through the signature "Particle Accelerator" rapid. Other notable rapids include Colton Falls, The Narrows, and The Tubs. The run is available during scheduled dam releases from the Colton hydroelectric facility, typically July through September. Put-in is at the base of the dam in Colton with take-out at Lenny Road near Brown Bridge Road. Expert paddlers only—the continuous gradient and powerful hydraulics demand solid Class V skills.',
    '04267500',
    '["Stone Valley","expert","Class V","dam release","Colton","Particle Accelerator","steep","Adirondacks","scheduled release","New York"]',
    NULL
  ),
  -- 106. Salmon River — AW: Class II–III, dam-release run near Pulaski
  (
    106,
    'Salmon River',
    'New York',
    'Oswego County / Pulaski',
    43.5312000, -76.0377000,
    43.5100000, -76.0200000,
    43.5658000, -76.1278000,
    'III',
    10.00,
    'A popular dam-release whitewater river flowing from the Salmon River Reservoir through the Tug Hill Plateau to Lake Ontario near Pulaski. The approximately 10-mile run from Lighthouse Hill (Altmar) to Pulaski features Class II–III rapids with fun waves, play spots, and ledges. Hydroelectric releases from the reservoir provide reliable flows, with scheduled whitewater releases drawing paddlers on weekends during festivals and special events. The Salmon River is also world-renowned for its fall and spring steelhead and salmon fishing runs, creating a unique multi-use river experience. The Pineville gauge is the primary flow reference for paddlers planning trips.',
    '04250200',
    '["dam release","Pulaski","Tug Hill","fishing","steelhead","salmon","play spots","intermediate","Pineville","New York"]',
    NULL
  ),
  -- 107. Ausable River (West Branch) — AW: Class I–V+, Wilmington Flume
  (
    107,
    'Ausable River (West Branch)',
    'New York',
    'Essex County / Wilmington',
    44.3885000, -73.8176000,
    44.3885000, -73.8176000,
    44.4414000, -73.6755000,
    'V+',
    11.00,
    'The West Branch of the Ausable River in the High Peaks region of the Adirondacks offers a diverse 11-mile run from Wilmington to Au Sable Forks with one of the most famous features in Northeast whitewater—the Wilmington Flume. This quarter-mile-long Class V+ slot canyon features steep walls, powerful hydraulics, and expert-only drops through a narrow rock gorge. The broader Wilmington to Au Sable Forks section is predominantly Class I–III+ with continuous rapids, waves, and scenic mountain views flowing past Whiteface Mountain. The river is snow-fed and rain-dependent, running best during spring snowmelt from April through June. The Flume itself should only be attempted by expert paddlers with solid Class V skills and appropriate safety gear.',
    '04275500',
    '["Wilmington Flume","Class V","expert","Adirondacks","High Peaks","Whiteface","slot canyon","spring","snow-fed","scenic","New York"]',
    NULL
  ),
  -- 108. Boquet River — AW: Class II–IV, Adirondack intermediate run
  (
    108,
    'Boquet River',
    'New York',
    'Essex County / Elizabethtown',
    44.2164000, -73.5975000,
    44.1800000, -73.5500000,
    44.2500000, -73.6500000,
    'IV',
    16.60,
    'A scenic Adirondack river flowing through Essex County from Elizabethtown toward Lake Champlain, offering a solid intermediate-to-advanced whitewater experience. The main Northway to Boquet section covers approximately 16.6 miles of Class II–IV rapids with beautiful scenery, technical features, and continuous action through the Adirondack foothills. Additional sections include the North Branch (Class III–IV, 6 miles) and the challenging Boquet to Willsboro stretch (Class II–V, 22.7 miles). The river is rain and snowmelt dependent, running best during spring runoff. A quality Adirondack river that offers more solitude than the heavily-trafficked Hudson Gorge while delivering excellent whitewater for skilled paddlers.',
    '04276208',
    '["Adirondacks","Elizabethtown","intermediate","advanced","Champlain","scenic","spring","multi-section","Essex County","New York"]',
    NULL
  ),
  -- 109. Esopus Creek — AW: Class II–III, Catskills classic
  (
    109,
    'Esopus Creek',
    'New York',
    'Ulster County / Phoenicia / Catskills',
    42.0145000, -74.2702000,
    42.0800000, -74.3200000,
    41.9700000, -74.2200000,
    'III',
    7.00,
    'The premier whitewater creek in the Catskill Mountains, the Esopus offers approximately 7 miles of continuous Class II–III rapids from the Shandaken Tunnel outlet to Phoenicia. Water releases from the NYC water supply system via the Shandaken Tunnel supplement natural flows, providing reliable whitewater from spring through fall—especially on scheduled weekend releases from May through September. The run features continuous waves, ledges, and technical rapids through a scenic Catskill Mountain valley along Route 28. The Esopus is popular with both kayakers and tubers, with several outfitters in Phoenicia offering rentals and shuttles. A great intermediate run with easy road access and consistent flows—one of the most accessible quality whitewater runs near New York City.',
    '01362500',
    '["Catskills","Phoenicia","dam release","intermediate","consistent flow","NYC water supply","tubing","accessible","Route 28","scenic","New York"]',
    NULL
  ),
  -- 110. Sacandaga River — AW: Class II–V+, multi-section Adirondack run
  (
    110,
    'Sacandaga River',
    'New York',
    'Saratoga & Hamilton Counties / Hadley',
    43.3114000, -73.8672000,
    43.3300000, -73.8800000,
    43.2900000, -73.8500000,
    'V',
    24.00,
    'A versatile Adirondack whitewater river offering multiple sections from beginner-friendly to expert-only. The popular Lower Sacandaga (Stewart''s Bridge to Hadley, ~3.5 miles) features reliable Class II–III dam-release whitewater with fun waves, play spots, and easy access—the most commercially rafted section. Named rapids include The Swimming Hole, Graveyard, and The Dam Rapid. Flows of 1,200–2,500 cfs from Great Sacandaga Lake provide consistent whitewater from spring through fall. The Upper Sacandaga (Christine Falls to East Branch, ~7.5 miles) ramps up to Class III–V+ with significant gradient and powerful rapids through remote Adirondack scenery—suitable for expert paddlers only. The East Branch to Hope section (13 miles, Class II) offers a more relaxed paddling experience.',
    '01325000',
    '["Adirondacks","Hadley","dam release","multi-section","rafting","play spots","beginner","expert","reliable","Stewarts Bridge","New York"]',
    1
  );

-- =============================================================
-- New York River Sections
-- =============================================================

-- ── Hudson River Gorge section (river_id=101) ─────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    101,
    'Indian Lake to North Creek',
    'Gorge Run (Indian Lake to North Creek)',
    'The classic 17-mile Hudson River Gorge run from Indian Lake to North Creek through the heart of the Adirondack Mountains. Continuous Class III–IV rapids including The Narrows (Class IV canyon), Blue Ledge, Harris Rift, and Ord Falls. A true wilderness run with limited road access along the gorge. Best during spring snowmelt and scheduled dam releases from Indian Lake Dam (April–June). The premier big-water Adirondack whitewater experience.',
    43.8300000, -74.2700000,
    43.7009000, -73.9832000,
    'IV',
    17.00,
    '01315500',
    '["gorge","The Narrows","wilderness","big water","dam release","spring","Adirondacks","classic","New York"]',
    NULL,
    1
  );

-- ── Black River sections (river_id=102) ───────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    102,
    'Route 3 Wave',
    'Route 3 Wave (Urban Play Spot)',
    'The iconic Route 3 Wave in downtown Watertown—a short Class II urban surf spot famous for its powerful, reliable standing wave. One of the best play spots in the Northeast, accessible directly from the Route 3 bridge. Great warm-up before tackling the downstream whitewater section. Dam-regulated flows ensure consistent conditions.',
    43.9700000, -75.9100000,
    43.9700000, -75.9100000,
    'II',
    0.25,
    '04260500',
    '["play spot","surf wave","urban","Route 3","Watertown","accessible","dam release","New York"]',
    NULL,
    1
  ),
  (
    102,
    'Watertown to Brownville',
    'Main Run (Watertown to Brownville)',
    'The main 8-mile Black River whitewater section from Watertown downstream to Brownville. Class III–V big-water rapids with powerful waves, hydraulics, and excellent play features. Dam-regulated flows provide reliable whitewater. Multiple outfitters offer guided rafting trips on this section. Advanced to expert skills recommended at higher flows.',
    43.9700000, -75.9100000,
    44.0100000, -75.9500000,
    'V',
    8.00,
    '04260500',
    '["big water","advanced","expert","Watertown","Brownville","dam release","rafting","powerful","New York"]',
    NULL,
    2
  );

-- ── Moose River sections (river_id=103) ───────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    103,
    'Middle Moose',
    'Middle (McKeever to Rock Island)',
    'The family-friendly 7-mile Middle Moose section from the McKeever USGS gauge to Rock Island. Class II–III rapids suitable for beginner-to-intermediate paddlers from May through September. A great introduction to Adirondack whitewater with moderate rapids and beautiful scenery.',
    43.6797000, -75.0947000,
    43.6500000, -75.1800000,
    'III',
    7.00,
    '04254500',
    '["Middle Moose","beginner","intermediate","family","McKeever","scenic","Adirondacks","New York"]',
    NULL,
    1
  ),
  (
    103,
    'Lower Moose',
    'Lower (Rock Island to Fowlersville)',
    'The challenging 8-mile Lower Moose section from Rock Island to above Fowlersville Falls. Class III–V rapids featuring Iron Bridge, Rooster Tail, Mixmaster, Elevator Shaft, and Tannery. Runs primarily during spring snowmelt or scheduled dam releases in April. Prior solid whitewater experience strongly recommended.',
    43.6500000, -75.1800000,
    43.6300000, -75.2500000,
    'V',
    8.00,
    '04254500',
    '["Lower Moose","advanced","spring","dam release","Iron Bridge","Mixmaster","Elevator Shaft","New York"]',
    NULL,
    2
  ),
  (
    103,
    'Bottom Moose',
    'Bottom (Fowlersville to Lyons Falls)',
    'One of the most iconic Class V runs in the Northeast—5.7 miles of pool-drop whitewater from Fowlersville to Lyons Falls. Legendary rapids include Fowlersville Falls, Funnel, Knife''s Edge, Double Drop, Agers Falls, Shurform, Powerline, and Crystal. Accessible during spring snowmelt or scheduled releases, notably during "Moose Fest" weekend (October). Expert-only with serious consequences. A bucket-list run for Northeast steep creekers.',
    43.6300000, -75.2500000,
    43.6131000, -75.3367000,
    'V',
    5.70,
    '04254500',
    '["Bottom Moose","Class V","expert","iconic","Moose Fest","pool-drop","waterfalls","Agers Falls","Fowlersville Falls","New York"]',
    NULL,
    3
  );

-- ── Beaver River sections (river_id=104) ──────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    104,
    'Taylorville Section',
    'Taylorville (Class III–IV)',
    'The Taylorville section features approximately 2 miles with six Class III–IV rapids including a dramatic 30-foot slide. Suitable for strong intermediate paddlers looking for a steep creeking introduction. Requires scheduled dam releases—featured during BeaverFest events.',
    43.9271000, -75.3115000,
    43.9316000, -75.3677000,
    'IV',
    2.00,
    '04258000',
    '["Taylorville","intermediate","30-foot slide","dam release","BeaverFest","steep creek","New York"]',
    NULL,
    1
  ),
  (
    104,
    'Moshier Section',
    'Moshier (Class IV–V)',
    'The Moshier section covers approximately 3 miles with two waterfalls and a technical Class V rapid. Recommended for expert or very experienced intermediate kayakers. The highlight section of the Beaver River during dam release events.',
    43.9316000, -75.3677000,
    43.9100000, -75.4000000,
    'V',
    3.00,
    '04258000',
    '["Moshier","expert","waterfalls","Class V","technical","dam release","BeaverFest","New York"]',
    NULL,
    2
  ),
  (
    104,
    'Eagle Section',
    'Eagle (Class V)',
    'The Eagle section is the most extreme—approximately 1 mile dropping an astounding 475 feet per mile with four intense Class V rapids. One of the steepest commonly paddled runs in the Northeast. Expert-only during scheduled dam releases.',
    43.9100000, -75.4000000,
    43.8700000, -75.4500000,
    'V',
    1.00,
    '04258000',
    '["Eagle","expert","extreme","475 ft/mi","Class V","steepest","dam release","BeaverFest","New York"]',
    NULL,
    3
  );

-- ── Raquette River section (river_id=105) ─────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    105,
    'Stone Valley (Colton to Brown Bridge)',
    'Stone Valley (Colton Dam to Brown Bridge)',
    'The legendary 2.95-mile Stone Valley section from the Colton Dam to Lenny Road near Brown Bridge. Class IV–V whitewater with an average 213-foot-per-mile gradient through the Particle Accelerator. Other major rapids include Colton Falls, The Narrows, and The Tubs. Available during scheduled dam releases July through September. Expert-only with continuous, powerful rapids.',
    44.5400000, -74.9200000,
    44.5200000, -74.9500000,
    'V',
    2.95,
    '04267500',
    '["Stone Valley","Particle Accelerator","expert","Class V","dam release","Colton","steep","continuous","New York"]',
    NULL,
    1
  );

-- ── Esopus Creek section (river_id=109) ───────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    109,
    'Shandaken Tunnel to Phoenicia',
    'Phoenicia Run (Tunnel to Phoenicia)',
    'The classic 7-mile Esopus Creek run from the Shandaken Tunnel outlet to Phoenicia. Continuous Class II–III rapids with waves, ledges, and technical features through a scenic Catskill Mountain valley along Route 28. Water releases from the NYC water supply system provide reliable flows—especially scheduled weekend releases May through September. Popular with both kayakers and tubers. Multiple outfitters in Phoenicia offer rentals and shuttles.',
    42.0800000, -74.3200000,
    41.9700000, -74.2200000,
    'III',
    7.00,
    '01362500',
    '["Phoenicia","Shandaken Tunnel","Catskills","intermediate","dam release","consistent flow","tubing","scenic","New York"]',
    NULL,
    1
  );

-- ── Sacandaga River sections (river_id=110) ───────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    110,
    'Lower Sacandaga (Stewarts Bridge to Hadley)',
    'Lower (Stewarts Bridge to Hadley)',
    'The most popular 3.5-mile Lower Sacandaga section from Stewart''s Bridge Dam to Hadley. Reliable Class II–III dam-release whitewater with fun waves, play spots, and easy access. Named rapids include The Swimming Hole, Graveyard, and The Dam Rapid. Flows of 1,200–2,500 cfs provide consistent whitewater spring through fall. The most commercially rafted section and a great intermediate run.',
    43.3300000, -73.8800000,
    43.2900000, -73.8500000,
    'III',
    3.50,
    '01325000',
    '["Stewarts Bridge","Hadley","intermediate","dam release","rafting","play spots","reliable","accessible","New York"]',
    1,
    1
  ),
  (
    110,
    'Upper Sacandaga (Christine Falls to East Branch)',
    'Upper (Christine Falls to East Branch)',
    'The challenging 7.5-mile Upper Sacandaga section from Christine Falls to the East Branch. Class III–V+ rapids with significant gradient and powerful currents through remote Adirondack scenery. Suitable for expert paddlers only—scouting and advanced rescue skills essential. Best during spring snowmelt when flows fill this more remote, unregulated section.',
    43.4500000, -74.1500000,
    43.3800000, -74.0500000,
    'V',
    7.50,
    NULL,
    '["Christine Falls","expert","Class V","remote","Adirondacks","spring","gradient","powerful","New York"]',
    NULL,
    2
  );

SET FOREIGN_KEY_CHECKS = 1;
