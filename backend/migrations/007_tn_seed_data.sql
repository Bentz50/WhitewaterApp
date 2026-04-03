-- Copyright © 2026 BentzTech LLC. All rights reserved.
-- Migration: Seed Tennessee river & section data from American Whitewater
-- Source: American Whitewater National Whitewater Inventory (americanwhitewater.org)
-- Version: 1.8.0

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- =============================================================
-- Tennessee Rivers (IDs 53–62)
-- Note: Ocoee River already exists as ID 3 in 003_aw_seed_data.sql
-- =============================================================
INSERT INTO rivers (id, name, state, region, lat, lng, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, description, usgs_site_id, tags, is_runnable) VALUES
  -- 53. Hiwassee River — AW: Dam-controlled Class II family run near Reliance
  (
    53,
    'Hiwassee River',
    'Tennessee',
    'Cherokee National Forest / Polk County',
    35.1860000, -84.5006000,
    35.1669000, -84.2961000,
    35.2323000, -84.5505000,
    'II',
    16.00,
    'A beautiful and accessible Class II river flowing through the Cherokee National Forest near Reliance, Tennessee. The Hiwassee is one of the Southeast''s most popular beginner and family-friendly whitewater runs, with dam-controlled flows from Appalachia Powerhouse providing reliable water levels throughout the paddling season. The 16-mile stretch from the powerhouse to the Gee Creek take-out features gentle but entertaining Class II rapids, crystal-clear water, and stunning valley scenery. Multiple access points allow trips of varying lengths. Popular with commercial rafting outfitters, recreational kayakers, canoeists, and tubers. The river corridor is part of the Cherokee National Forest and offers excellent wildlife viewing. TVA dam releases make this one of the most consistently runnable rivers in Tennessee.',
    '03557000',
    '["dam controlled","family","beginner friendly","Cherokee National Forest","TVA","popular","commercial","scenic","Reliance","Tennessee"]',
    1
  ),
  -- 54. Nolichucky River — AW: Class III–IV gorge, Poplar NC to Erwin TN
  (
    54,
    'Nolichucky River',
    'Tennessee',
    'Nolichucky Gorge / Unicoi County',
    36.1026000, -82.4475000,
    36.0789000, -82.3475000,
    36.1026000, -82.4475000,
    'IV',
    9.00,
    'One of the premier whitewater gorge runs in the Southeast, the Nolichucky flows through a dramatic, remote wilderness gorge from Poplar, North Carolina to the Chestoa Recreation Area near Erwin, Tennessee. The approximately 9-mile run features continuous Class III–IV rapids with big water, powerful hydraulics, and stunning scenery—sheer canyon walls rise hundreds of feet on both sides. The gorge is roadless and remote, making rescue difficult and self-sufficiency essential. Commercial rafting trips are available from local outfitters. The river is rain-dependent and can rise quickly after storms. Key rapids include Quarter Mile, On The Rocks, and Jaws. The Chestoa take-out is operated by the U.S. Forest Service. A classic must-do for intermediate-to-advanced paddlers visiting the southern Appalachians.',
    '03464650',
    '["gorge","wilderness","remote","big water","commercial","Appalachian","classic","Cherokee National Forest","Erwin","Tennessee"]',
    1
  ),
  -- 55. Pigeon River — AW: Class II–III near Great Smoky Mountains
  (
    55,
    'Pigeon River',
    'Tennessee',
    'Great Smoky Mountains / Cocke County',
    35.8125000, -83.1450000,
    35.7749000, -83.0998000,
    35.8125000, -83.1450000,
    'III',
    4.30,
    'A popular and scenic whitewater river near the Great Smoky Mountains, offering approximately 4.3 miles of Class II–III rapids from Walters Power Plant at Waterville to the bridge at Hartford, Tennessee. The Upper Pigeon section features fun, continuous rapids with waves, ledges, and playful hydraulics—perfect for intermediate paddlers looking for action close to Gatlinburg and the national park. One of the busiest commercially rafted rivers in Tennessee due to its proximity to major tourist destinations. Recreational dam releases create reliable flows during the summer paddling season. The Lower Pigeon section downstream of Hartford offers gentler Class I–II water suitable for beginners and families.',
    '03461000',
    '["Great Smoky Mountains","commercial","popular","dam release","tourist area","Gatlinburg","Hartford","scenic","Tennessee"]',
    1
  ),
  -- 56. Obed River — AW: National Wild & Scenic River, Class II–IV
  (
    56,
    'Obed River',
    'Tennessee',
    'Obed Wild & Scenic River / Morgan & Cumberland Counties',
    36.0789000, -84.7661000,
    36.0892000, -84.8289000,
    36.0678000, -84.6608000,
    'IV',
    12.00,
    'Tennessee''s only federally designated National Wild and Scenic River, the Obed system includes the Obed River, Clear Creek, Daddy''s Creek, and the Emory River—offering some of the finest wilderness whitewater in the Southeast. Designated in 1976 and managed by the National Park Service, the system features Class II–IV rapids flowing through spectacular sandstone gorges and pristine forest. The Obed proper (Potter''s Ford to Obed Junction) and Clear Creek (Lilly Bridge to Nemo Bridge) are the most popular whitewater runs. The river is entirely rain-dependent with no dam releases, so paddling opportunities are limited to rainy seasons (typically winter through spring). When running, the Obed offers a true wilderness creek experience with technical boulder gardens, pool-drop rapids, and dramatic canyon walls. A bucket-list destination for southeastern paddlers.',
    '03539800',
    '["wild and scenic","national park","wilderness","rain dependent","canyon","sandstone","NPS","Obed","Clear Creek","Tennessee"]',
    NULL
  ),
  -- 57. Watauga River — AW: Dam-release Class II–III, Wilbur Dam to Elizabethton
  (
    57,
    'Watauga River',
    'Tennessee',
    'Carter County / Elizabethton',
    36.3415000, -82.1265000,
    36.3415000, -82.1265000,
    36.3559000, -82.2235000,
    'III',
    7.00,
    'A scenic and reliable dam-release whitewater run in northeast Tennessee, flowing from below Wilbur Dam to Elizabethton. The approximately 7-mile stretch features Class II–III rapids with fun waves, ledges, and technical moves through a beautiful mountain valley. TVA water releases from Wilbur Dam create excellent paddling conditions, though flows can be unpredictable—check release schedules before heading out. The highlight is the Bee Cliff Rapids section shortly after the put-in. Popular with intermediate kayakers and commercial rafting outfitters. The river flows through scenic Carter County countryside before reaching Elizabethton, where it eventually joins Boone Lake. A solid intermediate run with reliable flows when TVA is generating.',
    '03486000',
    '["dam release","TVA","intermediate","Bee Cliff","Wilbur Dam","Elizabethton","northeast Tennessee","scenic","Tennessee"]',
    NULL
  ),
  -- 58. Big South Fork of the Cumberland — AW: Class III–IV gorge, National River
  (
    58,
    'Big South Fork of the Cumberland',
    'Tennessee',
    'Big South Fork National River & Recreation Area / Scott County',
    36.4792000, -84.6672000,
    36.3878000, -84.6353000,
    36.4792000, -84.6672000,
    'IV',
    14.00,
    'A premier wilderness whitewater river flowing through the Big South Fork National River and Recreation Area, managed by the National Park Service. The classic Burnt Mill Bridge to Leatherwood Ford run covers approximately 14 miles of Class III–IV rapids through a deep, scenic gorge with an average gradient of 20 feet per mile. Key rapids include Angel Falls and Devil''s Jump—both Class IV drops that most paddlers portage. The gorge is remote, roadless, and stunningly beautiful with towering sandstone cliffs, natural arches, and rich biodiversity. The river is rain-dependent and best run during winter and spring high water. Self-sufficiency is critical as rescue access is extremely limited. One of Tennessee''s most dramatic and challenging wilderness whitewater experiences.',
    '03410210',
    '["national river","NPS","wilderness","gorge","remote","sandstone","Angel Falls","Class IV","rain dependent","Tennessee"]',
    NULL
  ),
  -- 59. Doe River — AW: Class II–III gorge run, Hampton to Elizabethton
  (
    59,
    'Doe River',
    'Tennessee',
    'Doe River Gorge / Carter County',
    36.2631000, -82.1607000,
    36.2736000, -82.1806000,
    36.3489000, -82.2136000,
    'III',
    8.50,
    'A scenic 8.5-mile creek run through the beautiful Doe River Gorge in Carter County, Tennessee. The Hampton to Elizabethton section features Class II–III rapids flowing through a narrow, dramatic gorge with towering rock walls and lush forest. The gorge section is the highlight—tight, technical rapids through stunning geology before the river opens up toward Elizabethton. Rain-dependent and best run after storms or during spring snowmelt. Access has been improved through conservation efforts, with put-in at Hershel Julian Landing in Hampton and take-out options at Green Bridge Landing or downstream in Elizabethton. A hidden gem for intermediate paddlers visiting northeast Tennessee.',
    '03485500',
    '["gorge","scenic","rain dependent","intermediate","creek","Carter County","Hampton","Elizabethton","hidden gem","Tennessee"]',
    NULL
  ),
  -- 60. Tellico River — AW: Class III–IV, Cherokee National Forest
  (
    60,
    'Tellico River',
    'Tennessee',
    'Cherokee National Forest / Monroe County',
    35.3619000, -84.2792000,
    35.3200000, -84.2200000,
    35.3619000, -84.2792000,
    'IV',
    10.00,
    'A beloved southeastern whitewater classic flowing through the Cherokee National Forest near Tellico Plains, Tennessee. The Tellico offers multiple sections ranging from Class II to Class IV, with the Upper Tellico ("The Ledges") being the signature run—approximately 2 miles of splashy drops, technical boulder gardens, and pool-drop rapids rated Class III–IV. The Middle Tellico continues downstream with solid Class II–III rapids through beautiful forest scenery. The full run from the upper put-in to Tellico Plains covers roughly 10 miles. Rain-dependent and best run during winter and spring; the river rises and falls quickly with storms. Baby Pratt Falls is a popular rapid and play spot. The Tellico is also a gateway to nearby Bald River, one of Tennessee''s premier Class IV creek runs.',
    '03518500',
    '["Cherokee National Forest","creek","rain dependent","Ledges","Baby Pratt","Tellico Plains","classic","southeast","Tennessee"]',
    NULL
  ),
  -- 61. Caney Fork River — AW: Class II–IV, Rock Island State Park
  (
    61,
    'Caney Fork River',
    'Tennessee',
    'Rock Island State Park / Warren & White Counties',
    35.8085000, -85.6330000,
    35.8100000, -85.6350000,
    35.8060000, -85.6300000,
    'IV',
    1.00,
    'A unique whitewater destination at Rock Island State Park in middle Tennessee, where the Caney Fork River plunges through a dramatic gorge below Center Hill Dam. The short but intense 1-mile gorge run features Class II–IV rapids (with some Class V drops at high flows) in a spectacular setting of waterfalls and exposed rock. The famous Blue Hole play spot just below the dam is a world-class playboating feature that has hosted international freestyle kayaking competitions. The run is entirely dependent on dam generation schedules—check TVA/Army Corps release schedules before visiting. Paddlers often take multiple laps by walking back upstream. Crystal-clear tailwater makes this one of the most scenic short runs in the state. Note: the gorge may be closed during certain release conditions for safety.',
    '03422500',
    '["state park","dam release","playboating","Blue Hole","freestyle","gorge","short run","TVA","Rock Island","Tennessee"]',
    NULL
  ),
  -- 62. French Broad River — AW: Scenic Class I–II through east Tennessee
  (
    62,
    'French Broad River',
    'Tennessee',
    'Cocke & Jefferson Counties / East Tennessee',
    35.9815000, -83.1612000,
    35.8500000, -82.9500000,
    36.0000000, -83.2000000,
    'II',
    17.50,
    'A large-volume scenic river flowing through east Tennessee, offering approximately 17.5 miles of Class I–II paddling along the popular Section 10 from the Tennessee/North Carolina border through Paint Rock to the Wolf Creek/Del Rio area. The French Broad is one of the oldest rivers in the world and features gentle rapids, fun ledges, and beautiful Appalachian mountain scenery. Ideal for beginners, families, and those seeking a relaxed day on the water. The river is large enough to be paddleable year-round in most conditions. Multiple access points allow flexible trip planning. The corridor passes through scenic farmland and mountain valleys with excellent wildlife viewing opportunities. A perfect warm-up or cool-down run when visiting the many harder rivers nearby.',
    '03455000',
    '["scenic","beginner friendly","family","large river","Appalachian","Section 10","year-round","ancient river","east Tennessee","Tennessee"]',
    1
  );

