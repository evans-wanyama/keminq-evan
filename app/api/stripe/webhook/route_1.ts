import { NextRequest, NextResponse } from 'next/server'
import Stripe from 'stripe'
import { supabaseAdmin } from '@/lib/supabase'
const stripe=new Stripe(process.env.STRIPE_SECRET_KEY!)
export async function POST(req:NextRequest){const sig=req.headers.get('stripe-signature')!; const body=await req.text(); let event:Stripe.Event; try{event=stripe.webhooks.constructEvent(body,sig,process.env.STRIPE_WEBHOOK_SECRET!)}catch(err:any){return NextResponse.json({error:err.message},{status:400})} if(event.type==='checkout.session.completed'){const session=event.data.object as Stripe.Checkout.Session; const userId=session.metadata?.userId; let plan='pro'; if(session.amount_total && session.amount_total>=49900) plan='enterprise'; if(userId){await supabaseAdmin.from('users').update({plan}).eq('id',userId)}} return NextResponse.json({received:true})}
