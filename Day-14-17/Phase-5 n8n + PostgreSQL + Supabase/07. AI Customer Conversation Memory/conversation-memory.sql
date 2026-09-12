-- Task 7 — AI Customer Conversation Memory
-- Run ../../schema/phase5-schema.sql first.

-- 1. Find the customer by name (or create one on first contact)
SELECT id FROM customers WHERE name = $1 LIMIT 1;

INSERT INTO customers (name, email, phone)
VALUES ($1, $2, $3)
ON CONFLICT (email) DO UPDATE SET name = EXCLUDED.name
RETURNING id;

-- 2. Find that customer's most recent lead, or create one
--    (paper design: Customers -> Leads -> Conversations, not Customers -> Conversations directly)
--    name/email/phone already live on customers — leads only needs the FK.
SELECT id FROM leads WHERE customer_id = $1 ORDER BY created_at DESC LIMIT 1;

INSERT INTO leads (customer_id, source, lead_status)
VALUES ($1, 'chat', 'New')
RETURNING id;

-- 3. Find an open conversation for that lead, or start a new one
SELECT id FROM conversations
WHERE lead_id = $1 AND status = 'Open'
ORDER BY started_at DESC
LIMIT 1;

INSERT INTO conversations (lead_id) VALUES ($1) RETURNING id;

-- 3. Retrieve previous messages — this is the "memory" fed to the AI Agent
--    as context before it generates a reply
SELECT sender, message, sent_at
FROM messages
WHERE conversation_id = $1
ORDER BY sent_at ASC;

-- 4. Persist both turns of the exchange
INSERT INTO messages (conversation_id, sender, message) VALUES ($1, 'customer', $2);
INSERT INTO messages (conversation_id, sender, message) VALUES ($1, 'ai', $2);

-- ------------------------------------------------------------
-- Required test (README.md):
--   Turn 1: "My name is Ahmed and I need help with my order."
--           -> customer "Ahmed" created/found, message saved as sender='customer'
--   Turn 2 (same conversation_id): "What is my name?"
--           -> step 3 pulls turn 1 back out of the DB, AI Agent answers "Ahmed"
--              using retrieved history, not model memory
-- ------------------------------------------------------------
