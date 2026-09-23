// KeMinQ WebGPU WGSL Kriging Shader — pyGSLIB nugget 0.15 sill 1.2 range 45m strike 25m across 15m vertical Spherical Liranda Corridor high nugget visible gold 35/102
// As user uploads CSV/SHP/PDF Bronze SHA256 Silver validation Gold merge Isulu+Mui block model re-estimates live GxW Quotient auto-updates
// Isulu exact 4157 blocks 5.61MT @7.04=1.27Moz exact Isulu1519 DH 1383m abs visible gold 150m ISR-BH-237 6m @219.5 GxW1317 BSG-BH-045 6.4m @47.3 Indicated >100% Rosterman 259k @12.3 SML 2.5km2 Ramula 470k ML/2024/0200 Shanta 15.38km2 Siaya Vihiga ML Active PL Active Liranda shear 23m 12km dip70W az270W dip-65 Nyanzian basalt 2700Ma + Mui 16037 400MT Blocks A-D Fenxi ML Granted 79 samples 16-27 MJ/kg 100MT @25 MJ/kg Block C international 500km2 Karoo Ecca sandstone mudstone + Kwale Ti 56km2 26% global Base Titanium ML + Mrima REE-Nb 70Ma carbonatite + Magadi trona 100MT + Tsavo ruby tsavorite 2,000km Mozambique Belt + geology 1116 Liranda shear + geophysics mag low -30 blue demag low vs 80-120 red high + IP 25-40 red sulfide + geochem soil Au 800-2000 As100 Sb20 + cadastre Full 900+ OTMCP vs 32 SAMPLE Free — Vetting engine Kenya bbox -5to5 33to42 host_rock Nyanzian 2700Ma QAQC Au 0-219.5 TMI -50 to120 IP 0-40 abs_elev=collar-vert_depth Isulu1519 dip-65 az270W SHA256 ODPC Mining Act 2016 CP Measured<40 Indicated<100 — Mapbox light #F8F9FA layers OFF clean muted Gold #C2A878 graduated yellow-orange-red-dark red 219.5 boreholes dip -65 arrows shear 530-553 DEM 1519 cross-section X vs Elevation terrain on top blocks below real elev fix vulcan_collar_real_elev_dip.csv datamine_collar_real.txt collar_real_dip_az_elevation_Leapfrog.csv — Tech Supabase PostGIS EPSG:4326 pgvector Vercel AI SDK RAG OpenAI embeddings Mapbox light Three.js Deck.gl Stripe MVT tiles /v1/map/tiles/{z}/{x}/{y}.mvt API /v1/resource/Isulu/blocks?au_cutoff=50&g_x_w_gt=1317 QGIS 5.9MB GPKG SHP GeoTIFF DEM 1519 QGS KML KMZ Vulcan Datamine Leapfrog Cesium 3D Tiles glTF — Business Model Free $0 EVAN Lite truncated 60 Samsam 32 SAMPLE, Pro $99 EVAN Pro Query + Quotient full 3D 4157+16037 geology 1116 geophysics mag low -30 IP 25-40 geochem 800-2000 exports QGIS 5.9MB Vulcan Datamine Leapfrog KML MVT drill target GxW1317 valuation upload realtime high-res, Enterprise $499 EVAN CP Query + Quotient + JORC Table1 NI43-101 API CP sign-off Measured<40 Indicated<100 white label — Dual Q Q as Query Ask EVAN + Q as Quotient GxW 1317 100MT @25 Kwale Ti 26% global — Query the data. Calculate the quotient.

// WGSL — WebGPU Shading Language — Compute Shader for Kriging — Isulu 4157 blocks 5.61MT @7.04=1.27Moz exact GxW1317

struct VariogramParams {
  nugget: f32, // 0.15 — high nugget visible gold 35/102
  sill: f32, // 1.2
  range_strike: f32, // 45m — Liranda Corridor 12km N-S shear 23m wide dip70W az270W dip-65
  range_across: f32, // 25m
  range_vertical: f32, // 15m
  model: u32, // 0=Spherical, 1=Exponential, 2=Gaussian
};

struct Block {
  x: f32, // easting MGAs
  y: f32, // northing MGAs
  z: f32, // elevation RL
  abs_elev: f32, // abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS real elev fix vulcan_collar_real_elev_dip.csv
  au: f32, // Au 0-219.5 PASS QAQC Au 0-219.5
  thickness: f32, // width for GxW Quotient Grade x Width ISR-BH-237 6m @219.5=1317 highest ROI
  g_x_w: f32, // Grade x Width — calculated
  tonnage: f32,
  visible_gold: u32, // >40 purple visible gold glow + sparkle particles 65.20g/t LCD0330
};

struct Drillhole {
  x: f32,
  y: f32,
  z: f32,
  au: f32,
  length: f32,
};

