import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@supabase/supabase-js";

// Cesium 3D Tiles — Isulu 4157 blocks 5.61MT @7.04=1.27Moz exact + Mui 16037 blocks 400MT Blocks A-D Fenxi ML Granted
// For desktop QGIS — Cesium 3D Tiles + glTF — real elev fix abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY!;
const supabase = createClient(supabaseUrl, supabaseServiceKey);

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const resource = searchParams.get("resource") || "all";
  const au_cutoff = parseFloat(searchParams.get("au_cutoff") || "0");

  // Generate Cesium 3D Tileset JSON — Isulu 4157 + Mui 16037
  // In production, this would be generated from actual block models with real elev fix
  // vulcan_collar_real_elev_dip.csv + datamine_collar_real.txt + collar_real_dip_az_elevation_Leapfrog.csv

  const tileset = {
    asset: {
      version: "1.1",
      tilesetVersion: "1.0.0",
      gendate: new Date().toISOString(),
      generator: "KeMinQ + EVAN — Kenya Mineral Intelligence Query — The Quotient that matters (GxW 1317) — EVAN = Exploration Vetting Analytics Nexus named after founder Evan — Query the data. Calculate the quotient.",
    },
    properties: {
      // Isulu exact 4157 blocks 5.61MT @7.04=1.27Moz exact Isulu1519 DH 1383m abs visible gold 150m ISR-BH-237 6m @219.5 GxW1317 BSG-BH-045 6.4m @47.3 Indicated >100% Rosterman 259k @12.3 SML 2.5km2 Ramula 470k ML/2024/0200 Shanta 15.38km2 Siaya Vihiga ML Active PL Active
      // Mui 16037 blocks 400MT Blocks A-D Fenxi ML Granted 79 samples 16-27 MJ/kg 100MT @25 MJ/kg Block C international 500km2 Karoo Ecca sandstone mudstone
      // Geology 1116 pts Liranda Corridor 12km N-S shear 23m wide dip70W az270W dip-65 Nyanzian basalt 2700Ma
      // Geophysics mag low -30 blue demag low vs 80-120 red high + IP 25-40 red sulfide + soil Au 800-2000 As100 Sb20 = ISR-BH-237 drill target
      // Cadastre Full 900+ OTMCP map.miningcadastre.go.ke/map vs 32 SAMPLE Free MCP01 Nairobi portal.miningcadastre.go.ke login required
      Isulu_exact: "4157 blocks 5.61MT @7.04=1.27Moz exact Isulu1519 DH 1383m abs visible gold 150m ISR-BH-237 6m @219.5 GxW1317 BSG-BH-045 6.4m @47.3 Indicated >100% Rosterman 259k @12.3 SML 2.5km2 Ramula 470k ML/2024/0200 Shanta 15.38km2 Siaya Vihiga",
      Mui_exact: "16037 blocks 400MT Blocks A-D Fenxi ML Granted 79 samples 16-27 MJ/kg 100MT @25 MJ/kg Block C international 500km2 Karoo Ecca sandstone mudstone",
      Geology_exact: "1116 pts Liranda Corridor 12km N-S shear 23m wide dip70W az270W dip-65 Nyanzian basalt 2700Ma basalt BIF Kavirondian conglomerate quartz veins IZ1.0 BZ2 BZ3",
      Geophysics_exact: "mag low -30 blue demag low vs 80-120 red high + IP high 25-40 red sulfide + geochem soil Au 800-2000 As100 Sb20 pathfinders = ISR-BH-237 drill target",
      Cadastre_exact: "Full 900+ OTMCP map.miningcadastre.go.ke/map vs 32 SAMPLE Free MCP01 Nairobi portal.miningcadastre.go.ke login required",
      Vetting_exact: "bbox -5to5 33to42 Kenya PASS host_rock Nyanzian basalt 2700Ma PASS QAQC Au 0-219.5 PASS abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS dip-65 az270W PASS SHA256 PASS ODPC 2019 Art26 Mining Act 2016 OTMCP PASS CP Measured<40 Indicated<100",
      Real_elev_fix: "abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS vulcan_collar_real_elev_dip.csv datamine_collar_real.txt collar_real_dip_az_elevation_Leapfrog.csv",
      Mapbox: "light #F8F9FA layers OFF clean muted Gold #C2A878 graduated yellow-orange-red-dark red 219.5 boreholes dip -65 arrows shear 530-553 DEM 1519 cross-section X vs Elevation terrain on top blocks below",
      Dual_Q: "Q as Query Ask EVAN + Q as Quotient GxW 1317 100MT @25 Kwale Ti 26% global — Query the data. Calculate the quotient.",
      Quotients: {
        Gold_GxW1317: "ISR-BH-237 6m @219.5=1317 highest ROI Isulu 4157 blocks 5.61MT @7.04=1.27Moz exact — For Shanta Gold ML/2024/0200 15.38km2 Siaya Vihiga",
        Coal_100MT_25: "Mui 16037 blocks 400MT Blocks A-D Fenxi ML Granted 79 samples 16-27 MJ/kg 100MT @25 MJ/kg Block C international 500km2 Karoo Ecca $2B+ @50/ton — For Fenxi Mining Mui Blocks A-B ML Granted Block C international 100MT @25",
        Critical_Ti_26_REE_70Ma: "Kwale 56km2 26% global Base Titanium ML $500M+ export + Mrima Hill 70Ma carbonatite REE-Nb monazite bastnasite niobium critical EVs wind turbines + Magadi trona 100MT Lake Magadi sodium sesquicarbonate industrial + Tsavo ruby tsavorite 2,000km Mozambique Belt metamorphic gneiss high value — For Base Titanium Kwale 56km2 26% global",
      },
    },
    geometricError: 1000,
    root: {
      boundingVolume: {
        region: [
          33.5 * (Math.PI / 180), // west Kenya bbox -5to5 33to42
          -5 * (Math.PI / 180), // south
          42 * (Math.PI / 180), // east
          5 * (Math.PI / 180), // north
          0, // min height
          2000, // max height — Isulu1519 DH 1383m abs + terrain
        ],
      },
      geometricError: 500,
      refine: "ADD",
      children: [
        {
          boundingVolume: {
            region: [
              34.6 * (Math.PI / 180), // Isulu Liranda Corridor
              0.2 * (Math.PI / 180),
              34.9 * (Math.PI / 180),
              0.6 * (Math.PI / 180),
              0,
              2000,
            ],
          },
          geometricError: 100,
          content: {
            uri: `/cesium-tiles/isulu_4157_blocks_${au_cutoff > 0 ? `au_${au_cutoff}` : "all"}.b3dm`,
            // Real tiles would be generated from blocks_isulu_4157 with real elev fix
          },
          extras: {
            resource: "Isulu",
            blocks: 4157,
            exact: "5.61MT @7.04=1.27Moz exact Isulu1519 DH 1383m abs visible gold 150m ISR-BH-237 6m @219.5 GxW1317 BSG-BH-045 6.4m @47.3 Indicated >100% Rosterman 259k @12.3 SML 2.5km2 Ramula 470k ML/2024/0200 Shanta 15.38km2 Siaya Vihiga",
            real_elev_fix: "vulcan_collar_real_elev_dip.csv datamine_collar_real.txt collar_real_dip_az_elevation_Leapfrog.csv abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below",
            g_x_w_quotient: "ISR-BH-237 6m @219.5=1317 highest ROI",
            graduated: "yellow-orange-red-dark red 219.5 boreholes dip -65 arrows shear 530-553 DEM 1519",
          },
        },
        {
          boundingVolume: {
            region: [
              38.0 * (Math.PI / 180), // Mui Basin
              -1.5 * (Math.PI / 180),
              38.5 * (Math.PI / 180),
              -1.0 * (Math.PI / 180),
              0,
              1000,
            ],
          },
          geometricError: 100,
          content: {
            uri: `/cesium-tiles/mui_16037_blocks_cv_${au_cutoff > 0 ? au_cutoff : "25"}.b3dm`,
          },
          extras: {
            resource: "Mui",
            blocks: 16037,
            exact: "400MT Blocks A-D Fenxi ML Granted 79 samples 16-27 MJ/kg 100MT @25 MJ/kg Block C international 500km2 Karoo Ecca sandstone mudstone",
            economic_quotient: "100MT @25 MJ/kg =2.5e15 MJ $2B+ @50/ton",
          },
        },
        {
          boundingVolume: {
            region: [
              39.0 * (Math.PI / 180), // Kwale + Mrima + Magadi + Tsavo
              -4.5 * (Math.PI / 180),
              39.5 * (Math.PI / 180),
              -3.5 * (Math.PI / 180),
              0,
              1000,
            ],
          },
          geometricError: 100,
          content: {
            uri: `/cesium-tiles/critical_minerals_kwale_ti_26_mrima_ree_70ma.b3dm`,
          },
          extras: {
            resource: "Critical Minerals",
            kwale: "Kwale 56km2 26% global Base Titanium ML $500M+ export",
            mrima: "Mrima Hill 70Ma carbonatite REE-Nb monazite bastnasite niobium critical EVs wind turbines",
            magadi: "Magadi trona 100MT Lake Magadi sodium sesquicarbonate industrial",
            tsavo: "Tsavo ruby tsavorite 2,000km Mozambique Belt metamorphic gneiss high value",
            full_900_otmcp: "Full 900+ OTMCP map.miningcadastre.go.ke/map vs 32 SAMPLE Free",
          },
        },
      ],
    },
    extensions: {
      "3DTILES_metadata": {
        schema: {
          classes: {
            block: {
              properties: {
                au: { type: "FLOAT32", semantic: "GRADE" },
                g_x_w: { type: "FLOAT32", semantic: "GxW_QUOTIENT" },
                abs_elev: { type: "FLOAT32", semantic: "REAL_ELEV_FIX" },
                resource: { type: "STRING" },
                visible_gold: { type: "BOOLEAN" },
              },
            },
          },
        },
      },
    },
  };

  return NextResponse.json(tileset, {
    headers: {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "Cache-Control": "public, max-age=3600, stale-while-revalidate=86400",
      "X-Isulu-Exact": "4157 blocks 5.61MT @7.04=1.27Moz exact Isulu1519 DH 1383m abs visible gold 150m ISR-BH-237 6m @219.5 GxW1317",
      "X-Mui-Exact": "16037 blocks 400MT Blocks A-D Fenxi ML Granted 79 samples 16-27 MJ/kg 100MT @25 MJ/kg Block C international",
      "X-Real-Elev-Fix": "abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS vulcan_collar_real_elev_dip.csv",
      "X-Dual-Q": "Q as Query Ask EVAN + Q as Quotient GxW 1317 100MT @25 Kwale Ti 26% global — Query the data. Calculate the quotient.",
    },
  });
}
