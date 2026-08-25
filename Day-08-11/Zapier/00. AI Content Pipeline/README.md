# Task 0.5 — AI Content Pipeline

## 📋 Task Description

Warm-up automation that turns a raw **Topic** into an AI-written, AI-illustrated social post queued for review, entirely hands-off:

```
Topic (Google Sheets) → AI by Zapier (Content Creator) → Formatter (Text) → ChatGPT (Image Generator) → Google Sheets (Content Pipeline) → Buffer (Add to Queue)
```

- **Trigger:** a new row on the **Topic** tab of the "Content Pipeline" Google Sheet (polled every 2 min)
- **AI step:** AI by Zapier's "Content Creator" action (GPT-4o mini) turns the Topic into a JSON payload — `hook`, `caption`, `hashtags`
- **Formatter step:** cleans/combines the AI's `hook` + `caption` into a single ready-to-post field
- **Image step:** ChatGPT (OpenAI) "Image Generator" action creates a matching illustration and returns a hosted image URL
- **Google Sheets step:** appends the finished record to the "Content Pipeline" sheet tab (Topic, Generated Content, Hashtags, Image URL, Date, Status)
- **Social media step:** Buffer's "Add to Queue" action pushes the caption + image to the connected Instagram channel's queue, tagged for manual review

## ⚙️ How It Works

1. **Trigger — Google Sheets "New Spreadsheet Row"** watches the **Topic** tab of the "Content Pipeline" sheet (2‑minute polling interval).
2. **AI by Zapier — "Content Creator"** sends the Topic to GPT‑4o mini (Standard usage) with a prompt that forces structured JSON output — see the exact prompt in Configuration below.
3. **Formatter by Zapier — "Text"** joins the AI's `hook` and `caption` into one clean **Generated Content** string (and preps the text used as the image prompt) so nothing has to be re-typed downstream.
4. **ChatGPT (OpenAI) — "Image Generator"** generates one illustration per topic from the formatted content and returns a hosted **Image URL**.
5. **Google Sheets — "Create Spreadsheet Row"** appends the full record — Topic, Generated Content, Hashtags, Image URL, Date, Status = `Ready to Post` — to the **Content Pipeline** tab.
6. **Buffer — "Add to Queue"** posts the caption + generated image to the connected Instagram channel (`anila.gulzar`), tagged `MATalogics Internship`. Posts land in Buffer's queue for a manual **Publish Now** rather than auto-publishing, so there's a human review step before anything goes live.

No branching/filter step was needed for this warm-up Zap — every Topic row flows straight through to a queued post.

## 🔧 Configuration

- **Trigger:** Google Sheets → New Spreadsheet Row → **Topic** tab, 2 min poll.
- **AI app/model:** AI by Zapier, "Content Creator" action, **Standard (GPT‑4o mini)**, 1 task per run. Prompt asks for strict JSON:

  ```json
  {
    "hook": "scroll-stopping first line, max 60 chars",
    "caption": "engaging caption, 120-150 words, warm and conversational, 2-3 short paragraphs, 1-2 emojis max, ends with a question or CTA",
    "hashtags": "8-12 relevant hashtags, space-separated, no commas"
  }
  ```
- **Formatter transform:** Formatter by Zapier → **Text**, used to merge the `hook` + `caption` fields into a single Generated Content string written to the sheet.
- **Image generation:** ChatGPT (OpenAI) app → **Image Generator** action, one illustration generated per topic; the returned file is hosted on Zapier's file storage (S3) and its URL is stored in the **Image URL** column.
- **Google Sheet:** "Content Pipeline" spreadsheet —

  - **Topic** tab: single input column, `Topic`
  - **Content Pipeline** tab: output columns `Topic | Generated Content | Hashtags | Image URL | Date | Status`
- **Social media app:** Buffer, **Add to Queue** action → Instagram channel `anila.gulzar`, auto-tagged `MATalogics Internship`. Posting mode is **queued for manual approval** (each entry needs "Publish Now" in Buffer) rather than auto-publish.

## 🧪 Test Input & Output

Actual verified run (two Topic rows processed end-to-end):

| Field               | Value                                                                                                                                                                                                                          |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Topic (input)#1     | "3 AI tools that actually save time (and 2 that are hype)"                                                                                                                                                                     |
| Generated Content#1 | "Unlock Time with These AI Tools! Ever feel like there aren't enough hours in the day? ⏳ Discover three amazing AI tools that can genuinely save you time in your daily tasks, plus two that might not live up to the hype…" |
| Hashtags#1          | `AItools productivity efficiency time-saving techhype automation`                                                                                                                                                            |
| Topic (input)#2     | "The 6 browser extensions I can't work without"                                                                                                                                                                                |
| Generated Content#2 | "These extensions will change your browsing game! 🌟 Are you tired of feeling overwhelmed while browsing? Here are the 6 browser extensions I absolutely can't live without…"                                                 |
| Hashtags#2          | `#BrowserExtensions #ProductivityHacks #TechTools #MustHaveExtensions #WebBrowsing #StayOrganized #TechSavvy #EfficiencyBoost`                                                                                               |
| Google Sheets row   | Both rows written to**Content Pipeline** tab with Image URL populated and Status = `Ready to Post`                                                                                                                     |
| Social media result | Both posts (plus a 3rd generated on a retry) appeared in the Buffer queue for the`anila.gulzar` Instagram channel with their generated image, tagged `MATalogics Internship`, awaiting manual **Publish Now**        |

## 🖼️ Screenshots

- **Workflow overview** (all 6 Zap steps): [`AI Content Pipeline Zap.png`](<AI%20Content%20Pipeline%20Zap.png>)
- **Topic source (Google Sheet):** [`screenshots/Google Sheet Topic.png`](<screenshots/Google%20Sheet%20Topic.png>)
- **AI step config/preview (hook, caption, hashtags):** [`screenshots/AI Generated Content.png`](<screenshots/AI%20Generated%20Content.png>)
- **Final Content Pipeline sheet row (test run output):** [`screenshots/Google Sheet Content Pipeline.png`](<screenshots/Google%20Sheet%20Content%20Pipeline.png>)
- **Queued posts in Buffer (Instagram):** [`screenshots/Posts on Instagram.png`](<screenshots/Posts%20on%20Instagram.png>)
