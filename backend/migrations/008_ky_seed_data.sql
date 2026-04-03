-- Copyright © 2026 BentzTech LLC. All rights reserved.
-- Migration: Seed Kentucky river & section data from American Whitewater
-- Source: American Whitewater National Whitewater Inventory (americanwhitewater.org)
-- Version: 1.9.0

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

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

SET FOREIGN_KEY_CHECKS = 1;
