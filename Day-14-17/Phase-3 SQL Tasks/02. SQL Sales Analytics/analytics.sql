-- ============================================================
-- Task 2: SQL Sales Analytics
-- (uses the leads table created in Task 1)
-- ============================================================

--Q1: How many total leads are there?
SELECT COUNT(*) AS total_leads FROM leads;

--Q2: How many leads are New / Contacted / Qualified / Converted / Lost?
SELECT status, COUNT(*) AS count FROM leads GROUP BY status;

--Q3: What is the average lead score?
SELECT AVG(lead_score) AS avg_score FROM leads;

--Q4: Which lead has the highest score?
SELECT * FROM leads ORDER BY lead_score DESC LIMIT 1;

--Q5: How many leads came from each source Facebook / LinkedIn / Website / Google / Referral?
SELECT source, COUNT(*) AS count FROM leads GROUP BY source;

--Q6: Leads with a score between 50 and 80, highest to lowest
SELECT * FROM leads WHERE lead_score BETWEEN 50 AND 80 ORDER BY lead_score DESC;