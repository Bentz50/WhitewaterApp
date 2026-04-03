-- Copyright © 2026 BentzTech LLC. All rights reserved.
-- Migration: Seed river & section data from American Whitewater
-- Source: American Whitewater National Whitewater Inventory (americanwhitewater.org)
-- Version: 1.2.0

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- =============================================================
-- STEP 1: Clear existing seed data (sections first due to FK)
-- =============================================================
DELETE FROM river_sections WHERE river_id IN (1, 2, 3, 4, 5);
DELETE FROM rivers WHERE id IN (1, 2, 3, 4, 5);

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

SET FOREIGN_KEY_CHECKS = 1;
