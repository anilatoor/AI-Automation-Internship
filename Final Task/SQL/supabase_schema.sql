-- =====================================================================
-- UrbanCart — Complete Supabase schema
-- Run once in Supabase SQL Editor (project is currently empty, so this
-- creates everything from scratch).
-- =====================================================================

create extension if not exists vector;

create table if not exists customers (
  id uuid primary key default gen_random_uuid(),
  name text, phone text unique, email text, city text,
  channel_first_seen text, created_at timestamptz default now()
);

create table if not exists leads (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid references customers(id),
  product_interest text, budget_pkr numeric, city text,
  intent text check (intent in ('ready','browsing')),
  score text, source text, status text default 'new',
  airtable_record_id text, created_at timestamptz default now()
);

create table if not exists orders (
  id uuid primary key default gen_random_uuid(),
  order_code text unique,          -- e.g. 'UC-10452'
  customer_id uuid references customers(id),
  items jsonb, status text, total_pkr numeric,
  placed_at timestamptz, expected_delivery date
);

create table if not exists conversations (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid references customers(id),
  channel text check (channel in ('chat','whatsapp','voice')),
  transcript text, detected_intent text, outcome text,
  created_at timestamptz default now()
);

create table if not exists tickets (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid references customers(id),
  order_id uuid references orders(id),
  category text, priority text default 'high',
  status text default 'open', airtable_record_id text,
  summary text,                    -- complaint/issue text from chat or voice
  created_at timestamptz default now()
);

create table if not exists documents (
  id uuid primary key default gen_random_uuid(),
  drive_file_id text, title text, doc_type text,
  version int default 1, status text default 'active',
  last_synced timestamptz default now()
);

create table if not exists doc_chunks (
  id uuid primary key default gen_random_uuid(),
  document_id uuid references documents(id),
  chunk_index int, content text,
  embedding vector(1536), metadata jsonb
);

create table if not exists events (
  id uuid primary key default gen_random_uuid(),
  entity text, entity_id uuid, event_type text,
  detail jsonb, created_at timestamptz default now()
);

-- Similarity search function for direct/manual use (joins documents,
-- filters by doc_type). Kept for your own use outside n8n if useful.
create or replace function match_chunks(
  query_embedding vector(1536), match_count int default 5, filter_doc_type text default null
) returns table (content text, doc_type text, similarity float)
language sql stable as $$
  select c.content, d.doc_type,
         1 - (c.embedding <=> query_embedding) as similarity
  from doc_chunks c join documents d on d.id = c.document_id
  where d.status = 'active'
    and (filter_doc_type is null or d.doc_type = filter_doc_type)
  order by c.embedding <=> query_embedding
  limit match_count;
$$;

-- Second match function, shaped specifically for n8n's Supabase Vector
-- Store node — it always calls its RPC as (query_embedding, match_count,
-- filter jsonb) and expects (id, content, metadata, similarity) back.
-- No join to documents here: that node has no field to populate
-- doc_chunks.document_id on insert, so it always stays NULL — an inner
-- join on it would silently return nothing.
create or replace function match_doc_chunks (
    query_embedding vector(1536),
    match_count int default null,
    filter jsonb default '{}'
) returns table (
    id uuid,
    content text,
    metadata jsonb,
    similarity float
)
language plpgsql
as $$
begin
    return query
    select
        c.id,
        c.content,
        c.metadata,
        1 - (c.embedding <=> query_embedding) as similarity
    from doc_chunks c
    where (filter = '{}'::jsonb or c.metadata @> filter)
    order by c.embedding <=> query_embedding
    limit match_count;
end;
$$;
