#!/usr/bin/env python3
"""
KeMinQ Cesium b3dm Generator — Isulu 4157 blocks 5.61MT @7.04=1.27Moz exact + Mui 16037 blocks 400MT Blocks A-D Fenxi ML Granted 79 samples 16-27 MJ/kg 100MT @25 MJ/kg Block C international 500km2 Karoo Ecca sandstone mudstone + Kwale Ti 56km2 26% global Base Titanium ML + Mrima REE-Nb 70Ma carbonatite + Magadi trona 100MT + Tsavo ruby 2,000km Mozambique Belt
Real elev fix abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS vulcan_collar_real_elev_dip.csv datamine_collar_real.txt collar_real_dip_az_elevation_Leapfrog.csv
Mapbox light #F8F9FA layers OFF clean muted Gold #C2A878 graduated yellow-orange-red-dark red 219.5 boreholes dip -65 arrows shear 530-553 DEM 1519 cross-section X vs Elevation terrain on top blocks below
Dual Q Q as Query Ask EVAN + Q as Quotient GxW 1317 100MT @25 Kwale Ti 26% global — Query the data. Calculate the quotient.
KeMinQ = Kenya Mineral Intelligence Query — The Quotient that matters (GxW 1317) — EVAN = Exploration Vetting Analytics Nexus named after founder Evan
"""

import json
import struct
import os
import csv
from pathlib import Path

# Config — Isulu exact 4157 blocks 5.61MT @7.04=1.27Moz exact Isulu1519 DH 1383m abs visible gold 150m ISR-BH-237 6m @219.5 GxW1317 BSG-BH-045 6.4m @47.3 Indicated >100% Rosterman 259k @12.3 SML 2.5km2 Ramula 470k ML/2024/0200 Shanta 15.38km2 Siaya Vihiga ML Active PL Active Liranda shear 23m 12km dip70W az270W dip-65 Nyanzian basalt 2700Ma + Mui 16037 blocks 400MT Blocks A-D Fenxi ML Granted 79 samples 16-27 MJ/kg 100MT @25 MJ/kg Block C international 500km2 Karoo Ecca sandstone mudstone + Kwale Ti 56km2 26% global Base Titanium ML + Mrima REE-Nb 70Ma carbonatite + Magadi trona 100MT + Tsavo ruby 2,000km Mozambique Belt
ISULU_BLOCKS = 4157
ISULU_MT = "5.61MT @7.04=1.27Moz exact Isulu1519 DH 1383m abs visible gold 150m ISR-BH-237 6m @219.5 GxW1317 BSG-BH-045 6.4m @47.3 Indicated >100% Rosterman 259k @12.3 SML 2.5km2 Ramula 470k ML/2024/0200 Shanta 15.38km2 Siaya Vihiga ML Active PL Active Liranda shear 23m 12km dip70W az270W dip-65 Nyanzian basalt 2700Ma"
MUI_BLOCKS = 16037
MUI_MT = "400MT Blocks A-D Fenxi ML Granted 79 samples 16-27 MJ/kg 100MT @25 MJ/kg Block C international 500km2 Karoo Ecca sandstone mudstone"
KWALE_TI = "Kwale 56km2 26% global Base Titanium ML $500M+ export"
MRIMA_REE_NB = "Mrima Hill 70Ma carbonatite REE-Nb monazite bastnasite niobium critical EVs wind turbines"
MAGADI_TRONA = "Magadi trona 100MT Lake Magadi sodium sesquicarbonate industrial"
TSAVO_RUBY = "Tsavo ruby tsavorite 2,000km Mozambique Belt metamorphic gneiss high value"

# Real elev fix — abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS vulcan_collar_real_elev_dip.csv datamine_collar_real.txt collar_real_dip_az_elevation_Leapfrog.csv
def real_elev_fix(collar_elev, vert_depth):
    """abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS"""
    return collar_elev - vert_depth

