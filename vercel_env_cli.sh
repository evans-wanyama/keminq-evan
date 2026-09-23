#!/bin/bash
# KeMinQ Vercel Env CLI — One-line paste for vercel env add — Tonight from Nairobi
# KeMinQ = Kenya Mineral Intelligence Query — The Quotient that matters (GxW 1317) — EVAN = Exploration Vetting Analytics Nexus named after founder Evan — Query the data. Calculate the quotient.
# Gold DB exact Isulu 4157 blocks 5.61MT @7.04=1.27Moz exact Isulu1519 DH 1383m abs visible gold 150m ISR-BH-237 6m @219.5 GxW1317 BSG-BH-045 6.4m @47.3 Indicated >100% Rosterman 259k @12.3 SML 2.5km2 Ramula 470k ML/2024/0200 Shanta 15.38km2 Siaya Vihiga ML Active PL Active Liranda shear 23m 12km dip70W az270W dip-65 Nyanzian basalt 2700Ma + Mui 16037 400MT Blocks A-D Fenxi ML Granted 79 samples 16-27 MJ/kg 100MT @25 MJ/kg Block C international 500km2 Karoo Ecca sandstone mudstone + Kwale Ti 56km2 26% global Base Titanium ML + Mrima REE-Nb 70Ma carbonatite + Magadi trona 100MT + Tsavo ruby tsavorite 2,000km Mozambique Belt + geology 1116 Liranda shear + geophysics mag low -30 blue demag low vs 80-120 red high + IP 25-40 red sulfide + geochem soil Au 800-2000 As100 Sb20 + cadastre Full 900+ OTMCP vs 32 SAMPLE Free MCP01 Nairobi portal.miningcadastre.go.ke login required — Vetting engine Kenya bbox -5to5 33to42 host_rock Nyanzian 2700Ma QAQC Au 0-219.5 TMI -50 to120 IP 0-40 abs_elev=collar-vert_depth Isulu1519 dip-65 az270W SHA256 ODPC Mining Act 2016 CP Measured<40 Indicated<100 — Mapbox light #F8F9FA layers OFF clean muted Gold #C2A878 graduated yellow-orange-red-dark red 219.5 boreholes dip -65 arrows shear 530-553 DEM 1519 cross-section X vs Elevation terrain on top blocks below real elev fix vulcan_collar_real_elev_dip.csv datamine_collar_real.txt collar_real_dip_az_elevation_Leapfrog.csv — Tech Supabase PostGIS EPSG:4326 pgvector Vercel AI SDK RAG OpenAI embeddings Mapbox light Three.js Deck.gl Stripe MVT tiles /v1/map/tiles/{z}/{x}/{y}.mvt API /v1/resource/Isulu/blocks?au_cutoff=50&g_x_w_gt=1317 QGIS 5.9MB GPKG SHP GeoTIFF DEM 1519 QGS KML KMZ Vulcan Datamine Leapfrog Cesium 3D Tiles glTF — Business Model Free $0 EVAN Lite truncated 60 Samsam 32 SAMPLE, Pro $99 EVAN Pro Query + Quotient full 3D 4157+16037 geology 1116 geophysics mag low -30 IP 25-40 geochem 800-2000 exports QGIS 5.9MB Vulcan Datamine Leapfrog KML MVT drill target GxW1317 valuation upload realtime high-res, Enterprise $499 EVAN CP Query + Quotient + JORC Table1 NI43-101 API CP sign-off Measured<40 Indicated<100 white label — Dual Q Q as Query Ask EVAN + Q as Quotient GxW 1317 100MT @25 Kwale Ti 26% global — Query the data. Calculate the quotient.

# ONE-LINE VERCEL ENV PASTE — For Vercel Dashboard Bulk Paste (recommended)
# Open https://vercel.com/your-team/keminq-evan/settings/environment-variables
# Click "Add" -> Bulk Paste -> Paste all lines from vercel_env_bulk_paste.txt
# Replace placeholder values (your-project, eyJ..., sk-xxx, pk.xxx, re_xxx, pk_test_xxx, sk_test_xxx, whsec_xxx) with your real keys
# Set Environment = Production, Preview, Development (all 3) -> Save -> vercel --prod

echo "KeMinQ Vercel Env Paste — One-line ready — GxW 1317 + Mui 400MT + Kwale Ti 26% + Mrima REE-Nb 70Ma + Magadi 100MT + Tsavo ruby 2,000km Mozambique Belt — Two-shields logo integration ready — evan@keminq.ai"

# CLI alternative — vercel env add — Run these one by one if dashboard bulk paste fails
# Replace YOUR_VALUE with real values — These are all from env.example.final

