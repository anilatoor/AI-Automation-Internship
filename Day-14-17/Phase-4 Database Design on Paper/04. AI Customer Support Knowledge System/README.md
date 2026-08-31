# Task 4 — AI Customer Support Knowledge System (Paper Design — no SQL)

## Scenario

AI Customer Support Agent behind a chatbot, storing customer information, support tickets, conversations, messages, products, orders, and FAQs —designed so the AI agent can look at a customer's previous conversations and order info before answering.

## Design Summary

Seven tables were designed on paper: `Customers`, `Support Tickets`, `Conversations`,`Messages`, `Products`, `Orders`, and `FAQs` (independent — no foreign keys, standalone Q&A lookup).

| Table           | Key Columns                    | Primary Key     | Foreign Key(s)                                        |
| --------------- | ------------------------------ | --------------- | ----------------------------------------------------- |
| Customers       | name, email, phone, created_at | customer_id     | —                                                    |
| Support Tickets | subject, status, created_at    | ticket_id       | customer_id (Customers)                               |
| Conversations   | started_at                     | conversation_id | customer_id (Customers), ticket_id ()Support Tickets) |
| Messages        | sender, message_text, sent_at  | message_id      | conversation_id (Conversations)                      |
| Products        | name, price, description       | product_id      | —                                                    |
| Orders          | order_amount, order_date       | order_id        | customer_id (Customers), product_id (Products)       |
| FAQs            | question, answer               | faq_id          | —                                                    |

## Relationships (one-to-many)

- Customers → Support Tickets (`opens`)
- Customers → Conversations (`has`)
- Support Tickets → Conversations (`generates`)
- Conversations → Messages (`contains`)
- Customers → Orders (`places`)
- Products → Orders (`appears in`)
- FAQs is standalone — no relationships to other tables

## Bonus — answered

> "What was my previous order and why was my support ticket opened?"

Both branches key off `customer_id`: `Orders.customer_id` joins back to `Customers`for order history, and `Support Tickets.customer_id` (linked on through`Conversations.ticket_id`) joins back to `Customers` for ticket/conversation history — so the AI agent can pull both from the same `customer_id` in one lookup.

## Deliverables

- Hand-drawn table designs (columns, PK, FK) and ER-style relationship diagram, combined on one sheet → [CSR Agnet Databse ERD.jpg](<CSR Agnet Databse ERD.jpg>)
