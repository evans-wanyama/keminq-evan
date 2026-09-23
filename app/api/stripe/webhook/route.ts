
import { NextRequest, NextResponse } from 'next/server'
import Stripe from 'stripe'
import { supabaseAdmin } from '@/lib/supabase'
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, { apiVersion: '2023-10-16' })

export async function POST(req: NextRequest) {
  const sig = req.headers.get('stripe-signature')!
  const buf = await req.arrayBuffer()
  const event = stripe.webhooks.constructEvent(Buffer.from(buf), sig, process.env.STRIPE_WEBHOOK_SECRET!)
  
  if (event.type === 'checkout.session.completed') {
    const session = event.data.object as Stripe.Checkout.Session
    const plan = session.metadata?.plan || 'pro'
    const email = session.customer_email!
    
    // Grant EVAN access
    await supabaseAdmin.from('subscriptions').upsert({
      email,
      plan, // pro = EVAN Pro Query + Quotient, enterprise = EVAN CP, cp = one-off report
      stripe_customer_id: session.customer as string,
      stripe_session_id: session.id,
      ai_name: 'EVAN',
      ai_full: 'Exploration Vetting Analytics Nexus - Named after founder Evan',
      brand: 'KeMinQ = Kenya Mineral Intelligence Query — The Quotient that matters (GxW 1317)',
      tagline: 'Query the data. Calculate the quotient.',
      entitlements: plan === 'pro' ? ['evan_lite','evan_pro_query','evan_pro_quotient','blocks_3d_4157_16037','geology_1116','geophysics_mag_ip','geochemistry_soil','exports_qgis_vulcan','drill_target_gxw1317','valuation','upload_realtime','chat_full','cadastre_full_900'] : 
                    plan === 'enterprise' ? ['evan_lite','evan_pro_query','evan_pro_quotient','evan_cp','blocks_3d','geology','geophysics','geochemistry','exports','jorc_table1','api','cp_signoff','white_label','cadastre_full_900'] :
                    ['evan_cp_report_oneoff','jorc_table1'],
      isulu_access: '4157 blocks 5.61MT @7.04=1.27Moz exact ISR-BH-237 6m @219.5 GxW1317',
      status: 'active'
    })
  }
  
  if (event.type === 'customer.subscription.deleted') {
    const sub = event.data.object as Stripe.Subscription
    await supabaseAdmin.from('subscriptions').update({ plan: 'free', entitlements: ['evan_lite','occurrence_sample_60','cadastre_32_sample','isulu_summary_1.27Moz'] }).eq('stripe_customer_id', sub.customer as string)
  }
  
  return NextResponse.json({ received: true, evan: 'EVAN Pro - Query + Quotient wired' })
}
