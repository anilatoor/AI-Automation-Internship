-- Task 6 — AI Lead Qualification + Database
-- Run after the AI Agent node returns { lead_score, lead_status, lead_category }.
-- Mirrors the live workflow: find-or-create the customer first (leads.customer_id
-- is NOT NULL), then insert the lead with the AI's analysis attached directly —
-- no separate UPDATE step, and no name/email/company/ai_analysis on `leads`
-- (those live on `customers`; ai_analysis is not persisted, see ../Database Schema/phase5-schema.sql).

-- 1. Find the customer by email, or create one on first contact
WITH existing AS (
    SELECT id FROM customers WHERE email = $1 LIMIT 1
), inserted AS (
    INSERT INTO customers (name, email, phone, company)
    SELECT $2, $1, $3, $4
    WHERE NOT EXISTS (SELECT 1 FROM existing)
    RETURNING id
)
SELECT id FROM existing
UNION ALL
SELECT id FROM inserted;

-- 2. Insert the lead with the AI's analysis already attached
INSERT INTO leads (customer_id, source, lead_score, lead_status, lead_category)
VALUES ($1, $2, $3, $4, $5)
RETURNING *;

-- 3. Bonus IF-node gate: only rows the Slack notification branch should fire for
SELECT l.id, c.name, c.company, l.lead_score, l.lead_status, l.lead_category
FROM leads l
JOIN customers c ON c.id = l.customer_id
WHERE l.lead_score >= 70
ORDER BY l.created_at DESC
LIMIT 1;

-- Example AI output this schema is built around:
-- { "lead_score": 87, "lead_status": "Qualified", "lead_category": "High Intent" }