# Branding - Dual Q
vercel env add NEXT_PUBLIC_APP_NAME production <<< "KeMinQ"
vercel env add NEXT_PUBLIC_APP_FULL_NAME production <<< "Kenya Mineral Intelligence Query"
vercel env add NEXT_PUBLIC_AI_NAME production <<< "EVAN"
vercel env add NEXT_PUBLIC_AI_FULL production <<< "Exploration Vetting Analytics Nexus"
vercel env add NEXT_PUBLIC_AI_NAMED_AFTER production <<< "Founder Evan — Your AI Resource Geologist"
vercel env add NEXT_PUBLIC_BRAND production <<< "KeMinQ = Kenya Mineral Intelligence Query — The Quotient that matters (GxW 1317)"
vercel env add NEXT_PUBLIC_TAGLINE production <<< "Query the data. Calculate the quotient."
vercel env add NEXT_PUBLIC_DUAL_Q production <<< "Q as Query (user-facing Ask EVAN) + Quotient (technical GxW 1317 Grade x Width ISR-BH-237 6m @219.5 highest ROI + 100MT @25 MJ/kg Mui + Kwale Ti 56km2 26% global)"

# Exact Data - Vetted
vercel env add NEXT_PUBLIC_ISULU_EXACT production <<< "4157 blocks 5.61MT @7.04=1.27Moz exact ISR-BH-237 6m @219.5 GxW1317 Isulu1519 DH 1383m abs visible gold 150m BSG-BH-045 6.4m @47.3 Indicated >100% Rosterman 259k @12.3 Ramula 470k ML/2024/0200 15.38km2 Siaya Vihiga ML Active PL Active"
vercel env add NEXT_PUBLIC_MUI_EXACT production <<< "16037 blocks 400MT Blocks A-D Fenxi ML Granted 79 samples 16-27 MJ/kg 100MT @25 MJ/kg Block C international 500km2 Karoo Ecca sandstone mudstone"
vercel env add NEXT_PUBLIC_GEOLOGY_EXACT production <<< "1116 pts Liranda Corridor 12km N-S shear 23m wide dip70W az270W dip-65 Nyanzian 2700Ma basalt BIF"
vercel env add NEXT_PUBLIC_GEOPHYSICS_EXACT production <<< "mag low -30 blue demag low vs 80-120 red high + IP high 25-40 red sulfide + soil Au 800-2000 ppb As100 Sb20 pathfinders"
vercel env add NEXT_PUBLIC_CADASTRE_EXACT production <<< "Full 900+ OTMCP map.miningcadastre.go.ke/map vs 32 SAMPLE Free, ML Active PL Active, MCP01 Nairobi portal.miningcadastre.go.ke login required"
vercel env add NEXT_PUBLIC_VETTING_EXACT production <<< "bbox -5to5 33to42 Kenya PASS host_rock Nyanzian basalt 2700Ma PASS QAQC Au 0-219.5 g/t PASS abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS dip -65 az270W PASS SHA256 PASS ODPC 2019 Art26 Mining Act 2016 OTMCP PASS CP Measured<40 Indicated<100 Inferred"

# Supabase / PostGIS - REPLACE WITH YOUR REAL PROJECT
vercel env add NEXT_PUBLIC_SUPABASE_URL production <<< "https://your-project.supabase.co"
vercel env add NEXT_PUBLIC_SUPABASE_ANON_KEY production <<< "eyJhbGciOiJIUzI1NiIs..."
vercel env add SUPABASE_SERVICE_ROLE_KEY production <<< "eyJhbGciOiJIUzI1NiIs..."

# AI / RAG - EVAN
vercel env add OPENAI_API_KEY production <<< "sk-xxx"
vercel env add NEXT_PUBLIC_OPENAI_MODEL production <<< "gpt-4o-mini"

# Mapbox - Light theme clean muted Gold #F8F9FA layers OFF
vercel env add MAPBOX_TOKEN production <<< "pk.xxx"
vercel env add NEXT_PUBLIC_MAPBOX_TOKEN production <<< "pk.xxx"
vercel env add NEXT_PUBLIC_MAPBOX_STYLE production <<< "mapbox://styles/mapbox/light-v11"
vercel env add NEXT_PUBLIC_MAPBOX_LIGHT_COLOR production <<< "#F8F9FA"
vercel env add NEXT_PUBLIC_MAPBOX_LAYERS_OFF production <<< "true"
vercel env add NEXT_PUBLIC_MAPBOX_GOLD_MUTED production <<< "#C2A878"
vercel env add NEXT_PUBLIC_MAPBOX_GRADUATED production <<< "yellow-orange-red-dark red 219.5"