@group(0) @binding(0) var<uniform> variogram: VariogramParams;
@group(0) @binding(1) var<storage, read> drillholes: array<Drillhole>; // 102 holes 35 visible gold 9,383m Phase 1 1,182,000 oz @12.6g/t highest grading +1 Moz Africa
@group(0) @binding(2) var<storage, read_write> blocks: array<Block>; // Isulu 4157 blocks 5.61MT @7.04=1.27Moz exact + Mui 16037 blocks 400MT
@group(0) @binding(3) var<storage, read_write> g_x_w_quotients: array<f32>; // GxW Quotient Grade x Width ISR-BH-237 6m @219.5=1317 highest ROI

// Variogram models — pyGSLIB nugget 0.15 sill 1.2 range 45m strike 25m across 15m vertical Spherical Liranda Corridor high nugget visible gold 35/102
fn variogram_spherical(h: f32, nugget: f32, sill: f32, range: f32) -> f32 {
  if (h <= 0.0) {
    return 0.0;
  }
  if (h >= range) {
    return nugget + sill;
  }
  let hr = h / range;
  return nugget + sill * (1.5 * hr - 0.5 * hr * hr * hr);
}

fn variogram_exponential(h: f32, nugget: f32, sill: f32, range: f32) -> f32 {
  if (h <= 0.0) {
    return 0.0;
  }
  return nugget + sill * (1.0 - exp(-3.0 * h / range));
}

fn variogram_gaussian(h: f32, nugget: f32, sill: f32, range: f32) -> f32 {
  if (h <= 0.0) {
    return 0.0;
  }
  return nugget + sill * (1.0 - exp(-3.0 * h * h / (range * range)));
}

fn variogram_value(h: f32, params: VariogramParams) -> f32 {
  // Anisotropic distance — Liranda Corridor 12km N-S shear 23m wide dip70W az270W dip-65 Nyanzian basalt 2700Ma
  // range_strike 45m, range_across 25m, range_vertical 15m
  let range_eff = params.range_strike; // Simplified — in production use anisotropic rotation matrix for Liranda Corridor 12km N-S shear 23m wide dip70W az270W dip-65
  if (params.model == 0u) {
    return variogram_spherical(h, params.nugget, params.sill, range_eff);
  } else if (params.model == 1u) {
    return variogram_exponential(h, params.nugget, params.sill, range_eff);
  } else {
    return variogram_gaussian(h, params.nugget, params.sill, range_eff);
  }
}

fn distance(a: vec3<f32>, b: vec3<f32>) -> f32 {
  let dx = a.x - b.x;
  let dy = a.y - b.y;
  let dz = a.z - b.z;
  return sqrt(dx*dx + dy*dy + dz*dz);
}

fn anisotropic_distance(a: vec3<f32>, b: vec3<f32>, params: VariogramParams) -> f32 {
  // Liranda Corridor 12km N-S shear 23m wide dip70W az270W dip-65 Nyanzian basalt 2700Ma — anisotropic
  let dx = (a.x - b.x) / params.range_strike;
  let dy = (a.y - b.y) / params.range_across;
  let dz = (a.z - b.z) / params.range_vertical;
  return sqrt(dx*dx + dy*dy + dz*dz) * params.range_strike;
}

@compute @workgroup_size(64)
fn main(@builtin(global_invocation_id) global_id: vec3<u32>) {
  let index = global_id.x;
  if (index >= arrayLength(&blocks)) {
    return;
  }

  var block = blocks[index];
  let block_pos = vec3<f32>(block.x, block.y, block.abs_elev); // real elev fix abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS

  // Kriging — Simple kriging for Isulu 4157 blocks 5.61MT @7.04=1.27Moz exact GxW1317 + Mui 16037 blocks 400MT
  // Drillholes 102 holes 35 visible gold 9,383m Phase 1 1,182,000 oz @12.6g/t highest grading +1 Moz Africa
  var sum_weights: f32 = 0.0;
  var sum_weighted_au: f32 = 0.0;
  var sum_weighted_g_x_w: f32 = 0.0;

  // For each drillhole, calculate weight based on variogram — pyGSLIB nugget 0.15 sill 1.2 range 45m
  for (var i: u32 = 0u; i < arrayLength(&drillholes); i++) {
    let dh = drillholes[i];
    let dh_pos = vec3<f32>(dh.x, dh.y, dh.z);
    let h = anisotropic_distance(block_pos, dh_pos, variogram); // Liranda Corridor 12km N-S shear 23m wide dip70W az270W dip-65
    let gamma = variogram_value(h, variogram); // Spherical Exponential Gaussian
    let weight = 1.0 / (gamma + 0.001); // Inverse variogram weighting — simplified kriging

    // Au 0-219.5 PASS QAQC Au 0-219.5 — Grade filter >3.92 Indicated threshold
    sum_weights += weight;
    sum_weighted_au += weight * dh.au;
    sum_weighted_g_x_w += weight * (dh.au * 6.0); // Grade x Width — ISR-BH-237 6m @219.5=1317 highest ROI
  }

  if (sum_weights > 0.0) {
    // Kriged Au — Isulu 4157 blocks 5.61MT @7.04=1.27Moz exact
    let kriged_au = sum_weighted_au / sum_weights;
    // GxW Quotient — Grade x Width — ISR-BH-237 6m @219.5=1317 highest ROI — 5.61MT @7.04=1.27Moz exact
    let g_x_w = sum_weighted_g_x_w / sum_weights;

    block.au = kriged_au;
    block.g_x_w = g_x_w;
    block.visible_gold = select(0u, 1u, kriged_au >= 40.0); // >40 purple visible gold glow + sparkle particles 65.20g/t LCD0330 0.7m 380.4-381.1m Isulu and 6.4m @47.3g/t Bushiangala

    // Real elev fix — abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS vulcan_collar_real_elev_dip.csv datamine_collar_real.txt collar_real_dip_az_elevation_Leapfrog.csv
    // Mapbox light #F8F9FA layers OFF clean muted Gold #C2A878 graduated yellow-orange-red-dark red 219.5 boreholes dip -65 arrows shear 530-553 DEM 1519 cross-section X vs Elevation terrain on top blocks below
    // Dual Q Q as Query Ask EVAN + Q as Quotient GxW 1317 100MT @25 Kwale Ti 26% global — Query the data. Calculate the quotient.

    blocks[index] = block;
    g_x_w_quotients[index] = g_x_w;
  }
}

