# Task 5 — Lead Capture Automation

## Scenario

A website sends a new lead to n8n through a webhook.

## Schema

Uses the shared Phase 5 schema — see [../Database Schema/phase5-schema.sql](<../Database Schema/phase5-schema.sql>).
This task only touches `customers` and `leads`:

```text
Customers (name, email, phone, company) ──has──▶ Leads (customer_id, source, lead_status)
```

`leads` has no `name`/`email`/`phone`/`company`/`message` columns of its own — that data belongs to the customer. The webhook's free-text `message` field is used in-flow (available to whichever step needs it) but is not persisted anywhere,
matching the Phase 4 Task 3 paper design.

## Workflow

```text
Webhook → Validate Lead (Code) → If valid
  → Find or Create Customer (Postgres) → Insert Lead (Postgres) → Sync to Supabase → Respond success
  → (invalid) → Respond error
```

`Find or Create Customer` runs a single `WITH existing … inserted …` statement keyed on email, so the same customer is never duplicated across repeat submissions. `Insert Lead` then only needs `customer_id`, `source`, and `lead_status` — `leads.customer_id` is `NOT NULL`, so every captured lead must resolve to a customer first.

## Requirements

Webhook payload: `name`, `email` (required), `phone`, `company`, `message`, `source` (optional)

1. Receive the lead through a Webhook
2. Validate the required fields (`name`, `email`)
3. Find-or-create the customer, then insert the lead into PostgreSQL
4. Sync the lead in Supabase
5. Return a successful response
6. Handle invalid/missing data with a `400` and no DB write

## What's built

- Workflow: [Task 5 - Lead Capture Automation.json](<Task%205%20-%20Lead%20Capture%20Automation.json>)
- No standalone SQL file — the find-or-create-customer and insert-lead queries live directly in the workflow's Postgres nodes (see the JSON above).

## How to test

Valid lead:

```json
{
  "name": "Hassan Raza",
  "email": "hassan.raza@example.com",
  "phone": "03211234567",
  "company": "Raza Textiles",
  "message": "Looking for a demo of your platform.",
  "source": "Website"
}
```

Expect `200 {"status":"success","message":"Lead captured and stored in PostgreSQL + Supabase"}`,
a new row in `customers`, and a new row in `leads` with `customer_id` pointing at it.

Invalid lead (missing `email`):

```json
{ "name": "No Email Guy" }
```

Expect `400 {"status":"error","message":"Missing required fields: email"}` and no DB write.

## Deliverables

- Exported n8n workflow JSON → [Task 5 - Lead Capture Automation.json](<Task%205%20-%20Lead%20Capture%20Automation.json>)
- n8n workflow screenshot (canvas view) → [screenshots/](screenshots/)
- Sample execution screenshot (webhook request/response) → [screenshots/](screenshots/)
- PostgreSQL/Supabase table screenshot (`customers` + `leads` rows) → [screenshots/](screenshots/)

## 🖼️ Screenshots

All screenshots live in [`screenshots/`](screenshots/):

- **Workflow overview:** [`Task 5 - Lead Capture Automation.png`](<screenshots/Task%205%20-%20Lead%20Capture%20Automation.png>)
- **Automation steps:** [`Validate Lead.png`](<screenshots/Validate%20Lead.png>), [`Is Valid or Not.png`](<screenshots/Is%20Valid%20or%20Not.png>), [`Find Postgress Record.png`](<screenshots/Find%20Postgress%20Record.png>), [`Insert Record in Postgress.png`](<screenshots/Insert%20Record%20in%20Postgress.png>)
- **Database records:** [`Customers Table Record.png`](<screenshots/Customers%20Table%20Record.png>), [`Leads Table Record.png`](<screenshots/Leads%20Table%20Record.png>)
