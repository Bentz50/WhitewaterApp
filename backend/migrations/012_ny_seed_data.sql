-- Copyright © 2026 BentzTech LLC. All rights reserved.
-- Migration: Seed New York river & section data from American Whitewater
-- Source: American Whitewater National Whitewater Inventory (americanwhitewater.org)
-- Version: 1.13.0

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

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