-- =============================================================
-- Tennessee River Sections
-- =============================================================

-- ── Hiwassee River sections (river_id=53) ─────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    53,
    'Appalachia Powerhouse to Reliance Bridge',
    'Upper (Powerhouse to Reliance)',
    'The classic 12-mile upper section from the Appalachia Powerhouse to the bridge at Reliance. Continuous Class II rapids with fun waves, small hydraulics, and beautiful clear water flowing through Cherokee National Forest. Dam-controlled releases from TVA''s Appalachia Powerhouse provide consistent, reliable flows throughout the paddling season. Multiple access points at Towee Creek and other landings allow shorter trips. Extremely popular with commercial rafting outfitters and families. A quintessential beginner-to-intermediate southeastern whitewater experience.',
    35.1669000, -84.2961000,
    35.1858000, -84.5006000,
    'II',
    12.00,
    '03557000',
    '["dam controlled","family","beginner","TVA","Cherokee National Forest","Reliance","clear water","Tennessee"]',
    1,
    1
  ),
  (
    53,
    'Reliance Bridge to Gee Creek',
    'Lower (Reliance to Gee Creek)',
    'A gentle 4-mile extension below Reliance Bridge to the Gee Creek take-out. Easier Class I–II water with a more relaxed character, ideal for families, fishing, and scenic floating. Beautiful forest scenery and excellent wildlife habitat. Can be combined with the upper section for a full 16-mile day trip.',
    35.1858000, -84.5006000,
    35.2323000, -84.5505000,
    'I',
    4.00,
    '03557000',
    '["family","gentle","scenic","fishing","wildlife","extension","Tennessee"]',
    1,
    2
  );

