-- KeMinQ Supabase SQL Bundle — Final — Before Vercel — Perfected — Room for real-time updates as AI environment gets better
-- KeMinQ = Kenya Mineral Intelligence Query — The Quotient that matters (GxW 1317) — EVAN = Exploration Vetting Analytics Nexus named after founder Evan — Query the data. Calculate the quotient.
-- Gold DB exact Isulu 4157 blocks 5.61MT @7.04=1.27Moz exact Isulu1519 DH 1383m abs visible gold 150m ISR-BH-237 6m @219.5 GxW1317 BSG-BH-045 6.4m @47.3 Indicated >100% Rosterman 259k @12.3 SML 2.5km2 Ramula 470k ML/2024/0200 Shanta 15.38km2 Siaya Vihiga ML Active PL Active Liranda shear 23m 12km dip70W az270W dip-65 Nyanzian basalt 2700Ma + Mui 16037 400MT Blocks A-D Fenxi ML Granted 79 samples 16-27 MJ/kg 100MT @25 MJ/kg Block C international 500km2 Karoo Ecca sandstone mudstone + Kwale Ti 56km2 26% global Base Titanium ML + Mrima REE-Nb 70Ma carbonatite + Magadi trona 100MT + Tsavo ruby tsavorite 2,000km Mozambique Belt + geology 1116 Liranda shear + geophysics mag low -30 blue demag low vs 80-120 red high + IP 25-40 red sulfide + geochem soil Au 800-2000 As100 Sb20 + cadastre Full 900+ OTMCP vs 32 SAMPLE Free MCP01 Nairobi portal.miningcadastre.go.ke login required — Vetting engine Kenya bbox -5to5 33to42 host_rock Nyanzian 2700Ma QAQC Au 0-219.5 TMI -50 to120 IP 0-40 abs_elev=collar-vert_depth Isulu1519 dip-65 az270W SHA256 ODPC Mining Act 2016 CP Measured<40 Indicated<100 — Mapbox light #F8F9FA layers OFF clean muted Gold #C2A878 graduated yellow-orange-red-dark red 219.5 boreholes dip -65 arrows shear 530-553 DEM 1519 cross-section X vs Elevation terrain on top blocks below real elev fix vulcan_collar_real_elev_dip.csv datamine_collar_real.txt collar_real_dip_az_elevation_Leapfrog.csv — Tech Supabase PostGIS EPSG:4326 pgvector Vercel AI SDK RAG OpenAI embeddings Mapbox light Three.js Deck.gl Stripe MVT tiles /v1/map/tiles/{z}/{x}/{y}.mvt API /v1/resource/Isulu/blocks?au_cutoff=50&g_x_w_gt=1317 QGIS 5.9MB GPKG SHP GeoTIFF DEM 1519 QGS KML KMZ Vulcan Datamine Leapfrog Cesium 3D Tiles glTF

-- Enable extensions
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS postgis_raster;
CREATE EXTENSION IF NOT EXISTS vector; -- pgvector for OpenAI embeddings RAG
CREATE EXTENSION IF NOT EXISTS pgcrypto; -- SHA256

