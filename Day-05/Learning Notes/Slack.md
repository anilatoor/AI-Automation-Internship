# Slack — Notes & Reference

Learning notes from the [Slack intro video](https://youtu.be/hJzgnaiLNkk?si=Mag8-m0Qwiaxaj42) and Slack's own docs, written up for anyone reading this folder who hasn't used Slack before.

## What is Slack

A team communication platform — a more organized, work-focused alternative to WhatsApp or a group chat. Conversations live in topic-based **channels** instead of one long thread with everyone in it, so a message about deployments and a message about lunch never end up in the same feed.

## Core concepts

| Concept | What it means | How it showed up here |
| --- | --- | --- |
| **Workspace** | Your organization's whole Slack environment — one workspace holds every channel, member, and app for a team | Created the `MATalogics` workspace as the container for everything below |
| **Channel** | A dedicated conversation/topic. Public by default (anyone in the workspace can join); can be made private | Built 5 task-required channels — `#n8n-alerts`, `#client-updates`, `#internship`, `#workflow-errors`, `#project-status` — plus `#social` and `#all-matalogics` |
| **Thread** | Replies nested under one specific message, instead of flooding the main channel | Practiced replying in a thread — see [Thread Message.png](<../Screenshots/Slack/Thread%20Message.png>) |
| **DM (Direct Message)** | A private, 1:1 (or small group) conversation outside any channel | See [Direct Message.png](<../Screenshots/Slack/Direct%20Message.png>) |
| **@mention** | Pings a specific person (or `@channel`/`@here` for everyone) so they get a direct notification even if they're not watching the channel live | Used inside test messages to confirm notification delivery |
| **File sharing** | Drop documents, images, code snippets, etc. directly into a channel or DM | Used implicitly when n8n posts links/attachments into alerts |
| **Apps / Integrations** | Slack connects to outside tools (like n8n) via a **Slack App** — a bot identity with a token and a defined set of permissions (OAuth scopes) | Created a Slack App, generated a bot token (`xoxb-...`), scoped it with `chat:write`, `channels:manage`, `channels:read` |
| **Notifications** | Per-channel or global rules for what interrupts you — all activity, only mentions, or nothing | Checked per-channel notification preferences during setup |

## Why the bot needs to be *in* the channel

A Slack bot can only post to a channel it's a member of (or one that allows `chat:write.public`). This is the most common early error — `not_in_channel` — and the fix is either inviting the bot (`/invite @YourBot`) or granting the broader scope.

## Applied in this project

- Workspace `MATalogics` created, 5 required channels + 2 extra built — [Slack Workspace.png](<../Screenshots/Slack/Slack%20Workspace.png>)
- Bot connected to n8n, used to **send messages** (Workflow 1) and **create channels** (Workflow 2)
- New client channel created live by Workflow 2 — [New Client Channel.png](<../Screenshots/Slack/New%20Client%20Channel.png>)
- Onboarding announcement posted with dynamic client fields — [Clinent Onbording Announcement.png](<../Screenshots/Slack/Clinent%20Onbording%20Announcement.png>)
- Task-added notification posted with dynamic task fields — [Notification in Slack.png](<../Screenshots/Slack/Notification%20in%20Slack.png>)
- Deliberate workflow failure routed to `#workflow-errors` — [Error Alerts.png](<../Screenshots/Slack/Error%20Alerts.png>)
- Manual status update posted to `#project-status` — [Project status update - Manual.png](<../Screenshots/Slack/Project%20status%20update%20-%20Manual.png>)

## Further reading

- [Slack Help Center](https://slack.com/help)
- [api.slack.com/apps](https://api.slack.com/apps) — where Slack Apps (bots) are created and scoped