-- ── Nolichucky River section (river_id=54) ────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    54,
    'Nolichucky Gorge (Poplar to Chestoa)',
    'Gorge (Poplar to Chestoa)',
    'The classic 9-mile Nolichucky Gorge run from Poplar, NC to Chestoa Recreation Area near Erwin, TN. Continuous Class III–IV rapids through a dramatic, roadless wilderness gorge with sheer canyon walls rising hundreds of feet. The gorge is one of the deepest east of the Mississippi. Key rapids include Quarter Mile (a long, continuous Class III+ rapid), On The Rocks, and Jaws. Self-sufficiency is critical—there is no road access once you enter the gorge. Commercial rafting trips available. The Chestoa take-out is maintained by the U.S. Forest Service. Best after rain; the river rises quickly with storms. Intermediate-to-advanced skills required.',
    36.0789000, -82.3475000,
    36.1026000, -82.4475000,
    'IV',
    9.00,
    '03464650',
    '["gorge","wilderness","continuous","big water","commercial","Chestoa","Poplar","advanced","Tennessee"]',
    1,
    1
  );

-- ── Pigeon River sections (river_id=55) ───────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    55,
    'Upper Pigeon (Waterville to Hartford)',
    'Upper (Waterville to Hartford)',
    'The popular 4.3-mile Upper Pigeon section from Walters Power Plant at Waterville to the bridge at Hartford. Continuous Class II–III rapids with fun waves, ledges, and playful features. One of the busiest commercially rafted stretches in Tennessee, thanks to its proximity to Gatlinburg and the Great Smoky Mountains. Dam releases provide reliable summer flows. A great intermediate run with consistent action.',
    35.7749000, -83.0998000,
    35.8125000, -83.1450000,
    'III',
    4.30,
    '03461000',
    '["commercial","popular","dam release","Great Smoky Mountains","Gatlinburg","Hartford","intermediate","Tennessee"]',
    1,
    1
  ),
  (
    55,
    'Lower Pigeon (Hartford to Newport)',
    'Lower (Hartford to Newport)',
    'A gentler 8-mile section below Hartford offering Class I–II water suitable for beginners and families. The Lower Pigeon meanders through scenic agricultural valleys and Appalachian foothills. A relaxed float with occasional riffles and small rapids. Popular for tubing, canoeing, and recreational kayaking. A nice complement to the more exciting Upper Pigeon section.',
    35.8125000, -83.1450000,
    35.9500000, -83.1900000,
    'II',
    8.00,
    '03461000',
    '["beginner","family","scenic","gentle","tubing","canoe","Lower Pigeon","Tennessee"]',
    1,
    2
  );

