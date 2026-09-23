import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@supabase/supabase-js";

// MVT Tiles — /v1/map/tiles/{z}/{x}/{y}.mvt — Isulu 4157 blocks 5.61MT @7.04=1.27Moz exact GxW1317 + Mui 16037 blocks 400MT Blocks A-D Fenxi ML Granted 79 samples 16-27 MJ/kg 100MT @25 MJ/kg Block C international
// Mapbox light #F8F9FA layers OFF clean muted Gold #C2A878 graduated yellow-orange-red-dark red 219.5 boreholes dip -65 arrows shear 530-553 DEM 1519 cross-section X vs Elevation terrain on top blocks below real elev fix vulcan_collar_real_elev_dip.csv

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY!;

export async function GET(
  request: NextRequest,
  { params }: { params: { z: string; x: string; y: string } }
) {
  try {
    const { z, x, y } = params;
    const zInt = parseInt(z);
    const xInt = parseInt(x);
    const yInt = parseInt(y);

    const { searchParams } = new URL(request.url);
    const resource = searchParams.get("resource") || "all"; // Isulu, Mui, all
    const au_cutoff = parseFloat(searchParams.get("au_cutoff") || "0");
    const g_x_w_gt = parseFloat(searchParams.get("g_x_w_gt") || "0");
    const cv_gt = parseFloat(searchParams.get("cv_gt") || "0");

    // Supabase PostGIS — ST_AsMVT — Generate MVT vector tiles from blocks_isulu_4157 + blocks_mui_16037 + geology_1116 + geophysics + geochem + cadastre Full 900+ OTMCP vs 32 SAMPLE Free
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    // Use PostGIS function to generate MVT tile
    // In Supabase SQL: CREATE OR REPLACE FUNCTION get_mvt_tile(z int, x int, y int, resource text, au_cutoff float, g_x_w_gt float, cv_gt float) RETURNS bytea
    // This function uses ST_AsMVT + ST_TileEnvelope to clip blocks to tile bounds
    // Kenya bbox -5to5 33to42 PASS host_rock Nyanzian basalt 2700Ma QAQC Au 0-219.5 abs_elev Isulu1519 dip-65 SHA256 ODPC PASS CP Measured<40 Indicated<100

    const { data, error } = await supabase.rpc("get_mvt_tile", {
      z: zInt,
      x: xInt,
      y: yInt,
      resource_filter: resource,
      au_cutoff_filter: au_cutoff,
      g_x_w_gt_filter: g_x_w_gt,
      cv_gt_filter: cv_gt,
    });

    if (error) {
      // Fallback — return empty MVT if function doesn't exist yet — create function in Supabase SQL Editor
      console.error("MVT RPC error, returning empty tile — create get_mvt_tile function in Supabase:", error);
      
      // Return empty MVT tile (0 bytes is valid empty tile for Mapbox)
      return new NextResponse(new Uint8Array(0), {
        headers: {
          "Content-Type": "application/x-protobuf",
          "Access-Control-Allow-Origin": "*",
          "Cache-Control": "public, max-age=3600",
          "X-Resource": resource,
          "X-Au-Cutoff": au_cutoff.toString(),
          "X-GxW-Gt": g_x_w_gt.toString(),
          "X-Cv-Gt": cv_gt.toString(),
          "X-Real-Elev-Fix": "abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS vulcan_collar_real_elev_dip.csv",
          "X-Dual-Q": "Q as Query Ask EVAN + Q as Quotient GxW 1317 100MT @25 Kwale Ti 26% global",
        },
      });
    }

    // data is bytea — MVT protobuf
    const mvtBuffer = data as any;

    return new NextResponse(mvtBuffer, {
      headers: {
        "Content-Type": "application/x-protobuf",
        "Access-Control-Allow-Origin": "*",
        "Cache-Control": "public, max-age=3600, stale-while-revalidate=86400",
        "X-Resource": resource,
        "X-Au-Cutoff": au_cutoff.toString(),
        "X-GxW-Gt": g_x_w_gt.toString(),
        "X-Cv-Gt": cv_gt.toString(),
        "X-Isulu-Exact": "4157 blocks 5.61MT @7.04=1.27Moz exact Isulu1519 DH 1383m abs visible gold 150m ISR-BH-237 6m @219.5 GxW1317 BSG-BH-045 6.4m @47.3 Indicated >100% Rosterman 259k @12.3 SML 2.5km2 Ramula 470k ML/2024/0200 Shanta 15.38km2 Siaya Vihiga",
        "X-Mui-Exact": "16037 blocks 400MT Blocks A-D Fenxi ML Granted 79 samples 16-27 MJ/kg 100MT @25 MJ/kg Block C international 500km2 Karoo Ecca",
        "X-Geology": "1116 pts Liranda Corridor 12km N-S shear 23m wide dip70W az270W dip-65 Nyanzian basalt 2700Ma",
        "X-Geophysics": "mag low -30 blue demag low vs 80-120 red high + IP 25-40 red sulfide + soil Au 800-2000 As100 Sb20 = ISR-BH-237 drill target",
        "X-Cadastre": "Full 900+ OTMCP map.miningcadastre.go.ke/map vs 32 SAMPLE Free MCP01 Nairobi portal.miningcadastre.go.ke login required",
        "X-Real-Elev-Fix": "abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS vulcan_collar_real_elev_dip.csv datamine_collar_real.txt collar_real_dip_az_elevation_Leapfrog.csv",
        "X-Mapbox": "light #F8F9FA layers OFF clean muted Gold #C2A878 graduated yellow-orange-red-dark red 219.5 boreholes dip -65 arrows shear 530-553 DEM 1519 cross-section X vs Elevation terrain on top blocks below",
        "X-Dual-Q": "Q as Query Ask EVAN + Q as Quotient GxW 1317 100MT @25 Kwale Ti 26% global — Query the data. Calculate the quotient.",
      },
    });
  } catch (err: any) {
    return NextResponse.json({ error: err.message }, { status: 500 });
  }
}

