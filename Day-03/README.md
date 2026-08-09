# Day 03 — Git & GitHub + Postman + APIs

## What this folder covers

Day 03 combined three modules from the task brief into one deliverable: version control (Git/GitHub, including a real open-source contribution), API fundamentals, and a hands-on build — a four-endpoint Lead Management API implemented as n8n webhooks, tested with Postman, backed by Google Sheets.

## Folder structure

```text
Day-03/
├── GitHub/
│   ├── Open Source Repository Link.txt   — the upstream project explored
│   ├── Fork Repository Link.txt          — my fork + branch + commands used
│   ├── Pull Request Link.txt             — the PR submitted upstream
│   └── Screenshots/                      — git config, fork, PR, issues view
│
├── Postman/
│   ├── MATalogics Lead Management API.postman_collection.json
│   ├── Environment.postman_environment.json
│   └── Screenshots/                      — each request/response, CRUD flow
│
├── n8n/
│   ├── Lead Management API.json          — the exported n8n workflow
│   └── (workflow + Get All Leads canvas screenshots)
│
├── Google Sheets/
│   ├── Google Sheet Link.txt             — sheet used as the data store
│   └── Screenshots/                      — row create/update/delete evidence
│
└── Report/
    └── Day-03 Report.docx                — full write-up (all modules, Q&A, learnings)
```

## Module 1 — Git & GitHub

- Configured Git locally (`user.name`, `user.email`) and practiced the core workflow: `init`, `clone`, `add`, `commit`, `push`, `pull`.
- Explored and contributed to an open-source project on the n8n topic — see [GitHub/Open Source Repository Link.txt](<GitHub/Open%20Source%20Repository%20Link.txt>).
- Forked it, branched (`feature/my-improvement`), fixed nine README links broken by unescaped parentheses plus a hardcoded absolute link — see [GitHub/Fork Repository Link.txt](<GitHub/Fork%20Repository%20Link.txt>).
- Opened a Pull Request upstream, currently open — see [GitHub/Pull Request Link.txt](<GitHub/Pull%20Request%20Link.txt>).

## Module 2 — API Fundamentals

Studied and applied REST concepts directly in the Lead Management build: HTTP methods (GET/POST/PUT/DELETE), status codes (200/201/400/401/404/500), headers (Content-Type, Authorization, Accept), and authentication (API keys, Bearer tokens). Full explanations are written up in the [Day-03 Report](<Report/Day-03%20Report.docx>).

## Module 3 — Postman, n8n & Google Sheets — Lead Management API

One n8n workflow hosts four webhook endpoints, all reading/writing one Google Sheet (`Lead Management`, columns: Name, Email, Phone, Company, Interest, Created At):

| Endpoint         | Method | Purpose                                                                    |
| ---------------- | ------ | -------------------------------------------------------------------------- |
| `/create-lead` | POST   | Validates name & email, appends a row, responds 201 (400 on invalid input) |
| `/get-leads`   | GET    | Reads all rows, responds 200 with the full lead list                       |
| `/update-lead` | PUT    | Finds the row by email, overwrites phone/company/interest, responds 200    |
| `/delete-lead` | DELETE | Finds the row by email, deletes it, responds 200                           |

Each endpoint was tested from the **MATalogics Lead Management API** Postman collection (variables, JSON bodies, Bearer auth) and verified directly against the sheet — see the screenshots under `Postman/Screenshots/` and `Google Sheets/Screenshots/`.

## Learning outcomes

- Practiced the full open-source contribution cycle: fork → branch → fix → PR, on a real, active repository.
- Mapped CRUD operations onto REST methods and status codes in a working system, not just in theory.
- Built and tested a multi-endpoint API with Postman (collections, variables, auth, exported collection).
- Designed a single n8n workflow exposing multiple webhook endpoints, each validating input before writing to Google Sheets.
- Used Google Sheets as an inspectable datastore wired into four different operations (append, read, update-by-match, delete-by-match).

Full details, module-by-module answers, and reflections are in [Report/Day-03 Report.docx](<Report/Day-03%20Report.docx>).
