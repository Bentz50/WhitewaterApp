-- Copyright © 2026 BentzTech LLC. All rights reserved.
-- Migration: Seed Maryland river & section data from American Whitewater
-- Source: American Whitewater National Whitewater Inventory (americanwhitewater.org)
-- Version: 1.7.0

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

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

SET FOREIGN_KEY_CHECKS = 1;
