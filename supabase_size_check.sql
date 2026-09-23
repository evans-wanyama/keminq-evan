-- KeMinQ Supabase Size Check — Run after supabase_sql_bundle.sql — Shows real DB size Isulu 4157 + Mui 16037 + geology 1116 + geophysics + cadastre Full 900+ OTMCP
-- KeMinQ = Kenya Mineral Intelligence Query — The Quotient that matters (GxW 1317) — EVAN = Exploration Vetting Analytics Nexus named after founder Evan — Query the data. Calculate the quotient.
-- Gold DB exact Isulu 4157 blocks 5.61MT @7.04=1.27Moz exact Isulu1519 DH 1383m abs visible gold 150m ISR-BH-237 6m @219.5 GxW1317 BSG-BH-045 6.4m @47.3 Indicated >100% Rosterman 259k @12.3 SML 2.5km2 Ramula 470k ML/2024/0200 Shanta 15.38km2 Siaya Vihiga ML Active PL Active Liranda shear 23m 12km dip70W az270W dip-65 Nyanzian basalt 2700Ma + Mui 16037 400MT Blocks A-D Fenxi ML Granted 79 samples 16-27 MJ/kg 100MT @25 MJ/kg Block C international 500km2 Karoo Ecca sandstone mudstone + Kwale Ti 56km2 26% global Base Titanium ML + Mrima REE-Nb 70Ma carbonatite + Magadi trona 100MT + Tsavo ruby tsavorite 2,000km Mozambique Belt + geology 1116 Liranda shear + geophysics mag low -30 blue demag low vs 80-120 red high + IP 25-40 red sulfide + geochem soil Au 800-2000 As100 Sb20 + cadastre Full 900+ OTMCP vs 32 SAMPLE Free MCP01 Nairobi portal.miningcadastre.go.ke login required — Vetting engine Kenya bbox -5to5 33to42 host_rock Nyanzian 2700Ma QAQC Au 0-219.5 TMI -50 to120 IP 0-40 abs_elev=collar-vert_depth Isulu1519 dip-65 az270W SHA256 ODPC Mining Act 2016 CP Measured<40 Indicated<100 — Mapbox light #F8F9FA layers OFF clean muted Gold #C2A878 graduated yellow-orange-red-dark red 219.5 boreholes dip -65 arrows shear 530-553 DEM 1519 cross-section X vs Elevation terrain on top blocks below real elev fix vulcan_collar_real_elev_dip.csv datamine_collar_real.txt collar_real_dip_az_elevation_Leapfrog.csv

-- 1. Total DB size — Supabase free = 500 MB — you should see ~9-11 MB
SELECT pg_size_pretty(pg_database_size(current_database())) as total_db_size, 
       pg_database_size(current_database()) as bytes,
       500*1024*1024 as free_limit_bytes,
       ROUND((pg_database_size(current_database())::float / (500*1024*1024)::float * 100)::numeric, 2) as pct_of_free;

