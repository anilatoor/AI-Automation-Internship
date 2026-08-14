
# Day 07 — Vapi + n8n AI Client Onboarding System

## What this folder covers

Day 07 is the first true end-to-end automation in this internship — the trigger is a **phone call**, not a form or a spreadsheet edit. A caller talks to a Vapi voice agent, which hands structured data to an n8n workflow; n8n classifies the request with AI, scores its priority with a plain deterministic rule, and fans the result out to Airtable (the permanent record), Notion (a readable team page), and Slack (an instant alert) — a working **AI Client Onboarding System**, built and proven with real live calls, not just wired up and left untested. (See [AI Client Onboarding System/README.md](<AI Client Onboarding System/README.md>) for the project-level architecture and field-name reference.)

---

## 🎓 What I Learned

### 🔹 Designing a Voice-First Intake (Vapi)

Built a voice agent, `Client Onboarding Agent`, whose entire job is collecting exactly six fields — name, company, email, service, description, budget — and nothing else: no pricing, no timelines, no technical promises. The system prompt does real work: it extracts whatever a caller volunteers up front instead of re-asking, reads back and spells out names/companies/emails (phone audio mangles proper nouns constantly), and enforces a **critical rule** — never submit before all six fields have real, confirmed values. That rule exists because early submission was a genuine bug during development: the agent would sometimes file a lead with only two of six fields filled in. There's also a narrow, explicit exception for a caller who truly refuses a field after being asked twice, and a confidentiality rule so the agent never reveals what's running behind the call. Full rulebook and the `submit_client_intake` function schema: [Vapi/vapi-voice-agent configuration.md](<AI Client Onboarding System/Vapi/vapi-voice-agent configuration.md>).

### 🔹 n8n as an AI Orchestrator, Not Just a Pipe

The workflow is an 11-station chain: unpack Vapi's nested envelope, classify with AI, compute priority, write to two destinations in parallel, wait for both, then report real status to Slack. Two things worth calling out:

- **Priority is a plain rule, not an AI guess** — budget ≥ 500,000 PKR is HIGH, 200,000–499,999 is MEDIUM, below that is LOW. The AI only handles the fuzzy work (category, summary, next action); anything that should never be a coin-flip is a deterministic `if` statement instead.
- **The AI classification step was built two different ways on purpose** — a plain HTTP Request node calling OpenAI directly, and n8n's dedicated AI Agent node paired with a Chat Model sub-node. Both are fed identical instructions and return identical results; only *how* the model gets called differs (hand-built request vs. a managed node). One is wired in, the other kept parked on the canvas as a side-by-side reference.

Every destination node is set to continue on failure rather than halt the workflow, and a "Build status" node actually checks whether Airtable and Notion succeeded before Slack reports it — so a partial failure shows up as a ⚠️ in the alert instead of vanishing silently. Full node-by-node walkthrough: [n8n/n8n-workflow guide.md](<AI Client Onboarding System/n8n/n8n-workflow guide.md>).

### 🔹 Three Views of One Client (Airtable + Notion + Slack)

Airtable is the source of truth — the actual record. Notion is the same client as a readable page for the team's daily workspace. Slack is the instant "someone should look at this now" ping. All three are fed from one merged object, so the recurring lesson was **field-name discipline**: the same six names (`client_name`, `company_name`, `email`, `service_required`, `project_description`, `budget_pkr`) have to match exactly across the Vapi function schema, the n8n normalize step, and wherever they land — a mismatch doesn't throw an error, the value just arrives empty. Notion added its own gotcha on top: a database has to be explicitly shared with the integration, and n8n needs the *database* link (with `?v=` in it), not the page link that contains it — get either wrong and every write fails with a permissions error that gives no hint why. Details: [Airtable/airtable schema.md](<AI Client Onboarding System/Airtable/airtable schema.md>), [Notion/notion schema.md](<AI Client Onboarding System/Notion/notion schema.md>), [Slack/slack setup.md](<AI Client Onboarding System/Slack/slack setup.md>).

### 🔹 Practical Assignment

Combining the voice agent, the orchestration workflow, and the three destinations into one system is, in effect, exactly the "AI Client Onboarding System" the brief asks for — a phone call becomes a classified, prioritized, filed lead across three tools in about ten seconds, with no manual data entry anywhere in the chain.

---

## 🛠️ What I Built

### Vapi — `Client Onboarding Agent`

