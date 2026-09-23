import { NextRequest, NextResponse } from 'next/server'
import { ragQuery } from '@/lib/rag'
import { supabaseAdmin } from '@/lib/supabase'
export async function POST(req:NextRequest){const {query,userId,plan='free'}=await req.json(); let userPlan=plan; if(userId){const {data}=await supabaseAdmin.from('users').select('plan').eq('id',userId).single(); if(data) userPlan=data.plan} const result=await ragQuery(query,userPlan); await supabaseAdmin.from('chat_sessions').insert({user_id:userId, query, answer:result.answer, citations:result.citations, confidence:result.confidence, vetting:result.vetting}); return NextResponse.json(result)}