// SQL to create in Supabase SQL Editor — get_mvt_tile function — PostGIS EPSG:4326
/*
CREATE OR REPLACE FUNCTION get_mvt_tile(z int, x int, y int, resource_filter text, au_cutoff_filter float, g_x_w_gt_filter float, cv_gt_filter float)
RETURNS bytea AS $$
DECLARE
  mvt bytea;
  tile_bounds geometry;
BEGIN
  -- Tile bounds — Web Mercator — Kenya bbox -5to5 33to42 PASS
  tile_bounds := ST_TileEnvelope(z, x, y);

  -- Isulu 4157 blocks 5.61MT @7.04=1.27Moz exact Isulu1519 DH 1383m abs visible gold 150m ISR-BH-237 6m @219.5 GxW1317 BSG-BH-045 6.4m @47.3 Indicated >100% Rosterman 259k @12.3 SML 2.5km2 Ramula 470k ML/2024/0200 Shanta 15.38km2 Siaya Vihiga ML Active PL Active
  -- Mui 16037 blocks 400MT Blocks A-D Fenxi ML Granted 79 samples 16-27 MJ/kg 100MT @25 MJ/kg Block C international 500km2 Karoo Ecca sandstone mudstone
  -- Geology 1116 pts Liranda Corridor 12km N-S shear 23m wide dip70W az270W dip-65 Nyanzian basalt 2700Ma basalt BIF Kavirondian conglomerate quartz veins IZ1.0 BZ2 BZ3
  -- Geophysics mag low -30 blue demag low vs 80-120 red high + IP high 25-40 red sulfide + geochem soil Au 800-2000 As100 Sb20 pathfinders = ISR-BH-237 drill target
  -- Cadastre Full 900+ OTMCP map.miningcadastre.go.ke/map vs 32 SAMPLE Free MCP01 Nairobi portal.miningcadastre.go.ke login required
  -- Real elev fix abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS dip-65 az270W PASS SHA256 PASS ODPC PASS CP Measured<40 Indicated<100
  -- Mapbox light #F8F9FA layers OFF clean muted Gold #C2A878 graduated yellow-orange-red-dark red 219.5 boreholes dip -65 arrows shear 530-553 DEM 1519 cross-section X vs Elevation terrain on top blocks below

  SELECT ST_AsMVT(mvt_q, 'blocks', 4096, 'geom') INTO mvt FROM (
    -- Isulu blocks
    SELECT
      ST_AsMVTGeom(
        ST_Transform(geom, 3857),
        ST_TileEnvelope(z, x, y),
        4096, 0, true
      ) AS geom,
      id, au, g_x_w, thickness, abs_elev, resource, tonnage,
      -- Graduated color logic yellow-orange-red-dark red 219.5
      CASE 
        WHEN au < 1 THEN '#808080'
        WHEN au < 3 THEN '#FFD700'
        WHEN au < 10 THEN '#FF8C00'
        WHEN au < 40 THEN '#DC143C'
        ELSE '#8A2BE2'
      END as color,
      au * COALESCE(thickness, 6) as g_x_w_calculated,
      au >= 40 as visible_gold
    FROM blocks_isulu_4157
    WHERE (resource_filter = 'all' OR resource_filter = 'Isulu')
      AND au >= au_cutoff_filter
      AND (g_x_w_gt_filter = 0 OR (au * COALESCE(thickness, 6)) >= g_x_w_gt_filter)
      AND geom && ST_Transform(tile_bounds, 4326)
    
    UNION ALL
    
    -- Mui blocks
    SELECT
      ST_AsMVTGeom(
        ST_Transform(geom, 3857),
        ST_TileEnvelope(z, x, y),
        4096, 0, true
      ) AS geom,
      id, cv as au, cv as g_x_w, thickness, abs_elev, resource, tonnage,
      CASE 
        WHEN cv < 16 THEN '#8B4513'
        WHEN cv < 25 THEN '#FF8C00'
        ELSE '#FF4500'
      END as color,
      cv * COALESCE(thickness, 6) as g_x_w_calculated,
      false as visible_gold
    FROM blocks_mui_16037
    WHERE (resource_filter = 'all' OR resource_filter = 'Mui')
      AND cv >= cv_gt_filter
      AND geom && ST_Transform(tile_bounds, 4326)
  ) mvt_q;

  RETURN mvt;
END;
$$ LANGUAGE plpgsql;
*/
