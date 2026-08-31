# Task 3 — AI Automation CRM (Paper Design — no SQL)

## Scenario

AI-powered CRM for a digital marketing agency. Leads arrive from Website, Facebook, Instagram, LinkedIn, and WhatsApp; an AI agent assigns lead score, lead status, and lead category. A customer may have multiple conversations, and each conversation may contain many messages.

## Design Summary

Four tables were designed on paper: `Customers`, `Leads`, `Conversations`, `Messages`.

| Table         | Key Columns                                                | Primary Key     | Foreign Key(s)                  |
| ------------- | ---------------------------------------------------------- | --------------- | ------------------------------- |
| Customers     | name, email, phone, created_at                             | customer_id     | -                               |
| Leads         | source, lead_score, lead_status, lead_category, created_at | lead_id         | customer_id (Customers)         |
| Conversations | started_at                                                 | conversation_id | lead_id  (Leads)               |
| Messages      | sender, text_message, sent_at                              | message_id      | conversation_id (Conversations) |

## Relationships (one-to-many)

- Customers -> Leads (`has`)
- Leads -> Conversations (`has`)
- Conversations -> Messages (`contain`)

```text
Customer
 |__ Lead
      |__ Conversation
           |__ Messages
```

## Deliverables

- Hand-drawn table designs (columns, PK, FK) and relationship diagram, combined on one sheet -> [CRM ERD.jpg](<CRM ERD.jpg>)
