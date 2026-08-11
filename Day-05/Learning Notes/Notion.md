# Notion — Notes & Reference

Learning notes from [Notion basics](https://www.youtube.com/watch?v=92LK3J0ZykA), [Notion expert workspace structure](https://www.youtube.com/watch?v=nUx2FMRuyGw), and the [official Notion docs](https://www.notion.com/help), written up for anyone reading this folder who hasn't used Notion before.

## What is Notion

An all-in-one workspace — think **Google Docs + Trello + Google Sheets + a Wiki** combined into one tool. The same building blocks (pages made of blocks) can become a document, a task board, or a structured database, all inside the same app.

## Core concepts

| Concept                       | What it means                                                                                                       | How it showed up here                                                                                                                                |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Pages**               | The basic unit of Notion — a document, a note, or a container for other pages/databases                            | `Page 1` is the container for the Tasks database                                                                                                   |
| **Blocks**              | Every piece of content on a page — text, headings, images, embeds, a database — is a block that can be rearranged | Used implicitly across all pages                                                                                                                     |
| **Databases**           | Structured, filterable, sortable collections of pages — like a spreadsheet where every row is also a full page     | Built**Tasks**, **Clients**, and **Students** databases                                                                            |
| **Database properties** | Typed columns on a database — Title, Status, Select, Date, Person, etc. — that define what data each row can hold | Tasks DB uses Title (Task Name), Status, Select (Priority), Date (Due Date), Person (Assignee)                                                       |
| **Views**               | The same underlying database shown differently — Table, Board, Calendar, Timeline — without duplicating data      | Added a**Board view** grouped by Status alongside the default Table view                                                                       |
| **Filters & sorting**   | Narrow or order a view by property values (e.g. only "In Progress" tasks, sorted by due date)                       | Used while inspecting the Tasks board view                                                                                                           |
| **Templates**           | Reusable page/database structures so new entries start pre-filled                                                   | Understood conceptually; not required for this task's databases                                                                                      |
| **Relations**           | Link a row in one database to a row in another (e.g. a task linked to a client)                                     | Read about via docs; Clients/Students kept as separate databases for this task                                                                       |
| **Collaboration**       | Multiple people editing/viewing the same workspace in real time                                                     | N/A for a solo practice workspace, but same mechanism integrations rely on                                                                           |
| **Integrations**        | An internal integration is a scoped API key that lets external tools (like n8n) read/write specific databases       | Created an integration at [notion.so/my-integrations](https://www.notion.so/my-integrations), then explicitly **shared** each database with it |
| **Notion AI**           | Built-in AI for summarizing, writing, and searching across the workspace                                            | Explored, not used in the automated workflows                                                                                                        |

## The #1 gotcha

Creating an integration does **not** give it access to anything by default. Every database (or its parent page) has to be shared with the integration explicitly via the `•••` menu → **Connections**. Skipping this is the most common reason an n8n Notion node returns an empty result or a 404.

## Applied in this project

- Practice workspace with **Page 1 → Tasks** database — [Notion Workspace.png](<../Screenshots/Notion/Notion%20Workspace.png>)
- Tasks DB with all 5 required properties (Task Name / Status / Priority / Due Date / Assignee) and 6 sample rows — [Tasks DB.png](<../Screenshots/Notion/Tasks%20DB.png>)
- Second view (Board, grouped by Status) to see how Views work — [Board View of Task DB.png](<../Screenshots/Notion/Board%20View%20of%20Task%20DB.png>)
- **Clients** and **Students** databases mirroring the same property pattern, feeding Workflows 2 and 3 — [Client + Student DB.png](<../Screenshots/Notion/Client%20%2B%20Student%20DB.png>)
- A 6th task added live to confirm Workflow 1 fires end-to-end — [New Task added.png](<../Screenshots/Notion/New%20Task%20added.png>)
- A Students DB page created automatically by Workflow 3 from a form submission — [Result n8n+notion WF.png](<../Screenshots/Notion/Result%20n8n%2Bnotion%20WF.png>)

## Further reading

- [notion.com/help](https://www.notion.com/help) — focus on Pages, Databases, Database properties, Views, Templates, Integrations
