# Task 3 — AI Customer Support Bot


## 📋 Task Description

Zapier Chatbot for fictional company **"CloudFlow"** that answers pricing/feature/account questions from a fixed knowledge base, refuses to invent information, and escalates to a human ticket when needed.

- **Knowledge base:** pricing (Starter $19/mo, Professional $49/mo, Business $149/mo), features, refund policy (14 days), support hours (Mon-Fri 9AM-6PM), troubleshooting
- **Guardrails:** no hallucinated answers; fallback message when info isn't in the KB
- **Escalation:** detects "talk to a human" phrasing → collects Name/Email/Problem → hands off to a Zap
- **Ticket automation:** chatbot handoff → generate Ticket ID → detect priority (Critical/High/Medium/Low) → store in "Support Tickets" table → notify team

## ⚙️ How It Works

1. **Chatbot** ("CloudFlow Support Bot", built on Zapier Chatbots) — a Directive instructs it to act as CloudFlow's official support assistant, scoped to exactly five responsibilities: pricing, features, account/billing, troubleshooting, and escalation to a human. It answers by grounding responses in an uploaded **Knowledge** file (`CloudFlow KB.pdf`) rather than the model's general knowledge.
2. **Guardrail** — the Directive instructs the bot not to invent information; when a question isn't covered by the KB it either declines/clarifies rather than hallucinating, or falls back to the configured message: *"I don't have enough information to answer that accurately. I can create a support request for you."*
3. **Escalation** — when the user asks to talk to a human, the bot collects **Name**, **Email**, and **Problem** conversationally, then writes them (plus an auto-generated **Chatbot Session ID**) into a Zapier Table, **"CloudFlow Support Bot Collected Data"**.
4. **Zap (table → ticket)** — a new row in that table triggers a Zap that:
   - Generates a **Ticket ID** in the format `CF-{YYYYMMDD}-{HHMMSS}` (date+time based, not a simple counter)
   - Detects **Priority** from the Problem text (keyword/intent rules — see Configuration)
   - Creates a record in the **Support Tickets** table with Status defaulted to `New`
   - Posts a "New Support Ticket Created" message to the **#support-tickets** Slack channel with Ticket ID, Customer, Email, Issue, Priority, Status, and Created timestamp

## 🔧 Configuration

- **Knowledge base:** `CloudFlow KB.pdf` (in this folder) — About CloudFlow, 3 pricing tiers with full feature breakdown, key features, account/billing (refund policy, cancellation, payment methods, password reset), support hours, and 6 troubleshooting scenarios (Flow not running, can't log in, connector expired, action didn't fire, task limit hit, app slow/won't load).
- **Fallback response text:** *"I don't have enough information to answer that accurately. I can create a support request for you."*
- **Escalation trigger phrase(s):** "I want to talk to a human" and similar phrasing; fields collected: Name, Email, Problem (+ auto Chatbot Session ID).
- **Priority-detection rules** (applied to the collected Problem text):
  - "System completely down" / whole platform affected → **Critical**
  - "Can't access account" → **High**
  - Normal how-to/account question → **Medium**
  - General feedback/request → **Low**
- **Ticket ID format:** `CF-YYYYMMDD-HHMMSS`.
- **Notification channel:** Slack `#support-tickets` channel, one message per new ticket, posted by a "Support Ticket Bot" Zapier app connection.

## 🧪 Test Input & Output

Actual verified runs:

| Scenario               | Input                                                                                                      | Output                                                                                                                                                                                                                                                                             |
| ---------------------- | ---------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Pricing question       | "How much does the Professional plan cost and what do I get with it?"                                      | Correct, fully-detailed answer sourced from the KB ($49/mo, 25 Flows, 10K tasks, 10 members, 150+ connectors incl. Salesforce/HubSpot/Shopify, multi-step + conditional logic, priority email support)                                                                             |
| Question outside KB    | "Does CloudFlow have a mobile app for iOS?"                                                                | Bot correctly answered "CloudFlow does not have an iOS mobile app. It runs in a web browser, with nothing to install." — grounded in the KB's "nothing to install" line rather than hallucinating, though it didn't use the literal configured fallback sentence (see note below) |
| Escalation → High     | "I can't access my account anymore — my password reset link never arrives and I'm locked out completely." | Name/Email/Problem collected (Ali Ahmed) →`Ticket CF-20260823-080000, Priority: High, Status: New` → Slack notified                                                                                                                                                            |
| Escalation → Critical | "Every single one of our Flows just stopped, the entire platform is dead"                                  | `Ticket CF-20260823-090900, Priority: Critical, Status: New` → Slack notified                                                                                                                                                                                                   |
| Escalation → Medium   | "Can I change which email address gets the workspace invoices?"                                            | `Ticket CF-20260823-091200, Priority: Medium, Status: New` → Slack notified                                                                                                                                                                                                     |
| Escalation → Low      | "Just some feedback: the template gallery could use better search"                                         | `Ticket CF-20260823-111700, Priority: Low, Status: New` → Slack notified                                                                                                                                                                                                        |

All four priority tiers (Critical/High/Medium/Low) are proven with real tickets 

## 🖼️ Screenshots

All screenshots live in [`screenshots/`](screenshots/):

- **Workflow overview:** [`AI Customer Support Bot Zap.png`](<AI%20Customer%20Support%20Bot%20Zap.png>) (project root, not in `screenshots/`)
- **Chatbot setup / KB:** [`CloudFlow KB.pdf`](<CloudFlow%20KB.pdf>) (project root, the actual knowledge file uploaded to the bot)
- **Conversation tests:** [`Correct Answer from KB.png`](<screenshots/Correct%20Answer%20from%20KB.png>), [`Response Outside KB.png`](<screenshots/Response%20Outside%20KB.png>), [`Details Collected by Bot.png`](<screenshots/Details%20Collected%20by%20Bot.png>)
- **Table / handoff:** [`Collected Data stored in Table.png`](<screenshots/Collected%20Data%20stored%20in%20Table.png>), [`Support Tickets Table.png`](<screenshots/Support%20Tickets%20Table.png>)
- **Notification:** [`Slack Notification.png`](<screenshots/Slack%20Notification.png>)
