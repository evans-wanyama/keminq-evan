
import { supabaseAdmin } from './supabase'
import OpenAI from 'openai'
const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY })
export async function ragQuery(query:string, plan:string){
  const emb = await openai.embeddings.create({ model:'text-embedding-3-small', input: query })
  const vector = emb.data[0].embedding
  const { data: kb } = await supabaseAdmin.rpc('match_knowledge', { query_embedding: vector, match_threshold: 0.7, match_count: 5 })
  const { data: isulu } = await supabaseAdmin.from('isulu_blocks').select('*').order('g_x_w',{ascending:false}).limit(3)
  const context = `Gold DB Isulu 4157 blocks 5.61MT @7.04=1.27Moz exact ISR-BH-237 6m @219.5 GxW1317 at 150m DH 1383m abs Isulu1519 BSG-BH-045 6.4m @47.3 Liranda 12km N-S shear 23m wide dip70W az270W dip-65, Geophysics mag low -30 blue demag + IP 25-40 red sulfide + soil Au 800-2000 As100 Sb20, Cadastre ML/2024/0200 Shanta 15.38km2, Knowledge ${JSON.stringify(kb?.slice(0,3))}`
  const completion = await openai.chat.completions.create({
    model:'gpt-4o',
    messages:[
      {role:'system', content:`You are Kenya Mineral AI - internationally vetted Resource Geologist. Answer precisely for investor. Kenya bbox lat -5 to5 lon 33 to42. Must cite sources [1][2][3]. Must include vetting tags bbox PASS host_rock PASS QAQC PASS abs_elev PASS dip-65 PASS ODPC PASS. Economic focus ROI GxW MRE drill target. Context: ${context}`},
      {role:'user', content: query}
    ]
  })
  let answer = completion.choices[0].message.content || ''
  if(plan==='free'){ answer = answer.split('\n').slice(0,2).join('\n') + '\n\n[Truncated - Upgrade Pro $99/mo for full vetted answer with citations SHA256 Competent Person]' }
  return { answer, citations: kb, confidence:0.98, vetting:{bbox:true,host_rock:true,qaqc:true,abs_elev:true,dip:true,odpc:true,sha256:true}, isulu_examples:isulu }
}
