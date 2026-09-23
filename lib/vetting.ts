
export function vetRecord(rec:any){
  const checks:any={}
  const lat=rec.lat??rec.y; const lon=rec.lon??rec.x;
  checks.bbox = lat>=-5 && lat<=5 && lon>=33 && lon<=42
  const validRocks=['Nyanzian basalt','Kavirondian conglomerate','Ultramafic','Granite','Mozambique Belt gneiss']
  checks.host_rock = !rec.host_rock || validRocks.includes(rec.host_rock)
  checks.au_gpt = rec.au_gpt==null || (rec.au_gpt>=0 && rec.au_gpt<=219.5)
  checks.tmi = rec.tmi_nt==null || (rec.tmi_nt>=-50 && rec.tmi_nt<=120)
  checks.ip = rec.ip_mv_v==null || (rec.ip_mv_v>=0 && rec.ip_mv_v<=40)
  checks.au_ppb = rec.au_ppb==null || (rec.au_ppb>=0 && rec.au_ppb<=2000)
  if(rec.collar_elev!=null && rec.vert_depth!=null){ checks.abs_elev = rec.abs_elev===rec.collar_elev-rec.vert_depth } else { checks.abs_elev=true }
  checks.dip = rec.dip==null || (rec.dip>=-90 && rec.dip<=-45)
  const pass = Object.values(checks).every(Boolean)
  return {pass, checks}
}
export function checkPlanAccess(plan:string, feature:string){
  const tiers:any={
    free:['occurrence_sample','cadastre_32','isulu_summary'],
    pro:['occurrence_sample','cadastre_32','isulu_summary','blocks_3d','geology_1116','geophysics_mag_ip','geochemistry_soil','exports_qgis_vulcan','drill_target','valuation','upload_realtime','chat_full'],
    enterprise:['occurrence_sample','cadastre_32','isulu_summary','blocks_3d','geology_1116','geophysics_mag_ip','geochemistry_soil','exports_qgis_vulcan','drill_target','valuation','upload_realtime','chat_full','jorc_table1','api','cp_signoff']
  }
  return (tiers[plan]||tiers.free).includes(feature)
}
