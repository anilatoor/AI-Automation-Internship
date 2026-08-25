# Task 1 — Lead Intake System


## 📋 Task Description

Zapier Form + Zapier Table system that captures sales leads, scores and prioritizes them automatically, and notifies the sales team of hot leads.

- **Live Form:** [Sales Lead Intake](https://cmt2w033m00c9hstxgs81b0aa.zapier.app/new-form)
- **Form:** "Sales Lead Intake" — Full Name, Email, Phone, Company, Industry, Budget, Lead Source, Requirement, Urgency
- **Table:** "Leads" — Lead ID, Name, Email, Phone, Company, Industry, Budget, Lead Source, Requirement, Urgency, Lead Score, Status, Created At
- **Automation:** form submitted → generate unique Lead ID → calculate Lead Score (Urgency + Budget + Source weighting) → classify priority (Hot ≥70 / Warm 40-69 / Cold <40) → store record → notify sales team if Hot

## ⚙️ How It Works

1. **Trigger** — Zapier Forms fires on new "Sales Lead Intake" submission.
2. **Increment or Decrement** (Zapier Tables/Storage) — bumps a running counter used for the Lead ID sequence.
3. **Generate Lead ID** (Code by Zapier) — builds `LEAD-${currentYear}-${seq}`, where `seq` is the counter value zero-padded to 3 digits (e.g. `LEAD-2026-001`).
4. **Calculate Score** (Code by Zapier) — sums weighted points from Urgency, Budget, and Lead Source (see Configuration below).
5. **Classify Priority** (Code by Zapier) — converts the numeric score into Hot / Warm / Cold using the thresholds below.
6. **Create Record** (Zapier Tables) — writes the full lead, including Lead ID, Score, Priority-derived Status, and Created At, into the **Leads** table.
7. **Filter by Zapier** — only lets records with Priority = Hot continue.
8. **Send Channel Message** (Slack) — posts a "🔥 Hot Lead Alert" to the `#priority-leads` channel with the lead's details and Lead ID.
9. **Send Outbound Email** (Email by Zapier) — in parallel with the Slack step, emails the sales team a "New Hot Lead Captured" summary.

Warm and Cold leads are stored in the table but stop at the Filter step — no Slack or email fires for them.

## 🔧 Configuration

- **Lead ID format:** `LEAD-{year}-{counter}`, counter from a Zapier Storage "Increment Value" step, zero-padded to 3 digits, assembled in a Code by Zapier step.
- **Scoring weights** (Code by Zapier):
  - **Urgency:**
    - High +30
    - Medium +20
    - Low +10
  - **Budget:**
    - $5,000 +30
    - $1,000–$5,000 +20
    - <$1,000 +10
  - **Source:**
    - Referral +20
    - LinkedIn +15 (other sources contribute 0)
- **Priority thresholds:**
  - Score ≥70 → **Hot**
  - Score 40–69 → **Warm**
  - <40 → **Cold**.
- **Notification channel:** Hot leads only — Slack message to `#priority-leads` **and** an email (Email by Zapier) to the sales team, both gated behind the same Filter step.

## 🧪 Test Input & Output

Actual verified run:

| Field         | Value                                                                                                                                                                    |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Input         | Ahmed Khan\| TechVision Solutions \| $8,000 budget \| LinkedIn \| High urgency                                                                                           |
| Output        |  `Lead ID: LEAD-2026-001, Score: 75 (30 urgency + 30 budget + 15 source), Priority: Hot, Status: New`                                                                  |
| Confirmed     | Slack`#priority-leads` alert received; "New Hot Lead Captured" email received                                                                                          |
| Also verified | Warm-tier leads (score 40 and 50, from a $2,500/Website/Medium-urgency case and a $1,000/Referral/Low-urgency case) stored correctly with**no** notification fired |

## 🖼️ Screenshots

All screenshots live in [`screenshots/`](screenshots/):

- **Workflow overview:** [`Lead Capture System - v6.png`](<Lead%20Capture%20System%20-%20v6.png>) (project root, not in `screenshots/`)
- **Automation steps:** [`Generating Lead ID.png`](<screenshots/Generating%20Lead%20ID.png>), [`Lead Score Calculation.png`](<screenshots/Lead%20Score%20Calculation.png>), [`Classifying Priority.png`](<screenshots/Classifying%20Priority.png>)
- **Form / Table:** [`Lead Capture Form.png`](<screenshots/Lead%20Capture%20Form.png>), [`Leads Table Left.png`](<screenshots/Leads%20Table%20Left.png>), [`Leads Table Right.png`](<screenshots/Leads%20Table%20Right.png>)
- **Test run / notifications:** [`Slack Notification.png`](<screenshots/Slack%20Notification.png>), [`Email Notification.png`](<screenshots/Email%20Notification.png>)
