# Agium Sales Effort Dashboard

Eén-bestand HTML-dashboard om per week klantbezoeken, prospectbezoeken en
consultantbezoeken te loggen per sales medewerker, met propositie-registratie
en een dashboard-overzicht (totaal + per medewerker, alfabetisch).

Geen build-stap, geen framework. Live data via Supabase, hosting naar keuze
via GitHub Pages of Netlify.

## Stap 1 — Supabase-project aanmaken (of een bestaand project hergebruiken)

1. Heb je al een Supabase-project draaien (bijv. voor de referral tracker of
   het sales event dashboard) en tegen de gratis-projectlimiet aangelopen?
   Gebruik dan gewoon dat bestaande project — de tabelnaam `efforts` botst
   nergens mee. Anders: ga naar [supabase.com](https://supabase.com) en maak
   (gratis) een nieuw account/project aan.
2. Open in je project links **SQL Editor**.
3. Plak de inhoud van `schema.sql` erin en klik **Run**. Dit maakt de tabel
   `efforts` aan, met de juiste kolommen, checks en RLS-policies, en zet
   Realtime aan.
4. `seed_data.sql` hoef je niet te draaien — dat bestand is bewust leeg
   (schone lei, zie verderop). Alleen relevant als je zelf een paar
   voorbeeldregels wil toevoegen; zie de comments daarin.

## Stap 2 — Sleutels ophalen

1. Ga naar **Project Settings → API**.
2. Kopieer de **Project URL** en de **anon / public key**.
3. Open `index.html` in een teksteditor en vul bovenin het `<script>`-blok
   in bij:
   ```javascript
   const SUPABASE_URL = 'PLAATS_HIER_JE_SUPABASE_URL';
   const SUPABASE_ANON_KEY = 'PLAATS_HIER_JE_SUPABASE_ANON_KEY';
   ```
   Vervang de twee placeholder-strings door je eigen waarden (laat de
   aanhalingstekens staan).

## Stap 3 — Live zetten

**Optie A — GitHub Pages:**
```bash
git init
git add index.html schema.sql seed_data.sql README.md
git commit -m "Sales effort dashboard"
git branch -M main
git remote add origin https://github.com/<jouw-gebruikersnaam>/<repo-naam>.git
git push -u origin main
```
Of zonder terminal: maak een repository aan op [github.com](https://github.com),
**Add file → Upload files**, sleep de bestanden erin, **Commit changes**.
Zet daarna **Settings → Pages** aan (branch `main`, map `/ (root)`). Na
~1 minuut staat het dashboard op `https://<jouw-gebruikersnaam>.github.io/<repo-naam>/`.

**Optie B — Netlify (geen GitHub-account nodig):**
1. Ga naar [app.netlify.com/drop](https://app.netlify.com/drop).
2. Sleep de map met `index.html` (en de andere bestanden) in het browservenster.
3. Netlify geeft direct een live URL terug (bijv. `iets-random.netlify.app`),
   later aan te passen naar iets herkenbaars via **Site settings → Change
   site name**.
4. Update je het bestand later? Sleep de nieuwe versie gewoon opnieuw naar
   dezelfde site in het Netlify-dashboard.

Beide opties hosten alleen het bestand zelf — de data blijft in Supabase
staan, ongeacht welke van de twee je kiest.

## Schone lei — geen historische Excel-data

Dit dashboard start bewust leeg. Er is geen data overgenomen uit
`Performance_Management.xlsx` — dat bestand hield Afspraken/Aanvragen/
Plaatsingen bij, wat een andere manier van tellen is dan de Klantbezoek/
Prospect bezoek/Consultant bezoek-registratie die dit dashboard nu gebruikt.
Iedereen logt vanaf de eerste dag gewoon zelf zijn/haar efforts in via de
"+ Nieuwe effort"-knop in de Log-tab — geen import, geen aparte stap nodig.

De offline testversie (`index-test.html`) bevat wel een klein setje
voorbeelddata (16 regels, verspreid over de afgelopen paar weken) zodat je
meteen iets ziet in de grafieken; die staat los van de echte Supabase-data
en kan met de "Voorbeelddata resetten"-knop altijd teruggezet worden.

## Gebruik

- **Dashboard-tab**: KPI's en grafieken over de huidige selectie (filters
  bovenaan). De grafiek "Effort per medewerker" staat altijd op alfabetische
  volgorde — niet gesorteerd op aantal. Ook een "Laatst actief per
  medewerker"-tabel, zodat je in één oogopslag ziet wie een tijdje niks heeft
  gelogd.
- **Log-tab**: alle geregistreerde efforts als tabel, met een knop om een
  nieuwe effort toe te voegen (opent een pop-up) en potlood/prullenbak-iconen
  om te bewerken of te verwijderen. Verwijderen vraagt altijd om bevestiging.
- **Exporteren naar Excel / PDF**: beide knoppen staan naast elkaar in de
  Log-tab. Excel exporteert een gekozen periode (of alles) als `.xlsx`. PDF
  opent een pop-up waarin je een periode kiest én aanvinkt wat je wil
  meenemen (KPI's, grafieken, aantallen per medewerker, totalen, detail-log).
- Alle collega's die het dashboard open hebben staan, zien elkaars
  toevoegingen automatisch verschijnen (Supabase Realtime).

## Beveiliging — belangrijk om te weten

Dit dashboard heeft geen login. De Supabase anon-key staat zichtbaar in de
broncode van `index.html` — dat is normaal en op zichzelf geen lek (deze key
is bedoeld om publiek te zijn), maar de Row Level Security-policies staan
wel op "iedereen mag alles" (`using (true)`). Dat betekent: wie de live-URL
van het dashboard heeft, kan in principe ook zonder de UI rechtstreeks bij
de data. Voor een intern, niet-gevoelig effort-logboek is dat een prima
afweging; zet er geen persoonsgegevens (e-mail, telefoon, BSN e.d.) in,
want die horen sowieso niet in dit dashboard thuis — de tabel heeft er ook
geen kolommen voor.

## Werkt zonder internet-CDN's

Chart.js, de xlsx-library (Excel-export) en jsPDF + AutoTable (PDF-export)
staan **inline** in `index.html` en `index-test.html` gebakken, in plaats
van van een extern CDN geladen te worden. Dat is bewust gedaan: sommige
bedrijfsnetwerken blokkeren CDN's als cdnjs.cloudflare.com, en dan bleven
grafieken en de Log-tab eerder helemaal leeg staan zonder duidelijke reden.
Nu werkt alles ook op een afgeschermd bedrijfsnetwerk of volledig offline.
Alleen Supabase zelf (in `index.html`, niet in de testversie) heeft
uiteraard wél een live internetverbinding nodig — dat is de bedoeling, want
dat is je gedeelde backend.

Mocht je toch nog een leeg grafiekvak zien: het dashboard toont dan een
duidelijke melding in plaats van een stil leeg vlak, en de Log-tab en
KPI's blijven gewoon werken (die zijn niet afhankelijk van Chart.js).

## Bestanden

| Bestand | Doel |
|---|---|
| `index.html` | Het volledige dashboard (UI + logica) |
| `schema.sql` | Tabel + RLS-policies + realtime, één keer draaien |
| `seed_data.sql` | Uitleg + optionele voorbeeldregels (geen historische data — zie bestand) |
| `README.md` | Dit bestand |
