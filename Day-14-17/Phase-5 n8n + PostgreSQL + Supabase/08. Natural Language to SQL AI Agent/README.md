# Task 8 — Natural Language → SQL AI Agent

## Scenario

Business owner asks questions about the database in plain English, e.g.:

- "How many leads did we receive this month?"
- "Show me the top 5 leads."
- "How many qualified leads came from Facebook?"
- "What's our average lead score?"

## Schema

Reads from `leads` and `customers` — see [../Database Schema/phase5-schema.sql](<../Database Schema/phase5-schema.sql>). `leads` no longer carries `name`/`email`/`phone`/`company` directly, so any question needing those must join `customers` on `leads.customer_id = customers.id`— the agent's system prompt documents both tables and this join explicitly.

## Workflow

```text
Webhook (question) → AI Agent (generate SQL) → Validate read-only (Code node)
  → If safe → Execute Query (read-only DB role) → AI Agent (human-readable answer) → Respond
           → (unsafe) → Respond 400 "blocked", DB never touched
```

## Requirements

Agent must generate SQL for at least: `SELECT`, `WHERE`, `ORDER BY`, `COUNT`, `AVG`, `GROUP BY`

## ⚠️ Important — safety constraint

The AI must be restricted to **safe/read-only queries**.

- ✅ Allowed: `SELECT` (including joins between `leads` and `customers`)
- ❌ Not allowed: `DROP TABLE`, `DELETE`, `TRUNCATE`, `UPDATE`, `INSERT`, `ALTER` (or any other write/DDL statement)

## How the guardrail is enforced (two layers)

1. **Regex/allow-list check** — the "Validate SQL is Read-Only" Code node requires the generated query to start with `SELECT` and rejects it if it contains `drop|delete|truncate|update|insert|alter|grant|revoke` anywhere, before it ever reaches Postgres.
2. **Read-only DB role** — the Postgres credential used by the "Execute Query" node connects as a `phase5_readonly` role (`GRANT SELECT` only, see the schema file's Task 8 guardrail section), so even a guardrail bypass fails at the database level.

## What's built

- Workflow: [Task 8 - Natural Language to SQL AI Agent.json](<Task%208%20-%20Natural%20Language%20to%20SQL%20AI%20Agent.json>) — import into n8n and connect your own OpenAI credential and a **read-only** Postgres credential (`phase5_readonly` role, see the schema file). No live credentials or secrets are embedded in the file.
- Test bank: [nl-to-sql-test-bank.sql](nl-to-sql-test-bank.sql) — known-correct query shapes to diff the agent's generated SQL against.

## How to test

`POST <your-n8n-instance>/webhook/ask-database` — run this **after** submitting a few leads via Task 5/6, so there's data to query.

```json
{ "question": "How many leads do we have in total?" }
```

Other good questions to try:

- `"Show me the top 5 leads by score"`
- `"What are the names and companies of our qualified leads?"` — exercises the `leads` ⋈ `customers` join
- `"How many qualified leads came from LinkedIn?"`
- `"What's our average lead score?"`

Guardrail check (should return `400` and never touch the DB):

```json
{ "question": "Delete all the leads from the database" }
```

## Deliverables

-  Exported n8n workflow JSON (requires a read-only DB role when imported) → [Task 8 - Natural Language to SQL AI Agent.json](<Task%208%20-%20Natural%20Language%20to%20SQL%20AI%20Agent.json>)
-  SQL generated/used (test bank) → [nl-to-sql-test-bank.sql](nl-to-sql-test-bank.sql)
-  n8n workflow screenshot (canvas view) → [screenshots/](screenshots/)
-  Sample execution screenshots (multiple example questions + the blocked destructive one) → [screenshots/](screenshots/)
-  Guardrail proof — unsafe question correctly blocked before reaching the database → [screenshots/](screenshots/)

## 🖼️ Screenshots

All screenshots live in [`screenshots/`](screenshots/):

- **Workflow overview:** [`Task 8 - Natural Language to SQL AI Agent.png`](<screenshots/Task%208%20-%20Natural%20Language%20to%20SQL%20AI%20Agent.png>)
- **Automation steps:** [`AI Agent Generated SQL.png`](<screenshots/AI%20Agent%20Generated%20SQL.png>), [`SQL Validation.png`](<screenshots/SQL%20Validation.png>), [`Query Executed.png`](<screenshots/Query%20Executed.png>), [`Human Readable Response.png`](<screenshots/Human%20Readable%20Response.png>)
- **Second test question:** [`Test 2.png`](<screenshots/Test%202.png>), [`Response 2.png`](<screenshots/Response%202.png>)
- **Guardrail (unsafe question blocked):** [`Unsafe Question.png`](<screenshots/Unsafe%20Question.png>), [`Safety Check.png`](<screenshots/Safety%20Check.png>), [`Blocked Response.png`](<screenshots/Blocked%20Response.png>)
