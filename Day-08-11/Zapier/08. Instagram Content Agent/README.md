# Task 8 — Instagram Content Agent ⭐ Most Interesting

## 📋 Task Description

Autonomous agent that plans, writes, self-critiques, and queues Instagram content for human approval — never auto-publishing.

- **Input table:** "Content Ideas" — Topic, Product, Target Audience, Content Type, Goal, Status
- **Output table:** "Instagram Content Calendar" — Date, Topic, Caption, Hook, CTA, Hashtags, Visual Concept, Score, Status
- **Agent workflow (per run):**
  1. Analyze existing content (what's been posted, which content types are overused, which topics are stale)
  2. Choose content independently (Topic, Hook, Content Type, CTA, Target Audience)
  3. Generate the post (caption, hook, CTA, hashtags, visual concept)
  4. Quality check via a **critic agent** (hook strength, repetitiveness, CTA clarity, audience relevance, unsupported claims) — score <7 loops back to rewrite, ≥7 approves
  5. Store the approved post in the Content Calendar
  6. Human approval — Status = "Awaiting Approval", never auto-published
- **Diversity rule:** if the last 3 posts are all Educational, the agent recognizes it and switches content type

**Architecture:** Trigger → Agent → Research Tools → Decision → Content Generation → Critic Agent → Decision → Table → Human Approval

## ⚙️ How It Works

Built as a single **Zapier Agent** (not a multi-step Zap) so the model itself owns the reasoning loop end to end:

1. **Read the source table.** The agent's knowledge sources are the two Zapier Tables — `Content Ideas` and `Instagram Content Calendar` — synced directly into it, so it can see every prior post before deciding what to do next.
2. **Analyze & decide independently.** It reviews the calendar history (what's been posted, which content types are overused, which topics are stale) and picks the next Topic, Hook, Content Type, CTA, and Target Audience itself — it isn't told what to post.
3. **Generate the post.** It uses the `Content Ideas` row (Topic, Product, Target Audience, Content Type, Goal) as raw material and drafts the caption, hook, CTA, hashtags, and visual concept, optionally grounding claims with the **Web Search by Zapier** tool ("if you cite a fact, keep it defensible").
4. **Self-critique and score.** The same agent scores its own draft (hook strength, repetitiveness, CTA clarity, audience relevance, unsupported claims) on a 1–10 scale before moving on — in the captured run it scored its "AI Automation" post **9/10** and approved it straight through.
5. **Populate the Instagram Content Calendar directly.** This is the key wiring: **the agent itself calls the `Zapier Tables: Create Record` action** against the `Instagram Content Calendar` table — there's no separate downstream Zap populating it. The agent writes Date, Topic, Content Type, Caption, Hook, CTA, Hashtags, Visual Concept, Score, and sets `Status = "Awaiting Approval"` in that single tool call.
6. **Notify a human for sign-off.** Immediately after the record is created, the agent calls `Slack: Send Channel Message` to post the full post (score, hook, caption, CTA, hashtags, visual concept) into `#content-approvals`, asking a human to react ✅ to approve or 📝 to request changes. Nothing is ever auto-published — the agent's job ends at "Awaiting Approval."
7. **Diversity rule.** Because the agent re-reads the full `Instagram Content Calendar` history at step 1–2 on every run, it can see if the last 3 entries share a `Content Type` and is instructed to switch content types when that happens, rather than relying on a hardcoded counter.

## 🔧 Configuration

**Agent:** "Instagram Content Agent" (Zapier Agents, v1)

- **Tools available:**
  - Default Tools: Visit Site & Web Search
  - Web Search by Zapier — Search the Web
  - Zapier Tables: Create Record → Table: `Instagram Content Calendar`, with fields (Date, Status = "Awaiting Approval...", etc.) mapped from the agent's own draft
  - Slack: Send Channel Message → Channel: `content-approvals`, "Include a link to this automation?" = No
- **Knowledge sources:**
  - Zapier Tables: `Content Ideas` (the input/idea backlog)
  - Zapier Tables: `Instagram Content Calendar` (its own output history, used for diversity/repetition checks)
- **Scoring:** single self-critique pass, 1–10 scale, written back into the `Score` column (captured run: 9/10 → approved, no rewrite loop needed).
- **Human approval loop:** enforced entirely through Slack — the agent posts to `#content-approvals` and status stays `Awaiting Approval` until a human reacts.

## 🧪 Test Input & Output

Actual run captured below (single "AI Automation" idea seeded in `Content Ideas`):

| Step               | What Happened                                                                                                                                                                  |
| ------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Input row          | `Content Ideas`: Topic = AI Automation · Product = AI Course · Target Audience = Business Owners · Content Type = Educational · Goal = Leads · Status = Available       |
| Agent decision     | Kept the seeded Topic/Content Type (calendar was empty — "no diversity constraints" per its own reasoning trace) and generated the full post                                  |
| Self-critique      | Scored 9/10 → approved on the first pass (no rewrite loop triggered)                                                                                                          |
| Table write        | Agent called`Zapier Tables: Create Record` on `Instagram Content Calendar` → Record created successfully, ID `01M1442RANQTT660TM2QKYAZC8`, Status = "Awaiting Approval" |
| Human notification | Agent posted the full post to Slack`#content-approvals` via the Content Review Bot, tagged "New Instagram post ready for review - Score: 9/10", awaiting a ✅ / 📝 reaction  |
| Auto-publish check | Confirmed — post is stored as "Awaiting Approval" only; nothing was published                                                                                                 |

## 🖼️ Screenshots

- [`Content Idea Table.png`](<screenshots/Content%20Idea%20Table.png>) — the seeded `Content Ideas` input row (AI Automation / AI Course / Business Owners / Educational / Leads)
- [`Record Created by Agent.png`](<screenshots/Record%20Created%20by%20Agent.png>) — agent config (tools + knowledge sources) and its preview confirming `Zapier Tables: Create Record` succeeded
- [`Notification Summary by Agent.png`](<screenshots/Notification%20Summary%20by%20Agent.png>) — agent's own run summary (Date, Topic, Content Type, Goal, Score 9/10, Status, Record ID) right before it notifies a human
- [`Slack Notification for Approval.png`](<screenshots/Slack%20Notification%20for%20Approval.png>) — the resulting message in `#content-approvals`, with the full caption/hook/CTA/hashtags/visual concept and the approve/request-changes instructions
- [`Instagram Calander Table LHS.png`](<screenshots/Instagram%20Calander%20Table%20LHS.png>) / [`Instagram Calander Table RHS.png`](<screenshots/Instagram%20Calander%20Table%20RHS.png>) — the `Instagram Content Calendar` table **populated directly by the agent's table-write action**, showing all columns (Date, Topic, Content Type, Caption, Hook, CTA, Hashtags, Visual Concept, Score = 9, Status = Awaiting Approval)