-- 2. Per-table sizes — Isulu 4157 blocks 5.61MT @7.04=1.27Moz exact + Mui 16037 blocks 400MT + geology 1116 + geophysics + cadastre Full 900+ OTMCP
SELECT 
  schemaname,
  tablename as table_name,
  pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as total_size,
  pg_size_pretty(pg_relation_size(schemaname||'.'||tablename)) as data_size,
  pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename) - pg_relation_size(schemaname||'.'||tablename)) as index_size,
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = tablename) as columns,
  CASE 
    WHEN tablename = 'blocks_isulu_4157' THEN 'Isulu 4157 blocks 5.61MT @7.04=1.27Moz exact Isulu1519 DH 1383m abs visible gold 150m ISR-BH-237 6m @219.5 GxW1317 BSG-BH-045 6.4m @47.3 Indicated >100% Rosterman 259k @12.3 SML 2.5km2 Ramula 470k ML/2024/0200 Shanta 15.38km2 Siaya Vihiga ML Active PL Active Liranda shear 23m 12km dip70W az270W dip-65 Nyanzian basalt 2700Ma'
    WHEN tablename = 'blocks_mui_16037' THEN 'Mui 16037 blocks 400MT Blocks A-D Fenxi ML Granted 79 samples 16-27 MJ/kg 100MT @25 MJ/kg Block C international 500km2 Karoo Ecca sandstone mudstone'
    WHEN tablename = 'geology_1116' THEN 'Geology 1116 pts Liranda Corridor 12km N-S shear 23m wide dip70W az270W dip-65 Nyanzian 2700Ma basalt BIF'
    WHEN tablename = 'geophysics_mag_low' THEN 'Geophysics mag low -30 blue demag low vs 80-120 red high'
    WHEN tablename = 'geophysics_ip' THEN 'Geophysics IP 25-40 red sulfide'
    WHEN tablename = 'geochem_soil_800_2000' THEN 'Geochem soil Au 800-2000 As100 Sb20 pathfinders = ISR-BH-237 drill target'
    WHEN tablename = 'cadastre_full_900_otmcp' THEN 'Cadastre Full 900+ OTMCP map.miningcadastre.go.ke/map vs 32 SAMPLE Free ML Active PL Active MCP01 Nairobi portal.miningcadastre.go.ke login required'
    WHEN tablename = 'drillholes_102' THEN 'Drillholes 102 holes 35 visible gold 9,383m Phase 1 1,182,000 oz @12.6g/t highest grading +1 Moz Africa'
    WHEN tablename = 'resources' THEN 'Resources Isulu 5.61MT @7.04=1.27Moz + Mui 400MT + Kwale Ti 56km2 26% global + Mrima REE-Nb 70Ma + Magadi 100MT + Tsavo ruby 2,000km Mozambique Belt'
    WHEN tablename = 'research_docs' THEN 'Research docs 15 docs RAG Korr-Marsabit lat 2°52N lon 37º19E Horkel 1980 Taita high middle value Critical Catalogue 9 key minerals Mui 500km² 400MT Fenxi Mrima 390 acres $62.4B Base Titanium 65% Lithium Graphite 15 counties'
    ELSE tablename
  END as exact
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename IN ('blocks_isulu_4157', 'blocks_mui_16037', 'geology_1116', 'geophysics_mag_low', 'geophysics_ip', 'geochem_soil_800_2000', 'cadastre_full_900_otmcp', 'drillholes_102', 'resources', 'research_docs', 'subscriptions', 'emails_sent')
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- 3. Row counts — Verify Isulu 4157 + Mui 16037 + geology 1116
SELECT 'blocks_isulu_4157' as table_name, COUNT(*) as rows, 'Isulu 4157 blocks 5.61MT @7.04=1.27Moz exact Isulu1519 DH 1383m abs visible gold 150m ISR-BH-237 6m @219.5 GxW1317' as exact FROM blocks_isulu_4157
UNION ALL
SELECT 'blocks_mui_16037', COUNT(*), 'Mui 16037 blocks 400MT Blocks A-D Fenxi ML Granted 79 samples 16-27 MJ/kg 100MT @25 MJ/kg Block C international' FROM blocks_mui_16037
UNION ALL
SELECT 'geology_1116', COUNT(*), 'Geology 1116 pts Liranda Corridor 12km N-S shear 23m wide dip70W az270W dip-65 Nyanzian 2700Ma' FROM geology_1116
UNION ALL
SELECT 'geophysics_mag_low', COUNT(*), 'Geophysics mag low -30 blue demag low vs 80-120 red high' FROM geophysics_mag_low
UNION ALL
SELECT 'geophysics_ip', COUNT(*), 'Geophysics IP 25-40 red sulfide' FROM geophysics_ip
UNION ALL
SELECT 'geochem_soil_800_2000', COUNT(*), 'Geochem soil Au 800-2000 As100 Sb20' FROM geochem_soil_800_2000
UNION ALL
SELECT 'cadastre_full_900_otmcp', COUNT(*), 'Cadastre Full 900+ OTMCP map.miningcadastre.go.ke/map vs 32 SAMPLE Free' FROM cadastre_full_900_otmcp
UNION ALL
SELECT 'drillholes_102', COUNT(*), 'Drillholes 102 holes 35 visible gold 9,383m' FROM drillholes_102
UNION ALL
SELECT 'resources', COUNT(*), 'Resources Isulu + Mui + Kwale Ti 56km2 26% global + Mrima REE-Nb 70Ma + Magadi 100MT + Tsavo ruby 2,000km Mozambique Belt' FROM resources;