-- ── Obed River sections (river_id=56) ─────────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    56,
    'Clear Creek (Lilly Bridge to Nemo Bridge)',
    'Clear Creek (Lilly to Nemo)',
    'The most popular run in the Obed system—approximately 7.5 miles of Class II–IV whitewater from Lilly Bridge to Nemo Bridge. The run features technical boulder gardens, pool-drop rapids, and stunning sandstone canyon walls within the Obed Wild and Scenic River. Clear Creek is slightly more accessible than the Obed proper and sees the most paddler traffic. Rain-dependent with no dam releases. When running, it offers a true wilderness creek experience in a National Park Service unit. Intermediate-to-advanced skills required.',
    36.1042000, -84.7158000,
    36.0678000, -84.6608000,
    'IV',
    7.50,
    '03539800',
    '["wild and scenic","NPS","canyon","technical","rain dependent","wilderness","Clear Creek","Tennessee"]',
    NULL,
    1
  ),
  (
    56,
    'Obed River (Potter''s Ford to Obed Junction)',
    'Obed (Potter''s Ford to Junction)',
    'The Obed River proper from Potter''s Ford to Obed Junction—approximately 5 miles of Class III–IV whitewater through a spectacular, remote sandstone gorge. More difficult and committing than Clear Creek, with bigger drops, more powerful hydraulics, and very limited rescue access. The gorge walls are dramatic and the wilderness setting is pristine. Rain-dependent and rarely running at optimal levels. When it''s on, this is one of the finest wilderness gorge runs in the eastern US. Advanced-to-expert skills required.',
    36.0892000, -84.8289000,
    36.0789000, -84.7661000,
    'IV',
    5.00,
    '03539800',
    '["wild and scenic","NPS","gorge","advanced","remote","wilderness","sandstone","rain dependent","Tennessee"]',
    NULL,
    2
  ),
  (
    56,
    'Daddy''s Creek (Antioch Bridge to Devil''s Breakfast Table)',
    'Daddy''s Creek (Antioch to Devil''s Breakfast Table)',
    'A challenging 6.8-mile tributary run within the Obed system, from Antioch Bridge to Devil''s Breakfast Table Bridge. Class III–IV rapids with an average gradient of 37 feet per mile—the most intense whitewater is concentrated in a dramatic 2-mile canyon section. Notable rapids include Spike, Fang of the Rattlesnake, and Rocking Chair. The creek is rain-dependent and can rise dangerously fast. Access restrictions may apply during hunting season in the Catoosa Wildlife Management Area. Advanced skills and creek-boating experience essential.',
    36.0592000, -84.7908000,
    35.9989000, -84.8225000,
    'IV',
    6.80,
    '03539600',
    '["creek","steep","technical","canyon","rain dependent","advanced","Obed system","Catoosa","Tennessee"]',
    NULL,
    3
  );

