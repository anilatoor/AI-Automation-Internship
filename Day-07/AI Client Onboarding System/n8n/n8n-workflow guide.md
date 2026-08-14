# n8n — The Workflow

n8n is the brain of the system. Vapi hands it the raw details from a phone call, and by the time n8n finishes, a new client exists in Airtable, a page exists in Notion, the team has been alerted in Slack, and an AI model has classified the request along the way.

The workflow is a chain of connected "nodes," each doing one small job. This page walks through them in order. You don't need to be a programmer to follow it — think of each node as one station on an assembly line.

---

## The assembly line

```
Webhook → Normalize intake → AI classifier → Parse AI output → Compute priority
                                                                      │
                                              ┌───────────────────────┴───────────────────────┐
                                              ▼                                                 ▼
                                     Airtable (save record)                          Notion (create page)
                                              └───────────────────────┬───────────────────────┘
                                                                      ▼
                                                                    Merge
                                                                      ▼
                                                                Build status
                                                                      ▼
                                                             Slack (send alert)
                                                                      ▼
                                                            Respond to Webhook
```

Notice that **Slack comes last**, after Airtable and Notion — not alongside them. That's on purpose: the Slack message reports whether the two saves actually worked, so it has to wait until they're done.

---

## Station 1 — Webhook (the front door)

This node listens for incoming calls from Vapi. When Vapi's agent submits a lead, it arrives here.

Two settings matter: it accepts `POST` requests, and it's set to reply using the "Respond to Webhook" node at the end (not the default). Vapi needs a specific reply, so we control exactly what goes back.

---

## Station 2 — Normalize intake (unpack the box)

Vapi sends the data inside a nested envelope. This node opens the envelope and lays the six fields out flat so the rest of the workflow can use them easily. It reads exactly the six field names the system uses:

```
client_name, company_name, email, service_required, project_description, budget_pkr
```

It also safely handles a couple of real-world quirks: Vapi sometimes sends the details as text that needs converting, and this node handles that without crashing.

---

## Station 3 — The AI classifier (two ways to build it)

This is where an AI model reads the request and produces three things:

- **service_category** — which type of project this is (from a fixed list)
- **summary** — one clean sentence describing the client and their need
- **next_action** — a suggested next step for the team

Interestingly, this step can be built **two different ways**, and both are present in the workflow. They produce identical results — one is wired in, the other is kept alongside as a reference for comparison.

**Approach A — HTTP Request node.** A general-purpose node that sends a request straight to OpenAI. You write the request by hand and get back OpenAI's raw response. Simple, fast, and only needs one node.

**Approach B — AI Agent node.** n8n's purpose-built AI node, paired with a "Chat Model" sub-node. The instructions live in tidy fields instead of a hand-written request, and it's easy to swap the underlying model. It also unlocks advanced features (tools, memory) if the job ever grows.

**Why keep both?** They're a useful side-by-side comparison. Approach A is leaner and quicker; Approach B is more flexible. Either one, given the same intake, returns the same classification. 

The instructions given to the model are the same either way: pick one category from a fixed list of seven, write a one-sentence summary, suggest a next action, and return the answer as strict JSON — nothing else. It's explicitly told **not** to decide priority; that's handled separately by a plain rule.

---

## Station 4 — Parse AI output (read the AI's answer)

The AI returns its answer as a block of text. This small node reads that text and turns it into usable data. It's written to accept the answer from *either* classifier approach above, which is what makes the two interchangeable — swap one for the other and nothing downstream needs to change.

---

## Station 5 — Compute priority (the budget rule)

This node assigns priority using a fixed rule, deliberately kept out of the AI's hands so it's always consistent:

| Budget (PKR)       | Priority |
| ------------------ | -------- |
| 500,000 and above  | HIGH     |
| 200,000 to 499,999 | MEDIUM   |
| below 200,000      | LOW      |

It also fills in sensible fallbacks for any missing field, so a call that ended with a gap doesn't break the saves. One small but important detail: it builds a guaranteed non-empty **title** for the Notion page (falling back from company name, to client name, to "Unknown Client"), because Notion refuses to create a page with a blank title.

---

## Station 6 — Airtable (save the permanent record)

Writes a new row to the `Client Onboarding` table. One quirk handled here: Airtable's Priority field expects `High` / `Medium` / `Low` (normal capitalization), while the workflow uses `HIGH` / `MEDIUM` / `LOW` internally, so the value is adjusted on the way in.

This node is set to **continue even if it fails** — so a hiccup saving to Airtable won't stop Notion and Slack from doing their jobs.

---

## Station 7 — Notion (create the readable page)

Writes a new page to the `Clients` database. The page title is the client's company name, with the rest of the details as properties. Same "continue if it fails" safety net as Airtable, and a guard so a missing budget becomes `0` rather than an error (Notion rejects an empty number).

---

## Station 8 — Merge (wait for both)

A simple join. It waits for both Airtable and Notion to finish — whether they succeeded or failed — before moving on. This guarantees the next node has the full picture before it reports status.

---

## Station 9 — Build status (check what actually worked)

This is the node that makes the Slack alert honest. Instead of blindly claiming success, it checks each save: did Airtable actually return a record? Did Notion actually return a page? It then writes the Slack message with a ✅ or ⚠️ next to each destination, so the team sees the real outcome.

---

## Station 10 — Slack (ring the doorbell)

Posts the finished message to the `#new-clients` channel. All the wording was already assembled by "Build status," so this node just sends it. Same "continue if it fails" safety as the others.

---

## Station 11 — Respond to Webhook (reply to Vapi)

Sends the final reply back to Vapi so the agent can tell the caller they're all set. The reply includes the same call ID Vapi sent, so Vapi knows which call is being answered.

---

## The two approaches, side by side

A note kept on the workflow canvas summarizes the two classifier options:

|                        | **A: HTTP Request → OpenAI** | **B: AI Agent → Chat Model**          |
| ---------------------- | ----------------------------------- | -------------------------------------------- |
| How it calls the model | You write the request by hand       | n8n builds the request for you               |
| Where the answer lands | OpenAI's raw response shape         | A clean`output` field                      |
| Speed                  | Faster, simpler                     | A little slower, more moving parts           |
| Flexibility            | Just does the one job               | Can add tools/memory later; easy model swaps |
| Status in this build   | Kept as a reference (parked)        | Wired in and active                          |

Both are fed the same instructions and return the same `service_category`, `summary`, and `next_action`. To switch between them, you rewire "Normalize intake" into whichever classifier you want, and that classifier into "Parse AI output" — nothing else changes.

---

## A note on the Slack heading wording

The original brief called for three exact headings by tier — "HIGH PRIORITY CLIENT" / "MEDIUM PRIORITY CLIENT" / "STANDARD CLIENT". This build instead uses one consistent template for all tiers: `New client intake — [priority] priority`. So a low-priority lead reads "LOW priority" rather than "STANDARD CLIENT." The priority is still clearly visible in every message — it's just not the exact three-phrase wording. If literal wording matters, it's a one-line change in the "Build status" node.
