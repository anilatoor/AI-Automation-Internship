# Task 6 — AI Lead Qualification + Database

## Scenario

An AI agent analyzes an incoming lead and determines `lead_score`, `lead_status`,`lead_category`.

Example: `Lead Score: 87 · Status: Qualified · Category: High Intent`

## Schema

Same shared schema as Task 5 — see [../Database Schema/phase5-schema.sql](<../Database Schema/phase5-schema.sql>).`leads.lead_score`, `lead_status`, and `lead_category` are the AI-generated columns this task fills in; there's no separate `ai_analysis` column — the parsed
score/status/category *are* the persisted analysis.

## Workflow

```text
Webhook → AI Agent (score/status/category) → Parse AI Output
  → Find or Create Customer (Postgres) → Save Lead + Analysis (Postgres) → Sync to Supabase
  → If Score >= 70 → Slack notification → Respond (qualified)
              → (else) → Respond (not qualified)
```

The ≥70 gate is a deterministic IF node, not another AI call. `Find or Create Customer` (keyed on email, capturing `company` too) runs before the lead insert for the same reason as Task 5: `leads.customer_id` is `NOT NULL`. The
qualified-branch Slack notification and webhook response both read `name`/`company` from the `Parse AI Output` node directly, since those columns don't come back from the `leads` insert.

## Requirements

1. Receive a lead
2. Send the lead information to an AI model
3. Generate a score from 0–100
4. Generate a status
5. Generate a category
6. Find-or-create the customer
7. Save the lead with its AI-generated score/status/category
8. Store the final record in PostgreSQL and Supabase

IF node: `Score >= 70` → Send qualified lead notification to Slack (native Slack
node, `#leads` channel), including the lead's email/phone so the notified
person can contact them directly.

## What's built

- Workflow: [Task 6 - AI Lead Qualification + Database.json](<Task%206%20-%20AI%20Lead%20Qualification%20+%20Database.json>) — import into n8n and connect your own Postgres, Supabase, OpenAI, and Slack credentials. No live credentials or secrets are embedded in the file.
- SQL reference: [save-lead-analysis.sql](save-lead-analysis.sql) — find-or-create-customer, insert-lead-with-analysis, and the `score >= 70` gate query, matching the workflow exactly.

## How to test

`POST <your-n8n-instance>/webhook/lead-qualification`

High-intent (should score ≥70 and trigger the Slack notification):

```json
{
  "name": "Fatima Sheikh",
  "email": "fatima.sheikh@example.com",
  "phone": "03331234567",
  "company": "Sheikh Logistics",
  "source": "LinkedIn",
  "message": "We need this urgently, budget already approved, please call today."
}
```

Low-intent (should score <70 and skip the Slack branch):

```json
{
  "name": "Curious Visitor",
  "email": "curious@example.com",
  "source": "Generic Form",
  "message": "Just browsing, maybe later."
}
```

Both should return the full lead record (`id`, `customer_id`, `source`, `lead_score`,
`lead_status`, `lead_category`, `name`, `company`), and a matching row should
appear in `customers` + `leads`.

## Deliverables

-  Exported n8n workflow JSON → [Task 6 - AI Lead Qualification + Database.json](<Task%206%20-%20AI%20Lead%20Qualification%20+%20Database.json>)
-  SQL used → [save-lead-analysis.sql](save-lead-analysis.sql)
-  n8n workflow screenshot (canvas view) → [screenshots/](screenshots/)
-  Sample execution screenshots (one qualified, one not) → [screenshots/](screenshots/)
-  PostgreSQL/Supabase table screenshot → [screenshots/](screenshots/)
-  Slack notification screenshot → [screenshots/](screenshots/)

## 🖼️ Screenshots

All screenshots live in [`screenshots/`](screenshots/):

- **Workflow overview:** [`Task 6 - AI Lead Qualification + Database.png`](<screenshots/Task%206%20-%20AI%20Lead%20Qualification%20+%20Database.png>)
- **Automation steps:** [`Lead Analysis.png`](<screenshots/Lead%20Analysis.png>), [`Find or Create ID.png`](<screenshots/Find%20or%20Create%20ID.png>), [`Save Lead + Analysis.png`](<screenshots/Save%20Lead%20+%20Analysis.png>), [`Score Greater than 70.png`](<screenshots/Score%20Greater%20than%2070.png>), [`Slack Notification n8n.png`](<screenshots/Slack%20Notification%20n8n.png>)
- **Database record:** [`Analysis Record to Supabase.png`](<screenshots/Analysis%20Record%20to%20Supabase.png>)
- **Slack notification:**  [`Slack Notification Recieved.png`](<screenshots/Slack%20Notification%20Recieved.png>)