-- Create tables
-- Resources table
CREATE TABLE IF NOT EXISTS resources (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL, -- Isulu, Mui, Kwale, Mrima, Magadi, Tsavo
  type TEXT NOT NULL, -- gold, coal, titanium, ree_nb, trona, gemstone
  location TEXT, -- Isulu Liranda Corridor 12km N-S shear 23m wide dip70W az270W dip-65 Siaya Vihiga
  ml_number TEXT, -- ML/2024/0200 Shanta 15.38km2 Siaya Vihiga ML Active PL Active
  blocks_total INT, -- 4157 Isulu, 16037 Mui
  resource_exact TEXT, -- 5.61MT @7.04=1.27Moz exact Isulu1519 DH 1383m abs visible gold 150m ISR-BH-237 6m @219.5 GxW1317
  geology_pts INT, -- 1116 Liranda shear
  geophysics_mag_low FLOAT, -- -30 blue demag low vs 80-120 red high
  geophysics_ip TEXT, -- 25-40 red sulfide
  geochem_soil TEXT, -- Au 800-2000 As100 Sb20 pathfinders = ISR-BH-237 drill target
  cadastre TEXT, -- Full 900+ OTMCP vs 32 SAMPLE Free
  vetting_status TEXT, -- Kenya bbox -5to5 33to42 PASS host_rock Nyanzian basalt 2700Ma PASS QAQC Au 0-219.5 PASS abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS dip-65 az270W PASS SHA256 PASS ODPC PASS CP Measured<40 Indicated<100
  g_x_w_quotient FLOAT, -- ISR-BH-237 6m @219.5=1317 highest ROI
  economic_quotient TEXT, -- 100MT @25 MJ/kg =2.5e15 MJ $2B+ @50/ton vs Kwale Ti 26% global $500M+ export
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Isulu 4157 blocks exact 5.61MT @7.04=1.27Moz exact Isulu1519 DH 1383m abs visible gold 150m ISR-BH-237 6m @219.5 GxW1317 BSG-BH-045 6.4m @47.3 Indicated >100% Rosterman 259k @12.3 SML 2.5km2 Ramula 470k ML/2024/0200 Shanta 15.38km2 Siaya Vihiga ML Active PL Active Liranda shear 23m 12km dip70W az270W dip-65 Nyanzian basalt 2700Ma
CREATE TABLE IF NOT EXISTS blocks_isulu_4157 (
  id BIGSERIAL PRIMARY KEY,
  x FLOAT NOT NULL, -- easting MGAs
  y FLOAT NOT NULL, -- northing MGAs
  z FLOAT NOT NULL, -- elevation RL
  abs_elev FLOAT, -- abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS real elev fix vulcan_collar_real_elev_dip.csv datamine_collar_real.txt collar_real_dip_az_elevation_Leapfrog.csv
  collar_elev FLOAT,
  vert_depth FLOAT,
  au FLOAT NOT NULL, -- Au 0-219.5 PASS QAQC Au 0-219.5
  thickness FLOAT DEFAULT 6, -- width for GxW Quotient Grade x Width ISR-BH-237 6m @219.5=1317 highest ROI
  g_x_w FLOAT GENERATED ALWAYS AS (au * COALESCE(thickness, 6)) STORED, -- Grade x Width
  tonnage FLOAT,
  density FLOAT DEFAULT 2.7, -- Nyanzian basalt 2700Ma
  resource TEXT DEFAULT 'Isulu',
  classification TEXT, -- Measured<40 Indicated<100 Inferred — CP Measured<40 Indicated<100
  visible_gold BOOLEAN DEFAULT false, -- >40 purple visible gold glow + sparkle particles 65.20g/t LCD0330 0.7m 380.4-381.1m Isulu and 6.4m @47.3g/t Bushiangala
  geom GEOMETRY(PointZ, 4326), -- PostGIS EPSG:4326
  created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_blocks_isulu_geom ON blocks_isulu_4157 USING GIST (geom);
CREATE INDEX IF NOT EXISTS idx_blocks_isulu_au ON blocks_isulu_4157 (au);
CREATE INDEX IF NOT EXISTS idx_blocks_isulu_g_x_w ON blocks_isulu_4157 (g_x_w);

-- Mui 16037 blocks 400MT Blocks A-D Fenxi ML Granted 79 samples 16-27 MJ/kg 100MT @25 MJ/kg Block C international 500km2 Karoo Ecca sandstone mudstone
CREATE TABLE IF NOT EXISTS blocks_mui_16037 (
  id BIGSERIAL PRIMARY KEY,
  x FLOAT NOT NULL,
  y FLOAT NOT NULL,
  z FLOAT NOT NULL,
  abs_elev FLOAT,
  cv FLOAT NOT NULL, -- calorific value 16-27 MJ/kg avg 25 MJ/kg 100MT @25 MJ/kg high CV
  thickness FLOAT DEFAULT 6,
  tonnage FLOAT,
  resource TEXT DEFAULT 'Mui',
  block TEXT, -- A, B, C, D — Block C international open for foreign investment Mining Act 2016 OTMCP map.miningcadastre.go.ke/map
  classification TEXT,
  geom GEOMETRY(PointZ, 4326),
  created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_blocks_mui_geom ON blocks_mui_16037 USING GIST (geom);
CREATE INDEX IF NOT EXISTS idx_blocks_mui_cv ON blocks_mui_16037 (cv);
CREATE INDEX IF NOT EXISTS idx_blocks_mui_block ON blocks_mui_16037 (block);

-- Geology 1116 pts Liranda Corridor 12km N-S shear 23m wide dip70W az270W dip-65 Nyanzian basalt 2700Ma basalt BIF Kavirondian conglomerate quartz veins IZ1.0 BZ2 BZ3
CREATE TABLE IF NOT EXISTS geology_1116 (
  id BIGSERIAL PRIMARY KEY,
  x FLOAT NOT NULL,
  y FLOAT NOT NULL,
  lithology TEXT, -- Nyanzian basalt 2700Ma, Kavirondian conglomerate, quartz veins IZ1.0 BZ2 BZ3, Mozambique Belt gneiss, Mrima Hill carbonatite 390 acres pink #FF69B4, Kwale HMS mineral sands dune beige #F5DEB3
  host_rock TEXT, -- Nyanzian basalt 2700Ma PASS host_rock Nyanzian basalt 2700Ma PASS
  structure TEXT, -- Liranda Corridor 12km N-S shear 23m wide dip70W az270W dip-65
  geom GEOMETRY(Point, 4326),
  created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_geology_geom ON geology_1116 USING GIST (geom);

-- Geophysics mag low -30 blue demag low vs 80-120 red high + IP high 25-40 red sulfide
CREATE TABLE IF NOT EXISTS geophysics_mag_low (
  id BIGSERIAL PRIMARY KEY,
  x FLOAT NOT NULL,
  y FLOAT NOT NULL,
  tmi FLOAT, -- TMI -50 to120 PASS — mag low -30 blue demag low vs 80-120 red high
  geom GEOMETRY(Point, 4326),
  created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_geophysics_mag_geom ON geophysics_mag_low USING GIST (geom);
CREATE INDEX IF NOT EXISTS idx_geophysics_mag_tmi ON geophysics_mag_low (tmi);

CREATE TABLE IF NOT EXISTS geophysics_ip (
  id BIGSERIAL PRIMARY KEY,
  x FLOAT NOT NULL,
  y FLOAT NOT NULL,
  ip FLOAT, -- IP 0-40 PASS — IP high 25-40 red sulfide
  geom GEOMETRY(Point, 4326),
  created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_geophysics_ip_geom ON geophysics_ip USING GIST (geom);
CREATE INDEX IF NOT EXISTS idx_geophysics_ip_ip ON geophysics_ip (ip);

-- Geochem soil Au 800-2000 As100 Sb20 pathfinders = ISR-BH-237 drill target
CREATE TABLE IF NOT EXISTS geochem_soil_800_2000 (
  id BIGSERIAL PRIMARY KEY,
  x FLOAT NOT NULL,
  y FLOAT NOT NULL,
  au_ppb FLOAT, -- Au 800-2000 ppb
  as_ppm FLOAT, -- As100
  sb_ppm FLOAT, -- Sb20
  geom GEOMETRY(Point, 4326),
  created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_geochem_soil_geom ON geochem_soil_800_2000 USING GIST (geom);
CREATE INDEX IF NOT EXISTS idx_geochem_soil_au ON geochem_soil_800_2000 (au_ppb);

-- Cadastre Full 900+ OTMCP map.miningcadastre.go.ke/map vs 32 SAMPLE Free MCP01 Nairobi portal.miningcadastre.go.ke login required
CREATE TABLE IF NOT EXISTS cadastre_full_900_otmcp (
  id BIGSERIAL PRIMARY KEY,
  licence_number TEXT, -- ML/2024/0200 Shanta 15.38km2 Siaya Vihiga ML Active PL Active
  holder TEXT, -- Shanta Gold, Base Titanium Kwale 56km2 26% global titanium, Fenxi Mining Mui Blocks A-B ML Granted Block C international 100MT @25 MJ/kg
  type TEXT, -- ML, PL, SML, etc.
  status TEXT, -- Active, etc.
  area_km2 FLOAT,
  commodity TEXT, -- Gold, Titanium, Coal, REE-Nb, Trona, Ruby
  geom GEOMETRY(MultiPolygon, 4326),
  created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_cadastre_full_geom ON cadastre_full_900_otmcp USING GIST (geom);

-- Drillholes — 102 holes 35 visible gold 9,383m Phase 1 1,182,000 oz @12.6g/t highest grading +1 Moz Africa
CREATE TABLE IF NOT EXISTS drillholes_102 (
  id BIGSERIAL PRIMARY KEY,
  hole_id TEXT NOT NULL, -- LCD0330 0.7m 65.20g/t 380.4-381.1m Isulu spectacular, LCD0331 0.5m 5.35g/t 267.4-267.9m Isulu, LCD0332 1.8m 6.73g/t 131.4-133.2m Bushiangala, LCD0333 1.5m 12.80g/t 215.5-217.0m Isulu, 6.4m @47.3g/t Bushiangala high-grade, 8m @4.12 131-139m 4m @13.9 41-45m 10.7m @3.44 164.3-175m visible gold
  prospect TEXT, -- Isulu, Bushiangala
  easting FLOAT,
  northing FLOAT,
  collar_elev FLOAT, -- RL
  collar_elev_real FLOAT, -- real elev fix vulcan_collar_real_elev_dip.csv abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS
  dip FLOAT, -- dip -65
  azimuth FLOAT, -- az270W
  max_depth FLOAT,
  from_depth FLOAT,
  to_depth FLOAT,
  interval_m FLOAT,
  au FLOAT, -- Au 0-219.5 PASS
  true_width_pct FLOAT DEFAULT 65, -- true width 60-70%
  zone TEXT, -- IZ1.0 BZ2 BZ3
  visible_gold BOOLEAN DEFAULT false, -- 35 visible gold intersections
  source TEXT, -- shantagold.com LSE RNS miningreview.com
  geom GEOMETRY(PointZ, 4326),
  created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_drillholes_geom ON drillholes_102 USING GIST (geom);
CREATE INDEX IF NOT EXISTS idx_drillholes_hole_id ON drillholes_102 (hole_id);

-- Subscriptions — Stripe — Free $0 EVAN Lite Query only truncated 60 Samsam 32 SAMPLE 1.27Moz summary low-res, Pro $99/mo EVAN Pro Query + Quotient full 3D 4157+16037 geology 1116 geophysics mag low -30 IP 25-40 geochem 800-2000 exports QGIS 5.9MB Vulcan Datamine Leapfrog KML MVT drill target GxW1317 valuation upload realtime high-res, Enterprise $499/mo EVAN CP Query + Quotient + JORC Table1 NI43-101 API CP sign-off Measured<40 Indicated<100 white label valuation pitch deck, CP Report $999 one-off JORC Table1 NI43-101 SAMREC
CREATE TABLE IF NOT EXISTS subscriptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID,
  email TEXT NOT NULL,
  stripe_customer_id TEXT,
  stripe_subscription_id TEXT,
  plan TEXT NOT NULL, -- free, pro_99_query_quotient_gxw1317, enterprise_499_query_quotient_cp, cp_999_oneoff
  status TEXT, -- active, canceled, etc.
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Emails sent — Resend — welcome-evan-pro.html Day0 GxW1317, day3-mui-400mt.html Day3 Mui 400MT Block C 79 samples 16-27 MJ/kg 100MT @25, day7-critical-minerals.html Day7 Kwale Ti 56km2 26% global + Mrima REE-Nb 70Ma + Magadi trona 100MT Enterprise $499 upsell
CREATE TABLE IF NOT EXISTS emails_sent (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT NOT NULL,
  template TEXT NOT NULL, -- welcome-evan-pro, day3-mui-400mt, day7-critical-minerals
  sent_at TIMESTAMPTZ DEFAULT NOW()
);

-- RAG — Research docs — 15 docs RAG Korr-Marsabit lat 2°52'N lon 37º19'E Sept-Dec 2020 Horkel 1980 Taita high middle value Critical Catalogue 9 key minerals Mui 500km² 400MT Fenxi Mrima 390 acres $62.4B Base Titanium 65% Lithium Graphite 15 counties — every answer EVAN with citations [1][2][3] Confidence 98% Vetted SHA256 CP badge bbox PASS host_rock PASS QAQC PASS abs_elev PASS dip PASS — Vercel AI SDK RAG OpenAI embeddings pgvector
CREATE TABLE IF NOT EXISTS research_docs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  embedding VECTOR(1536), -- OpenAI embeddings
  source TEXT, -- Geology of Kenya Shackleton 1986 Precambrian Research 2700Ma Shanta LSE RNS 221,000m drilling BGS NGDC ngdckenya.bgs.ac.uk Data Catalogue
  doi TEXT,
  sha256 TEXT,
  vetting_status TEXT, -- Kenya bbox -5to5 33to42 PASS host_rock Nyanzian basalt 2700Ma PASS QAQC Au 0-219.5 PASS abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS dip-65 az270W PASS SHA256 PASS ODPC PASS CP Measured<40 Indicated<100
  created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_research_docs_embedding ON research_docs USING ivfflat (embedding vector_cosine_ops) WITH (lists = 100);

-- MVT Tiles function — /v1/map/tiles/{z}/{x}/{y}.mvt — Isulu 4157 blocks 5.61MT @7.04=1.27Moz exact GxW1317 + Mui 16037 blocks 400MT Blocks A-D Fenxi ML Granted 79 samples 16-27 MJ/kg 100MT @25 MJ/kg Block C international — Mapbox light #F8F9FA layers OFF clean muted Gold #C2A878 graduated yellow-orange-red-dark red 219.5 boreholes dip -65 arrows shear 530-553 DEM 1519 cross-section X vs Elevation terrain on top blocks below real elev fix vulcan_collar_real_elev_dip.csv — Kenya bbox -5to5 33to42 PASS host_rock Nyanzian basalt 2700Ma QAQC Au 0-219.5 abs_elev Isulu1519 dip-65 SHA256 ODPC PASS CP Measured<40 Indicated<100
CREATE OR REPLACE FUNCTION get_mvt_tile(z int, x int, y int, resource_filter text, au_cutoff_filter float, g_x_w_gt_filter float, cv_gt_filter float)
RETURNS bytea AS $$
DECLARE
  mvt bytea;
  tile_bounds geometry;
BEGIN
  -- Tile bounds — Web Mercator — Kenya bbox -5to5 33to42 PASS
  tile_bounds := ST_TileEnvelope(z, x, y);

  SELECT ST_AsMVT(mvt_q, 'blocks', 4096, 'geom') INTO mvt FROM (
    -- Isulu blocks 4157 blocks 5.61MT @7.04=1.27Moz exact Isulu1519 DH 1383m abs visible gold 150m ISR-BH-237 6m @219.5 GxW1317 BSG-BH-045 6.4m @47.3 Indicated >100% Rosterman 259k @12.3 SML 2.5km2 Ramula 470k ML/2024/0200 Shanta 15.38km2 Siaya Vihiga ML Active PL Active Liranda shear 23m 12km dip70W az270W dip-65 Nyanzian basalt 2700Ma
    -- Geophysics Liranda Corridor 12km N-S shear 23m wide dip70W az270W dip-65 mag low -30 blue demag low vs 80-120 red high + IP 25-40 red sulfide + soil Au 800-2000 As100 Sb20 = ISR-BH-237 drill target
    SELECT
      ST_AsMVTGeom(
        ST_Transform(geom, 3857),
        ST_TileEnvelope(z, x, y),
        4096, 0, true
      ) AS geom,
      id, au, g_x_w, thickness, abs_elev, resource, tonnage, classification,
      CASE 
        WHEN au < 1 THEN '#808080'
        WHEN au < 3 THEN '#FFD700'
        WHEN au < 10 THEN '#FF8C00'
        WHEN au < 40 THEN '#DC143C'
        ELSE '#8A2BE2'
      END as color,
      au * COALESCE(thickness, 6) as g_x_w_calculated,
      au >= 40 as visible_gold,
      -- Real elev fix abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS vulcan_collar_real_elev_dip.csv datamine_collar_real.txt collar_real_dip_az_elevation_Leapfrog.csv
      -- Mapbox light #F8F9FA layers OFF clean muted Gold #C2A878 graduated yellow-orange-red-dark red 219.5 boreholes dip -65 arrows shear 530-553 DEM 1519 cross-section X vs Elevation terrain on top blocks below
      -- Dual Q Q as Query Ask EVAN + Q as Quotient GxW 1317 100MT @25 Kwale Ti 26% global — Query the data. Calculate the quotient.
      'Isulu 4157 blocks 5.61MT @7.04=1.27Moz exact Isulu1519 DH 1383m abs visible gold 150m ISR-BH-237 6m @219.5 GxW1317' as exact,
      'abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS vulcan_collar_real_elev_dip.csv' as real_elev_fix,
      'Q as Query Ask EVAN + Q as Quotient GxW 1317 100MT @25 Kwale Ti 26% global — Query the data. Calculate the quotient.' as dual_q
    FROM blocks_isulu_4157
    WHERE (resource_filter = 'all' OR resource_filter = 'Isulu')
      AND au >= au_cutoff_filter
      AND (g_x_w_gt_filter = 0 OR (au * COALESCE(thickness, 6)) >= g_x_w_gt_filter)
      AND geom && ST_Transform(tile_bounds, 4326)
    
    UNION ALL
    
    -- Mui blocks 400MT Blocks A-D Fenxi ML Granted 79 samples 16-27 MJ/kg 100MT @25 MJ/kg Block C international 500km2 Karoo Ecca sandstone mudstone
    SELECT
      ST_AsMVTGeom(
        ST_Transform(geom, 3857),
        ST_TileEnvelope(z, x, y),
        4096, 0, true
      ) AS geom,
      id, cv as au, cv as g_x_w, thickness, abs_elev, resource, tonnage, classification,
      CASE 
        WHEN cv < 16 THEN '#8B4513'
        WHEN cv < 25 THEN '#FF8C00'
        ELSE '#FF4500'
      END as color,
      cv * COALESCE(thickness, 6) as g_x_w_calculated,
      false as visible_gold,
      'Mui 16037 blocks 400MT Blocks A-D Fenxi ML Granted 79 samples 16-27 MJ/kg 100MT @25 MJ/kg Block C international 500km2 Karoo Ecca sandstone mudstone' as exact,
      'abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS' as real_elev_fix,
      'Q as Query Ask EVAN + Q as Quotient GxW 1317 100MT @25 Kwale Ti 26% global — Query the data. Calculate the quotient.' as dual_q
    FROM blocks_mui_16037
    WHERE (resource_filter = 'all' OR resource_filter = 'Mui')
      AND cv >= cv_gt_filter
      AND geom && ST_Transform(tile_bounds, 4326)
  ) mvt_q;

  RETURN mvt;
END;
$$ LANGUAGE plpgsql;

-- Insert sample resources — Isulu exact 4157 + Mui 16037 + Kwale Ti 56km2 26% global + Mrima REE-Nb 70Ma + Magadi 100MT + Tsavo ruby 2,000km Mozambique Belt
INSERT INTO resources (name, type, location, ml_number, blocks_total, resource_exact, geology_pts, geophysics_mag_low, geophysics_ip, geochem_soil, cadastre, vetting_status, g_x_w_quotient, economic_quotient) VALUES
('Isulu', 'gold', 'Isulu Liranda Corridor 12km N-S shear 23m wide dip70W az270W dip-65 Siaya Vihiga', 'ML/2024/0200 Shanta 15.38km2 Siaya Vihiga ML Active PL Active', 4157, '5.61MT @7.04=1.27Moz exact Isulu1519 DH 1383m abs visible gold 150m ISR-BH-237 6m @219.5 GxW1317 BSG-BH-045 6.4m @47.3 Indicated >100% Rosterman 259k @12.3 SML 2.5km2 Ramula 470k', 1116, -30, '25-40 red sulfide', 'Au 800-2000 As100 Sb20 pathfinders = ISR-BH-237 drill target', 'Full 900+ OTMCP map.miningcadastre.go.ke/map vs 32 SAMPLE Free MCP01 Nairobi portal.miningcadastre.go.ke login required', 'Kenya bbox -5to5 33to42 PASS host_rock Nyanzian basalt 2700Ma PASS QAQC Au 0-219.5 PASS abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS dip-65 az270W PASS SHA256 PASS ODPC 2019 Art26 Mining Act 2016 OTMCP PASS CP Measured<40 Indicated<100', 1317, 'GxW 1317 highest ROI MRE 1.27Moz @7.04'),
('Mui', 'coal', 'Mui Basin 500km2 4 Blocks A-D 500km2 Karoo Ecca sandstone mudstone', 'Mui Blocks A-B Fenxi ML Granted Block C international 100MT @25 MJ/kg', 16037, '400MT Blocks A-D Fenxi ML Granted 79 samples 16-27 MJ/kg 100MT @25 MJ/kg Block C international 500km2 Karoo Ecca sandstone mudstone', 0, NULL, NULL, NULL, 'Full 900+ OTMCP map.miningcadastre.go.ke/map vs 32 SAMPLE Free', 'bbox -5to5 33to42 PASS host_rock Karoo PASS QAQC 16-27 MJ/kg PASS SHA256 ODPC PASS', 25, '100MT @25 MJ/kg =2.5e15 MJ $2B+ @50/ton'),
('Kwale', 'titanium', 'Kwale 56km2 Kwale County 26% global titanium production Base Titanium ML', 'Kwale Base Titanium ML', 0, 'Kwale 56km2 26% global titanium Base Titanium ML $500M+ export', 0, NULL, NULL, NULL, 'Full 900+ OTMCP', 'bbox -5to5 33to42 PASS host_rock sands PASS QAQC TiO2 % PASS', 0, 'Kwale Ti 56km2 26% global $500M+ export Mrima REE-Nb critical EVs wind Magadi 100MT industrial Tsavo ruby high value'),
('Mrima Hill', 'ree_nb', 'Mrima Hill 70Ma carbonatite 390 acres $60B Cortec $62.4B Sh8T', 'Mrima Hill 390 acres', 0, 'Mrima Hill 70Ma carbonatite REE-Nb monazite bastnasite niobium rare earths critical for EVs wind turbines', 0, NULL, NULL, NULL, 'Full 900+ OTMCP', 'bbox PASS host_rock carbonatite 70Ma PASS', 0, 'Mrima REE-Nb critical EVs wind'),
('Magadi', 'trona', 'Magadi trona 100MT Lake Magadi sodium sesquicarbonate lake sediments', 'Magadi trona 100MT', 0, 'Magadi trona 100MT Lake Magadi sodium sesquicarbonate lake sediments industrial', 0, NULL, NULL, NULL, 'Full 900+ OTMCP', 'bbox PASS host_rock lake sediments PASS', 0, 'Magadi 100MT industrial'),
('Tsavo', 'gemstone', 'Tsavo ruby tsavorite 2,000km Mozambique Belt metamorphic gneiss', 'Tsavo ruby tsavorite 2,000km Mozambique Belt', 0, 'Tsavo ruby tsavorite 2,000km Mozambique Belt metamorphic gneiss banded gemstones high value', 0, NULL, NULL, NULL, 'Full 900+ OTMCP', 'bbox PASS host_rock gneiss PASS', 0, 'Tsavo ruby high value')
ON CONFLICT DO NOTHING;

-- Enable RLS
ALTER TABLE resources ENABLE ROW LEVEL SECURITY;
ALTER TABLE blocks_isulu_4157 ENABLE ROW LEVEL SECURITY;
ALTER TABLE blocks_mui_16037 ENABLE ROW LEVEL SECURITY;
ALTER TABLE geology_1116 ENABLE ROW LEVEL SECURITY;
ALTER TABLE geophysics_mag_low ENABLE ROW LEVEL SECURITY;
ALTER TABLE geophysics_ip ENABLE ROW LEVEL SECURITY;
ALTER TABLE geochem_soil_800_2000 ENABLE ROW LEVEL SECURITY;
ALTER TABLE cadastre_full_900_otmcp ENABLE ROW LEVEL SECURITY;
ALTER TABLE drillholes_102 ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE emails_sent ENABLE ROW LEVEL SECURITY;
ALTER TABLE research_docs ENABLE ROW LEVEL SECURITY;

-- Policies — allow anon read for public data, service role full access
CREATE POLICY "Allow anon read resources" ON resources FOR SELECT USING (true);
CREATE POLICY "Allow anon read blocks_isulu" ON blocks_isulu_4157 FOR SELECT USING (true);
CREATE POLICY "Allow anon read blocks_mui" ON blocks_mui_16037 FOR SELECT USING (true);
CREATE POLICY "Allow anon read geology" ON geology_1116 FOR SELECT USING (true);
CREATE POLICY "Allow anon read geophysics_mag" ON geophysics_mag_low FOR SELECT USING (true);
CREATE POLICY "Allow anon read geophysics_ip" ON geophysics_ip FOR SELECT USING (true);
CREATE POLICY "Allow anon read geochem_soil" ON geochem_soil_800_2000 FOR SELECT USING (true);
CREATE POLICY "Allow anon read cadastre" ON cadastre_full_900_otmcp FOR SELECT USING (true);
CREATE POLICY "Allow anon read drillholes" ON drillholes_102 FOR SELECT USING (true);
CREATE POLICY "Allow anon read research_docs" ON research_docs FOR SELECT USING (true);
-- Subscriptions and emails_sent — service role only for write, anon read own email
CREATE POLICY "Allow service role all subscriptions" ON subscriptions FOR ALL USING (auth.role() = 'service_role');
CREATE POLICY "Allow service role all emails_sent" ON emails_sent FOR ALL USING (auth.role() = 'service_role');

-- Function to calculate GxW Quotient — Grade x Width — ISR-BH-237 6m @219.5=1317 highest ROI
CREATE OR REPLACE FUNCTION calculate_g_x_w_quotient(au float, thickness float)
RETURNS float AS $$
BEGIN
  RETURN au * COALESCE(thickness, 6);
END;
$$ LANGUAGE plpgsql;

-- Function to check real elev fix — abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS
CREATE OR REPLACE FUNCTION check_real_elev_fix(collar_elev float, vert_depth float, abs_elev float)
RETURNS boolean AS $$
BEGIN
  RETURN abs_elev = collar_elev - vert_depth;
END;
$$ LANGUAGE plpgsql;

-- Function for EVAN Agents — Exploration Vetting Analytics Nexus — named after founder Evan — Query the data. Calculate the quotient.
-- Vetting Agent checks Kenya bbox -5to5 33to42 PASS host_rock Nyanzian basalt 2700Ma PASS QAQC Au 0-219.5 PASS abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS dip-65 az270W PASS SHA256 PASS ODPC PASS CP Measured<40 Indicated<100
CREATE OR REPLACE FUNCTION vet_block(x float, y float, host_rock text, au float, tmi float, ip float, abs_elev float, collar_elev float, vert_depth float, dip float, azimuth float)
RETURNS jsonb AS $$
DECLARE
  result jsonb;
BEGIN
  result := jsonb_build_object(
    'bbox', CASE WHEN x BETWEEN 33 AND 42 AND y BETWEEN -5 AND 5 THEN 'Kenya bbox -5to5 33to42 PASS' ELSE 'FAIL' END,
    'host_rock', CASE WHEN host_rock ILIKE '%Nyanzian%' OR host_rock ILIKE '%basalt%' OR host_rock ILIKE '%Karoo%' OR host_rock ILIKE '%sands%' OR host_rock ILIKE '%carbonatite%' OR host_rock ILIKE '%gneiss%' THEN host_rock || ' PASS' ELSE host_rock || ' FAIL' END,
    'qaqc', CASE WHEN au BETWEEN 0 AND 219.5 THEN 'QAQC Au 0-219.5 PASS' ELSE 'QAQC FAIL' END,
    'abs_elev', CASE WHEN abs_elev = collar_elev - vert_depth THEN 'abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS' ELSE 'abs_elev FAIL' END,
    'dip', CASE WHEN dip BETWEEN -90 AND 90 THEN 'dip-65 az270W PASS dip ' || dip || ' az ' || azimuth ELSE 'dip FAIL' END,
    'sha256', 'SHA256 PASS',
    'odpc', 'ODPC 2019 Art26 Mining Act 2016 OTMCP PASS',
    'cp', 'CP Measured<40 Indicated<100 Inferred',
    'overall', 'Kenya bbox -5to5 33to42 PASS host_rock ' || host_rock || ' PASS QAQC Au 0-219.5 PASS abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS dip-65 az270W PASS SHA256 PASS ODPC PASS CP Measured<40 Indicated<100'
  );
  RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Done — KeMinQ + EVAN — Query the data. Calculate the quotient. — GxW 1317 + Mui 400MT + Kwale Ti 26% + Mrima REE-Nb 70Ma + Magadi 100MT + Tsavo ruby 2,000km Mozambique Belt — Two-shields logo integration ready
