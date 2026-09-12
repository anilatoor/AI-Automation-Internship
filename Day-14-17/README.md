# 🗄️ Databases + n8n — Completed Task Evidence

Four phases of the Database Task are built, tested, and documented here: PostgreSQL/pgAdmin setup, core SQL (tables, CRUD, analytics), two database designs done on paper, and a live n8n + PostgreSQL + Supabase AI automation build (Tasks 5–9). Every task folder follows the same structure so the evidence is easy to review.

## 📁 Structure

```text
Day-14-17/
├── Phase-2 Install and Setup/
├── Phase-3 SQL Tasks/
│   ├── 01. Lead Management Database/
│   └── 02. SQL Sales Analytics/
├── Phase-4 Database Design on Paper/
│   ├── 03. AI Automation CRM/
│   └── 04. AI Customer Support Knowledge System/
└── Phase-5 n8n + PostgreSQL + Supabase/
    ├── Database Schema/
    │   └── phase5-schema.sql
    ├── 05. Lead Capture Automation/
    ├── 06. AI Lead Qualification + Database/
    ├── 07. AI Customer Conversation Memory/
    ├── 08. Natural Language to SQL AI Agent/
    └── 09. Automated Database Reporting/
```

Each task folder holds:

| Item                                      | Where                                                                                   |
| ----------------------------------------- | --------------------------------------------------------------------------------------- |
| Task description / scenario               | `README.md`                                                                           |
| How the automation/design works           | `README.md`                                                                           |
| Configuration / schema details            | `README.md`                                                                           |
| Verified test input & output              | `README.md`                                                                           |
| Workflow, table, and test-run screenshots | flat in`screenshots/`, linked and captioned from the README's *Screenshots* section |

## ✅ Phase Index

| # | Phase                       | Focus                                                                                | Folder                                                                                 | Status |
| - | --------------------------- | ------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------- | ------ |
| 2 | Install & Setup             | PostgreSQL + pgAdmin installed, server/database connection verified                  | [Phase-2 Install and Setup](<Phase-2%20Install%20and%20Setup/>)                         | ☑     |
| 3 | SQL Tasks                   | `leads` table (CRUD) + sales analytics (`COUNT`/`GROUP BY`/`ORDER BY`)       | [Phase-3 SQL Tasks](<Phase-3%20SQL%20Tasks/>)                                           | ☑     |
| 4 | Database Design on Paper    | Two hand-drawn ER designs — AI Automation CRM, AI Customer Support Knowledge System | [Phase-4 Database Design on Paper](<Phase-4%20Database%20Design%20on%20Paper/>)         | ☑     |
| 5 | n8n + PostgreSQL + Supabase | 5 AI automation workflows, live on a real n8n instance + Supabase Postgres           | [Phase-5 n8n + PostgreSQL + Supabase](<Phase-5%20n8n%20+%20PostgreSQL%20+%20Supabase/>) | ☑     |

### Phase 3 — SQL Tasks

| # | Task                            | Folder                                                                                     |
| - | ------------------------------- | ------------------------------------------------------------------------------------------ |
| 1 | Lead Management Database (CRUD) | [01. Lead Management Database](<Phase-3%20SQL%20Tasks/01.%20Lead%20Management%20Database/>) |
| 2 | SQL Sales Analytics             | [02. SQL Sales Analytics](<Phase-3%20SQL%20Tasks/02.%20SQL%20Sales%20Analytics/>)           |

### Phase 4 — Database Design on Paper

| # | Task                                 | Folder                                                                                                                                    |
| - | ------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------- |
| 3 | AI Automation CRM                    | [03. AI Automation CRM](<Phase-4%20Database%20Design%20on%20Paper/03.%20AI%20Automation%20CRM/>)                                           |
| 4 | AI Customer Support Knowledge System | [04. AI Customer Support Knowledge System](<Phase-4%20Database%20Design%20on%20Paper/04.%20AI%20Customer%20Support%20Knowledge%20System/>) |

### Phase 5 — n8n + PostgreSQL + Supabase

| # | Task                             | Folder                                                                                                                                   |
| - | -------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| 5 | Lead Capture Automation          | [05. Lead Capture Automation](<Phase-5%20n8n%20+%20PostgreSQL%20+%20Supabase/05.%20Lead%20Capture%20Automation/>)                         |
| 6 | AI Lead Qualification + Database | [06. AI Lead Qualification + Database](<Phase-5%20n8n%20+%20PostgreSQL%20+%20Supabase/06.%20AI%20Lead%20Qualification%20+%20Database/>)   |
| 7 | AI Customer Conversation Memory  | [07. AI Customer Conversation Memory](<Phase-5%20n8n%20+%20PostgreSQL%20+%20Supabase/07.%20AI%20Customer%20Conversation%20Memory/>)       |
| 8 | Natural Language to SQL AI Agent | [08. Natural Language to SQL AI Agent](<Phase-5%20n8n%20+%20PostgreSQL%20+%20Supabase/08.%20Natural%20Language%20to%20SQL%20AI%20Agent/>) |
| 9 | Automated Database Reporting     | [09. Automated Database Reporting](<Phase-5%20n8n%20+%20PostgreSQL%20+%20Supabase/09.%20Automated%20Database%20Reporting/>)               |

Every task is complete: each README's schema/workflow/test sections hold real, verified results, and the linked `screenshots/` folder backs those results up.

## 🖼️ Screenshots

Screenshots were named descriptively and kept flat inside each task's `screenshots/` folder (e.g. `Find or Create Customer.png`, `Slack Notification Recieved.png`, `Daily Report Email.png`), then linked and grouped by section (Workflow overview / Automation steps / Database records / Test runs) from each README's own *Screenshots* heading.

## 🧩 Phase 5 — n8n build details

Phase 5's five workflows (Tasks 5–9) run on n8n against a Supabase PostgreSQL database, using OpenAI, Slack, and Gmail credentials. Each exported workflow JSON is a clean template — no live credentials or secrets are embedded; connect your own before running.

- **Schema**: `Customers → Leads → Conversations → Messages`, matching [Task 3&#39;s hand-drawn ERD](<Phase-4%20Database%20Design%20on%20Paper/03.%20AI%20Automation%20CRM/>) — one shared schema script (below) used by all five tasks.
- **Task 7's memory test**: two independent webhook calls ("My name is Bilal…" then "What is my name?") — the second reply recalls the name from the database.
- **Slack + email delivery**: Task 6's qualified-lead alert and Task 9's daily report post to Slack via the native Slack node; Task 9 also emails the report.
- **Task 8's safety guardrail**: read-only queries only, enforced by a regex allow-list and a `phase5_readonly` (`SELECT`-only) database role.

See [Database Schema/phase5-schema.sql](<Phase-5%20n8n%20+%20PostgreSQL%20+%20Supabase/Database%20Schema/phase5-schema.sql>) for the one-shot schema script shared by all five tasks.
