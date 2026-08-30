# 📘 Phase 0 — Complete Setup Guide (Novice-Friendly)

> **Who this is for:** Someone who has never used Zapier before.
> **What you'll have by the end:** A working Zapier account with every product you need for Modules 1–9, all app connections ready, the core concepts understood, and one practice Zap built and tested.
>
> Follow this document **top to bottom, in order**. Tick the box when you finish the section.

---

## ☐ 0.1 Create / Log In to a Zapier Account

**What Zapier is:** Zapier is a website where you connect your apps (Gmail, Slack, Google Sheets, etc.) so they automatically pass information to each other. You don't write code - you click together "when THIS happens, do THAT" rules.

**Steps:**

1. Open your browser and go to **https://zapier.com**
2. Click **Sign up** (top-right corner).
3. Sign up using your **Google account** (recommended — this makes connecting Gmail and Google Sheets later a one-click job) or with an email + password.
4. Zapier will ask a few onboarding questions like "What's your role?" and "Which apps do you use?" — your answers don't lock anything in; they only personalize suggestions. Pick anything reasonable (e.g., role: *Student/Other*, apps: *Gmail, Slack, Google Sheets*).
5. You'll land on the **Zapier dashboard**. This is your home base.

**Know your plan limits:** The free plan gives you a limited number of **tasks per month** (a "task" = one action step successfully executed). That's roughly 100 tasks/month, which is enough for building and testing, but **don't run mass tests in loops** or you'll burn through it. Test with 1–2 submissions at a time. Zapier also offers a 14-day trial of paid features when you sign up — some features below (multi-step Zaps, Paths) may require trial/paid access, so it's smart to **do this internship task during your trial window**.

**✅ You're done when:** You can log in and see the Zapier dashboard with a left sidebar.

---

## ☐ 0.2 Verify Access to Required Zapier Products

Zapier isn't just one tool,  it's a **suite of products** that live under one account. You'll use six of them. Find each one now so nothing surprises you mid-module.

**Where to look:** On the Zapier dashboard, the **left sidebar** lists the products. If you don't see one, click the **grid/apps icon** or "More"  or use the direct URLs below.

### ☐ 0.2.1 Zaps (the workflow builder) — used in EVERY module

- **What it is:** The core of Zapier. A **Zap** is an automated workflow: *"When a form is submitted (Trigger), score the lead, save it to a table, and send a Slack message (Actions)."*
- **Where:** Left sidebar → **Zaps**, or https://zapier.com/app/zaps
- **Verify:** Click **+ Create → Zap** (or the "Create Zap" button). You should see a canvas with two boxes: **Trigger** and **Action**. Don't build anything yet just close it.

### ☐ 0.2.2 Forms (forms & pages)

