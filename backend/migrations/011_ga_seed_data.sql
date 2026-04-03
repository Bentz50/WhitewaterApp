-- Copyright © 2026 BentzTech LLC. All rights reserved.
-- Migration: Seed Georgia river & section data from American Whitewater
-- Source: American Whitewater National Whitewater Inventory (americanwhitewater.org)
-- Version: 1.12.0

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

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

SET FOREIGN_KEY_CHECKS = 1;
