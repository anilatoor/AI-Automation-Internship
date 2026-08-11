# Day 05 — Slack & Notion + n8n Automation

## What this folder covers

Day 05 moved from building automations against a single tool into **connecting them together**: Slack for team notifications, Notion as the structured data source, and n8n as the glue running three real triggers — a new task, a new client, and a new form submission — each ending in a Slack message or a live Notion record.

## 🎓 What I Learned

### 🔹 Slack Fundamentals

Set up a workspace (`MATalogics`) and learned the core building blocks: **channels, threads, DMs, @mentions, file sharing, and per-channel notification settings** — then created a Slack App, generated a bot token (`xoxb-...`), and scoped it with `chat:write`, `channels:manage`, and `channels:read` so it could post messages and create channels from n8n.

### 🔹 Notion Fundamentals

Learned **pages, blocks, databases, database properties, and views**, then built a practice workspace with three databases: a **Tasks** DB (Title, Status, Priority, Date and Person properties), a **Clients** DB, and a **Students** DB — each shared explicitly with an internal Notion integration, since Notion won't expose a database to an integration it hasn't been shared with.

### 🔹 Connecting n8n to Slack & Notion

Added Slack and Notion credentials in n8n, understood **authentication, node scopes, and how to select a channel or database dynamically**, and tested each connection standalone (send a manual message, list a database) before wiring them into a full workflow.

### 🔹 Mapping Dynamic Data

Every Slack message and Notion page in these workflows is built from the trigger's actual output fields (task name, assignee, due date, client name, form answers) — not hardcoded text — so the automation reflects whatever data actually comes in.

### 🔹 Error Handling & Observability

Deliberately broke a workflow (bad Slack channel name) and routed the failure to `#workflow-errors`, confirming that a broken automation announces itself instead of failing silently.

---

## 🛠️ What I Built

### Slack workspace

Channels: `#n8n-alerts`, `#client-updates`, `#internship`, `#workflow-errors`, `#project-status` (plus `#social`, `#all-matalogics`). Bot invited to the channels it posts/creates in.

### Notion workspace

**Page 1 → Tasks** database with the required properties (Task Name / Status / Priority / Due Date / Assignee) and 6 sample tasks, plus **Clients** and **Students** databases feeding Workflows 2 and 3.

### n8n workflows

| Workflow                  | Trigger → Action                                                                         | File                                                                                                                                                                                                                |
| ------------------------- | ----------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1 — Task Creation        | New page in Notion Tasks DB → Slack message to`#n8n-alerts`                            | [Workflow 1 - New Task to Slack Alert.json](<n8n%20Workflows/Workflow%201%20-%20New%20Task%20to%20Slack%20Alert.json>)                                                                                               |
| 2 — Client Onboarding    | New page in Notion Clients DB → create a Slack channel → announce in`#client-updates` | [Workflow 2- Client Onboarding.json](<n8n%20Workflows/Workflow%202-%20Client%20Onboarding.json>) (+ [error-handling variant](<n8n%20Workflows/Workflow%202-%20Client%20Onboarding%20(with%20Error%20Handling).json>)) |
| 3 — Student Registration | Google Form → Sheets row added → Notion Students DB page created                        | [Workflow 3 - n8n + Notion (Student Registrations).json](<n8n%20Workflows/Workflow%203%20-%20n8n%20%2B%20Notion%20(Student%20Registrations).json>)                                                                   |

All three were run end-to-end (not just built) — each node shows a successful test execution on its canvas.

### Screenshots

```text
Screenshots/
├── Slack/     — workspace, channels, thread, DM, channel-created, error alerts, manual status update
├── Notion/    — workspace, Tasks DB (table + board view), Clients/Students DBs, page created by Workflow 3
├── n8n/       — canvas for all three workflows
└── Google Sheet Students Registerations.png
```

For anyone new to either tool, [Learning Notes/Slack.md](<Learning%20Notes/Slack.md>) and [Learning Notes/Notion.md](<Learning%20Notes/Notion.md>) walk through the core concepts (workspace, channels, threads, databases, views, integrations, etc.) with links to where each one shows up in this build.

---

## 🌟 The Takeaway

Days 1–4 each proved a tool could do one job well. Day 05 was about **wiring jobs together** — a Notion edit becomes a Slack message, a form submission becomes a database row, three separate apps behaving like one system. The unglamorous part turned out to matter most: sharing a database with the integration before it can be seen, scoping a bot token to exactly what it needs, and mapping *live* fields instead of typing sample text into a node. And routing a deliberate failure to `#workflow-errors` was the clearest reminder yet that "it worked once" and "it's production-ready" aren't the same claim — an automation should tell you when it breaks, not just when it works.

**In short:**

* 💬 Slack channels + bot scopes turn n8n into a system that can talk to a team
* 🗂️ Notion databases are the shared source of truth every workflow reads from or writes to
* 🔗 Three different triggers (Notion page added, Notion page added, Sheets row added) all resolve to the same pattern: watch → transform → notify/record
* 🚨 Error routing closes the loop — a silent failure is worse than no automation at all

Five days in, the automations are starting to look less like demos and more like small pieces of real infrastructure. Onward to Day 06. 🚀
