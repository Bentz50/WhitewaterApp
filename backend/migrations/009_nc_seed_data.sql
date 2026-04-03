-- Copyright © 2026 BentzTech LLC. All rights reserved.
-- Migration: Seed North Carolina river & section data from American Whitewater
-- Source: American Whitewater National Whitewater Inventory (americanwhitewater.org)
-- Version: 1.10.0

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

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

SET FOREIGN_KEY_CHECKS = 1;
