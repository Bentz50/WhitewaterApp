-- Copyright © 2026 BentzTech LLC. All rights reserved.
-- Migration: Seed Pennsylvania river & section data from American Whitewater
-- Source: American Whitewater National Whitewater Inventory (americanwhitewater.org)
-- Version: 1.6.0

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

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
    41.3306000, -79.2092000,
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
    '["scenic","gentle","family","multi-day","camping","canoe","rural","Clear water","Pennsylvania"]',
    1,
    2
  );

SET FOREIGN_KEY_CHECKS = 1;
