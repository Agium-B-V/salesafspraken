-- Agium Sales Effort Dashboard — schema
-- Voer dit één keer uit in de Supabase SQL editor van je project.
--
-- Kan gewoon in een bestaand Supabase-project (bijv. dat van de referral
-- tracker of het sales event dashboard) — de tabelnaam 'efforts' botst
-- nergens mee, dus je hoeft hiervoor geen nieuw project aan te maken.

create table if not exists efforts (
  id uuid primary key default gen_random_uuid(),
  medewerker text not null check (medewerker in (
    'Arno', 'Ghislaine', 'Joost', 'Marc', 'Max', 'Olaf', 'Roberto', 'Sander'
  )),
  type text not null check (type in (
    'Klantbezoek', 'Prospect bezoek', 'Consultant bezoek'
  )),
  propositie text not null default '-' check (propositie in (
    '-', 'ABS', 'AI', 'Deta', 'W&S', 'Kerst', 'Events', 'Golf', 'ABC'
  )),
  naam_notitie text,
  jaar int not null,
  week int not null check (week between 1 and 53),
  created_at timestamptz not null default now()
);

create index if not exists efforts_jaar_week_idx on efforts (jaar, week);
create index if not exists efforts_medewerker_idx on efforts (medewerker);

-- Row Level Security: publieke read/write policies.
-- Prima voor een intern tool zonder login. De publishable/anon-key staat
-- zichtbaar in index.html — dat is normaal (geen lek), maar betekent ook
-- dat dit geen echte toegangscontrole is. Zet dit dashboard dus niet open
-- op internet als er gevoelige data bij komt.
alter table efforts enable row level security;

create policy "efforts_public_select" on efforts
  for select using (true);

create policy "efforts_public_insert" on efforts
  for insert with check (true);

create policy "efforts_public_update" on efforts
  for update using (true);

create policy "efforts_public_delete" on efforts
  for delete using (true);

-- Realtime aanzetten zodat wijzigingen van collega's automatisch verschijnen.
alter publication supabase_realtime add table efforts;
