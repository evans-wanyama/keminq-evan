
-- Kenya Mineral AI v9.0 Production Schema
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE public.users (
  id UUID PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  plan TEXT NOT NULL DEFAULT 'free' CHECK (plan IN ('free','pro','enterprise')),
  stripe_customer_id TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE public.knowledge_base (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  type TEXT CHECK (type IN ('book','journal','industry_report','government','model')),
  citation TEXT,
  content TEXT,
  content_embedding VECTOR(1536),
  source_url TEXT,
  sha256 TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE public.occurrences (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  geom GEOMETRY(Point, 4326) NOT NULL,
  occurrence_name TEXT,
  host_rock TEXT,
  age_ma INT,
  mineral TEXT,
  grade_gpt NUMERIC,
  source TEXT,
  sha256 TEXT,
  vetted BOOLEAN DEFAULT false,
  contributor_id UUID,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE public.isulu_blocks (
  id SERIAL PRIMARY KEY,
  x NUMERIC, y NUMERIC, z NUMERIC,
  abs_elev NUMERIC,
  vert_depth NUMERIC,
  au_gpt NUMERIC CHECK (au_gpt BETWEEN 0 AND 219.5),
  au_cutoff NUMERIC,
  category TEXT CHECK (category IN ('Measured','Indicated','Inferred')),
  g_x_w NUMERIC,
  borehole_id TEXT,
  geom GEOMETRY(Point, 4326)
);

CREATE TABLE public.mui_blocks (
  id SERIAL PRIMARY KEY,
  x NUMERIC, y NUMERIC, z NUMERIC,
  mj_kg NUMERIC,
  ash_pct NUMERIC,
  s_pct NUMERIC,
  block TEXT,
  geom GEOMETRY(Point, 4326)
);

CREATE TABLE public.geology_overlay (
  id SERIAL PRIMARY KEY,
  lithology TEXT,
  structure TEXT,
  dip NUMERIC,
  azimuth NUMERIC,
  width_m NUMERIC,
  length_km NUMERIC,
  alteration TEXT,
  geom GEOMETRY(Point, 4326)
);

CREATE TABLE public.geophysics (
  id SERIAL PRIMARY KEY,
  tmi_nt NUMERIC,
  ip_mv_v NUMERIC,
  mag_low_bool BOOLEAN,
  ip_high_bool BOOLEAN,
  anomaly_type TEXT,
  geom GEOMETRY(Point, 4326)
);

CREATE TABLE public.geochemistry (
  id SERIAL PRIMARY KEY,
  au_ppb NUMERIC,
  as_ppm NUMERIC,
  sb_ppm NUMERIC,
  sample_type TEXT,
  geom GEOMETRY(Point, 4326)
);

CREATE TABLE public.cadastre (
  id SERIAL PRIMARY KEY,
  license_no TEXT,
  type TEXT,
  status TEXT,
  area_km2 NUMERIC,
  holder TEXT,
  commodity TEXT,
  county TEXT,
  geom GEOMETRY(Polygon, 4326)
);

CREATE TABLE public.ingestion_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  file_name TEXT,
  sha256 TEXT,
  source TEXT,
  bbox_check BOOLEAN,
  qa_qc_check BOOLEAN,
  host_rock_check BOOLEAN,
  status TEXT,
  user_id UUID,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE public.chat_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID,
  query TEXT,
  answer TEXT,
  citations JSONB,
  confidence NUMERIC,
  vetting JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
