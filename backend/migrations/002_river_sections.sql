-- Copyright © 2026 BentzTech LLC. All rights reserved.
-- Migration: Add river sections support
-- Version: 1.1.0

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- River sections table
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

-- Add nullable section_id to related tables
ALTER TABLE run_logs
  ADD COLUMN section_id INT UNSIGNED NULL AFTER river_id,
  ADD FOREIGN KEY fk_run_logs_section (section_id) REFERENCES river_sections(id) ON DELETE SET NULL,
  ADD INDEX idx_section_id (section_id);

ALTER TABLE hazards
  ADD COLUMN section_id INT UNSIGNED NULL AFTER river_id,
  ADD FOREIGN KEY fk_hazards_section (section_id) REFERENCES river_sections(id) ON DELETE SET NULL,
  ADD INDEX idx_hazards_section_id (section_id);

ALTER TABLE river_videos
  ADD COLUMN section_id INT UNSIGNED NULL AFTER river_id,
  ADD FOREIGN KEY fk_river_videos_section (section_id) REFERENCES river_sections(id) ON DELETE SET NULL,
  ADD INDEX idx_river_videos_section_id (section_id);

ALTER TABLE posts
  ADD COLUMN section_id INT UNSIGNED NULL AFTER river_id,
  ADD FOREIGN KEY fk_posts_section (section_id) REFERENCES river_sections(id) ON DELETE SET NULL;

ALTER TABLE river_tags
  ADD COLUMN section_id INT UNSIGNED NULL AFTER river_id,
  ADD FOREIGN KEY fk_river_tags_section (section_id) REFERENCES river_sections(id) ON DELETE SET NULL;

SET FOREIGN_KEY_CHECKS = 1;

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
