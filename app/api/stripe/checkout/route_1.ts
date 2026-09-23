import { NextRequest, NextResponse } from 'next/server'
import Stripe from 'stripe'
const stripe=new Stripe(process.env.STRIPE_SECRET_KEY!)
export async function POST(req:NextRequest){const {priceId,userId,email}=await req.json(); const session=await stripe.checkout.sessions.create({mode:'subscription', customer_email:email, line_items:[{price:priceId,quantity:1}], success_url:`${process.env.NEXT_PUBLIC_APP_URL}/?success=true&plan=pro`, cancel_url:`${process.env.NEXT_PUBLIC_APP_URL}/?canceled=true`, metadata:{userId}}); return NextResponse.json({url:session.url})}
