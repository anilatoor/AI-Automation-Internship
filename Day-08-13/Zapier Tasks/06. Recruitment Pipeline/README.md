# Task 6 — Recruitment Pipeline

## 📋 Task Description

Application form + Kanban board that moves a candidate through the hiring pipeline, auto-prioritizes by experience, fires stage-change notifications (including rejection from any stage), and alerts on stalled candidates.

- **Form fields:** Candidate Name, Email, Phone, Position, Experience, Expected Salary, Resume (file), Portfolio, Availability
- **Kanban stages:** Applied → Screening → Technical Interview → HR Interview → Offer → Hired → Rejected
- **Intake automation:** application arrives → create candidate record → create card in Applied → assign priority by experience (5+ yrs = High, 2-4 yrs = Medium, <2 yrs = Low)
- **Stage-change automations:** Applied→Screening (screening email), Screening→Technical Interview (scheduling email), Technical→HR Interview (notify HR), Offer→Hired (congrats email), **any stage→Rejected** (rejection email, must work from every stage)
- **Stalled-candidate alert:** no update for 5 days → notify recruiter

This module uses **three separate Zaps**, a more decomposed design than Modules 5's two-Zap approach:

## ⚙️ How It Works

**Zap 1 — Candidate Experience Priority Router** (fires on new candidate record):

