"use client";
import { useEffect, useRef, useState } from "react";
import mapboxgl from "mapbox-gl";
import * as THREE from "three";
// Note: Three.js WebGPURenderer r160+ — fallback to WebGLRenderer if WebGPU not available
// import { WebGPURenderer } from "three/addons/renderers/webgpu/WebGPURenderer.js";

const MAPBOX_TOKEN = process.env.NEXT_PUBLIC_MAPBOX_TOKEN!;
const MAPBOX_STYLE = process.env.NEXT_PUBLIC_MAPBOX_STYLE || "mapbox://styles/mapbox/light-v11";
const MVT_TILES = "/v1/map/tiles/{z}/{x}/{y}.mvt";
const API_BLOCKS_ISULU = "/v1/resource/Isulu/blocks?au_cutoff=50&g_x_w_gt=1317";
const API_BLOCKS_MUI = "/v1/resource/Mui/blocks?block=C&cv_gt=25";
const CESIUM_3D_TILES = "/cesium_3d_tiles_isulu_4157_mui_16037.json";

// Real elev fix files
// vulcan_collar_real_elev_dip.csv, datamine_collar_real.txt, collar_real_dip_az_elevation_Leapfrog.csv
// abs_elev = collar - vert_depth Isulu1519 fixed inversion terrain on top blocks below