-- ── Watauga River section (river_id=57) ───────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    57,
    'Wilbur Dam to Elizabethton',
    'Main Run (Wilbur Dam to Elizabethton)',
    'The classic 7-mile Watauga run from below Wilbur Dam to Elizabethton. Class II–III rapids with fun waves, ledges, and the notable Bee Cliff Rapids section shortly after the put-in. TVA dam releases create paddling conditions, though flow schedules can vary. The run passes through scenic Carter County mountain scenery. Popular with intermediate kayakers and local paddling clubs. Check TVA generation schedules before planning your trip—when they''re generating, this is one of northeast Tennessee''s most reliable intermediate runs.',
    36.3415000, -82.1265000,
    36.3559000, -82.2235000,
    'III',
    7.00,
    '03486000',
    '["dam release","TVA","Wilbur Dam","Bee Cliff","intermediate","Elizabethton","northeast Tennessee","Tennessee"]',
    NULL,
    1
  );

-- ── Big South Fork of the Cumberland section (river_id=58) ────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    58,
    'Burnt Mill Bridge to Leatherwood Ford',
    'Canyon Run (Burnt Mill to Leatherwood)',
    'The classic 14-mile Big South Fork canyon run from Burnt Mill Bridge to Leatherwood Ford. Class III–IV rapids through a deep, remote gorge with an average gradient of 20 feet per mile. The run passes through spectacular sandstone canyon scenery with towering cliffs, natural arches, and pristine forest. Key rapids include Angel Falls (Class IV, commonly portaged) and Devil''s Jump (Class IV). The gorge is roadless—once you commit, there is no easy exit until Leatherwood Ford. Rain-dependent and best during winter/spring high water. Check the USGS gauge at Leatherwood Ford (03410210) for current levels. Advanced self-rescue skills essential.',
    36.3878000, -84.6353000,
    36.4792000, -84.6672000,
    'IV',
    14.00,
    '03410210',
    '["gorge","wilderness","NPS","Angel Falls","sandstone","rain dependent","remote","advanced","Tennessee"]',
    NULL,
    1
  );