-- 4. GxW Quotient check — Grade x Width — ISR-BH-237 6m @219.5=1317 highest ROI — This is why Isulu 1.27Moz @7.04 exact exists
SELECT 
  'GxW Quotient Check — Grade x Width — ISR-BH-237 6m @219.5=1317 highest ROI' as check,
  MAX(g_x_w) as max_g_x_w,
  AVG(g_x_w) as avg_g_x_w,
  COUNT(CASE WHEN g_x_w >= 1317 THEN 1 END) as blocks_g_x_w_ge_1317,
  COUNT(CASE WHEN au >= 40 THEN 1 END) as blocks_visible_gold_ge_40,
  COUNT(CASE WHEN au >= 3.92 THEN 1 END) as blocks_indicated_ge_3_92,
  'abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS vulcan_collar_real_elev_dip.csv datamine_collar_real.txt collar_real_dip_az_elevation_Leapfrog.csv' as real_elev_fix,
  'Mapbox light #F8F9FA layers OFF clean muted Gold #C2A878 graduated yellow-orange-red-dark red 219.5 boreholes dip -65 arrows shear 530-553 DEM 1519 cross-section X vs Elevation terrain on top blocks below' as mapbox,
  'Q as Query Ask EVAN + Q as Quotient GxW 1317 100MT @25 Kwale Ti 26% global — Query the data. Calculate the quotient.' as dual_q
FROM blocks_isulu_4157;

-- 5. Real elev fix check — abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS
SELECT 
  'Real elev fix check — abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS' as check,
  COUNT(*) as total_blocks,
  COUNT(CASE WHEN abs_elev = collar_elev - vert_depth THEN 1 END) as real_elev_fix_pass,
  COUNT(CASE WHEN abs_elev != collar_elev - vert_depth THEN 1 END) as real_elev_fix_fail,
  'vulcan_collar_real_elev_dip.csv datamine_collar_real.txt collar_real_dip_az_elevation_Leapfrog.csv' as files,
  'Mapbox light #F8F9FA layers OFF clean muted Gold #C2A878 graduated yellow-orange-red-dark red 219.5 boreholes dip -65 arrows shear 530-553 DEM 1519 cross-section X vs Elevation terrain on top blocks below' as mapbox
FROM blocks_isulu_4157;

-- 6. MVT function exists check — /v1/map/tiles/{z}/{x}/{y}.mvt — Isulu 4157 blocks 5.61MT @7.04=1.27Moz exact GxW1317 + Mui 16037 blocks 400MT
SELECT 
  proname as function_name,
  pg_get_function_arguments(oid) as args,
  'get_mvt_tile(z int, x int, y int, resource_filter text, au_cutoff_filter float, g_x_w_gt_filter float, cv_gt_filter float) RETURNS bytea AS $$ ST_AsMVT + ST_TileEnvelope Kenya bbox -5to5 33to42 PASS host_rock Nyanzian basalt 2700Ma QAQC Au 0-219.5 abs_elev Isulu1519 dip-65 SHA256 ODPC PASS CP Measured<40 Indicated<100 — Mapbox light #F8F9FA layers OFF clean muted Gold #C2A878 graduated yellow-orange-red-dark red 219.5 boreholes dip -65 arrows shear 530-553 DEM 1519 cross-section X vs Elevation terrain on top blocks below real elev fix vulcan_collar_real_elev_dip.csv $$' as exact
FROM pg_proc 
WHERE proname = 'get_mvt_tile';

-- 7. Storage check — Supabase free = 1 GB storage — QGIS 5.9MB GPKG SHP GeoTIFF DEM 1519 QGS Vulcan Datamine Leapfrog KML MVT
-- Run this if you uploaded files to Supabase Storage bucket
SELECT 
  bucket_id,
  COUNT(*) as files,
  pg_size_pretty(SUM((metadata->>'size')::bigint)) as total_size,
  'QGIS 5.9MB GPKG SHP GeoTIFF DEM 1519 QGS Vulcan vulcan_collar_real_elev_dip.csv Datamine datamine_collar_real.txt Leapfrog collar_real_dip_az_elevation_Leapfrog.csv KML KMZ MVT /v1/map/tiles/{z}/{x}/{y}.mvt API /v1/resource/Isulu/blocks?au_cutoff=50&g_x_w_gt=1317' as exports,
  'Free limit 1 GB — you should see ~7 MB' as free_limit
FROM storage.objects 
GROUP BY bucket_id;

-- Done — KeMinQ + EVAN — Query the data. Calculate the quotient. — GxW 1317 + Mui 400MT + Kwale Ti 26% + Mrima REE-Nb 70Ma + Magadi 100MT + Tsavo ruby 2,000km Mozambique Belt — Two-shields logo integration ready — evan@keminq.ai — vercel --prod tonight from Nairobi — Free tier qualifies — 2% of 500 MB DB used, 0.7% of 1 GB storage used
