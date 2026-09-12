# Task 9 — Automated Database Reporting

## Scenario

Automated daily sales/lead report sent to the manager every morning.

## Schema

Reads from `leads` joined to `customers` — see [../Database Schema/phase5-schema.sql](<../Database Schema/phase5-schema.sql>).
The "top 5 leads" query needs the join because `leads` no longer carries a`name` column (that moved to `customers`).

## Workflow

```text
Schedule Trigger (8AM daily) → Query Headline Metrics → Query Top Lead Source → Query Top 5 Leads
  → Combine Metrics → AI Agent (business summary) → Send Report to Slack → Email Report to Manager
```

## Steps

1. Query PostgreSQL for headline metrics, top lead source, and top 5 leads
2. Combine the three results into one object
3. Send the combined data to an AI model
4. Generate a plain-English business summary
5. Send the report to Slack and by email

## Report must contain

Total Leads · New Leads Today · Qualified Leads · Converted Leads · Average Lead Score ·
Top Lead Source · Top 5 Leads (with name, via the `customers` join) · Conversion Rate

## Example AI output

```text
📊 Daily Lead Report
────────────────────
Total Leads: 47
Qualified: 18
Converted: 6
Conversion Rate: 12.7%
Top Source: LinkedIn

💡 Observation:
LinkedIn generated fewer leads than the website,
but produced the highest percentage of qualified leads.
```

## What's built

- Workflow: [Task 9 - Automated Database Reporting.json](<Task%209%20-%20Automated%20Database%20Reporting.json>) — import into n8n and connect your own Postgres, OpenAI, Slack, and Gmail credentials; the schedule trigger runs daily at `0 8 * * *`. No live credentials or secrets are embedded in the file.
- SQL: [daily-report-metrics.sql](daily-report-metrics.sql) — the exact three queries the workflow runs.

## How to test

This one is schedule-triggered, not a webhook — it has no request payload.


To see it run without waiting for 8 AM:

1. Submit a couple of leads via Task 5/6 first, so there's data to report on.
2. Open the workflow in the n8n editor and use "Execute workflow" / "Test workflow" to fire it manually — it will read whatever's currently in the DB, post to Slack, and send the manager email for real.

## Deliverables

-  Exported n8n workflow JSON, scheduled for its daily 8 AM run → [Task 9 - Automated Database Reporting.json](<Task%209%20-%20Automated%20Database%20Reporting.json>)
-  SQL used → [daily-report-metrics.sql](daily-report-metrics.sql)
-  n8n workflow screenshot (canvas view) → [screenshots/](screenshots/)
-  Sample execution / generated report screenshot → [screenshots/](screenshots/)
-  Slack + email delivery screenshots → [screenshots/](screenshots/)

## 🖼️ Screenshots

All screenshots live in [`screenshots/`](screenshots/):

- **Delivered report:** [`Daily Report Slack.png`](<screenshots/Daily%20Report%20Slack.png>), [`Daily Report Email.png`](<screenshots/Daily%20Report%20Email.png>)