-- ── Doe River section (river_id=59) ───────────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    59,
    'Hampton to Elizabethton (Doe River Gorge)',
    'Gorge Run (Hampton to Elizabethton)',
    'The full 8.5-mile Doe River run from Hershel Julian Landing in Hampton through the scenic Doe River Gorge to Elizabethton. The gorge section features tight, technical Class II–III rapids through narrow rock walls and lush forest—the highlight of the run. Below the gorge, the river opens up with easier Class II water as it approaches Elizabethton. Rain-dependent and best after storms or during spring flows. Access improvements at Hershel Julian Landing and Green Bridge Landing have made logistics easier. Check the USGS gauge at Elizabethton (03485500) for flow information. A scenic, hidden gem in northeast Tennessee.',
    36.2736000, -82.1806000,
    36.3489000, -82.2136000,
    'III',
    8.50,
    '03485500',
    '["gorge","scenic","rain dependent","creek","intermediate","Hampton","Elizabethton","hidden gem","Tennessee"]',
    NULL,
    1
  );

-- ── Tellico River sections (river_id=60) ──────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    60,
    'Upper Tellico (The Ledges)',
    'Upper (The Ledges)',
    'The signature 2-mile Upper Tellico run known as "The Ledges"—a classic southeastern Class III–IV stretch with splashy drops, technical boulder gardens, and pool-drop rapids. Features Baby Pratt Falls and other beloved rapids. Best run during winter and spring when rainfall provides adequate flows. The Tellico rises and falls quickly with storms. A favorite among experienced southeastern paddlers. Check the USGS Tellico Plains gauge (03518500) for levels.',
    35.3200000, -84.2200000,
    35.3400000, -84.2500000,
    'IV',
    2.00,
    '03518500',
    '["Ledges","Baby Pratt","technical","pool-drop","rain dependent","classic","Cherokee National Forest","Tennessee"]',
    NULL,
    1
  ),
  (
    60,
    'Middle Tellico',
    'Middle',
    'A solid 4-mile Class II–III section below the Upper Tellico, featuring continuous rapids, playful waves, and technical moves through beautiful Cherokee National Forest scenery. Ideal for intermediate paddlers looking for classic southeastern whitewater. Can be combined with the Upper section for a longer run. Rain-dependent.',
    35.3400000, -84.2500000,
    35.3600000, -84.2700000,
    'III',
    4.00,
    '03518500',
    '["intermediate","continuous","Cherokee National Forest","rain dependent","scenic","Tennessee"]',
    NULL,
    2
  ),
  (
    60,
    'Ranger Station to Tellico Plains',
    'Lower (Ranger Station to Tellico Plains)',
    'A 4.2-mile lower section from the Ranger Station to Tellico Plains. Class I–III water that is more beginner-friendly than the upper sections, though still offering solid rapids at the right flows. Beautiful forest scenery and a good introduction to Tellico River whitewater before stepping up to the more challenging upstream sections.',
    35.3600000, -84.2700000,
    35.3619000, -84.2792000,
    'III',
    4.20,
    '03518500',
    '["beginner friendly","scenic","Tellico Plains","introduction","rain dependent","Tennessee"]',
    NULL,
    3
  );

