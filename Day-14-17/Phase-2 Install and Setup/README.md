# Phase 2 — Install & Setup

## Checklist

- PostgreSQL installed — PostgreSQL 18.6 (x86_64-windows) confirmed via `psql -U postgres` → `SELECT version();`
- pgAdmin installed — pgAdmin 4 set up and used as the primary query tool for all task work.
- PostgreSQL server connection created — server `PostgreSQL 18` registered in pgAdmin, connected as `postgres`, database `lead_management` created and used for all queries

## Core Concepts

| Concept       | Notes                                                                                                                                                                             |
| ------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Server        | The running PostgreSQL instance (`PostgreSQL 18`, on `localhost`) that manages one or more databases and handles all client connections/authentication.                           |
| Database      | A named, isolated collection of schemas/tables on the server — here, `lead_management`, created to hold the `leads` table.                                                        |
| Schema        | A namespace inside a database that groups tables/views/functions (default is `public`); lets you organize objects and avoid name clashes.                                         |
| Table         | A structured object made of rows and columns that stores data of a defined shape — e.g. `leads`.                                                                                  |
| Row           | One record in a table — e.g. one lead, like "Ahmed Khan / Facebook / score 85".                                                                                                   |
| Column        | One named, typed field in every row — e.g. `name`, `lead_score`, `status`.                                                                                                        |
| Data Type     | The kind of value a column can hold — `VARCHAR(n)` for text, `INT` for whole numbers, `TIMESTAMP` for date/time, etc. Enforced by Postgres on every insert/update.                |
| Primary Key   | A column (or set of columns) that uniquely identifies each row and can't be NULL or duplicated — `id SERIAL PRIMARY KEY` on `leads`.                                              |
| Foreign Key   | A column that references another table's primary key, enforcing that the referenced row must exist — used in Phase 4/5 designs (e.g. `Conversations.customer_id → Customers.id`). |
| NULL          | The absence of a value — distinct from `0` or `''`. A column allows NULL unless marked `NOT NULL`.                                                                                |
| Relationships | How tables connect to each other via foreign keys — one-to-many (one customer → many leads), many-to-many (via a join table), etc.                                                |
| CRUD          | The four basic data operations: **C**reate (`INSERT`), **R**ead (`SELECT`), **U**pdate (`UPDATE`), **D**elete (`DELETE`) — all demonstrated on `leads` in Task 1.                 |
| SQL Query     | A statement written in SQL that tells the database what to do — e.g. `SELECT * FROM leads WHERE status = 'Qualified';`.                                                           |

## Deliverables

- Screenshot of PostgreSQL installed and running (via `psql`) → [screenshots/Postgres Installed.png](<screenshots/Postgres%20Installed.png>)
- Screenshot of pgAdmin connected to the PostgreSQL server (`lead_management/postgres@PostgreSQL 18`) → see [Phase-3 SQL Tasks/01. Lead Management Database/screenshots/](<../Phase-3 SQL Tasks/01. Lead Management Database/screenshots>) (same connection used throughout)