- **What it is:** A no-code page builder. You create a web page containing a **form** (like Google Forms, but living inside Zapier), and submissions can directly trigger your Zaps and fill your Tables. This is how "Sales Lead Intake" and "Employee Expense Portal" get built.
- **Where:** Left sidebar → **Forms**, or [https://forms.zapier.com](https://forms.zapier.com)
- **Verify:** Click **+ Create**. You should be offered templates or a blank page with draggable components (Form, Text, Table, Kanban…). Close without saving.
- **Novice tip:** This product used to be called **"Interfaces"** — you'll still see that name in some older Zapier help articles and templates. It's the same product: a *Form page* is the whole page/app; a *Form field* is one component you place on it.

### ☐ 0.2.3 Tables (the database)

- **What it is:** A spreadsheet-like database built for automation (think: a simple Airtable inside Zapier). Every module stores its records here — Leads, Expense Requests, Support Tickets, Appointments, Candidates, Content Calendar, and more. Unlike Google Sheets, Tables plug natively into Zaps, Forms, and Agents.
- **Where:** Left sidebar → **Tables**, or https://tables.zapier.com
- **Verify:** Click **+ Create table**. You should see an empty grid where you can add **fields (columns)** with types like Text, Number, Dropdown, Date, and even a Button. Delete or leave the empty table.
- **Novice tip:** In Tables, a **record** = a row, a **field** = a column. Fields have *types* — choosing the right type (e.g., Dropdown for "Urgency") is what makes filtering and Kanban grouping work later.

### ☐ 0.2.4 Chatbots (AI bots)

- **What it is:** A builder for customer-facing AI chatbots. You give the bot **instructions** (its personality and rules) and a **knowledge source** (documents/text it's allowed to answer from), and it chats with users. Bots can hand off data to Zaps — that's how "talk to a human" creates a support ticket.
- **Where:** https://zapier.com/app/chatbots (or left sidebar → **Chatbots**)
- **Verify:** Click **+ Create Chatbot**. You should see settings for the bot's name, instructions/directive, knowledge sources, and an embedded chat preview. Close without finishing.

### ☐ 0.2.5 Kanban View

- **What it is:** A board of cards in columns (like Trello), where each column is a **stage** and dragging a card between columns can trigger automations. In Zapier this is a **view of a Table**: you create a Table with a "Stage" dropdown field, then display it as Kanban (in the Table itself or as a Kanban component on a Form page).
- **Where:** Add a **Kanban component** when editing a Form page.
- **Verify:** Open your test table from 0.2.3, add a Dropdown field called `Stage` with 2–3 options, then switch the view to Kanban, place the table on a Form page as a Kanban component. You should see columns matching your dropdown options.
- **Novice tip:** The Kanban columns come **from a Dropdown field's options**. So "New Lead → Qualified → Proposal…"

### ☐ 0.2.6 Agents

- **What it is:** The most advanced product. A Chatbot answers from a script/knowledge base; an **Agent** *reasons and decides*. You give it a mission in plain English plus a set of **tools** (e.g., "Search Tickets table", "Create Ticket", "Send Email"), and on each run it decides *which* tools to use and in what order. This is what "autonomous" means.
- **Where:** https://zapier.com/agents (or left sidebar → **Agents**)
- **Verify:** Click **+ New Agent**. You should see a place to write instructions and to add tools/data sources, plus trigger options (on-demand, scheduled, etc.). Close without saving.
- **Note:** Agents may have separate usage limits ("activities") from your regular task limit. Build carefully and test with single runs.

**✅ You're done when:** You can open all six products and recognize what each is for. If any product is missing or locked, note it — you may need the trial enabled (check https://zapier.com/pricing or your account's plan page).

---

## ☐ 0.3 Connect Required App Integrations

Zapier acts on your behalf inside other apps, so you must grant it access **once per app**. Doing this now means no login popups interrupting you mid-build later.

**Where:** Left sidebar → **Apps** (or https://zapier.com/app/connections). Click **+ Add connection**, search for the app, and follow the login prompts.

### ☐ 0.3.1 Gmail (or Email by Zapier)

- **Why you need it:** Confirmation emails (M1, M5), approval requests (M2), screening/offer/rejection emails (M6), agent emails (M7).
- **Steps:** Add connection → search **Gmail** → sign in with your Google account → click **Allow** on every permission screen (Zapier needs "send email" permission).
- **No Gmail / don't want to connect it?** Use **"Email by Zapier"** instead — it's built in, needs zero setup, and can send simple emails from a Zapier address.

### ☐ 0.3.2 Slack

- **Why you need it:** Sales-team notifications (M1), manager/finance alerts (M2), ticket notifications (M3), PM/recruiter notifications (M5, M6).
- **Steps (if you have no Slack workspace — most students):**
  1. Go to https://slack.com/get-started → **Create a Workspace** (free) → name it anything, e.g., `MAT-Internship`.
  2. Inside Slack, create a channel like `#sales-alerts`.
  3. Back in Zapier: Add connection → **Slack** → sign in → **Allow**.
- **Alternative:** If Slack feels like too much, every "notify on Slack" step in the modules can be swapped for an email step. The grading logic is the same: *high priority → someone gets pinged*.

### ☐ 0.3.3 Google Sheets (optional — for the warm-up Zap)

- **Why:** Only used in the practice Zap (section 0.5). Real modules use Zapier Tables instead.
- **Steps:** Add connection → **Google Sheets** → sign in → **Allow**.

**✅ You're done when:** The Apps/Connections page shows Gmail (or you've decided on Email by Zapier), Slack, and optionally Google Sheets — all without warning icons.

---

## ☐ 0.4 Review Core Concepts

Read this section slowly — these five concepts appear in **every single module**. Ten minutes here saves hours later.

### ☐ 0.4.1 Trigger + Actions = Zap

- **Trigger** = the event that starts the workflow. *"Form submitted"*, *"New record in Table"*, *"Every day at 8 AM"*. Every Zap has exactly **one** trigger.
- **Action** = a step that does something. *"Create record"*, *"Send email"*, *"Send Slack message"*. A Zap can chain **many** actions.
- **Task** = one action step that successfully runs. A 4-action Zap that fires once = 4 tasks against your monthly limit. (Triggers are free; actions cost tasks.)
- **Zap History** (left sidebar → Zap History) = the log of every run. When something doesn't work, this is **always** the first place to look — it shows each step, the exact data in and out, and error messages.

### ☐ 0.4.2 Data Mapping — static vs dynamic fields

When you configure an action (say, an email body), you type into fields. Two kinds of content:

- **Static data** — plain text you type, identical every run:
  `Course: Agentic AI` · `Batch: August 2026`
- **Dynamic data** — values pulled from earlier steps, different every run. You insert them by clicking into a field and picking from the dropdown of previous steps' outputs. They display as tags like:
  `{{First Name}}` · `{{Email}}` · `{{Phone}}`

**Example email body mixing both:**

> Hi `{{First Name}}`, thanks for registering for **Agentic AI — Batch: August 2026**. We'll contact you at `{{Phone}}`.

**Golden rule:** Never *type* `{{First Name}}` manually — always **select** it from the field picker so Zapier links it to the real data.

### ☐ 0.4.3 Filters vs Paths (the two ways to add logic)

- **Filter** = a gate. *"Only continue if Priority = Hot."* If the condition fails, the Zap **stops silently** (not an error). Use when there's one condition and one outcome.
- **Paths** = a fork. *"If Risk = Low do X; if Medium do Y; if High do Z."* Each branch has its own rule + its own actions. Use whenever there are **2+ different outcomes** — which is most of Modules 1–6.
- Find both in the Zap editor: add a step → choose **Filter** or **Paths** (built-in tools).

### ☐ 0.4.4 Formatter & Code (the two ways to transform data)

- **Formatter by Zapier** = built-in no-code transformations: change date formats ("tomorrow" → `2026-08-21`), split/capitalize text, do simple math, look up values in a small table. Great for one-off tweaks.
- **Code by Zapier** = a step where you paste a short JavaScript or Python snippet. Use it when logic has *multiple rules combined* — like Module 1's lead scoring (urgency points + budget points + source points → total → Hot/Warm/Cold). Chaining 6 Formatter steps for that is painful; 10 lines of code is clean. You don't need to be a programmer — the roadmap modules only need if/else arithmetic, and Zapier's built-in Copilot/AI can generate the snippet if you describe the rules.

### ☐ 0.4.5 Delay steps (the "wait" tool)

- **Delay by Zapier** pauses a Zap: *"Delay for 3 days"* or *"Delay until [date]"*.
- This powers the stale-card challenges: card enters "Qualified" → **Delay 3 days** → check: *is it still in Qualified?* → if yes, notify the account manager (M5). Same pattern with 5 days for M6.

**✅ You're done when:** You can answer these from memory: *What's the difference between a Filter and a Path? Where do you look when a Zap misbehaves? What costs a task?*

---

## ☐ 0.5 Warm-Up: Build Your First Zap (Google Forms → Google Sheets → Gmail)

This practice Zap exercises everything from 0.4 in ~20 minutes, with zero risk. It mirrors the exact pattern of Modules 1–2 (form in → store → notify out).

### Step A — Prepare the Google side (outside Zapier)

1. Go to https://forms.google.com → **Blank form** → title it `Course Registration`.
2. Add three short-answer questions: **First Name**, **Email**, **Phone**.
3. Go to the form's **Responses** tab → click the green **Sheets icon** → "Create a new spreadsheet". (This linked spreadsheet is what Zapier actually watches.)
4. Submit **one test response** yourself (Zapier needs at least one row of sample data to work with).

### Step B — Create the Zap

1. In Zapier: **+ Create → Zap**.
2. **Trigger:** search **Google Forms** → event: **New Form Response** → connect your Google account → select the `Course Registration` form → **Test trigger**. You should see your test submission's data appear. ✔️
3. **Action 1:** **Google Sheets** → **Create Spreadsheet Row** → pick (or create) a sheet with columns `Name / Email / Phone / Course / Batch` → map fields:
   - Name → *select* `First Name` from trigger data (dynamic)
   - Email → `Email` (dynamic) · Phone → `Phone` (dynamic)
   - Course → type `Agentic AI` (static) · Batch → type `August 2026` (static)
   - Click **Test step** → check the sheet — a new row should appear. ✔️
4. **Action 2:** **Gmail** (or Email by Zapier) → **Send Email**:
   - To → `{{Email}}` (dynamic, from trigger)
   - Subject → `Registration Confirmed — Agentic AI`
   - Body → `Hi {{First Name}}, you're registered for Agentic AI, Batch August 2026. We'll reach you at {{Phone}}.`
   - **Test step** → check your inbox. ✔️
5. Name the Zap `Warm-up: Forms → Sheets → Gmail` and click **Publish**.

### Step C — Prove it end-to-end

1. Submit a **fresh** response through the real Google Form (a different name/email).
2. Wait up to a couple of minutes (free-plan polling isn't instant).
3. Confirm: new row in the sheet **and** confirmation email received.
4. Open **Zap History** → find the run → click into it → look at each step's data-in/data-out. Get comfortable with this screen; it's your debugger for all 9 modules.
5. **Turn the Zap OFF** afterward (toggle on the Zaps page) so stray form submissions don't eat your task quota.

**✅ You're done when:** The end-to-end run succeeded and you inspected it in Zap History.
