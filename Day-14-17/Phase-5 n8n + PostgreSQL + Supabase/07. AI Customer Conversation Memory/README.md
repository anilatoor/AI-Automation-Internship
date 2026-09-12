# Task 7 — AI Customer Conversation Memory

## Scenario

Customer support AI agent that remembers previous conversations, using PostgreSQL/Supabase as persistent memory — not the model's own context window.

## Schema

The full hierarchy from the Phase 4 Task 3 paper design — see [../Database Schema/phase5-schema.sql](<../Database Schema/phase5-schema.sql>):

```text
Customers ──has──▶ Leads ──has──▶ Conversations ──contain──▶ Messages
```

Every conversation hangs off a **lead**, not directly off the customer — so a chat message from a known customer still needs (or reuses) a lead record before a conversation can be found-or-created. `messages` columns are`sender`, `message`, `sent_at`.

## Workflow

```text
Webhook → Find or Create Customer → Find or Create Lead → Find or Create Conversation
  → Retrieve Previous Messages → AI Agent (generate response)
  → Save Customer Message → Save AI Message → Sync AI Message to Supabase → Respond
```

- `Find or Create Customer`, `Find or Create Lead`, and `Find or Create Conversation` are each a single `WITH existing … inserted …` statement, so repeat calls from the same customer never create duplicates.
- `Retrieve Previous Messages` uses `alwaysOutputData: true` — a brand-new conversation legitimately has 0 previous rows, and without this the whole execution would stop instead of continuing to generate a first reply.
- The AI Agent node has `executeOnce: true` — the history node can emit multiple rows (one per past message), and the agent already aggregates all of them itself, so it must run exactly once per request, not once per row.
- The system prompt explicitly forbids claiming to remember anything not present in the DB-retrieved history passed to it that turn.

## Requirements

The AI should be able to remember: customer name, previous questions, previous answers, previous conversation — using PostgreSQL/Supabase as the persistent database (not just temporary conversation memory).

## What's built

- Workflow: [Task 7 - AI Customer Conversation Memory.json](<Task%207%20-%20AI%20Customer%20Conversation%20Memory.json>) — import into n8n and connect your own Postgres, Supabase, and OpenAI credentials. No live credentials or secrets are embedded in the file.
- SQL reference: [conversation-memory.sql](conversation-memory.sql) — matches the workflow's Postgres nodes step-by-step.

## How to test (two separate webhook calls, same name + email)

`POST <your-n8n-instance>/webhook/conversation-memory`

Turn 1:

```json
{ "name": "Bilal Ahmed", "email": "bilal.ahmed@example.com", "phone": "03451234567", "message": "My name is Bilal and I'm having trouble logging in." }
```

Turn 2 (separate request, same identity, no other context):

```json
{ "name": "Bilal Ahmed", "email": "bilal.ahmed@example.com", "phone": "03451234567", "message": "What is my name?" }
```

Expect turn 2's reply to correctly say "Bilal" — proving the answer came from
the database, not the model's own memory (each webhook call is an independent
execution). Confirm in the DB: one `customers` row, one `leads` row, one
`conversations` row, and 4 `messages` rows in order (customer/ai/customer/ai).

## Deliverables

-  Exported n8n workflow JSON → [Task 7 - AI Customer Conversation Memory.json](<Task%207%20-%20AI%20Customer%20Conversation%20Memory.json>)
-  SQL used → [conversation-memory.sql](conversation-memory.sql)
-  n8n workflow screenshot (canvas view) → [screenshots/](screenshots/)
-  Both test-turn request/response screenshots → [screenshots/](screenshots/)
-  PostgreSQL/Supabase table screenshots (`customers`, `leads`, `conversations`, `messages`) → [screenshots/](screenshots/)

## 🖼️ Screenshots

All screenshots live in [`screenshots/`](screenshots/):

- **Workflow overview:** [`Task 7 - AI Customer Conversation Memory.png`](<screenshots/Task%207%20-%20AI%20Customer%20Conversation%20Memory.png>), [`AI Conversation Memory.png`](<screenshots/AI%20Conversation%20Memory.png>)
- **Find-or-create chain:** [`Find or Create Customer.png`](<screenshots/Find%20or%20Create%20Customer.png>), [`Customer Found.png`](<screenshots/Customer%20Found.png>), [`Find or Create Lead.png`](<screenshots/Find%20or%20Create%20Lead.png>), [`Lead Found.png`](<screenshots/Lead%20Found.png>), [`Find or Create Conversation.png`](<screenshots/Find%20or%20Create%20Conversation.png>)
- **Turn 1 (no prior history):** [`Retrieve Previous Messages.png`](<screenshots/Retrieve%20Previous%20Messages.png>), [`AI Agent Response.png`](<screenshots/AI%20Agent%20Response.png>), [`Save Customer Message.png`](<screenshots/Save%20Customer%20Message.png>), [`Save AI Message.png`](<screenshots/Save%20AI%20Message.png>)
- **Turn 2 (recall test — "What is my name?"):** [`Message with same Name.png`](<screenshots/Message%20with%20same%20Name.png>), [`Previous Chat Retrieved.png`](<screenshots/Previous%20Chat%20Retrieved.png>), [`2nd Customer Message Saved.png`](<screenshots/2nd%20Customer%20Message%20Saved.png>), [`2nd AI Response.png`](<screenshots/2nd%20AI%20Response.png>)
- **Database record:** [`Messages Table Record.png`](<screenshots/Messages%20Table%20Record.png>)
