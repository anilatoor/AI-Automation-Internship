# Task 9 — AI Operations Manager (Master Task) 🏆

## 📋 Task Description

Scheduled autonomous agent that reads Sales, Tasks, and Support data every morning, flags problems, recommends actions, delivers a report to a human, and takes a limited set of pre-approved actions itself.

- **Data layer:** Sales Table (Customer, Deal, Amount, Stage, Owner), Tasks Table (Task, Owner, Deadline, Status), Support Table (Customer, Issue, Priority, Status) — all seeded with realistic sample data
- **Agent:** runs every morning with read access to all three tables via tools (Sales Tool, Task Tool, Support Tool); analyzes stuck/overdue deals, overdue/overloaded task owners, unresolved critical tickets
- **Output — Daily Operations Report:** HIGH PRIORITY section + RECOMMENDED ACTIONS section, delivered via email/Slack
- **Autonomous actions:** full loop Analyze → Identify → Prioritize → Recommend → Take permitted action (e.g., auto-create a follow-up task for an overdue item)
- **Safety rules (hard constraints):** cannot delete records, cannot send external messages without approval, cannot change financial information — enforced via restricted tool access, not just instructions

**Architecture:** Schedule → AI Agent → Sales Tool + Task Tool + Support Tool → Reasoning → Action Tool → Report → Human

## ⚙️ How It Works

Built as a single **Zapier Agent** (the legacy Agents builder — see "⚠️ Limitations & Notes on AI by Zapier" below for why) that runs unattended every morning:

1. **Schedule trigger.** `Schedule by Zapier: Every Day` fires the agent once daily — no human starts the run.
2. **Read all three tables.** `Sales (AI OM)`, `Support (AI OM)`, and `Tasks (AI OM)` are wired in as **knowledge sources**, not one-off inputs — the agent re-syncs and re-reads all rows from all three on every run (confirmed in the run trace: "Retrieve all records from the Sales table with all columns" → "Retrieve all records from the Tasks table... Return every row without any filtering").
3. **Cross-reference & prioritize.** It analyzes the three tables together to find stuck/overdue deals, overloaded or overdue task owners, and unresolved critical support tickets, then writes a **HIGH PRIORITY** section (one specific, quantified line per issue) and a **RECOMMENDED ACTIONS** section (one specific action per issue) per its instructions.
4. **Take the one permitted action.** For the single most urgent stuck/overdue item, it calls its own `Zapier Tables: Create Record` tool — scoped to the `Tasks (AI OM)` table only — to create a follow-up task (`Task = "Follow up: [name]"`, `Owner = [item's owner]`, `Deadline = today`, `Status = Pending`), with an explicit instruction not to duplicate an existing matching follow-up. Anything that would require deleting, editing financial fields, or messaging externally is written into RECOMMENDED ACTIONS for a human instead of being performed.
5. **Deliver the report.** After producing it, the agent calls `Slack: Send Channel Message` to post the full Daily Operations Report into `#ops_daily`.
6. **Hard safety constraints, enforced by tool access.** The agent's tool list is deliberately just three tools: web search, `Zapier Tables: Create Record` (Tasks table only), and `Slack: Send Channel Message`. It has no delete tool, no update/edit tool on Sales or Support, and no way to message anyone outside `#ops_daily` — so "never delete records / never edit financial fields / never send external messages" is a structural limit, not just a prompt instruction the model could ignore.

## 🔧 Configuration

**Agent:** "Operation Manager" (Zapier Agents, v1 Published)

- **Trigger:** `Schedule by Zapier: Every Day`
- **Tools available:**
  - Default Tools: Visit Site & Web Search
  - `Zapier Tables: Create Record` → Table ID: `Tasks (AI OM)` **only** — this is the single permitted write action, and it can't touch Sales or Support
  - `Slack: Send Channel Message` → Channel: `ops_daily`
- **Knowledge sources** (full read access, re-synced each run):
  - Zapier Tables: `Sales (AI OM)`
  - Zapier Tables: `Support (AI OM)`
  - Zapier Tables: `Tasks (AI OM)`
