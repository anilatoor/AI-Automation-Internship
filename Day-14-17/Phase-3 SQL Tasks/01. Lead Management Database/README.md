# Task 1 — Build a Lead Management Database

## Table: `leads`

Created in database `lead_management` with 9 columns: `id`, `name`, `email`, `phone`, `company`, `source`, `lead_score`, `status`, `created_at`.

```sql
CREATE TABLE leads (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    phone VARCHAR(30),
    company VARCHAR(100),
    source VARCHAR(50),
    lead_score INT,
    status VARCHAR(30) DEFAULT 'New',
    created_at TIMESTAMP DEFAULT NOW()
);
```

## Queries — status: all 8 run successfully

| Query # | Requirement                   | Result                                                                                                                            |
| ------- | ----------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| 1       | Create the table              | ✅ `leads` created in `lead_management`                                                                                           |
| 2       | Insert at least 10 leads      | ✅ 10 rows inserted                                                                                                               |
| 3       | Display all leads             | ✅ `SELECT * FROM leads;`                                                                                                         |
| 4       | Display only qualified leads  | ✅ `WHERE status = 'Qualified'`                                                                                                   |
| 5       | Display leads with score > 70 | ✅ `WHERE lead_score > 70`                                                                                                        |
| 6       | Update one lead's status      | ✅ `id = 2` (Sara Ali) → `Converted`                                                                                              |
| 7       | Delete one lead               | ✅ `id = 9` (Hassan Tariq) removed                                                                                                |
| 8       | Top 5 leads by `lead_score`   | ✅ `ORDER BY lead_score DESC LIMIT 5` → Maria Garcia (95), Fatima Noor (90), Zainab Omar (88), Ahmed Khan (85), Ayesha Malik (78) |

Full query history (in order run) is captured in [screenshots/Task 1 Query Log.png](<screenshots/Task 1 Query Log.png>).

> Written and run independently — not copied from an internet solution.

## Deliverables

- [X] SQL file → [sql/leads.sql](sql/leads.sql)
- [X] Screenshots of execution + resulting table → [screenshots/](screenshots/)
  - `All Leads Data.png` — full table after insert
  - `Only Qualified Leads.png`
  - `Lead Score greater than 70.png`
  - `Update Lead Status.png`
  - `Delete One Lead.png` / `id 9 Deleted.png` —
  - `Top 5 Leads.png`
  - `Task 1 Query Log.png` — full pgAdmin query history for the session
