-- ============================================================
-- Goa Trip 2026 Scrapbook — Supabase schema
-- Run this in: Supabase Dashboard → SQL Editor → New query → Run
-- ============================================================

-- 1. NOTES (packing ideas, cafes, music, photo spots, custom categories)
create table if not exists notes (
  id uuid primary key default gen_random_uuid(),
  category text not null,            -- e.g. 'Cafes to explore', 'Music to hear', 'Photo spots'
  content text not null,
  author text,                       -- 'You' or partner's name, free text
  created_at timestamptz default now()
);

-- 2. PACKING CHECKLIST
create table if not exists checklist_items (
  id uuid primary key default gen_random_uuid(),
  item text not null,
  category text default 'General',   -- e.g. 'Beach', 'Documents', 'Electronics'
  is_checked boolean default false,
  added_by text,
  is_default boolean default false,  -- true for the pre-suggested starter items
  created_at timestamptz default now()
);

-- 3. PINBOARD MEMORIES
create table if not exists pins (
  id uuid primary key default gen_random_uuid(),
  image_url text not null,
  caption text,
  location_name text,
  memory_date date,
  font_theme text default 'handwritten',   -- 'handwritten' | 'typewriter' | 'elegant' | 'playful'
  sticker text,                             -- emoji or sticker id placed on the pin
  rotation int default 0,                   -- -8 to 8 degrees, for the scrapbook tilt
  author text,
  created_at timestamptz default now()
);

-- ============================================================
-- Row Level Security — since this is just the two of you sharing
-- one app with no public signups, we keep it simple: anyone with
-- your anon key (i.e. your deployed site) can read/write.
-- If you later add real login, tighten these policies.
-- ============================================================
alter table notes enable row level security;
alter table checklist_items enable row level security;
alter table pins enable row level security;

create policy "allow all on notes" on notes for all using (true) with check (true);
create policy "allow all on checklist_items" on checklist_items for all using (true) with check (true);
create policy "allow all on pins" on pins for all using (true) with check (true);

-- ============================================================
-- Seed data: pre-suggested beach vacation packing list
-- ============================================================
insert into checklist_items (item, category, is_default) values
  ('Sunscreen (SPF 50)', 'Beach', true),
  ('Swimwear', 'Beach', true),
  ('Flip-flops / slides', 'Beach', true),
  ('Sunglasses', 'Beach', true),
  ('Beach hat', 'Beach', true),
  ('Beach towel', 'Beach', true),
  ('Waterproof phone pouch', 'Beach', true),
  ('Aloe vera / after-sun gel', 'Beach', true),
  ('ID / passport', 'Documents', true),
  ('Travel tickets & bookings', 'Documents', true),
  ('Travel insurance copy', 'Documents', true),
  ('Power bank', 'Electronics', true),
  ('Chargers & cables', 'Electronics', true),
  ('Camera', 'Electronics', true),
  ('Earphones', 'Electronics', true),
  ('Light cotton clothes', 'Clothing', true),
  ('One nice outfit for dinner', 'Clothing', true),
  ('Light jacket for AC / evenings', 'Clothing', true),
  ('Insect repellent', 'Health', true),
  ('Basic first-aid / medicines', 'Health', true),
  ('Reusable water bottle', 'Health', true),
  ('Cash & cards', 'Essentials', true),
  ('Snacks for the road', 'Essentials', true)
on conflict do nothing;

-- ============================================================
-- Storage: run these two steps manually in the dashboard
-- (SQL editor can't create buckets)
-- ============================================================
-- 1. Go to Storage → Create bucket → name it: pins  → Public bucket: ON
-- 2. Storage → pins bucket → Policies → New policy → allow INSERT and SELECT
--    for everyone (since it's just you two, keep it simple):
--      Policy: "Public read"  → SELECT → USING (true)
--      Policy: "Public upload" → INSERT → WITH CHECK (true)
