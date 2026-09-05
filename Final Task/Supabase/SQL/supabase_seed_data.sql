-- =====================================================================
-- UrbanCart — Demo seed data
-- Run once in Supabase SQL Editor, after supabase_schema_patch.sql.
-- Safe to re-run: ON CONFLICT guards make it idempotent.
--
-- Covers the demo scenarios:
--   - UC-10452  → "My order UC-10452 hasn't arrived yet" (meeting minutes,
--                 shipped, arriving in 2 days) — voice/chat order-status demo
--   - UC-10453  → delayed order, past its expected delivery date —
--                 triggers the "important order issue" Slack notification
--   - Bilal Hussain → seeded as a known customer with no order yet, for the
--                 lead-capture / escalation demos (shows customer history
--                 lookup working even with zero prior purchases)
-- =====================================================================

insert into customers (name, phone, email, city, channel_first_seen) values
('Ahmed Raza','+92 300 1112223','ahmed@example.com','Lahore','chat'),
('Fatima Noor','+92 321 4445556','fatima@example.com','Karachi','whatsapp'),
('Bilal Hussain','+92 333 7778889','bilal@example.com','Islamabad','voice')
on conflict (phone) do nothing;

insert into orders (order_code, customer_id, items, status, total_pkr, placed_at, expected_delivery)
select 'UC-10452', id,
 '[{"product":"Wireless Headphones X2","qty":1,"price":18500}]'::jsonb,
 'shipped', 18500, now() - interval '4 days', current_date + 2
from customers where phone='+92 300 1112223'
on conflict (order_code) do nothing;

insert into orders (order_code, customer_id, items, status, total_pkr, placed_at, expected_delivery)
select 'UC-10453', id,
 '[{"product":"Smart Watch S9","qty":1,"price":42000}]'::jsonb,
 'delayed', 42000, now() - interval '9 days', current_date - 1
from customers where phone='+92 321 4445556'
on conflict (order_code) do nothing;
