# AI Client Onboarding System

An automated intake system for **MATalogics**, an AI automation agency. A caller phones in, an AI voice agent has a natural conversation and collects their project details, and within seconds that new lead is saved to a database, written up as a page the team can read, and announced in the team's chat — all with no human involved.

This repository documents how the whole thing was built, step by step, in plain language. If you've never used these tools before, you should still be able to follow along.

---

## What it does, in one picture

```
   Caller phones in
        │
        ▼
┌──────────────────┐
│  Vapi voice agent │   Talks to the caller, collects 6 details,
│  (the phone AI)   │   then sends them onward.
└──────────────────┘
        │
        ▼
┌──────────────────┐
│  n8n workflow     │   Receives the details, uses an AI model to
│  (the brain)      │   classify the request, scores priority,
│                   │   and fans the data out to three places.
└──────────────────┘
        │
        ├──────────────► Airtable   (the permanent record)
        │
        ├──────────────► Notion     (a readable page for the team)
        │
        └──────────────► Slack      (an instant alert in #new-clients)
```

The caller hears a normal, friendly conversation. Behind the scenes, one phone call turns into a fully filed lead in about ten seconds.

---

## The six things the agent collects

Every call gathers exactly these, and nothing is saved until they're all confirmed:

1. **Client name** — the caller's full name
2. **Company name** — their business
3. **Email** — read back and confirmed, since phone audio mangles emails
4. **Service required** — what they want built (voice agent, chatbot, automation, etc.)
5. **Project description** — a sentence or two of detail
6. **Budget** — in PKR

---

## The four tools, and why each is here

| Tool | Role in the system | Think of it as… |
|------|-------------------|-----------------|
| **Vapi** | The AI voice agent that answers the phone and talks to the caller | The receptionist |
| **n8n** | The automation that receives the data and routes it everywhere | The back office |
| **Airtable** | The database where every client permanently lives | The filing cabinet |
| **Notion** | A readable page per client for the team's daily workspace | The team binder |
| **Slack** | A real-time alert so the team knows instantly | The doorbell |

Airtable, Notion, and Slack are the three destinations. **Airtable is the source of truth** (the real record); Notion and Slack are convenient views onto that same new client.

---

## How to read this documentation

Read them in this order — each builds on the last:

1. **[Vapi — The Voice Agent](<Vapi/vapi-voice-agent configuration.md>)** — how the phone AI is set up: its personality, the rules it follows, and the "submit" function that hands data to n8n.
2. **[n8n — The Workflow](<n8n/n8n-workflow guide.md>)** — the heart of the system: how it unpacks the call, classifies it with AI, scores priority, and writes to all three destinations.
3. **[Airtable — The Database](<Airtable/airtable schema.md>)** — the permanent record: how the table is built and connected.
4. **[Notion — The Client Pages](<Notion/notion schema.md>)** — the readable team workspace: how the database is built, shared, and connected.
5. **[Slack — The Team Alert](<Slack/slack setup.md>)** — the instant notification: how the channel and bot are set up.

---

## The one rule that ties it all together

The same six field names must match in **three** places, or data silently goes missing:

- the **Vapi** agent's prompt and its submit function
- the **n8n** workflow that reads the incoming data
- (indirectly) the **Airtable/Notion** columns those values land in

This system uses these exact names everywhere:

```
client_name, company_name, email, service_required, project_description, budget_pkr
```

If you ever change one, change all of them. A mismatched name doesn't throw an error — the field just arrives empty. This was the single most common bug during development, so it's worth stating up front.

---

## A note on priority scoring

Priority (**HIGH / MEDIUM / LOW**) is **not** decided by the AI. It's a simple, predictable rule based on budget, so it's always consistent and auditable:

| Budget (PKR) | Priority |
|--------------|----------|
| 500,000 and above | HIGH |
| 200,000 to 499,999 | MEDIUM |
| below 200,000 | LOW |

The AI handles the fuzzy work (categorizing and summarizing); plain rules handle anything that should never be a guess.