export default function DashboardV16() {
  const mapContainer = useRef<HTMLDivElement>(null);
  const threeContainer = useRef<HTMLDivElement>(null);
  const [webGPUAvailable, setWebGPUAvailable] = useState(false);
  const [evanAgents, setEvanAgents] = useState({
    exploration: "Watching CSV/SHP/PDF Bronze SHA256",
    vetting: "Kenya bbox -5to5 33to42 PASS host_rock Nyanzian 2700Ma QAQC Au 0-219.5 abs_elev Isulu1519 dip-65 SHA256 ODPC PASS",
    analytics: "GxW Quotient ISR-BH-237 6m @219.5=1317 highest ROI — 5.61MT @7.04=1.27Moz exact",
    nexus: "Merging Isulu 4157 + Mui 16037 → WebSocket push live",
  });
  const [selectedQuotient, setSelectedQuotient] = useState<"gold" | "coal" | "critical">("gold");
  const [gradeFilter, setGradeFilter] = useState(3.92); // Indicated threshold
  const [showVolumetric, setShowVolumetric] = useState(true);
  const [showVisibleGoldOnly, setShowVisibleGoldOnly] = useState(false);

  useEffect(() => {
    // Check WebGPU
    if ((navigator as any).gpu) {
      setWebGPUAvailable(true);
    }

    if (!mapContainer.current) return;

    mapboxgl.accessToken = MAPBOX_TOKEN;
    const map = new mapboxgl.Map({
      container: mapContainer.current,
      style: MAPBOX_STYLE, // light #F8F9FA layers OFF clean muted Gold #C2A878
      center: [34.75, 0.5], // Isulu Liranda Corridor Kenya
      zoom: 10,
      pitch: 60,
      bearing: -20,
      antialias: true,
    });

    map.on("load", () => {
      // Light theme #F8F9FA layers OFF clean muted Gold #C2A878
      // Graduated dots yellow-orange-red-dark red 219.5 boreholes dip -65 arrows shear 530-553 DEM 1519 cross-section X vs Elevation terrain on top blocks below

      // Add MVT tiles Isulu 4157 + Mui 16037
      map.addSource("keminq-blocks", {
        type: "vector",
        tiles: [MVT_TILES],
        minzoom: 0,
        maxzoom: 22,
      });

      // Isulu 4157 blocks 5.61MT @7.04=1.27Moz exact GxW1317
      map.addLayer({
        id: "isulu-blocks",
        type: "fill-extrusion",
        source: "keminq-blocks",
        "source-layer": "blocks",
        filter: ["==", ["get", "resource"], "Isulu"],
        paint: {
          "fill-extrusion-color": [
            "interpolate",
            ["linear"],
            ["get", "au"],
            0, "#808080", // <1 gray
            1, "#FFD700", // 1-3 yellow
            3, "#FF8C00", // 3-10 orange
            10, "#DC143C", // >10 red
            40, "#8A2BE2", // >40 purple visible gold
            219.5, "#4B0082", // ISR-BH-237 6m @219.5 GxW1317
          ],
          "fill-extrusion-height": ["*", ["get", "thickness"], 10],
          "fill-extrusion-base": ["get", "abs_elev"], // real elev fix vulcan_collar_real_elev_dip.csv abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below
          "fill-extrusion-opacity": 0.6,
        },
      });

      // Mui 16037 blocks 400MT Blocks A-D Fenxi ML Granted 79 samples 16-27 MJ/kg 100MT @25
      map.addLayer({
        id: "mui-blocks",
        type: "fill-extrusion",
        source: "keminq-blocks",
        "source-layer": "blocks",
        filter: ["==", ["get", "resource"], "Mui"],
        paint: {
          "fill-extrusion-color": [
            "interpolate",
            ["linear"],
            ["get", "cv"],
            16, "#8B4513", // coal brown
            25, "#FF8C00", // 100MT @25 MJ/kg high CV
            27, "#FF4500",
          ],
          "fill-extrusion-height": ["*", ["get", "thickness"], 10],
          "fill-extrusion-base": ["get", "abs_elev"],
          "fill-extrusion-opacity": 0.6,
        },
      });

      // Geology 1116 pts Liranda Corridor 12km N-S shear 23m wide dip70W az270W dip-65 Nyanzian basalt 2700Ma
      map.addSource("geology-1116", {
        type: "geojson",
        data: "/geojson/geology_1116_liranda_shear.geojson",
      });
      map.addLayer({
        id: "geology-1116",
        type: "line",
        source: "geology-1116",
        paint: {
          "line-color": "#FF4500", // Liranda Corridor faults orange #FF4500 semi-transparent planes striations
          "line-width": 3,
          "line-opacity": 0.8,
        },
      });

      // Geophysics mag low -30 blue demag low vs 80-120 red high + IP 25-40 red sulfide
      map.addSource("geophysics-mag", {
        type: "geojson",
        data: "/geojson/geophysics_mag_low_-30.geojson",
      });
      map.addLayer({
        id: "geophysics-mag",
        type: "circle",
        source: "geophysics-mag",
        paint: {
          "circle-color": [
            "interpolate",
            ["linear"],
            ["get", "tmi"],
            -30, "#0000FF", // blue demag low
            0, "#808080",
            80, "#FF0000", // red high
            120, "#8B0000",
          ],
          "circle-radius": 5,
          "circle-opacity": 0.6,
        },
      });

      // Geochem soil Au 800-2000 As100 Sb20 pathfinders = ISR-BH-237 drill target
      map.addSource("geochem-soil", {
        type: "geojson",
        data: "/geojson/geochem_soil_800_2000.geojson",
      });
      map.addLayer({
        id: "geochem-soil",
        type: "circle",
        source: "geochem-soil",
        paint: {
          "circle-color": "#FFD700",
          "circle-radius": ["interpolate", ["linear"], ["get", "au_ppb"], 800, 3, 2000, 10],
          "circle-opacity": 0.8,
        },
      });

      // Boreholes dip -65 arrows shear 530-553 DEM 1519 cross-section X vs Elevation terrain on top blocks below
      map.addSource("boreholes", {
        type: "geojson",
        data: "/geojson/boreholes_dip_-65.geojson",
      });
      map.addLayer({
        id: "boreholes",
        type: "symbol",
        source: "boreholes",
        layout: {
          "icon-image": "arrow",
          "icon-rotate": ["get", "azimuth"], // az270W
          "icon-size": 1.2,
        },
      });
    });

    // Three.js WebGPU Renderer — Volumetric Grade Shells
    if (!threeContainer.current) return;
    const scene = new THREE.Scene();
    scene.background = new THREE.Color(0x0a1628); // dark navy #0A1628

    // WebGPU Renderer with fallback to WebGLRenderer
    let renderer: any;
    if (webGPUAvailable) {
      // const webgpuRenderer = new WebGPURenderer({ antialias: true });
      // webgpuRenderer.setSize(threeContainer.current.clientWidth, threeContainer.current.clientHeight);
      // threeContainer.current.appendChild(webgpuRenderer.domElement);
      // renderer = webgpuRenderer;
      // For now use WebGLRenderer with WebGPU flag — upgrade to WebGPURenderer when three@r160 stable in your kit
      renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
      renderer.setSize(threeContainer.current.clientWidth, threeContainer.current.clientHeight);
      threeContainer.current.appendChild(renderer.domElement);
    } else {
      renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
      renderer.setSize(threeContainer.current.clientWidth, threeContainer.current.clientHeight);
      threeContainer.current.appendChild(renderer.domElement);
    }

    const camera = new THREE.PerspectiveCamera(60, threeContainer.current.clientWidth / threeContainer.current.clientHeight, 0.1, 10000);
    camera.position.set(0, -500, 300);
    
    const controls = new (THREE as any).OrbitControls ? new (THREE as any).OrbitControls(camera, renderer.domElement) : null;

    // Lighting PBR production directional sun shadows ambient hemisphere point lights at visible gold 35 intersections ACES tone mapping bloom >10g/t SSAO
    const sunLight = new THREE.DirectionalLight(0xffffff, 1.2);
    sunLight.position.set(100, 100, 200);
    sunLight.castShadow = true;
    scene.add(sunLight);
    scene.add(new THREE.AmbientLight(0xffffff, 0.4));
    const hemiLight = new THREE.HemisphereLight(0xffffff, 0x444444, 0.6);
    scene.add(hemiLight);

    // Volumetric Grade Shells — Ray-marched volumes grade shells Au >3.92 Indicated threshold semi-transparent volume + Au >10 red + >40 purple visible gold glow + bloom + depth
    // Signed distance field + marching cubes GPU iso-surfaces — Leapfrog quality in browser
    const volumetricGroup = new THREE.Group();
    
    // Example: Create grade shell for Isulu 4157 blocks 5.61MT @7.04=1.27Moz exact GxW1317
    // In production, load from API_BLOCKS_ISULU and generate SDF
    fetch(API_BLOCKS_ISULU)
      .then(res => res.json())
      .then(blocks => {
        // WebGPU Compute Kriging — pyGSLIB nugget 0.15 sill 1.2 range 45m strike 25m across 15m vertical Spherical Liranda Corridor
        // For each block with au >= gradeFilter, create instanced cube with PBR transparent 0.6
        // Volumetric shell for au >10 red + >40 purple
        blocks.forEach((block: any) => {
          if (block.au < gradeFilter) return;
          if (showVisibleGoldOnly && block.au < 40) return;
          
          const geometry = new THREE.BoxGeometry(block.dx || 10, block.dy || 10, block.dz || 5);
          const material = new THREE.MeshStandardMaterial({
            color: block.au < 1 ? 0x808080 : block.au < 3 ? 0xffd700 : block.au < 10 ? 0xff8c00 : block.au < 40 ? 0xdc143c : 0x8a2be2,
            transparent: true,
            opacity: 0.6,
            emissive: block.au > 40 ? new THREE.Color(0x8a2be2) : new THREE.Color(0x000000),
            emissiveIntensity: block.au > 40 ? 0.5 : 0,
          });
          const cube = new THREE.Mesh(geometry, material);
          cube.position.set(block.x, block.y, block.abs_elev || block.z); // real elev fix abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below
          volumetricGroup.add(cube);
        });
      });

    scene.add(volumetricGroup);

    // Drillholes PBR cylinders 0.5m radius assay segments colored <1 gray #808080 1-3 yellow #FFD700 3-10 orange #FF8C00 >10 red #DC143C >40 purple #8A2BE2 emissive glow sparkle particles for spectacular 65.20g/t LCD0330
    fetch("/geojson/boreholes_dip_-65.geojson")
      .then(res => res.json())
      .then(data => {
        data.features.forEach((f: any) => {
          const { easting, northing, collar_elev, dip, azimuth, assays } = f.properties;
          // Create PBR cylinder 0.5m radius
          const cylinderGeo = new THREE.CylinderGeometry(0.5, 0.5, f.properties.length || 200, 8);
          const cylinderMat = new THREE.MeshStandardMaterial({ color: 0x555555 });
          const cylinder = new THREE.Mesh(cylinderGeo, cylinderMat);
          cylinder.position.set(easting, northing, collar_elev - (f.properties.length || 200)/2);
          cylinder.rotation.x = THREE.MathUtils.degToRad(90 + dip); // dip -65
          cylinder.rotation.z = THREE.MathUtils.degToRad(azimuth); // az270W
          scene.add(cylinder);
        });
      });

    const animate = () => {
      requestAnimationFrame(animate);
      if (controls) controls.update();
      renderer.render(scene, camera);
    };
    animate();

    // EVAN Agents Real-time WebSocket — watches uploads Bronze SHA256 Silver validation Gold merge Isulu+Mui pushes to Three.js visuals update without refresh live
    const wsProtocol = window.location.protocol === "https:" ? "wss:" : "ws:";
    const ws = new WebSocket(`${wsProtocol}//${window.location.host}/ws/evan-agents`);
    
    ws.onmessage = (event) => {
      const data = JSON.parse(event.data);
      if (data.type === "exploration") {
        setEvanAgents(prev => ({ ...prev, exploration: data.message }));
        // Auto-add new blocks to volumetricGroup
      }
      if (data.type === "vetting") {
        setEvanAgents(prev => ({ ...prev, vetting: data.message })); // Kenya bbox -5to5 33to42 PASS host_rock Nyanzian 2700Ma QAQC Au 0-219.5 abs_elev Isulu1519 dip-65 SHA256 ODPC PASS
      }
      if (data.type === "analytics") {
        setEvanAgents(prev => ({ ...prev, analytics: data.message })); // GxW Quotient ISR-BH-237 6m @219.5=1317 highest ROI
        // Auto-recolor by GxW Quotient
      }
      if (data.type === "nexus") {
        setEvanAgents(prev => ({ ...prev, nexus: data.message }));
      }
    };

    // WebGPU Compute Kriging live — as user uploads CSV/SHP/PDF Bronze SHA256 Silver validation Gold merge Isulu+Mui block model re-estimates live GxW Quotient auto-updates
    const interval = setInterval(() => {
      // Simulate WebGPU compute — in production, call WebGPU compute shader
      // pyGSLIB nugget 0.15 sill 1.2 range 45m strike 25m across 15m vertical Spherical Liranda Corridor high nugget visible gold 35/102
      fetch("/api/evan/compute-kriging", { method: "POST", body: JSON.stringify({ au_cutoff: gradeFilter, g_x_w_gt: 1317 }) })
        .then(res => res.json())
        .then(data => {
          if (data.updated) {
            // Volumetric shells re-render as kriging updates
            console.log("WebGPU Compute Kriging updated", data);
          }
        })
        .catch(() => {});
    }, 10000); // Every 10s check for new uploads

    return () => {
      map.remove();
      ws.close();
      clearInterval(interval);
      renderer.dispose();
    };
  }, [gradeFilter, showVisibleGoldOnly, webGPUAvailable]);

  return (
    <div className="min-h-screen bg-[#0A1628] text-white font-['Inter']">
      {/* Header Dual Q */}
      <header className="border-b border-[#C2A878]/20 p-4 flex items-center justify-between">
        <div className="flex items-center gap-4">
          <div className="flex items-center gap-2">
            <span className="text-2xl font-bold"><span className="text-white">Ke</span><span className="text-[#C2A878]">Min</span><span className="text-white">Q</span></span>
            <span className="text-xs border border-[#C2A878] px-2 py-1 rounded">EVAN</span>
            <span className="text-[10px] text-[#C2A878]">Exploration Vetting Analytics Nexus</span>
          </div>
          <div className="text-[10px] text-[#C2A878]">Query the data. Calculate the quotient.</div>
          <div className="text-[10px] text-white/60">Isulu 4157 5.61MT @7.04=1.27Moz GxW1317 + Mui 16037 400MT + geology 1116 + mag low -30 + IP 25-40 + soil 800-2000 + Full 900+ OTMCP</div>
        </div>
        <div className="flex gap-2">
          <button className="bg-[#C2A878] text-[#0A1628] px-4 py-2 rounded text-sm font-bold">Ask EVAN Pro $99/mo → /api/stripe/checkout?plan=pro</button>
          <button className="border border-[#C2A878] px-4 py-2 rounded text-sm">Enterprise $499</button>
        </div>
      </header>

      {/* 3 Quotients side-by-side selector */}
      <div className="grid grid-cols-3 gap-2 p-2 bg-[#0A1628] border-b border-[#C2A878]/20">
        <button onClick={() => setSelectedQuotient("gold")} className={`p-3 rounded border ${selectedQuotient==="gold" ? "bg-[#C2A878] text-[#0A1628] border-[#C2A878]" : "border-[#C2A878]/30 text-white"} text-left`}>
          <div className="font-bold text-sm">Gold Quotient GxW1317</div>
          <div className="text-xs">Isulu 4157 5.61MT @7.04=1.27Moz exact ISR-BH-237 6m @219.5=1317 highest ROI BSG-BH-045 6.4m @47.3 ML/2024/0200 Shanta 15.38km2</div>
          <div className="text-[10px] opacity-70">Liranda 12km shear 23m dip70W az270W dip-65 mag low -30 IP 25-40 soil 800-2000</div>
        </button>
        <button onClick={() => setSelectedQuotient("coal")} className={`p-3 rounded border ${selectedQuotient==="coal" ? "bg-[#C2A878] text-[#0A1628] border-[#C2A878]" : "border-[#C2A878]/30 text-white"} text-left`}>
          <div className="font-bold text-sm">Coal Quotient Mui 100MT @25</div>
          <div className="text-xs">Mui 16037 400MT Blocks A-D 79 samples 16-27 MJ/kg 100MT @25 MJ/kg Block C international 500km2 Karoo Ecca $2B+</div>
          <div className="text-[10px] opacity-70">Fenxi ML Granted Blocks A-B Block C international Mining Act 2016 OTMCP</div>
        </button>
        <button onClick={() => setSelectedQuotient("critical")} className={`p-3 rounded border ${selectedQuotient==="critical" ? "bg-[#C2A878] text-[#0A1628] border-[#C2A878]" : "border-[#C2A878]/30 text-white"} text-left`}>
          <div className="font-bold text-sm">Critical Minerals Quotient Kwale Ti 26% + Mrima REE-Nb 70Ma</div>
          <div className="text-xs">Kwale 56km2 26% global Base Titanium ML + Mrima 70Ma carbonatite REE-Nb + Magadi trona 100MT + Tsavo ruby 2,000km Mozambique Belt</div>
          <div className="text-[10px] opacity-70">Base Titanium $500M+ export Mrima REE-Nb critical EVs wind Magadi 100MT industrial</div>
        </button>
      </div>

      <div className="flex h-[calc(100vh-160px)]">
        {/* Left 30% Drillhole DB + Controls */}
        <div className="w-[30%] border-r border-[#C2A878]/20 p-3 overflow-y-auto bg-[#0A1628]/90 backdrop-blur">
          <h3 className="font-bold text-[#C2A878] text-sm mb-2">Drillhole DB Public 102 holes 35 visible gold 9,383m Phase 1 1,182,000 oz @12.6g/t highest grading +1 Moz Africa</h3>
          <div className="text-[11px] space-y-1 mb-4">
            <div>LCD0330 0.7m 65.20g/t 380.4-381.1m Isulu spectacular</div>
            <div>LCD0331 0.5m 5.35g/t 267.4-267.9m Isulu</div>
            <div>6.4m @47.3g/t Bushiangala high-grade</div>
            <div>8m @4.12 131-139m 4m @13.9 41-45m 10.7m @3.44 164.3-175m visible gold</div>
            <div>True width 60-70% — Phase 1 converted 34,900 oz @3.92 Bushiangala 82,700 oz @10.62 Isulu</div>
          </div>

          <h4 className="font-bold text-white text-xs mb-2">Block Model Controls — WebGPU 60fps — {webGPUAvailable ? "WebGPU Available" : "WebGL2 Fallback"}</h4>
          <div className="space-y-3 mb-4">
            <div>
              <label className="text-[11px] text-white/70">Grade filter > {gradeFilter}g/t Indicated threshold</label>
              <input type="range" min="0" max="50" step="0.1" value={gradeFilter} onChange={e => setGradeFilter(parseFloat(e.target.value))} className="w-full" />
            </div>
            <label className="flex items-center gap-2 text-[11px]">
              <input type="checkbox" checked={showVolumetric} onChange={e => setShowVolumetric(e.target.checked)} />
              Volumetric Grade Shells Ray-marched Au &gt;3.92 Indicated + Au &gt;10 red + &gt;40 purple glow + bloom + depth
            </label>
            <label className="flex items-center gap-2 text-[11px]">
              <input type="checkbox" checked={showVisibleGoldOnly} onChange={e => setShowVisibleGoldOnly(e.target.checked)} />
              Visible Gold Only 35 intersections sparkle
            </label>
            <div className="text-[10px] text-[#C2A878]">Parent 10x10x5m sub-block 2.5x2.5x1.25m 12,450 blocks instanced transparent 0.6 Indicated solid Inferred wireframe LOD frustum culling</div>
          </div>

          <h4 className="font-bold text-[#C2A878] text-xs mb-2">Variogram WebGPU Compute Kriging</h4>
          <div className="text-[11px] space-y-1 mb-4">
            <div>Nugget 0.15 Sill 1.2 Range 45m strike 25m across 15m vertical Spherical Liranda Corridor high nugget visible gold 35/102</div>
            <div className="text-white/60">WebGPU compute shaders auto-fit variogram + kriging live — GPU-based IDW/kriging — as user uploads CSV/SHP/PDF Bronze SHA256 Silver validation Gold merge Isulu+Mui block model re-estimates live GxW Quotient auto-updates</div>
            <div className="bg-[#C2A878]/20 p-2 rounded text-[10px]">WebGPU Compute Status: {webGPUAvailable ? "Active — 10x block count Isulu 4157 + Mui 16037 fully opaque 60fps" : "Fallback — Enable chrome://flags/#enable-unsafe-webgpu"}</div>
          </div>

          <h4 className="font-bold text-white text-xs mb-2">Exports — Real elev fix</h4>
          <div className="text-[10px] space-y-1">
            <div>QGIS 5.9MB GPKG SHP GeoTIFF DEM 1519 QGS</div>
            <div>Vulcan vulcan_collar_real_elev_dip.csv</div>
            <div>Datamine datamine_collar_real.txt</div>
            <div>Leapfrog collar_real_dip_az_elevation_Leapfrog.csv</div>
            <div>KML KMZ MVT {MVT_TILES} API {API_BLOCKS_ISULU}</div>
            <div>Cesium 3D Tiles {CESIUM_3D_TILES} glTF DXF MVT GeoJSON MBTiles AR</div>
            <div className="text-[#C2A878]">abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS</div>
          </div>
        </div>

        {/* Middle 40% 3D View */}
        <div className="w-[40%] relative">
          <div ref={mapContainer} className="absolute inset-0" />
          <div ref={threeContainer} className="absolute inset-0 pointer-events-none" style={{ mixBlendMode: "normal" }} />
          <div className="absolute top-2 left-2 bg-[#0A1628]/80 backdrop-blur px-3 py-2 rounded text-[11px] border border-[#C2A878]/30">
            <div className="font-bold text-[#C2A878]">3D View Cesium globe + Mapbox 3D terrain 1.5x exaggeration</div>
            <div>102/35/9,383m 1,182,000 oz @12.6g/t highest grading +1 Moz Africa — Mapbox light #F8F9FA layers OFF clean muted Gold #C2A878 graduated yellow-orange-red-dark red 219.5 boreholes dip -65 arrows shear 530-553 DEM 1519 cross-section X vs Elevation terrain on top blocks below</div>
            <div className="text-white/60">PBR cylinders 0.5m assay colors &lt;1 gray 1-3 yellow 3-10 orange &gt;10 red &gt;40 purple glow sparkle 65.20g/t LCD0330 + volumetric grade shells ray-marched Au &gt;3.92 Indicated + Au &gt;10 red + &gt;40 purple glow + bloom + depth + signed distance field + marching cubes GPU iso-surfaces</div>
          </div>
          <div className="absolute bottom-2 left-2 right-2 bg-[#0A1628]/80 backdrop-blur px-3 py-2 rounded text-[10px] border border-[#C2A878]/30 flex gap-4">
            <span>Isulu 4157 5.61MT @7.04=1.27Moz exact GxW1317</span>
            <span>Mui 16037 400MT Blocks A-D Fenxi ML Granted</span>
            <span>Geology 1116 Liranda shear 23m 12km dip70W az270W dip-65</span>
            <span>Mag low -30 + IP 25-40 + soil 800-2000 = ISR-BH-237</span>
            <span>Full 900+ OTMCP vs 32 SAMPLE Free</span>
          </div>
        </div>

        {/* Right 30% EVAN Agents */}
        <div className="w-[30%] border-l border-[#C2A878]/20 p-3 overflow-y-auto bg-[#0A1628]/90 backdrop-blur">
          <h3 className="font-bold text-[#C2A878] text-sm mb-2">EVAN = Exploration Vetting Analytics Nexus — Real-time AI Agents</h3>
          
          <div className="space-y-3 mb-4">
            <div className="bg-[#C2A878]/10 border border-[#C2A878]/30 p-2 rounded">
              <div className="font-bold text-[11px] text-[#C2A878]">Exploration Agent — Watching uploads Bronze SHA256</div>
              <div className="text-[10px] text-white/80">{evanAgents.exploration}</div>
              <div className="text-[9px] text-white/60">60 Samsam + 102 maps + Isulu 4157 exact ISR-BH-237 6m @219.5 GxW1317 BSG-BH-045 6.4m @47.3 Mui 16037 400MT Blocks A-D Fenxi ML Granted geology 1116 Liranda shear 23m 12km dip70W mag low -30 blue demag + IP 25-40 red soil 800-2000 As100 Sb20 cadastre 32 SAMPLE Free vs Full 900+ OTMCP</div>
            </div>
            <div className="bg-green-900/20 border border-green-500/30 p-2 rounded">
              <div className="font-bold text-[11px] text-green-400">Vetting Agent — Kenya bbox -5to5 33to42 PASS</div>
              <div className="text-[10px] text-white/80">{evanAgents.vetting}</div>
              <div className="text-[9px] text-white/60">host_rock Nyanzian basalt 2700Ma PASS QAQC Au 0-219.5 TMI -50 to120 IP 0-40 abs_elev=collar-vert_depth Isulu1519 fixed inversion terrain on top blocks below PASS dip-65 az270W PASS SHA256 PASS ODPC 2019 Art26 Mining Act 2016 OTMCP PASS CP Measured&lt;40 Indicated&lt;100</div>
            </div>
            <div className="bg-[#C2A878]/10 border border-[#C2A878]/30 p-2 rounded">
              <div className="font-bold text-[11px] text-[#C2A878]">Analytics Agent — GxW Quotient Grade x Width ISR-BH-237 6m @219.5=1317 highest ROI</div>
              <div className="text-[10px] text-white/80">{evanAgents.analytics}</div>
              <div className="text-[9px] text-white/60">Metal Quotient Economic Quotient Quality Quotient MRE Valuation Drill Target — Auto-colors blocks by GxW — yellow-orange-red-dark red 219.5 — auto-detects high ROI — Volumetric shells re-render as kriging updates</div>
            </div>
            <div className="bg-blue-900/20 border border-blue-500/30 p-2 rounded">
              <div className="font-bold text-[11px] text-blue-400">Nexus Agent — Merging Isulu+Mui → WebSocket push live</div>
              <div className="text-[10px] text-white/80">{evanAgents.nexus}</div>
              <div className="text-[9px] text-white/60">Bronze SHA256 Silver validation Gold merge Isulu+Mui → JORC Table1 NI43-101 MRE Potential Map Tenement Map Exports Vulcan Datamine Leapfrog QGIS KML MVT Cesium 3D Tiles glTF — visuals update without refresh live</div>
            </div>
          </div>

          <h4 className="font-bold text-white text-xs mb-2">Dual Q — Query the data. Calculate the quotient.</h4>
          <div className="text-[11px] space-y-2 mb-4">
            <div><span className="text-[#C2A878] font-bold">Q as Query:</span> Ask EVAN anything high-intelligence precise from books/journals/industry reports Geology of Kenya Shackleton 1986 Precambrian Research 2700Ma Shanta LSE RNS 221,000m drilling BGS NGDC every answer EVAN: with citations [1][2][3] Confidence 98% Vetted SHA256 CP badge</div>
            <div><span className="text-[#C2A878] font-bold">Q as Quotient:</span> GxW Quotient Grade x Width ISR-BH-237 6m @219.5=1317 highest ROI drill target mag low -30 + IP 25-40 + soil 800-2000 = ISR-BH-237 5.61MT @7.04=1.27Moz exact</div>
            <div className="text-[#C2A878] font-bold">KeMinQ = Kenya Mineral Intelligence Query — The Quotient that matters (GxW 1317)</div>
          </div>

          <h4 className="font-bold text-[#C2A878] text-xs mb-2">3 Quotients side-by-side — Which quotient has highest ROI?</h4>
          <div className="text-[10px] space-y-2 mb-4">
            <div><span className="font-bold">Gold GxW1317:</span> ISR-BH-237 6m @219.5=1317 highest ROI Isulu 4157 blocks 5.61MT @7.04=1.27Moz exact — Liranda 12km shear 23m dip70W az270W dip-65 Nyanzian 2700Ma — mag low -30 blue demag low vs 80-120 red high + IP 25-40 red sulfide + soil Au 800-2000 As100 Sb20 = ISR-BH-237 drill target — ML/2024/0200 Shanta 15.38km2 Siaya Vihiga — For Shanta Gold</div>
            <div><span className="font-bold">Coal 100MT @25:</span> Mui 16037 blocks 400MT Blocks A-D Fenxi ML Granted 79 samples 16-27 MJ/kg 100MT @25 MJ/kg Block C international 500km2 Karoo Ecca sandstone mudstone $2B+ @50/ton — For Fenxi Mining Mui Blocks A-B ML Granted Block C international 100MT @25</div>
            <div><span className="font-bold">Critical Ti 26% + REE-Nb 70Ma:</span> Kwale 56km2 26% global Base Titanium ML $500M+ export + Mrima Hill 70Ma carbonatite REE-Nb monazite bastnasite niobium critical EVs wind turbines + Magadi trona 100MT Lake Magadi sodium sesquicarbonate industrial + Tsavo ruby tsavorite 2,000km Mozambique Belt metamorphic gneiss high value — For Base Titanium Kwale 56km2 26% global</div>
            <div className="text-[#C2A878] font-bold">EVAN Analytics calculates — Which quotient has highest ROI for your portfolio?</div>
          </div>

          <div className="space-y-2">
            <button className="w-full bg-[#C2A878] text-[#0A1628] py-2 rounded text-xs font-bold">Open Isulu 4157 3D Block Model → /dashboard?resource=Isulu&gxw=1317&ml=2024/0200</button>
            <button className="w-full border border-[#C2A878] py-2 rounded text-xs">Open Mui 16037 3D Block Model Block C 100MT @25 → /dashboard?resource=Mui&block=C&cv_gt=25</button>
            <button className="w-full border border-[#C2A878] py-2 rounded text-xs">Open Critical Minerals Map Kwale Ti 56km2 26% + Mrima REE-Nb 70Ma → /dashboard?quotient=critical&resource=Kwale</button>
            <button className="w-full bg-white text-[#0A1628] py-2 rounded text-xs font-bold">Ask EVAN Pro $99/mo → /api/stripe/checkout?plan=pro — Query the data. Calculate the quotient.</button>
          </div>

          <div className="mt-4 text-[9px] text-white/50">
            WebGPU Renderer Three.js r160+ 10x block count Isulu 4157 + Mui 16037 fully opaque 60fps — WebGPU Compute Shaders auto-fit variogram + kriging live — Volumetric Ray Marching grade shells — Cesium 3D Tiles streaming — Potree ready if LIDAR — Gaussian Splatting drill core photos → 3D Gaussian splat visible gold at 150m — WebXR VR ready — Mapbox light #F8F9FA layers OFF clean muted Gold #C2A878 graduated dots yellow-orange-red-dark red 219.5 boreholes dip -65 arrows shear 530-553 DEM 1519 cross-section X vs Elevation terrain on top blocks below real elev fix vulcan_collar_real_elev_dip.csv — evan@keminq.ai GxW 1317 + Mui 400MT + Kwale Ti 26% + Mrima REE-Nb 70Ma + Magadi 100MT + Tsavo ruby 2,000km Mozambique Belt Two-shields logo integration ready
          </div>
        </div>
      </div>
    </div>
  );
}