-- ── Caney Fork River section (river_id=61) ────────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    61,
    'Rock Island Gorge (Blue Hole Run)',
    'Gorge (Blue Hole)',
    'The short but intense 1-mile gorge run at Rock Island State Park, featuring Class II–IV rapids and the famous Blue Hole play spot. The gorge is carved below Center Hill Dam with crystal-clear tailwater, waterfalls, and dramatic exposed rock. A world-class playboating destination that has hosted international freestyle kayaking competitions. Entirely dependent on dam generation schedules—check TVA/Army Corps release schedules before visiting. Most paddlers take multiple laps. The gorge may be closed during high releases for safety. A unique and photogenic paddling experience.',
    35.8100000, -85.6350000,
    35.8060000, -85.6300000,
    'IV',
    1.00,
    '03422500',
    '["state park","dam release","playboating","Blue Hole","freestyle","gorge","short run","TVA","Tennessee"]',
    NULL,
    1
  );

-- ── French Broad River section (river_id=62) ──────────────────
INSERT INTO river_sections (river_id, name, section_label, description, put_in_lat, put_in_lng, take_out_lat, take_out_lng, aw_rating, length_miles, usgs_site_id, tags, is_runnable, sort_order) VALUES
  (
    62,
    'Section 10 (Paint Rock to Wolf Creek)',
    'Section 10 (Paint Rock to Wolf Creek)',
    'The popular 17.5-mile Section 10 of the French Broad River from the Tennessee/North Carolina border at Paint Rock to Wolf Creek/Del Rio. Class I–II rapids with fun ledges and moving water through beautiful Appalachian mountain scenery. The French Broad is one of the oldest rivers in the world and carries significant volume year-round. Multiple access points allow trips of varying length. Ideal for beginners, families, and those seeking a relaxed day trip. Recommended minimum flow is approximately 1,000 CFS with enjoyable paddling above 2,000 CFS at the Newport gauge.',
    35.8500000, -82.9500000,
    36.0000000, -83.2000000,
    'II',
    17.50,
    '03455000',
    '["scenic","beginner","family","Section 10","year-round","ancient river","Appalachian","large volume","Tennessee"]',
    1,
    1
  );

SET FOREIGN_KEY_CHECKS = 1;
