# Notion — The Client Pages

Airtable is the permanent record; Notion is where the team actually works day to day. So every new client also gets a proper page in Notion — something a person can open and read, not just a spreadsheet row.

---

## Building the database

Create a page called **`Vapi Client Projects`** in your Notion workspace, and inside it add a database named **`Clients Projects`**. Putting the database inside a page (rather than a bare database) gives it a home in the sidebar, with room to add notes above the table later if the team wants.

Each client becomes one page in that database. The page **title is the client's company name**, with the rest of the details as properties:

| Property     | Type         | Notes                                                                                                    |
| ------------ | ------------ | -------------------------------------------------------------------------------------------------------- |
| Name (title) | Title        | The company name, e.g. "BrightCart Retail"                                                               |
| Client       | Text         | The contact's name, e.g. "Sara Khan"                                                                     |
| Service      | Text         | The AI's`service_category` output                                                                      |
| Budget       | Number       | Notion's number property can show a currency format; pick PKR if offered, otherwise plain number is fine |
| Priority     | Select       | Options`HIGH` / `MEDIUM` / `LOW`, colored red/yellow/green so the split is obvious at a glance     |
| Summary      | Text         | The AI's`summary` output                                                                               |
| Next Action  | Text         | The AI's`next_action` output                                                                           |
| Status       | Select       | Options`New` / `In Progress` / `Contacted` / `Closed`, starting at `New`                       |
| Email        | Email        | The system already has it from the call, so no reason to drop it                                         |
| Created      | Created time | Notion fills this in automatically — nothing to write                                                   |

Use the **Table** view as the default (easiest to read and screenshot). A Board view grouped by Priority is a nice optional second view.

Test it the same way as Airtable: type in one page by hand for the standard test client, confirm every property accepts the value you expect, then delete it before the real records go in.

---

## The step that silently breaks everything if you skip it

**Notion integrations don't get access to your databases automatically.** You have to explicitly share each database with your integration, or every API call from n8n fails with a permissions error that gives no hint the sharing step was the cause. This was one of the trickiest parts to diagnose during development, so do it carefully:

1. Go to **[notion.so/my-integrations](https://www.notion.so/my-integrations)** and create a new internal integration. Copy its **Internal Integration Secret** (a long token).
2. Open the **`Clients` database** in Notion (open it as its own full page, not the page that contains it). Click the **"…"** menu → **Connections** → add your integration.
3. Only after step 2 will n8n's calls against this database succeed.

> **Finding the right database ID (a related gotcha):** n8n needs to point at the *database*, not the page that holds it. Open the database as its own page and copy its link — a database link has `?v=` in it. A page link does not. Using the page link by mistake causes a "resource could not be found" error even when everything else is correct.

---

## Connecting n8n to Notion

In n8n, create a **Notion API** credential and paste in the Internal Integration Secret from step 1. The Notion node can then see and write to the `Clients` database — but *only* because you shared it with that same integration in step 2.
