-- Copyright © 2026 BentzTech LLC. All rights reserved.
-- Migration: Seed South Carolina river & section data from American Whitewater
-- Source: American Whitewater National Whitewater Inventory (americanwhitewater.org)
-- Version: 1.11.0

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

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

SET FOREIGN_KEY_CHECKS = 1;
