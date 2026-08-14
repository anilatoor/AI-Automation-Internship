
# Slack — The Team Alert

Airtable and Notion are where a new client's record *lives*. Slack is how the team *finds out* one exists. Of the three destinations, this is the one that has to happen in real time — nobody sits refreshing a Notion table waiting for a lead.

---

## Building it

1. Create a public channel called **`#new-clients`**.
2. Posting into a channel from an automation requires a Slack app with a bot token. Go to **[api.slack.com/apps](https://api.slack.com/apps) → Create New App → From scratch**. 
3. Give the app the **`chat:write`** permission (OAuth scope).
4. Install it to your workspace. This produces a **Bot User OAuth Token** (it starts with `xoxb-…`) — that's the credential n8n uses.

> **A valid token isn't enough on its own:** a bot can only post in channels it has been invited to. In the `#new-clients` channel, type `/invite @your-bot-name`. Skip this and n8n's Slack step fails every time with a `not_in_channel` error, even though the token is perfectly valid. (I just invited the n8n-bot in the new created channel I created on Day-06)

---

## What the message looks like

The alert is built upstream in n8n's "Build status" node (not typed into the Slack node directly), because that node knows whether Airtable and Notion actually succeeded — so the message can report the real outcome instead of assuming success. A real test call produced this:

```
📞 New client intake — HIGH priority
Client: Bilal Khan (Urban Wear Appearance)
Service: AI Chatbot Development
Summary: The client wants to build an AI-powered chatbot integrated with Zendesk and WhatsApp for handling product inquiries and order tracking.
Next action: Schedule a scoping call to discuss integration details and user flow.
Email: bilal.khan@gmail.com  |  Budget: 600000 PKR

Records:  ✅ Airtable record created   ✅ Notion page created
```

Two things make this useful at a glance: the **priority in the heading** (so the team can triage instantly), and the **✅ / ⚠️ markers** showing whether each destination actually saved. If Notion had failed, that line would read `⚠️ Notion FAILED` — and the alert would still send, so a partial failure is visible rather than silent.

---

## Two small formatting notes

**Bold uses single asterisks.** Slack's message formatting (called `mrkdwn`) uses `*single asterisks*` for bold, not the double asterisks of normal Markdown. The n8n message is written accordingly.

**Typing asterisks into Slack's own box doesn't show bold.** If you paste `*text*` into Slack's normal message composer, you'll see literal asterisks — because that editor wants you to click the **B** button instead. This is only a quirk of the browser composer; anything sent through the API (like our n8n message) renders bold correctly regardless. (If you want the composer to accept typed markup too: **Slack Preferences → Advanced → "Format messages with markup".**)

---

## Connecting n8n to Slack

In n8n, create a **Slack API** credential using the Bot User OAuth Token from above, and point the Slack node's "Send Message" action at the `#new-clients` channel. (I have used the API saved on Day-06)
