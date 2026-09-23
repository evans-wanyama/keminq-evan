
import { NextRequest, NextResponse } from 'next/server'
import Stripe from 'stripe'
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, { apiVersion: '2023-10-16' })

const PLANS = {
  pro: {
    price: 9900,
    name: 'EVAN Pro - Query the data. Calculate the quotient.',
    description: `KeMinQ = Kenya Mineral Intelligence Query — The Quotient that matters (GxW 1317). Powered by EVAN = Exploration, Vetting, Analytics, Nexus, named after founder Evan.

Query Benefits:
• Unlimited Ask EVAN — high-intelligence Q&A vetted from books/journals/industry reports (Geology of Kenya, Shackleton 1986, Precambrian Research 2700Ma, Shanta LSE RNS 221,000m drilling 1.27Moz @7.04, BGS NGDC)
• Every answer with citations [1][2][3], Confidence 98% Vetted, SHA256 manifest, Competent Person badge, vetting tags bbox PASS host_rock PASS QAQC Au 0-219.5 PASS abs_elev Isulu1519 PASS dip -65 PASS ODPC PASS
• Real-time upload CSV/SHP/PDF -> Bronze SHA256 -> Silver validation Kenya bbox -5 to5 33to42 host_rock Nyanzian 2700Ma -> Gold merge Isulu 4157 + Mui 16037

Quotient Benefits:
• GxW Quotient = 1317 — ISR-BH-237 6m @219.5 = highest ROI, BSG-BH-045 6.4m @47.3 Indicated >100%, MRE 5.61MT @7.04=1.27Moz exact, Valuation
• Full 3D Block Model Isulu 4157 + Mui 16037 400MT Blocks A-D Fenxi ML Granted + geology 1116 Liranda shear 23m 12km dip70W + geophysics mag low -30 blue + IP 25-40 red + geochem soil Au 800-2000 As100 Sb20 + cadastre Full 900+ OTMCP vs 32 SAMPLE Free
• All exports QGIS 5.9MB GPKG SHP GeoTIFF DEM 1519 QGS Vulcan vulcan_collar_real_elev_dip.csv Datamine datamine_collar_real.txt Leapfrog KML KMZ MVT /v1/map/tiles/{z}/{x}/{y}.mvt API /v1/resource/Isulu/blocks?au_cutoff=50&g_x_w_gt=1317
• Drill Target Report mag low -30 + IP 25-40 + soil 800-2000 = ISR-BH-237

Isulu 4157 blocks 5.61MT @7.04=1.27Moz exact, Mui 16,037 400MT, Liranda 12km N-S shear 23m wide dip70W az270W dip-65, Rosterman 259k @12.3 SML 2.5km2 Ramula 470k ML/2024/0200 15.38km2 Siaya Vihiga, ML Active PL Active.`,
    metadata: { plan: 'pro', persona: 'EVAN - Exploration Vetting Analytics Nexus', tagline: 'Query the data. Calculate the quotient.', gxw: '1317', isulu: '4157 blocks 5.61MT @7.04=1.27Moz exact ISR-BH-237 6m @219.5 GxW1317', mui: '16037 blocks 400MT', vetting: 'bbox host_rock qaqc abs_elev dip sha256 odpc' }
  },
  enterprise: {
    price: 49900,
    name: 'EVAN Enterprise - Query + Quotient + JORC CP Sign-off',
    description: `EVAN Enterprise $499/mo — Query + Quotient + JORC Table1 NI43-101 API CP sign-off Measured <40 Indicated <100 Inferred + white label + valuation + pitch deck + full 900+ OTMCP + 3D block model 4157+16037 + geology 1116 + geophysics mag low -30 + IP 25-40 + geochem 800-2000 + exports Vulcan Datamine Leapfrog QGIS KML MVT. Same Query benefits as Pro plus Quotient + CP.`,
    metadata: { plan: 'enterprise', persona: 'EVAN CP', tagline: 'Query the data. Calculate the quotient. Sign-off the resource.' }
  },
  cp: {
    price: 99900,
    name: 'EVAN CP Report $999 - One-off Competent Person Report',
    description: `EVAN CP Report — One-off JORC Table1 NI43-101 SAMREC compliant report for Isulu 1.27Moz @7.04 exact GxW1317 ISR-BH-237 6m @219.5 + Mui 400MT + Liranda 12km shear 23m + mag low -30 + IP 25-40 + soil 800-2000 + cadastre ML/2024/0200 Shanta 15.38km2. Signed Competent Person Measured<40 Indicated<100.`,
    metadata: { plan: 'cp', persona: 'EVAN CP Report' }
  }
}

export async function POST(req: NextRequest) {
  const { plan = 'pro', email } = await req.json()
  const selected = PLANS[plan as keyof typeof PLANS] || PLANS.pro
  
  const session = await stripe.checkout.sessions.create({
    payment_method_types: ['card'],
    line_items: [{
      price_data: {
        currency: 'usd',
        product_data: {
          name: selected.name,
          description: selected.description.slice(0, 500),
          metadata: selected.metadata
        },
        unit_amount: selected.price,
        recurring: plan !== 'cp' ? { interval: 'month' } : undefined
      },
      quantity: 1
    }],
    mode: plan === 'cp' ? 'payment' : 'subscription',
    success_url: `${process.env.NEXT_PUBLIC_APP_URL}/dashboard?session_id={CHECKOUT_SESSION_ID}&plan=${plan}&evan=pro`,
    cancel_url: `${process.env.NEXT_PUBLIC_APP_URL}/pricing?canceled=true`,
    customer_email: email,
    metadata: {
      plan,
      ai_name: 'EVAN',
      ai_full: 'Exploration Vetting Analytics Nexus - Named after founder Evan',
      brand: 'KeMinQ = Kenya Mineral Intelligence Query — The Quotient that matters (GxW 1317)',
      tagline: 'Query the data. Calculate the quotient.',
      isulu_exact: '4157 blocks 5.61MT @7.04=1.27Moz exact ISR-BH-237 6m @219.5 GxW1317 Isulu1519',
      mui_exact: '16037 blocks 400MT Blocks A-D Fenxi ML Granted',
      geology_exact: '1116 pts Liranda 12km shear 23m dip70W az270W dip-65 Nyanzian 2700Ma',
      vetting_exact: 'bbox -5to5 33to42 host_rock Nyanzian QAQC Au 0-219.5 abs_elev=collar-vert_depth Isulu1519 dip-65 SHA256 ODPC Mining Act 2016 CP Measured<40 Indicated<100'
    }
  })
  return NextResponse.json({ url: session.url, id: session.id, plan, evan: 'EVAN Pro - Query + Quotient' })
}
