-- Phase 5 — shared schema for PostgreSQL + Supabase
-- Run this file once, identically, in both databases (local pgAdmin and the
-- Supabase SQL editor) before building any of the Task 5-9 workflows.
-- Safe to re-run: drops the four tables first (no-ops on a fresh database)
-- so it always leaves this exact shape behind.
--
-- Hierarchy (paper design, Phase 4 Task 3 — AI Automation CRM):
--   Customers -> Leads -> Conversations -> Messages

DROP TABLE IF EXISTS messages CASCADE;
DROP TABLE IF EXISTS conversations CASCADE;
DROP TABLE IF EXISTS leads CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

CREATE TABLE customers (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    email       VARCHAR(150) UNIQUE,
    phone       VARCHAR(30),
    company     VARCHAR(100),
    created_at  TIMESTAMP DEFAULT NOW()
);

CREATE TABLE leads (
    id             SERIAL PRIMARY KEY,
    customer_id    INT NOT NULL REFERENCES customers(id),
    source         VARCHAR(50),
    lead_score     INT,                         -- Task 6: AI-generated 0-100
    lead_status    VARCHAR(30) DEFAULT 'New',
    lead_category  VARCHAR(50),                 -- Task 6: AI-generated category
    created_at     TIMESTAMP DEFAULT NOW()
);

CREATE TABLE conversations (
    id          SERIAL PRIMARY KEY,
    lead_id     INT NOT NULL REFERENCES leads(id),
    channel     VARCHAR(30) DEFAULT 'chat',
    status      VARCHAR(30) DEFAULT 'Open',
    started_at  TIMESTAMP DEFAULT NOW()
);

CREATE TABLE messages (
    id              SERIAL PRIMARY KEY,
    conversation_id INT NOT NULL REFERENCES conversations(id),
    sender          VARCHAR(10) NOT NULL CHECK (sender IN ('customer', 'ai')),
    message         TEXT NOT NULL,
    sent_at         TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_messages_conversation ON messages(conversation_id);
CREATE INDEX idx_conversations_lead    ON conversations(lead_id);
CREATE INDEX idx_leads_customer        ON leads(customer_id);
CREATE INDEX idx_leads_status          ON leads(lead_status);

-- ============================================================
-- Task 8 guardrail — read-only role for the NL-to-SQL agent
-- (restrict via DB role, not just prompt wording: an AI-generated
-- DROP/DELETE/UPDATE fails at the database level even if the regex
-- guardrail in the workflow is somehow bypassed)
-- ============================================================

-- CREATE ROLE phase5_readonly LOGIN PASSWORD 'change-me';
-- GRANT CONNECT ON DATABASE phase5 TO phase5_readonly;
-- GRANT USAGE ON SCHEMA public TO phase5_readonly;
-- GRANT SELECT ON ALL TABLES IN SCHEMA public TO phase5_readonly;
-- ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO phase5_readonly;
-- -- n8n's Postgres credential for Task 8 connects as phase5_readonly.
