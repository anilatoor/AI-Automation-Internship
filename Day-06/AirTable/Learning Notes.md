# Learning Notes — Airtable

Core concepts, with a pointer to where each one actually shows up in the **MATalogics AI Operations Base** built for Day 06.

## What is Airtable

A cloud-based database and workflow platform — think **Google Sheets + Database + Forms + Views + Automation**. Same row/column feel as a spreadsheet, but each column has a real data type, rows are relational records, and the same data can be viewed multiple ways without duplicating it.

## Core Terminology

| Term                 | Meaning                                                                                    | Where it shows up in this build                                                                                                                                                                      |
| -------------------- | ------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Base**       | The overall database/project                                                               | `MATalogics AI Operations Base` — [AI Agents Table.png](<AI Agents Table.png>) header shows the base name on every screenshot                                                                      |
| **Table**      | Like a database table                                                                      | 5 tables:`Clients`, `Projects`, `Leads`, `AI Agents`, `Interns`                                                                                                                            |
| **Record**     | One row/item                                                                               | E.g. one lead ("Hassan Raza") in[Leads Table.png](<Leads Table.png>)                                                                                                                                  |
| **Field**      | A column/property, with a real type (single line text, email, single select, number, date) | `Status` and `Deployment Status` are Single select fields (colored pills); `Task Count`/`Performance Score` are Number fields; `Email` is an Email field with a clickable `mailto:` link |
| **View**       | A different way of displaying the same records                                             | Grid (default, spreadsheet-like), Kanban (cards grouped by a select field), Calendar (by date field), Gallery (visual cards), Form (data-entry)                                                      |
| **Interface**  | A custom dashboard/UI built on top of the base data                                        | Not built for this task — base + views were sufficient for the required workflows                                                                                                                   |
| **Automation** | Trigger + actions running*inside* Airtable                                               | Not used directly — automation logic lives in n8n instead, reading/writing the base over the API                                                                                                    |

## Views used per table

| Table     | Views built                  | Screenshot                                                            |
| --------- | ---------------------------- | --------------------------------------------------------------------- |
| Clients   | Grid, Kanban (by Status)     | [Client Table Kanban View.png](<Client Table Kanban View.png>)         |
| Projects  | Grid, Calendar (by Deadline) | [Projects Table Calander View.png](<Projects Table Calander View.png>) |
| AI Agents | Grid, Gallery                | [AI Agents Table Gallery View.png](<AI Agents Table Gallery View.png>) |
| Interns   | Grid, Kanban (by Department) | [Interns Table Kan ban View.png](<Interns Table Kan ban View.png>)     |
| Leads     | Grid, Form                   | [Leads Table.png](<Leads Table.png>)                                   |

Grid view is the spreadsheet-style default everyone starts from; the second view per table proves the same records can be re-sliced (by status, by date, visually, as cards) without copying data anywhere.

## Why Airtable is useful for automation

Airtable acts as the **shared source of truth** that an automation tool like n8n polls or writes to — instead of hardcoding data into a workflow, the workflow watches a table and reacts to real record changes:

```text
Website Form → Airtable → n8n → Slack / Gmail
```

That's exactly the shape of all 5 workflows built for this task: an Airtable Trigger node polls a table (`Created`, `Last Modified`, or a specific field like `Last Updated`), and downstream nodes turn that record into a Slack message, a Gmail notification, or a write-back to another field.

## Airtable ↔ n8n — CRUD

Connected via a **Personal Access Token** credential ([Air Table Credentials.png](<../n8n/Screenshots/Air Table Credentials.png>)) and exercised all 4 operations in one chained test workflow ([Airtable CRUD Test.json](<../n8n/Workflow JSON/Airtable CRUD Test.json>)):

1. **Create Record** — add a new Intern row
2. **Search Record** — look it up by its Airtable record ID (`RECORD_ID()` formula)
3. **Update Record** — change its Performance Score
4. **Delete Record** — remove the test row

Results: [CURD Create Record Result.png](<CURD Create Record Result.png>), [CURD Updata Result.png](<CURD Updata Result.png>), [CURD Delete Result.png](<CURD Delete Result.png>).

## Learning Resources

Videos assigned in the Day 06 task brief, watched in full before building the base:

* **Beginners** — [Airtable Tutorial for Beginners](https://www.youtube.com/watch?v=9EI_negwSYw)
* **Crash Course** — [Airtable Crash Course](https://www.youtube.com/watch?v=lBsGOWV216Y)

Other references used while building:

* [Airtable Support — Guides](https://support.airtable.com/) — field types, views, and Personal Access Token scopes
* [n8n Docs — Airtable node](https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.airtable/) — Create/Search/Update/Delete operations and the Airtable Trigger node used across all 5 workflows

## Key takeaway

Airtable's job in this build isn't to *do* the automation — it's to be the structured, shared place both humans (via Grid/Kanban/Calendar/Gallery views) and n8n (via the API) read from and write to, so a form submission, a status change, or a completed task becomes a real trigger instead of a manual step.
