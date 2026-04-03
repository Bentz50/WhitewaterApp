-- Copyright © 2026 BentzTech LLC. All rights reserved.
-- Migration: Seed Ohio river & section data from American Whitewater
-- Source: American Whitewater National Whitewater Inventory (americanwhitewater.org)
-- Version: 1.4.0

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

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

SET FOREIGN_KEY_CHECKS = 1;
