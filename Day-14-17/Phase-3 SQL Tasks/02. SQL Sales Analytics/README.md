# Task 2 — SQL Sales Analytics

Using the `leads` table from Task 1 (9 rows remaining after the Task 1 delete), the following questions were answered:

## Results

### Q1 — Total leads

```sql
SELECT COUNT(*) AS total_leads FROM leads;
```

→ **9**

### Q2 — Leads by status

```sql
SELECT status, COUNT(*) AS count FROM leads GROUP BY status;
```

| Status    | Count |
| --------- | ----- |
| New       | 2     |
| Qualified | 3     |
| Converted | 3     |
| Lost      | 1     |

### Q3 — Average lead score

```sql
SELECT AVG(lead_score) AS avg_score FROM leads;
```

→ **74.22** (74.2222222222222222)

### Q4 — Highest-scoring lead

```sql
SELECT * FROM leads ORDER BY lead_score DESC LIMIT 1;
```

→ **Maria Garcia** — score **95**, source Referral, status Converted

### Q5 — Leads by source

```sql
SELECT source, COUNT(*) AS count FROM leads GROUP BY source;
```

| Source   | Count |
| -------- | ----- |
| Facebook | 2     |
| Google   | 1     |
| Referral | 2     |
| Website  | 2     |
| LinkedIn | 2     |

### Q6 — Leads scoring 50–80, highest to lowest

```sql
SELECT * FROM leads WHERE lead_score BETWEEN 50 AND 80 ORDER BY lead_score DESC;
```

| Name         | Score |
| ------------ | ----- |
| Ayesha Malik | 78    |
| Sara Ali     | 72    |
| John Smith   | 60    |
| David Lee    | 55    |

## Concepts demonstrated

`SELECT` · `WHERE` · `ORDER BY` · `LIMIT` · `COUNT()` · `AVG()` · `GROUP BY` · `BETWEEN` — all used above.

## Deliverables

-  SQL file → [sql/analytics.sql](sql/analytics.sql)
-  Screenshots of execution/results → [screenshots/](screenshots/)
  - `Q1. Total Leads.png` through `Q6. Leads Between 50-80.png`
  - `To Analyse.png` — starting table state used for the analysis