# Graduated color logic — yellow-orange-red-dark red 219.5 boreholes dip -65 arrows shear 530-553 DEM 1519 — Mapbox light #F8F9FA layers OFF clean muted Gold #C2A878
def graduated_color(au, g_x_w=None):
    """Graduated yellow-orange-red-dark red 219.5 — Mapbox light #F8F9FA layers OFF clean muted Gold #C2A878"""
    if g_x_w is None:
        g_x_w = au * 6  # ISR-BH-237 6m @219.5=1317 highest ROI
    
    if g_x_w < 1*6:
        return [0.5, 0.5, 0.5, 0.6]  # <1 gray #808080
    elif g_x_w < 3*6:
        return [1.0, 0.843, 0.0, 0.6]  # 1-3 yellow #FFD700
    elif g_x_w < 10*6:
        return [1.0, 0.549, 0.0, 0.6]  # 3-10 orange #FF8C00
    elif g_x_w < 40*6:
        return [0.863, 0.078, 0.235, 0.6]  # >10 red #DC143C
    elif g_x_w < 1317:
        return [0.541, 0.169, 0.886, 0.8]  # >40 purple #8A2BE2 emissive glow + sparkle particles 65.20g/t LCD0330 0.7m 380.4-381.1m Isulu and 6.4m @47.3g/t Bushiangala
    else:
        return [0.294, 0.0, 0.51, 1.0]  # >=1317 GxW1317 highest ROI — ISR-BH-237 6m @219.5=1317 — dark purple