# WebGPU + Real-time AI
vercel env add NEXT_PUBLIC_WEBGPU_ENABLED production <<< "true"
vercel env add NEXT_PUBLIC_WEBGPU_KRIGING_NUGGET production <<< "0.15"
vercel env add NEXT_PUBLIC_WEBGPU_KRIGING_SILL production <<< "1.2"
vercel env add NEXT_PUBLIC_WEBGPU_KRIGING_RANGE_STRIKE production <<< "45"
vercel env add NEXT_PUBLIC_GXW_QUOTIENT production <<< "1317"
vercel env add NEXT_PUBLIC_GXW_HOLE production <<< "ISR-BH-237 6m @219.5=1317 highest ROI"
vercel env add NEXT_PUBLIC_REAL_ELEV_FIX production <<< "abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS vulcan_collar_real_elev_dip.csv"

# MVT + Cesium + API
vercel env add NEXT_PUBLIC_MVT_TILES_URL production <<< "/v1/map/tiles/{z}/{x}/{y}.mvt"
vercel env add NEXT_PUBLIC_CESIUM_TILES_URL production <<< "/cesium_3d_tiles_isulu_4157_mui_16037.json"
vercel env add NEXT_PUBLIC_API_BLOCKS_ISULU production <<< "/v1/resource/Isulu/blocks?au_cutoff=50&g_x_w_gt=1317"
vercel env add NEXT_PUBLIC_WS_EVAN_AGENTS production <<< "/ws/evan-agents"

# Stripe - EVAN Pro Query + Quotient
vercel env add NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY production <<< "pk_test_xxx"
vercel env add STRIPE_SECRET_KEY production <<< "sk_test_xxx"
vercel env add STRIPE_WEBHOOK_SECRET production <<< "whsec_xxx"
vercel env add NEXT_PUBLIC_APP_URL production <<< "https://keminq.ai"
vercel env add NEXT_PUBLIC_STRIPE_PRO_PRICE_ID production <<< "price_pro_99_query_quotient_gxw1317"
vercel env add NEXT_PUBLIC_STRIPE_ENTERPRISE_PRICE_ID production <<< "price_enterprise_499_query_quotient_cp"
vercel env add NEXT_PUBLIC_STRIPE_CP_REPORT_PRICE_ID production <<< "price_cp_999_oneoff"

# Emails - Resend - EVAN Sequence Day0 GxW1317 Day3 Mui 400MT Day7 Kwale Ti 26% + Mrima REE-Nb 70Ma + Magadi 100MT Enterprise $499 upsell
vercel env add RESEND_API_KEY production <<< "re_xxx"
vercel env add EMAIL_FROM production <<< "EVAN by KeMinQ <evan@keminq.ai>"
vercel env add EMAIL_REPLY_TO production <<< "evan@keminq.ai"

# Exports - Real Elev Fix
vercel env add NEXT_PUBLIC_VULCAN_FILE production <<< "vulcan_collar_real_elev_dip.csv"
vercel env add NEXT_PUBLIC_DATAMINE_FILE production <<< "datamine_collar_real.txt"
vercel env add NEXT_PUBLIC_LEAPFROG_FILE production <<< "collar_real_dip_az_elevation_Leapfrog.csv"

# Business Model
vercel env add NEXT_PUBLIC_PRICING_PRO production <<< "Pro $99/mo = EVAN Pro Query + Quotient full 3D 4157+16037 geology 1116 geophysics mag low -30 IP 25-40 geochem 800-2000 exports QGIS Vulcan Datamine Leapfrog KML MVT drill target GxW1317 valuation upload realtime high-res"
vercel env add NEXT_PUBLIC_PRICING_ENTERPRISE production <<< "Enterprise $499/mo = EVAN CP Query + Quotient + JORC Table1 NI43-101 API CP sign-off Measured<40 Indicated<100 Inferred white label valuation pitch deck"

# Done — KeMinQ + EVAN — Query the data. Calculate the quotient. — GxW 1317 + Mui 400MT + Kwale Ti 26% + Mrima REE-Nb 70Ma + Magadi 100MT + Tsavo ruby 2,000km Mozambique Belt — Two-shields logo integration ready — evan@keminq.ai — vercel --prod tonight from Nairobi

echo "Paste complete — Now run: vercel --prod — evan@keminq.ai — GxW 1317 + Mui 400MT + Kwale Ti 26% + Mrima REE-Nb 70Ma + Magadi 100MT + Tsavo ruby 2,000km Mozambique Belt — Two-shields logo integration ready — Query the data. Calculate the quotient."
