# Airtable — The Database

Airtable is where every client permanently lives. Notion and Slack are handy views onto a new lead, but Airtable is the actual record — the filing cabinet the whole system writes to.

---

## Building the table

Create a new Airtable base called **`Vapi AI Client Onboarding`**, and rename its default table to **`Client Onboarding`**. One table is all you need — a single client record doesn't link to anything else yet.

> **Why exact names matter:** n8n matches Airtable fields by their names. A typo doesn't throw a loud error — it quietly creates a blank column or skips the value. So get the field names right the first time.

Build the fields in the order the data arrives — the six things the voice agent collects first, then the fields the AI fills in, then bookkeeping last:

| Field       | Type                     | Notes                                                                                                                        |
| ----------- | ------------------------ | ---------------------------------------------------------------------------------------------------------------------------- |
| Client Name | Single line text         | The contact's name, e.g. "Sara Khan"                                                                                         |
| Company     | Single line text         | The company name, e.g. "BrightCart Retail"                                                                                   |
| Email       | Email                    | The system already has it from the call                                                                                      |
| Service     | Single line text         | The client's own words for what they asked for. Kept as plain text (not a dropdown) so a new phrasing never fails the write. |
| Description | Long text                | The project description, as the client gave it                                                                               |
| Budget      | Currency (PKR) or Number | Currency looks nicer in a screenshot; plain Number is safer if you'll ever do math on it                                     |
| Category    | Single line text         | The AI's`service_category` output                                                                                          |
| Priority    | Single select            | Options:`HIGH`, `MEDIUM`, `LOW`                                                                                        |
| Summary     | Long text                | The AI's`summary` output                                                                                                   |
| Status      | Single select            | Options:`New`, `In Progress`, `Contacted`, `Closed` — every record starts as `New`                                |
| Created At  | Date (with time)         | Or use Airtable's own "Created time" field type to fill it in automatically                                                  |

> **A gotcha with dropdown (Single select) fields:** create the options (`HIGH`/`MEDIUM`/`LOW`, and the Status options) *before* running the workflow. A dropdown with no options yet will reject a write until the option exists.

---

## Test it by hand first

Before pointing n8n at the table, add one row manually using the standard test client — Sara Khan from BrightCart Retail, a voice AI agent, budget PKR 600,000. Typing it in yourself confirms that Budget accepts a plain number and Email validates correctly, *before* a workflow ever has the chance to fail against it. Delete the test row (or keep it) once you've confirmed the shape works.

---

## Connecting n8n to Airtable

Airtable logs in with a **Personal Access Token**, not a username and password. Here's how to create one:

1. In Airtable, go to your **account icon → Developer Hub → Personal access tokens → Create new token**.
2. Give it these three permissions (scopes):
   - `data.records:read`
   - `data.records:write`
   - `schema.bases:read`
3. Under **Access**, explicitly add the `Vapi AI Client Onboarding` base.

> **Easy to miss:** Airtable tokens are granted per-base, not for your whole account. If you skip step 3, n8n's base picker will come up empty and you'll wonder why.

Finally, in n8n, create an **Airtable Personal Access Token** credential and paste the token in. The Airtable node can then pick your base and table from dropdown menus by name.