1. **New Record** (Zapier Tables trigger) — fires when a new row lands in the Candidates table (the form itself is connected directly to the table, so form→record creation isn't a separate visible Zap step).
2. **Path — Split into paths**, 3 branches by Experience:
   * **Path A (≥5 yrs)**
   * **Path B (2–4 yrs)**
   * **Path C (<2 yrs)**
3. Each branch just runs **Update Record** to set the Priority field (High / Medium / Low) — no notification, matching the roadmap (priority assignment only, no confirmation email required at intake).

**Zap 2 — Recruitment Stage-Change** (fires on any Stage field update):

1. **Updated Record in** (Zapier Tables trigger).
2. **Path — Split into paths**, 5 branches, one per condition (No branch for `Applied` — initial state, nothing to fire — or `Offer` — an intermediate stage with no required action ):
   * `Stage = Screening`
   * `Stage = Technical Interview`
   * `Stage = HR Interview`
   * `Stage = Hired`
   * `Stage = Rejected`.
3. Each branch: **Send Email** (Gmail, personalized per candidate) → **Update Record**.
4. Because the **Rejected** branch only checks the candidate's *current* stage (not what it came from), it fires identically no matter which stage the candidate was rejected from — correctly satisfying "any stage → Rejected" by construction, not by enumerating every possible prior stage.

**Zap 3 — Daily Stalled-Candidate Alert to Slack** (scheduled, not event-triggered — a materially different design from Module 5's inline Delay):

1. **Schedule by Zapier — Every Day** — a real recurring trigger, not a single-run Delay step.
2. **Find Records** (Zapier Tables) — pulls candidates (likely filtered to exclude Hired/Rejected).
3. **Filter by Zapier** — narrows further before the code step.
4. **Code by Zapier (Python)** — computes days-since-`Last Updated` per candidate and builds the alert list/message.
5. **Slack — Send Channel Message** to `#recruitment-alerts`, via a "Candidate Status Bot" app.

## 🔧 Configuration

- **Priority thresholds:** Experience ≥5 → High, 2–4 → Medium, <2 → Low.
- **Stage-change trigger:** generic "record updated" on the Candidates table, routed by a single Path step with 5 stage-value branches — same trigger/Path pattern as Module 5.
- **Notification channel per stage:** Gmail (not Email by Zapier), personalized with candidate name, position, and (for the HR-interview notice) priority.
- **Rejection path design:** single shared branch, condition = `Stage = Rejected` only — deliberately prior-stage-agnostic so it can't miss a rejection from an unanticipated stage.
- **Stalled-candidate check:** a genuinely scheduled **daily** Zap (Schedule by Zapier) that re-queries `Last Updated` timestamps each run, rather than a single Delay held open inside the triggering Zap run. This is architecturally more robust than Module 5's approach — it keeps working even if the Zap that created the record was long since finished, and it doesn't tie up a long-running task.

## 🧪 Test Input & Output

Actual verified data — all 5 stage-change emails are **real, delivered Gmail messages**, not just Zap-editor test previews (a stronger evidence bar than Module 5 met):

| Scenario                            | Input                                          | Output                                                                                                                                                                                      |
| ----------------------------------- | ---------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Priority — High                    | Anila Gulzar Toor, Developer, 7 yrs experience | Priority =`High` in Candidates table                                                                                                                                                      |
| Priority — Medium                  | Naveed Abbass, Developer, 3 yrs experience     | Priority =`Medium`                                                                                                                                                                        |
| Priority — Low                     | Anas Nawab, Developer, 1 yr experience         | Priority =`Low`                                                                                                                                                                           |
| Applied → Screening                | Anas Nawab moved to Screening                  | Real email received:*"Your application for Developer — next steps... move you to our screening stage"*                                                                                   |
| Screening → Technical Interview    | Naveed Abbass moved to Technical Interview     | Real email received:*"Technical Interview Scheduled - Developer"*                                                                                                                         |
| Technical Interview → HR Interview | Anila Gulzar Toor moved to HR Interview        | Real email received:*"HR Interview Scheduled - Anila Gulzar Toor"*, correctly includes her Priority (High)                                                                                |
| → Hired                            | Anila Gulzar Toor moved to Hired               | Real email received:*"Congratulations Anila Gulzar Toor - Job Offer"*                                                                                                                     |
| → Rejected                         | Anas Nawab rejected                            | Real email received:*"Application Status Update"* — rejection sent politely                                                                                                              |
| Board reflects real stage moves     | —                                             | `Stage Changes.png` shows Anas Nawab in Screening, Naveed Abbass in Technical Interview, Anila Gulzar Toor in HR Interview simultaneously on the live Kanban board (not just table edits) |
| Stalled-candidate alert             | Daily schedule fired                           | Real Slack message posted to`#recruitment-alerts`: "🚨 Stalled Candidate Alert (5+ Days) 🚨" — candidate bullet line came back empty; per the builder, the test ran same-day, before any candidate had genuinely gone 5+ days without an update, so there was no real stale row with populated data to interpolate — **not yet proven to fill in real data, see note below**                                                     |

## 🖼️ Screenshots

All screenshots live in [`screenshots/`](screenshots/):

- **Workflow:** [`Candidate Experience Priority Router Zap.png`](<Candidate%20Experience%20Priority%20Router%20Zap.png>), [`Recruitment Stage-Change Zap.png`](<Recruitment%20Stage-Change%20Zap.png>), [`Daily Stalled-Candidate Alert to Slack Zap.png`](<Daily%20Stalled-Candidate%20Alert%20to%20Slack%20Zap.png>) (all in project root)
- **Form / Board / Table:** [`Candidate Application Form.png`](<screenshots/Candidate%20Application%20Form.png>), [`Canban View LHS.png`](<screenshots/Canban%20View%20LHS.png>), [`Kanban View RHS.png`](<screenshots/Kanban%20View%20RHS.png>), [`Stage Changes.png`](<screenshots/Stage%20Changes.png>), [`Candidates Table LHS.png`](<screenshots/Candidates%20Table%20LHS.png>), [`Candidates Table RHS.png`](<screenshots/Candidates%20Table%20RHS.png>)
- **Test run — stage emails:** [`Stage Change - Screening.png`](<screenshots/Stage%20Change%20-%20Screening.png>), [`Stage Change - Technical Interview.png`](<screenshots/Stage%20Change%20-%20Technical%20Interview.png>), [`Stage Change - HR Interview.png`](<screenshots/Stage%20Change%20-%20HR%20Interview.png>), [`Stage Change - Hired.png`](<screenshots/Stage%20Change%20-%20Hired.png>), [`Stage Change - Rejected.png`](<screenshots/Stage%20Change%20-%20Rejected.png>)
- **Test run — stall alert:** [`Every Day Schedule for Stall Candidates.png`](<screenshots/Every%20Day%20Schedule%20for%20Stall%20Candidates.png>), [`Slack Alert for Stall Candidate.png`](<screenshots/Slack%20Alert%20for%20Stall%20Candidate.png>)