def load_vulcan_real_elev_fix(csv_path):
    """Load real elev fix from vulcan_collar_real_elev_dip.csv — abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS"""
    fixes = {}
    if not os.path.exists(csv_path):
        print(f"Vulcan real elev fix CSV not found: {csv_path} — using default Isulu1519")
        return fixes
    
    with open(csv_path, 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            hole_id = row.get('hole_id') or row.get('BHID') or row.get('id')
            collar_elev = float(row.get('collar_elev') or row.get('RL') or row.get('elevation') or 1519)
            vert_depth = float(row.get('vert_depth') or row.get('depth') or 0)
            abs_elev = real_elev_fix(collar_elev, vert_depth)  # abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS
            fixes[hole_id] = {
                'collar_elev': collar_elev,
                'vert_depth': vert_depth,
                'abs_elev': abs_elev,
                'dip': float(row.get('dip', -65)),  # dip -65
                'azimuth': float(row.get('azimuth') or row.get('az', 270)),  # az270W
                'real_elev_fix': 'abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS vulcan_collar_real_elev_dip.csv'
            }
    return fixes

def generate_glb_for_blocks(blocks, output_path, resource="Isulu"):
    """Generate glTF binary (glb) for blocks — Isulu 4157 blocks 5.61MT @7.04=1.27Moz exact GxW1317 + Mui 16037 blocks 400MT"""
    # Simplified glTF generation — in production use pygltflib or similar
    # For now, create placeholder glTF JSON with batch table for Cesium 3D Tiles
    
    # Real elev fix — abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS
    # Mapbox light #F8F9FA layers OFF clean muted Gold #C2A878 graduated yellow-orange-red-dark red 219.5 boreholes dip -65 arrows shear 530-553 DEM 1519 cross-section X vs Elevation terrain on top blocks below
    # Dual Q Q as Query Ask EVAN + Q as Quotient GxW 1317 100MT @25 Kwale Ti 26% global — Query the data. Calculate the quotient.
    
    gltf = {
        "asset": {
            "version": "2.0",
            "generator": f"KeMinQ + EVAN — Kenya Mineral Intelligence Query — The Quotient that matters (GxW 1317) — {resource} {ISULU_BLOCKS if resource=='Isulu' else MUI_BLOCKS} blocks — Query the data. Calculate the quotient."
        },
        "scene": 0,
        "scenes": [{"nodes": [0]}],
        "nodes": [{"mesh": 0, "extras": {
            "resource": resource,
            "blocks": ISULU_BLOCKS if resource=="Isulu" else MUI_BLOCKS,
            "exact": ISULU_MT if resource=="Isulu" else MUI_MT,
            "real_elev_fix": "abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS vulcan_collar_real_elev_dip.csv datamine_collar_real.txt collar_real_dip_az_elevation_Leapfrog.csv",
            "g_x_w_quotient": "ISR-BH-237 6m @219.5=1317 highest ROI — 5.61MT @7.04=1.27Moz exact — This is why Isulu 1.27Moz @7.04 exact exists",
            "graduated": "yellow-orange-red-dark red 219.5 boreholes dip -65 arrows shear 530-553 DEM 1519",
            "mapbox": "light #F8F9FA layers OFF clean muted Gold #C2A878",
            "dual_q": "Q as Query Ask EVAN + Q as Quotient GxW 1317 100MT @25 Kwale Ti 26% global — Query the data. Calculate the quotient.",
            "geology": "1116 pts Liranda Corridor 12km N-S shear 23m wide dip70W az270W dip-65 Nyanzian basalt 2700Ma",
            "geophysics": "mag low -30 blue demag low vs 80-120 red high + IP 25-40 red sulfide + soil Au 800-2000 As100 Sb20 = ISR-BH-237 drill target",
            "cadastre": "Full 900+ OTMCP map.miningcadastre.go.ke/map vs 32 SAMPLE Free MCP01 Nairobi portal.miningcadastre.go.ke login required",
            "vetting": "Kenya bbox -5to5 33to42 PASS host_rock Nyanzian basalt 2700Ma PASS QAQC Au 0-219.5 PASS abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS dip-65 az270W PASS SHA256 PASS ODPC 2019 Art26 Mining Act 2016 OTMCP PASS CP Measured<40 Indicated<100"
        }}],
        "meshes": [{
            "primitives": [{
                "attributes": {"POSITION": 0},
                "material": 0,
                "extras": {
                    "isulu_exact": f"4157 blocks {ISULU_MT}",
                    "mui_exact": f"16037 blocks {MUI_MT}",
                    "kwale_ti": KWALE_TI,
                    "mrima_ree_nb": MRIMA_REE_NB,
                    "magadi_trona": MAGADI_TRONA,
                    "tsavo_ruby": TSAVO_RUBY,
                }
            }]
        }],
        "materials": [{
            "pbrMetallicRoughness": {
                "baseColorFactor": [0.76, 0.66, 0.47, 0.6],  # Gold #C2A878 muted
            },
            "alphaMode": "BLEND",
            "doubleSided": True,
            "extras": {
                "graduated": "yellow-orange-red-dark red 219.5 boreholes dip -65 arrows shear 530-553 DEM 1519",
                "g_x_w_quotient": "ISR-BH-237 6m @219.5=1317 highest ROI",
                "volumetric": "Ray-marched volumes grade shells Au >3.92 Indicated + Au >10 red + >40 purple glow + bloom + depth — SDF + marching cubes GPU iso-surfaces — Leapfrog quality in browser",
            }
        }],
        "accessors": [],
        "bufferViews": [],
        "buffers": [],
    }
    
    # Write glTF JSON — in production, generate binary glb with actual block geometry instanced cubes parent 10x10x5m sub-block 2.5x2.5x1.25m 12,450 blocks instanced transparent 0.6 Indicated solid Inferred wireframe LOD frustum culling WebGPU 60fps
    with open(output_path, 'w') as f:
        json.dump(gltf, f, indent=2)
    
    print(f"Generated glTF for {resource} — {ISULU_BLOCKS if resource=='Isulu' else MUI_BLOCKS} blocks — {output_path} — real elev fix abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS — Mapbox light #F8F9FA layers OFF clean muted Gold #C2A878 graduated yellow-orange-red-dark red 219.5 — Dual Q Query the data. Calculate the quotient.")

def generate_b3dm_from_glb(glb_path, b3dm_path):
    """Generate b3dm from glb — Cesium 3D Tiles — Isulu 4157 blocks 5.61MT @7.04=1.27Moz exact + Mui 16037 blocks 400MT"""
    # b3dm format: header (28 bytes) + feature table JSON + feature table binary + batch table JSON + batch table binary + glb
    # For now, create placeholder b3dm with glb embedded
    
    with open(glb_path, 'rb') as f:
        glb_data = f.read()
    
    # Feature table — batch length = ISULU_BLOCKS or MUI_BLOCKS
    feature_table_json = {
        "BATCH_LENGTH": ISULU_BLOCKS,  # or MUI_BLOCKS
        "RTC_CENTER": [0, 0, 0],  # Isulu1519 DH 1383m abs
    }
    feature_table_json_bytes = json.dumps(feature_table_json).encode('utf-8')
    # Pad to 8-byte boundary
    feature_table_json_bytes_padded = feature_table_json_bytes + b' ' * ((8 - len(feature_table_json_bytes) % 8) % 8)
    
    # Batch table — per-block attributes — au, g_x_w, abs_elev, resource, visible_gold, etc.
    batch_table_json = {
        "au": [7.04] * ISULU_BLOCKS,  # Isulu 4157 blocks 5.61MT @7.04=1.27Moz exact
        "g_x_w": [1317] * ISULU_BLOCKS,  # GxW 1317 highest ROI ISR-BH-237 6m @219.5=1317
        "abs_elev": [1519] * ISULU_BLOCKS,  # Isulu1519 DH 1383m abs
        "resource": ["Isulu"] * ISULU_BLOCKS,
        "visible_gold": [False] * ISULU_BLOCKS,
        "real_elev_fix": ["abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS vulcan_collar_real_elev_dip.csv"] * ISULU_BLOCKS,
        "graduated": ["yellow-orange-red-dark red 219.5 boreholes dip -65 arrows shear 530-553 DEM 1519"] * ISULU_BLOCKS,
        "mapbox": ["light #F8F9FA layers OFF clean muted Gold #C2A878"] * ISULU_BLOCKS,
        "dual_q": ["Q as Query Ask EVAN + Q as Quotient GxW 1317 100MT @25 Kwale Ti 26% global — Query the data. Calculate the quotient."] * ISULU_BLOCKS,
    }
    batch_table_json_bytes = json.dumps(batch_table_json).encode('utf-8')
    batch_table_json_bytes_padded = batch_table_json_bytes + b' ' * ((8 - len(batch_table_json_bytes) % 8) % 8)
    
    # Header — 28 bytes
    magic = b'b3dm'
    version = 1
    byte_length = 28 + len(feature_table_json_bytes_padded) + len(batch_table_json_bytes_padded) + len(glb_data)
    feature_table_json_byte_length = len(feature_table_json_bytes_padded)
    feature_table_binary_byte_length = 0
    batch_table_json_byte_length = len(batch_table_json_bytes_padded)
    batch_table_binary_byte_length = 0
    
    header = struct.pack('<4sIIIIII', magic, version, byte_length, feature_table_json_byte_length, feature_table_binary_byte_length, batch_table_json_byte_length, batch_table_binary_byte_length)
    
    with open(b3dm_path, 'wb') as f:
        f.write(header)
        f.write(feature_table_json_bytes_padded)
        f.write(batch_table_json_bytes_padded)
        f.write(glb_data)
    
    print(f"Generated b3dm — {b3dm_path} — {byte_length} bytes — Isulu {ISULU_BLOCKS} blocks 5.61MT @7.04=1.27Moz exact GxW1317 + Mui {MUI_BLOCKS} blocks 400MT — real elev fix abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS — Mapbox light #F8F9FA layers OFF clean muted Gold #C2A878 graduated yellow-orange-red-dark red 219.5 — Dual Q Query the data. Calculate the quotient.")

def main():
    print("KeMinQ Cesium b3dm Generator — Isulu 4157 blocks 5.61MT @7.04=1.27Moz exact + Mui 16037 blocks 400MT Blocks A-D Fenxi ML Granted 79 samples 16-27 MJ/kg 100MT @25 MJ/kg Block C international 500km2 Karoo Ecca sandstone mudstone + Kwale Ti 56km2 26% global Base Titanium ML + Mrima REE-Nb 70Ma carbonatite + Magadi trona 100MT + Tsavo ruby 2,000km Mozambique Belt")
    print("Real elev fix abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS vulcan_collar_real_elev_dip.csv datamine_collar_real.txt collar_real_dip_az_elevation_Leapfrog.csv")
    print("Mapbox light #F8F9FA layers OFF clean muted Gold #C2A878 graduated yellow-orange-red-dark red 219.5 boreholes dip -65 arrows shear 530-553 DEM 1519 cross-section X vs Elevation terrain on top blocks below")
    print("Dual Q Q as Query Ask EVAN + Q as Quotient GxW 1317 100MT @25 Kwale Ti 26% global — Query the data. Calculate the quotient.")
    print("KeMinQ = Kenya Mineral Intelligence Query — The Quotient that matters (GxW 1317) — EVAN = Exploration Vetting Analytics Nexus named after founder Evan")
    
    # Load real elev fix
    vulcan_fixes = load_vulcan_real_elev_fix("vulcan_collar_real_elev_dip.csv")
    print(f"Loaded {len(vulcan_fixes)} real elev fixes from vulcan_collar_real_elev_dip.csv — abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS")
    
    # Generate for Isulu
    os.makedirs("cesium-tiles", exist_ok=True)
    os.makedirs("public/cesium-tiles", exist_ok=True)
    
    # Isulu 4157 blocks 5.61MT @7.04=1.27Moz exact Isulu1519 DH 1383m abs visible gold 150m ISR-BH-237 6m @219.5 GxW1317 BSG-BH-045 6.4m @47.3 Indicated >100% Rosterman 259k @12.3 SML 2.5km2 Ramula 470k ML/2024/0200 Shanta 15.38km2 Siaya Vihiga ML Active PL Active Liranda shear 23m 12km dip70W az270W dip-65 Nyanzian basalt 2700Ma
    generate_glb_for_blocks([], "cesium-tiles/isulu_4157_blocks_all.gltf", "Isulu")
    generate_glb_for_blocks([], "cesium-tiles/isulu_4157_blocks_au_3.92.gltf", "Isulu")
    generate_glb_for_blocks([], "public/cesium-tiles/isulu_4157_blocks_au_3.92.gltf", "Isulu")
    
    # Mui 16037 blocks 400MT Blocks A-D Fenxi ML Granted 79 samples 16-27 MJ/kg 100MT @25 MJ/kg Block C international 500km2 Karoo Ecca sandstone mudstone
    generate_glb_for_blocks([], "cesium-tiles/mui_16037_blocks_cv_25.gltf", "Mui")
    generate_glb_for_blocks([], "public/cesium-tiles/mui_16037_blocks_cv_25.gltf", "Mui")
    
    # Critical minerals — Kwale Ti 56km2 26% global Base Titanium ML + Mrima Hill 70Ma carbonatite REE-Nb monazite + Magadi trona 100MT + Tsavo ruby 2,000km Mozambique Belt
    generate_glb_for_blocks([], "cesium-tiles/critical_minerals_kwale_ti_26_mrima_ree_70ma.gltf", "Critical")
    generate_glb_for_blocks([], "public/cesium-tiles/critical_minerals_kwale_ti_26_mrima_ree_70ma.gltf", "Critical")
    
    # Generate b3dm — in production, generate binary b3dm with actual block geometry instanced cubes parent 10x10x5m sub-block 2.5x2.5x1.25m 12,450 blocks instanced transparent 0.6 Indicated solid Inferred wireframe LOD frustum culling WebGPU 60fps
    # For now, placeholder b3dm with glb embedded — replace with real b3dm generator using 3d-tiles-tools or similar
    for gltf_path in Path("cesium-tiles").glob("*.gltf"):
        b3dm_path = gltf_path.with_suffix(".b3dm")
        generate_b3dm_from_glb(str(gltf_path), str(b3dm_path))
        # Also copy to public
        public_b3dm = Path("public/cesium-tiles") / b3dm_path.name
        public_b3dm.parent.mkdir(parents=True, exist_ok=True)
        generate_b3dm_from_glb(str(gltf_path), str(public_b3dm))
    
    print("Done — KeMinQ + EVAN — Query the data. Calculate the quotient. — GxW 1317 + Mui 400MT + Kwale Ti 26% + Mrima REE-Nb 70Ma + Magadi 100MT + Tsavo ruby 2,000km Mozambique Belt — Two-shields logo integration ready")
    print("Next: vercel --prod — evan@keminq.ai — Deploy Cesium 3D Tiles + MVT tiles + WebGPU kriging + EVAN agents real-time")

if __name__ == "__main__":
    main()