| Piece                         | What it does                                                                                          | Evidence                                                                                 |
| ----------------------------- | ----------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| Greeting + system prompt      | Frames the call as MATalogics' intake line, collects the 6 fields conversationally                    | [Call Onboarding Agent.png](<AI Client Onboarding System/Vapi/Call Onboarding Agent.png>) |
| `submit_client_intake` tool | Sends the 6 confirmed fields to n8n, waits for confirmation before the agent speaks                   | [Agent provided tool.png](<AI Client Onboarding System/Vapi/Agent provided tool.png>)     |
| Live call                     | Real transcript, budget confirmed at the midpoint of a stated range, tool call completed successfully | [Agent Call Response.png](<AI Client Onboarding System/Vapi/Agent Call Response.png>)     |

### n8n — the workflow

Webhook → Normalize intake → AI classifier (two interchangeable approaches) → Parse AI output → Compute priority → Airtable + Notion (parallel) → Merge → Build status → Slack → Respond to Webhook. Active workflow, exported as [n8n/Workflow JSON/AI Client Onboarding System.json](<AI Client Onboarding System/n8n/Workflow JSON/AI Client Onboarding System.json>); full walkthrough in [n8n/n8n-workflow guide.md](<AI Client Onboarding System/n8n/n8n-workflow guide.md>).

### The three destinations

| Tool               | Role                                                                         | Evidence                                                                                           |
| ------------------ | ---------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| **Airtable** | Permanent record — the`Client Onboarding` table                           | [Vapi Airtable Onboarding.png](<AI Client Onboarding System/Airtable/Vapi Airtable Onboarding.png>) |
| **Notion**   | Readable team page per client — the`Clients` database                     | [Vapi Notion Update.png](<AI Client Onboarding System/Notion/Vapi Notion Update.png>)               |
| **Slack**    | Real-time alert in`#new-clients`, with real ✅/⚠️ status per destination | [Vapi Slack Notification.png](<AI Client Onboarding System/Slack/Vapi Slack Notification.png>)      |

### Required test — 3 live calls (brief asks for 3, all 3 priority tiers covered)

| Caller        | Company               | Service                    | Budget (PKR) | Priority |
| ------------- | --------------------- | -------------------------- | ------------ | -------- |
| Bilal Khan    | Urban Wear Appearance | AI Chatbot Development     | 600,000      | HIGH     |
| Aisha Reza    | Lumina Health         | AI Chatbot Development     | 350,000      | MEDIUM   |
| Artif Hussein | Fresh Bite Cafe       | AI Voice Agent Development | 150,000      | LOW      |

Every call ran the full chain for real — voice → n8n → AI classification → Airtable + Notion + Slack — and all three destination screenshots above reflect these actual records, not staged data.

### Folder structure

```text
Day-07/
├── README.md                                    — this file (build journal)
└── AI Client Onboarding System/
    ├── README.md                                — project explanation (architecture, field reference)
    ├── Vapi/                                     — agent rulebook, tool schema, call evidence
    ├── Airtable/                                 — table schema + screenshot
    ├── Notion/                                   — database schema + screenshot
    ├── Slack/                                    — channel setup + screenshot
    └── n8n/
        ├── n8n-workflow guide.md                 — full 11-station walkthrough + screenshot
        └── Workflow JSON/
            └── AI Client Onboarding System.json
```

---

## 🌟 The Takeaway

Day 07 is the first build in this internship where a human never touches the data at all — the trigger is a voice, not a click. The two ideas that mattered most: keep anything that should be deterministic (priority, from budget) out of the AI's hands entirely, and make every downstream write honest about whether it actually succeeded rather than assuming it did. Discovering that the AI classification step could be built two structurally different ways — a raw HTTP call versus n8n's managed AI Agent node — and get the identical result was the clearest proof that the *design* (six fixed fields in, three fixed fields out, JSON only) mattered more than which node happened to call the model.

**In short:**

- 📞 The trigger is a phone call — Vapi turns speech into six confirmed, structured fields
- 🧮 Priority is a rule, not a guess — the LLM classifies and summarizes, budget math decides urgency
- 🔀 Two ways to call an AI classifier, one identical result — proof the workflow's design, not the specific node, is what matters
- 🛡️ Every destination write is fault-tolerant, and Slack reports what *actually* happened, not what should have happened
- 🔑 One set of field names, used exactly everywhere — the single most common bug in this build was a name that didn't match

Seven days in, this is the first system where nobody has to open an app to start the process — they just call. Onward to Day 08. 🚀
