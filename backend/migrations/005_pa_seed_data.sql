-- Copyright © 2026 BentzTech LLC. All rights reserved.
-- Migration: Seed Pennsylvania river & section data from American Whitewater
-- Source: American Whitewater National Whitewater Inventory (americanwhitewater.org)
-- Version: 1.5.0

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- =============================================================
-- Pennsylvania Rivers (IDs 23–27)
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

SET FOREIGN_KEY_CHECKS = 1;
