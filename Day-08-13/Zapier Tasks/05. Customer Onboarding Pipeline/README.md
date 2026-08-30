# Task 5 — Customer Onboarding Pipeline

## 📋 Task Description

Form + Kanban board that moves a new client through onboarding stages, firing a distinct automation each time the card changes stage, with a stale-card alert for clients stuck too long.

- **Form fields:** Client Name, Company, Email, Service, Project Budget, Start Date, Account Manager, Requirements
- **Kanban stages:** New Lead → Qualified → Proposal → Won → Onboarding → In Progress → Completed
- **Intake automation:** form submitted → create customer record → create card in New Lead → assign account manager → send confirmation email → add due date
- **Stage-change automations:** New Lead→Qualified ("Lead qualified"), Qualified→Proposal (create proposal task), Won→Onboarding (onboarding email), Onboarding→In Progress (notify PM), In Progress→Completed (completion email)
- **Stale-card alert:** card stuck in Qualified >3 days → notify account manager (Delay step or scheduled check)

## ⚙️ How It Works

**Zap 1 — Intake** (triggered by form submission):

1. **Form Submission Created** (Zapier Forms) — "Customer Intake Form", collects Client Name, Company, Email, Service, Project Budget, Start Date, Requirements, and **Account Manager** (a dropdown the client/sales rep picks from directly — see the note on this in "Things worth checking" below).
2. **Compute Due Date** (Formatter by Zapier) — adds a fixed **14 days** to Start Date (verified: 08/25/26 → 09/08/26, 09/01/26 → 09/15/26, 09/20/26 → 10/04/26 — all exactly +14 days).
3. **Lookup Manager's Email** (Formatter by Zapier) — maps the selected Account Manager name to their email (e.g. Ayesha Khan → ayesha@company.com), likely via a Formatter Lookup Table keyed on the fixed dropdown options.
4. **Update Record** (Zapier Tables) — writes the row into the **Customers** table with Stage defaulted to `New Lead`.
5. **Send Email** (Gmail) — sends "We've received your onboarding request" to the client, confirming their account manager, target start date, and projected (due) date.

**Zap 2 — Kanban stage-change automation** (triggered by a Stage field update on the Customers table):

1. **Updated Record** (Zapier Tables trigger) — fires whenever a card's Stage changes.
2. **Path — Split into paths**, one branch per relevant stage:
   - **Path 1 — Stage is Qualified:** sends the "lead qualified" outbound email, then **Delay by Zapier**, then re-runs **Find Records** + **Filter** ("continue only if Stage is [still] Qualified") before finally sending a **Stale Lead Notification to PM** — this re-check-before-alert pattern correctly avoids false-alarming on a card that already moved on.
   - **Path 2 — Proposal:** creates a row in a separate **Tasks** table ("Prepare proposal for {client} — {service}, budget {amount}", due-dated).
   - **Path 3 — Onboarding:** sends a "Welcome aboard" email to the customer, naming their assigned PM/account manager.
   - **Path 4 — Stage is In Progress:** emails the PM/account manager "Project Started: {client}-{company}-{service}" to notify them the project is now in progress.
   - **Path E — Completed:** emails the customer "Your project is complete 🎉".

## 🔧 Configuration

