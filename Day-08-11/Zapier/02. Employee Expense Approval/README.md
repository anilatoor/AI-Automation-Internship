# Task 2 — Employee Expense Approval


## 📋 Task Description

Zapier Form + Zapier Table system that routes employee expense requests for approval based on risk level, with a hard override when a receipt is missing.

- **Form:** "Employee Expense Portal" — Employee Name, Employee Email, Department, Expense Type, Amount, Expense Date, Description, Receipt Upload, Manager Email
- **Table:** "Expense Requests" — Request ID, Employee, Department, Type, Amount, Description, Receipt, Manager, Approval Status, Risk Level, Submitted At
- **Automation:** form submitted → generate Request ID → store request → determine Risk Level from Amount → route by risk (Low = auto-approve, Medium = manager email, High = manager + finance email) → **Receipt check overrides routing**: missing receipt → Status = "Receipt Required"

## ⚙️ How It Works

1. **Trigger** — Zapier Forms fires on new "Employee Expense Portal" submission.
2. **Increment Value** (Storage by Zapier) — bumps a running counter used for the Request ID sequence.
3. **ID, Risk and Status** (Code by Zapier) — one step that generates the Request ID, computes Risk Level from Amount, and sets the initial Approval Status (`Approved` for Low risk, `Pending Approval` for Medium/High).
4. **Create Record** (Zapier Tables) — writes the full request into the **Expense Requests** table.
5. **Path — Split into paths**, evaluated as three branches:
   - **Receipt Missing** → Email by Zapier sends "Action needed: Receipt required for expense {ID}" directly to the **employee**, with a link back to the form to resubmit. This branch fires whenever the Receipt field is empty, regardless of computed risk — it overrides the risk-based routing below.
   - **Approval Required (Medium Risk)** → Email by Zapier sends an approval-request email to the **Manager** only.
   - **Approval Required (High Risk)** → Email by Zapier sends an approval-request email to the **Manager** (To) with **Finance** copied (Cc) — the email text explicitly states "Finance has been copied per policy for amounts over $500."
6. Low-risk requests with a receipt attached don't match any Path condition, so they're stored as `Approved` with no notification — the auto-approval.

No formal in-flow Approval step (approve/reject buttons) was added — the emails are informational only; approval currently happens outside the Zap (updating the table's Approval Status manually).

## 🔧 Configuration

- **Request ID format:** `EXP-####`, sequential and zero-padded to 4 digits (Storage by Zapier counter + Code by Zapier), e.g. `EXP-0001`, `EXP-0002`.
- **Risk Level thresholds:**
  - Amount **<$100 → Low**
  - Amount **$100–$500 → Medium**
  - Amount **>$500 → High** (confirmed by the High-risk email copy referencing the "$500" policy line)
- **Notification recipients per risk level:**
  - Low → none (auto-approved)
  - Medium → Manager email field only
  - High → Manager email field (To) + a fixed Finance address (Cc) — Finance is hardcoded in the Zap, not a form field
- **Receipt-missing override:** enforced by Path branch ordering/condition — "Receipt Missing" is its own top-level branch alongside the risk branches, so an empty Receipt field always routes there instead of the Medium/High approval branches, no matter the Amount.

## 🧪 Test Input & Output

Actual verified runs:

| Scenario              | Input                                            | Output                                                                                                                              |
| --------------------- | ------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------- |
| High risk + receipt   | Usman Tariq, Equipment, $1,250, receipt attached |  `EXP-0001, Risk: High, Status: Pending Approval` — email sent to Manager + Finance (Cc), noting the >$500 policy                |
| Medium risk + receipt | Bilal Khan, Travel, $320, receipt attached       | `EXP-0002, Risk: Medium, Status: Pending Approval` — email sent to Manager only                                                  |
| Low risk + receipt    | Sarah Ahmed, Food, $45, receipt attached         | `EXP-0003, Risk: Low, Status: Approved` (auto) — no notification sent                                                            |
| Missing receipt       | Equipment expense, $1,250, no receipt attached   | `Status: Receipt Required` — employee emailed directly with a resubmission link, confirming the override beats High-risk routing |

> ⚠️ Note: the missing-receipt test used a separate run (its own Request ID, not one of the three rows currently in the Expense Requests table) — all three persisted table rows now have a receipt attached, so there's no "Receipt Required" row currently visible in the table screenshots. The behavior is proven by the email screenshot, but if you want the table itself to show a `Receipt Required` row as evidence, submit one more no-receipt test and leave it in the table.
>
> The roadmap's literal suggested test (`Software | $750 | No receipt` → `EXP-0045, High, Receipt Required`) was substituted with an equivalent Equipment/$1,250 case — behavior matches the spec either way.

## 🖼️ Screenshots

All screenshots live in [`screenshots/`](screenshots/):

- **Workflow overview:** [`Expense Management System Zap.png`](<Expense%20Management%20System%20Zap.png>) (project root, not in `screenshots/`)
- **Form:** [`Employee Expense Portal Form.png`](<screenshots/Employee%20Expense%20Portal%20Form.png>), [`Form Configuration.png`](<screenshots/Form%20Configuration.png>), [`Form Test.png`](<screenshots/Form%20Test.png>)
- **Table:** [`Expense Requests LHS.png`](<screenshots/Expense%20Requests%20LHS.png>), [`Expense Requests RHS.png`](<screenshots/Expense%20Requests%20RHS.png>)
- **Test run / notifications:** [`High Risk Approval Email.png`](<screenshots/High%20Risk%20Approval%20Email.png>), [`High Risk CC to Finance.png`](<screenshots/High%20Risk%20CC%20to%20Finance.png>), [`Medium Risk Approval Email.png`](<screenshots/Medium%20Risk%20Approval%20Email.png>), [`Missing Reciept Provision Email.png`](<screenshots/Missing%20Reciept%20Provision%20Email.png>)
- **Dummy test receipts (for re-testing):** [`techmart_receipt.pdf`](techmart_receipt.pdf), [`flight_receipt.pdf`](flight_receipt.pdf), [`lunch_receipt.pdf`](lunch_receipt.pdf)