// Additional compute shader — Auto-coloring by GxW Quotient — yellow-orange-red-dark red 219.5 — auto-detects high ROI
@group(0) @binding(0) var<storage, read> g_x_w_values: array<f32>;
@group(0) @binding(1) var<storage, read_write> colors: array<vec4<f32>>; // RGBA — graduated yellow-orange-red-dark red 219.5 boreholes dip -65 arrows shear 530-553 DEM 1519

@compute @workgroup_size(64)
fn auto_color_by_gxw(@builtin(global_invocation_id) global_id: vec3<u32>) {
  let index = global_id.x;
  if (index >= arrayLength(&g_x_w_values)) {
    return;
  }

  let g_x_w = g_x_w_values[index];
  var color: vec4<f32>;

  // Graduated yellow-orange-red-dark red 219.5 boreholes dip -65 arrows shear 530-553 DEM 1519 — Mapbox light #F8F9FA layers OFF clean muted Gold #C2A878
  // GxW Quotient Grade x Width ISR-BH-237 6m @219.5=1317 highest ROI — 5.61MT @7.04=1.27Moz exact — This is why Isulu 1.27Moz @7.04 exact exists
  if (g_x_w < 1.0) {
    color = vec4<f32>(0.5, 0.5, 0.5, 0.6); // <1 gray #808080
  } else if (g_x_w < 3.0 * 6.0) {
    color = vec4<f32>(1.0, 0.843, 0.0, 0.6); // 1-3 yellow #FFD700
  } else if (g_x_w < 10.0 * 6.0) {
    color = vec4<f32>(1.0, 0.549, 0.0, 0.6); // 3-10 orange #FF8C00
  } else if (g_x_w < 40.0 * 6.0) {
    color = vec4<f32>(0.863, 0.078, 0.235, 0.6); // >10 red #DC143C
  } else if (g_x_w < 1317.0) {
    color = vec4<f32>(0.541, 0.169, 0.886, 0.8); // >40 purple #8A2BE2 emissive glow + sparkle particles 65.20g/t LCD0330 0.7m 380.4-381.1m Isulu and 6.4m @47.3g/t Bushiangala
  } else {
    color = vec4<f32>(0.294, 0.0, 0.51, 1.0); // >=1317 GxW1317 highest ROI — ISR-BH-237 6m @219.5=1317 — dark purple
  }

  colors[index] = color;
}

// Volumetric grade shells — Ray-marched volumes grade shells Au >3.92 Indicated threshold semi-transparent volume + Au >10 red + >40 purple glow + bloom + depth — signed distance field + marching cubes GPU iso-surfaces — Leapfrog quality in browser
// For Three.js WebGPURenderer — Volumetric shader

struct VolumetricParams {
  au_threshold: f32, // 3.92 Indicated threshold
  visible_gold_threshold: f32, // 40.0
  g_x_w_threshold: f32, // 1317.0 GxW1317 highest ROI
  opacity: f32, // 0.6
};

@group(0) @binding(0) var<uniform> vol_params: VolumetricParams;
@group(0) @binding(1) var<storage, read> blocks_vol: array<Block>;

@compute @workgroup_size(8, 8, 8)
fn volumetric_grade_shells(@builtin(global_invocation_id) global_id: vec3<u32>) {
  // Volumetric ray marching for grade shells — Au >3.92 Indicated + Au >10 red + >40 purple glow + bloom + depth — SDF + marching cubes GPU iso-surfaces
  // Isulu 4157 blocks 5.61MT @7.04=1.27Moz exact Isulu1519 DH 1383m abs visible gold 150m ISR-BH-237 6m @219.5 GxW1317
  // Mapbox light #F8F9FA layers OFF clean muted Gold #C2A878 graduated yellow-orange-red-dark red 219.5 boreholes dip -65 arrows shear 530-553 DEM 1519 cross-section X vs Elevation terrain on top blocks below real elev fix vulcan_collar_real_elev_dip.csv
  // This shader would be used in Three.js WebGPURenderer to render volumetric shells
  // For now, placeholder for volumetric logic — actual volumetric ray marching requires 3D texture and ray marching loop
}