- **`Tasks (AI OM)` is deliberately wired in twice, in two different roles** — as a knowledge source (read) and as the `Create Record` tool (write). That's not a config duplication: the knowledge-source copy lets the agent read existing tasks to judge Ahmad's workload and check whether a matching follow-up already exists (so it doesn't create a duplicate); the tool copy is the only thing that lets it actually insert a new row. Sales and Support are knowledge-source-only — the agent can read them but has no tool that can write to either, which is *why* it can only ever produce a follow-up task, never touch a deal stage or a ticket directly.
- **Delete/financial-edit exclusion:** enforced by tool selection — no delete tool and no update/edit tool exist on the agent at all, so those actions are physically unavailable rather than merely discouraged by instructions.
- **Output fields (from the AI step schema):** `Follow Up Task`, `Recommended Actions`, `High Priority Issues`, plus Zapier's own `_agent_meta` / execution ID for traceability.
- **Per-run limit:** Zapier caps each AI step at **75 tasks per run** — if a real deployment's Sales/Tasks/Support tables grew past that, the Zap would pause and require a manual restart (see Limitations).

## 🧪 Test Input & Output

Actual run captured below, seeded with exactly the roadmap's three problem scenarios:

| Seeded Data | Detail |
| --- | --- |
| Sales (AI OM) | Acme Corp — "Enterprise Platform Implementation", $12,000, Stage = Negotiation, Owner = Sarah Chen, unmoved since 08/22/26 |
| Tasks (AI OM) | 7 tasks, all owned by Ahmad, all Pending, deadlines 27–30 days in the past |
| Support (AI OM) | Acme Corp — "Payment system down", Priority = Critical, Status = Open |

| Step | What Happened |
| --- | --- |
| Morning run | Agent posted a **DAILY OPERATIONS REPORT** (Aug 30, 2026 – 06:46 UTC) to `#ops_daily` |
| HIGH PRIORITY flagged | ① $12,000 Acme Corp deal stuck in Negotiation for 8 days · ② 7 overdue tasks on Ahmad, 27–30 days overdue · ③ Ahmad overloaded (7 pending vs. threshold 3+) · ④ Critical support ticket still Open, not Resolved |
| RECOMMENDED ACTIONS | Follow up with Sarah Chen on the Acme deal · reassign 4–5 of Ahmad's tasks · prioritize Ahmad's 3 most-overdue items by name · escalate the critical ticket to senior support |
| Permitted action taken | Agent called `Zapier Tables: Create Record` on `Tasks (AI OM)` and created follow-up task(s) itself (e.g. "Follow up: Prepare monthly analytics report", Owner = Ahmad, Deadline = today, Status = Pending) — confirmed present in the table afterward, not just claimed in the report |
| Safety check | No delete/financial-edit tool is attached to the agent at all — verified directly from the "Tools this agent can use" list, not inferred from behavior |

## ⚠️ Limitations & Notes on AI by Zapier

- **Zapier is retiring the legacy "Agents" builder.** Opening the Agents dashboard now shows a "Moving to AI by Zapier" prompt telling you to rebuild in the standard Zap editor using the newer **AI by Zapier** step instead. This task was deliberately kept on the legacy Agents builder (chose "Continue") rather than migrated.
- **Why: AI by Zapier gates tools behind a paid plan.** Rebuilding this in a normal Zap's `AI by Zapier` action step, the Tools & Knowledge panel shows: *"Tools require Advanced or Premium tier."* On the free plan used here, that step can't be given the web-search tool or table read/write tools at all — it can only produce static text/output fields from a prompt, with no ability to actually query Sales/Tasks/Support or write a follow-up task. The legacy Agents product was the only way to get a free-tier agent real tool access (table reads, table writes, Slack) for this task.
- **75-task ceiling per AI step, per run.** Zapier hard-caps every AI step at 75 tasks per run; a Zap hitting that limit pauses and needs manual attention — a real operations table with more historical rows than that would need pagination/filtering the agent doesn't currently do.
- **Knowledge-source sync isn't a live query.** Captured directly in the `#ops_daily` history: an earlier run reported *"Tasks table data unavailable in current sync - unable to assess task overdue status and owner workload. Please verify Tasks (AI OM) table is properly connected and synced."* The three tables are knowledge sources synced into the agent on an interval (visible as "Synced 7/8/35/36 minutes ago" in the config), not queried fresh every second — so a report can go out with one table's data stale or temporarily missing if a sync lags behind a table edit.

## 🖼️ Screenshots

- [`Triger and Instructions.png`](<screenshots/Triger%20and%20Instructions.png>) — the daily schedule trigger and the agent's full instructions (High Priority / Recommended Actions format, permitted follow-up-task action, hard constraints)
- [`Agent KB and Tools.png`](<screenshots/Agent%20KB%20and%20Tools.png>) — tool list (Create Record scoped to Tasks only, Slack) and the three tables wired in as knowledge sources
- [`Agent Searching and Analysing.png`](<screenshots/Agent%20Searching%20and%20Analysing.png>) — live run trace showing the agent retrieving all records from Sales/Support/Tasks before analyzing
- [`Screenshot 2026-08-30 112856.png`](<screenshots/Screenshot%202026-08-30%20112856.png>) — `Tasks (AI OM)` table mid-run, showing the seeded overdue tasks plus the agent's own follow-up row
- [`Sales Table.png`](<screenshots/Sales%20Table.png>) / [`Support Table.png`](<screenshots/Support%20Table.png>) — seeded source data (stuck $12,000 deal; critical open support ticket)
- [`Tasks Created in Tasks Table.png`](<screenshots/Tasks%20Created%20in%20Tasks%20Table.png>) — `Tasks (AI OM)` after the run, with the agent's auto-created follow-up task rows visible alongside the original seeded tasks
- [`Slack Report Notification.png`](<screenshots/Slack%20Report%20Notification.png>) — the delivered Daily Operations Report in `#ops_daily`, including the prior run's knowledge-sync-warning note referenced above
- [`Limitation of AI by Zapier.png`](<screenshots/Limitation%20of%20AI%20by%20Zapier.png>) — the "AI by Zapier" step showing tools gated behind Advanced/Premium tier, plus the 75-tasks-per-run limit notice
- [`Continued with Agents.png`](<screenshots/Continued%20with%20Agents.png>) — the "Moving to AI by Zapier" migration prompt Zapier shows on the Agents dashboard
