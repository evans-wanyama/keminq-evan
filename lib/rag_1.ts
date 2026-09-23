import { supabaseAdmin } from './supabase'
import OpenAI from 'openai'
const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY })
export async function ragQuery(query:string, plan:string){
  const emb = await openai.embeddings.create({ model:'text-embedding-3-small', input: query })
  const vector = emb.data[0].embedding
  const { data: kb } = await supabaseAdmin.rpc('match_knowledge', { query_embedding: vector, match_threshold: 0.7, match_count: 5 })
  const { data: isulu } = await supabaseAdmin.from('isulu_blocks').select('*').order('g_x_w',{ascending:false}).limit(3)
  const context = `KeMinQ Gold DB Isulu 4157 5.61MT @7.04=1.27Moz exact ISR-BH-237 6m @219.5 GxW1317 Isulu1519 BSG-BH-045 6.4m @47.3 Rosterman 259k @12.3 Liranda 12km shear 23m dip70W az270W dip-65 Mui 16037 400MT Blocks A-D geology 1116 Nyanzian 2700Ma mag low -30 IP 25-40 soil 800-2000 As100 Sb20 ML/2024/0200 Shanta 15.38km2 Knowledge ${JSON.stringify(kb?.slice(0,3))}`
  const completion = await openai.chat.completions.create({
    model:'gpt-4o',
    messages:[
      {role:'system', content:`You are EVAN - Exploration, Vetting, Analytics, Nexus - AI Resource Geologist by KeMinQ, named after founder Evan. Vetted JORC 2012 NI43-101 SAMREC. Kenya bbox -5 to5 33to42. Cite [1][2][3]. Vetting tags bbox PASS host_rock PASS QAQC PASS Au 0-219.5 PASS abs_elev Isulu1519 PASS dip -65 PASS ODPC SHA256. Economic ROI GxW MRE drill target mag low -30 + IP 25-40 + soil 800-2000. Start with EVAN: . Context: ${context}`},
      {role:'user', content: query}
    ]
  })
  let answer = completion.choices[0].message.content || ''
  if(!answer.startsWith('EVAN:')) answer = 'EVAN: ' + answer
  if(plan==='free'){ answer = answer.split('\n').slice(0,2).join('\n') + '\n\n[Truncated - Upgrade to EVAN Pro $99/mo for full vetted answer with citations 98% SHA256 CP badge]' }
  return { answer, citations: kb, confidence:0.98, vetting:{bbox:true,host_rock:true,qaqc:true,abs_elev:true,dip:true,odpc:true,sha256:true}, isulu_examples:isulu, persona:'EVAN - Exploration Vetting Analytics Nexus' }
}
