-- Task 9 — Automated Database Reporting
-- Same aggregate shapes as Phase-3 Task 2 (Q1 total, Q3 avg, Q5 by source),
-- extended with a conversion rate and a top-5 query, for the daily report.

-- Headline metrics — one row
SELECT
    COUNT(*)                                                    AS total_leads,
    COUNT(*) FILTER (WHERE created_at >= CURRENT_DATE)          AS new_leads_today,
    COUNT(*) FILTER (WHERE lead_status = 'Qualified')           AS qualified_leads,
    COUNT(*) FILTER (WHERE lead_status = 'Converted')           AS converted_leads,
    ROUND(AVG(lead_score), 2)                                   AS avg_lead_score,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE lead_status = 'Converted')
        / NULLIF(COUNT(*), 0), 1
    )                                                            AS conversion_rate_pct
FROM leads;

-- Top lead source
SELECT source, COUNT(*) AS count
FROM leads
GROUP BY source
ORDER BY count DESC
LIMIT 1;

-- Top 5 leads by score
SELECT c.name, l.source, l.lead_score, l.lead_status
FROM leads l
JOIN customers c ON c.id = l.customer_id
ORDER BY l.lead_score DESC
LIMIT 5;

-- ------------------------------------------------------------
-- Example AI-written summary this data feeds (from README.md):
--
-- Daily Lead Report
-- Total Leads: 47
-- Qualified: 18
-- Converted: 6
-- Conversion Rate: 12.7%
-- Top Source: LinkedIn
--
-- Observation:
-- LinkedIn generated fewer leads than the website,
-- but produced the highest percentage of qualified leads.
-- ------------------------------------------------------------
