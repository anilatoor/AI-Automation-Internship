# Day 06 — Airtable + n8n Automation

## What this folder covers

Day 06 introduced **Airtable** as the central database for an AI agency, then connected it to n8n so record changes trigger real notifications — the same trigger → transform → notify/record pattern from Day 05, but with Airtable as the shared source of truth instead of Notion, and full CRUD (not just reads) driving the automations.

## 🎓 What I Learned

### 🔹 Airtable Fundamentals

Set up an Airtable account and learned the core building blocks — **Base, Table, Record, Field, View, Interface, Automation** — then created the `MATalogics AI Operations Base` to hold all of it. Full concept notes with pointers into this build: [AirTable/Learning Notes.md](<AirTable/Learning Notes.md>).

### 🔹 Database Design

Designed 5 tables against a fixed schema — **Clients, Projects, Leads, AI Agents, Interns** — each with the exact fields specified in the task brief, seeded with realistic sample records so the automations below had real data to fire on. Most tables also got a second view (Kanban, Calendar, Gallery) to show the same records can be re-sliced without duplicating data.

### 🔹 Airtable + n8n Integration

Connected Airtable to n8n with a **Personal Access Token** credential and exercised all 4 CRUD operations — **Create, Search, Update, Delete** — in one chained test workflow before building anything that depended on them.

### 🔹 Automation Workflows

Built and ran 5 real, trigger-based workflows end-to-end (not just wired — each one fired for real):

1. New Lead → Slack alert
2. New Client → generate Client ID → notify team on Slack
3. Project Status changed → Gmail notification
4. AI Agent Status updated → notify Ops on Slack
5. Task completed → n8n recalculates Performance Score → writes it back to Airtable

### 🔹 Practical Assignment

Combining the 5 tables and 5 workflows into one base is, in effect, a working **Client Management + Lead Management + Project Tracker + Internship Tracker + AI Agent Tracker** system — the "AI Agency Database" the task asked for.

---

## 🛠️ What I Built

### Airtable base — `MATalogics AI Operations Base`

| Table     | Fields                                                             | Views                        |
| --------- | ------------------------------------------------------------------ | ---------------------------- |
| Clients   | Client ID, Name, Company, Email, Status                            | Grid, Kanban (by Status)     |
| Projects  | Project Name, Assigned To, Deadline, Status                        | Grid, Calendar (by Deadline) |
| Leads     | Lead Name, Source, Contact Number, Interested Service              | Grid, Form                   |
| AI Agents | Agent Name, Type, Deployment Status, Last Updated                  | Grid, Gallery                |
| Interns   | Intern Name, Department, Task Count, Completed*, Performance Score | Grid, Kanban (by Department) |

\* `Completed` is an extra field beyond the original spec, added so Workflow 5 can compute `Performance Score = round(Completed ÷ Task Count × 100)`.

### n8n workflows

| Workflow                 | Trigger → Action                                                   | Evidence                                                                                                                                                                                                  |
| ------------------------ | ------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1 — Lead Management     | New Lead in Airtable → Slack`#leads`                             | [WF1 Lead Management.png](<n8n/Screenshots/WF1 Lead Management.png>), [New Lead Notification.png](<Slack/New Lead Notification.png>)                                                                        |
| 2 — Client Onboarding   | New Client record → generate Client ID → Slack`#client-updates` | [WF2 Client Onboarding.png](<n8n/Screenshots/WF2 Client Onboarding.png>), [Generate Client ID.png](<n8n/Screenshots/Generate Client ID.png>), [New Client Onboarding.png](<Slack/New Client Onboarding.png>) |
| 3 — Project Tracking    | Project Status changed → Gmail notification                        | [WF3 Project Tracking.png](<n8n/Screenshots/WF3 Project Tracking.png>), [Project Update Email.png](<Gmail/Project Update Email.png>)                                                                        |
| 4 — AI Agent Monitoring | Agent Status updated → Slack`#ai-agents-updates`                 | [AI Agent Monitoring.png](<n8n/Screenshots/AI Agent Monitoring.png>), [Agent Status update.png](<Slack/Agent Status update.png>)                                                                            |
| 5 — Internship Tracker  | Task completed → recalculate & write back Performance Score        | [WF5 Internship Tracker.png](<n8n/Screenshots/WF5 Internship Tracker.png>)                                                                                                                                 |

All 5 live in one export, [MATalogics AI Operations Base — All Automation Flows.json](<n8n/Workflow JSON/MATalogics AI Operations Base — All Automation Flows.json>), and the workflow is active (each trigger polls its table on a schedule rather than needing a manual run).

### CRUD test

[Airtable CRUD Test.json](<n8n/Workflow JSON/Airtable CRUD Test.json>) — Create → Search → Update → Delete, chained in one manual-trigger workflow against the Interns table. Results: [Test Create Record.png](<n8n/Screenshots/Test Create Record.png>), [Test Search Record.png](<n8n/Screenshots/Test Search Record.png>), [Test Update Record.png](<n8n/Screenshots/Test Update Record.png>), [Test Delete Record.png](<n8n/Screenshots/Test Delete Record.png>).

### Folder structure

```text
Day-06/
├── Airtable Day 6.pdf            — task brief
├── AirTable/                     — base + all 5 tables, alternate views, CRUD results, Learning Notes.md
├── Slack/                        — Lead/Client/Agent notification screenshots
├── Gmail/                        — Project status email
└── n8n/
    ├── Screenshots/                — credential, CRUD test run, all 5 workflow canvases
    └── Workflow JSON/
        ├── Airtable CRUD Test.json
        └── MATalogics AI Operations Base — All Automation Flows.json
```

---

## 🌟 The Takeaway

Day 05 connected two tools through n8n; Day 06 made the database itself the point — Airtable isn't just a place to store rows, it's the trigger surface every workflow reacts to. The CRUD test mattered more than it looked: proving Create/Search/Update/Delete all worked against the base *before* building 5 workflows on top of it meant every downstream failure was actually a workflow logic problem, not a credential or field-mapping problem. And Workflow 5 — recompute a score and write it back into the same table that triggered the workflow — was the first time this internship's automations closed a loop instead of just reacting outward to Slack or email.

**In short:**

* 🗂️ Airtable is the shared source of truth; n8n is what makes it *react*
* 🔑 A Personal Access Token + verified CRUD came first, workflows came second
* 🔁 5 workflows, one pattern: poll a table → transform → notify or write back
* 📊 Multiple views (Grid/Kanban/Calendar/Gallery/Form) prove the same records serve different audiences without duplicating data

Six days in, the base isn't a demo dataset anymore — it's a small, working operations system for an AI agency. Onward to Day 07. 🚀