- **Due Date formula:** Start Date + 14 days (Formatter by Zapier, "Compute Due Date" step).
- **Manager email lookup:** Formatter step mapping the Account Manager dropdown value to a fixed email address (2 managers observed: Ayesha Khan / ayesha@company.com, Bilal Raza / bilal@company.com).
- **Stage-change trigger:** a single Zap triggered on **any** Customers-table record update, split via one **Path** step into 5 named branches (Qualified, Proposal, Onboarding, In Progress, Completed) — New Lead and Won have no branch (no action fires when a card first lands in New Lead via intake, or when it's marked Won).
- **Stale-card check:** implemented as **Delay by Zapier** (holds the Zap run for the configured period) → **Find Records** (re-query the same card) → **Filter** (only proceed if Stage is still Qualified) → **Email by Zapier** to the PM. This runs inline inside the same Zap run that sent the "lead qualified" email, rather than as a separate scheduled/polling Zap.
- **Tasks table:** separate from Customers — columns Task, Client, Due — populated only by the Proposal-stage action.

## 🧪 Test Input & Output

Actual verified data:

| Stage transition                               | Evidence                                                                                                                                                                                                                                                                                                                                                                            | Verified?                                                                                                                                                                                                                     |
| ---------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Form submitted → New Lead                     | 3 real clients captured (Ahmed Saddiqui/Siddiqui & Co, Imran Malik/Malik Traders, Sana Riaz/Riaz Textiles), each with computed Due Date and looked-up Manager Email in the Customers table; confirmation email actually received in Gmail ("We've received your onboarding request", real account manager + dates)                                                                  | ✅ Real, end-to-end                                                                                                                                                                                                           |
| Qualified → Proposal                          | Tasks table has real created rows: "Prepare proposal for Sana Riaz — AI Automation, budget 6000" and "...for Ahmed Saddiqui — Consulting, budget 1500"; Customers table Stage updated to`Proposal` for both                                                                                                                                                                     | ✅ Real, end-to-end                                                                                                                                                                                                           |
| Onboarding → welcome email                    | "Welcome aboard, Sana Riaz!" actually delivered via Email by Zapier, naming PM Bilal Raza                                                                                                                                                                                                                                                                                           | ✅ Real, end-to-end                                                                                                                                                                                                           |
| New Lead → Qualified ("lead qualified" email) | Zap-editor**Test step** ran successfully (step 4, Path 1); no inbox screenshot exists because the Manager Email is a Formatter-assigned placeholder (e.g. ayesha@company.com), not a real mailbox                                                                                                                                                                             | ⚠️ Configured and step-tested successfully in the editor, not proven to fire from a real drag-triggered stage change — manager address isn't a real inbox, so delivery can't be screenshotted                              |
| Onboarding → In Progress (notify PM)          | Zap-editor**Test step** preview only: To bilal@company.com, "Project Started: Sana Riaz-Riaz Textiles-AI Automation"                                                                                                                                                                                                                                                          | ⚠️ Configured and step-tested successfully in the editor, not proven to fire from a real drag-triggered stage change with a real client/manager inbox                                                                       |
| In Progress → Completed (customer email)      | Zap-editor**Test step** preview only: To anila.toor@gmail.com (developer's own address, not a real client email), "Your project is complete 🎉"                                                                                                                                                                                                                               | ⚠️ Configured and step-tested successfully in the editor, not proven to fire from a real drag-triggered stage change with a real client/manager inbox                                                                       |
| Stale-card alert (>3 days in Qualified)        | Zap-editor**Test step** screen shows the exact content that would be forwarded to the PM (Subject: "Stale lead: Sana Riaz", Body: "Sana Riaz (Riaz Textiles) has been in Qualified for over 3 days. Please follow up.") — the test itself was skipped because, like the other manager-facing steps, PM Email is a Formatter-assigned placeholder address, not a real mailbox | ⚠️ Notification content confirmed correct via preview; the full Delay → re-check → notify chain has never fired end-to-end with a real elapsed delay, and there is no live PM inbox to confirm actual delivery either way |

## 🖼️ Screenshots

All screenshots live in [`screenshots/`](screenshots/):

- **Workflow:** [`Client Onboard Intake Automation Zap.png`](<Client%20Onboard%20Intake%20Automation%20Zap.png>), [`Kanban Stage Change Automation Zap.png`](<Kanban%20Stage%20Change%20Automation%20Zap.png>) (both in project root)
- **Form / Board:** [`Customer Intake Form.png`](<screenshots/Customer%20Intake%20Form.png>), [`Kanban View.png`](<screenshots/Kanban%20View.png>), [`Kanban Remaining Fields.png`](<screenshots/Kanban%20Remaining%20Fields.png>), [`Card Details.png`](<screenshots/Card%20Details.png>)
- **Tables:** [`Customer Table LHS.png`](<screenshots/Customer%20Table%20LHS.png>), [`Customer Table RHS.png`](<screenshots/Customer%20Table%20RHS.png>), [`Stage Change Update Customer Table.png`](<screenshots/Stage%20Change%20Update%20Customer%20Table.png>), [`Stage Change Update Task Table.png`](<screenshots/Stage%20Change%20Update%20Task%20Table.png>), [`Task Table Updated.png`](<screenshots/Task%20Table%20Updated.png>)
- **Test run:** [`Email to Client.png`](<screenshots/Email%20to%20Client.png>) (intake confirmation), [`Onboarding Email.png`](<screenshots/Onboarding%20Email.png>) (welcome email), [`In Progress Nitification to PM.png`](<screenshots/In%20Progress%20Nitification%20to%20PM.png>), [`Project Completion Email to Customer.png`](<screenshots/Project%20Completion%20Email%20to%20Customer.png>), [`Stale Lead Notification.png`](<screenshots/Stale%20Lead%20Notification.png>), [`Stage Change in Kanban.png`](<screenshots/Stage%20Change%20in%20Kanban.png>)
