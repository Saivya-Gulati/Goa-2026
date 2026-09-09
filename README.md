# Goa Trip 2026 — Scrapbook

A shared travel scrapbook: notes, a packing checklist, and a photo pinboard. Built as a single static site (no build step), so it deploys straight to Vercel and connects to Supabase for shared storage — everything below can be done from your phone's browser.

## What's included
- `index.html` — the whole app (HTML/CSS/JS, no build tools needed)
- `schema.sql` — sets up your Supabase database + starter packing list

## 1. Set up Supabase (5 min)
1. Go to [supabase.com](https://supabase.com) → sign up → **New project**
2. Once it's ready, go to **SQL Editor → New query**
3. Open `schema.sql` from this folder, copy all of it, paste it in, hit **Run**
4. Go to **Storage → Create bucket** → name it exactly `pins` → toggle **Public bucket: ON** → Create
5. Still in Storage → click into the `pins` bucket → **Policies** → add two policies:
   - **SELECT** (read) → `USING (true)`
   - **INSERT** (upload) → `WITH CHECK (true)`
6. Go to **Settings → API** → copy your **Project URL** and **anon public key** — you'll need these next

## 2. Connect the app to Supabase
Open `index.html` (you can edit it right in GitHub's mobile web editor — see step 3) and find this near the top of the `<script>` section:

```js
const CONFIG = {
  SUPABASE_URL: "YOUR_SUPABASE_URL",
  SUPABASE_ANON_KEY: "YOUR_SUPABASE_ANON_KEY",
  TRIP_NAME: "Goa Trip 2026",
  TRIP_DATE: "2026-12-20T00:00:00"
};
```

Paste in your Project URL and anon key, and set `TRIP_DATE` to your actual travel date. Save.

## 3. Put it on GitHub (from your phone)
1. Go to [github.com](https://github.com) → sign up if needed → **New repository** (e.g. `goa-trip-2026`)
2. On the repo page, tap **Add file → Upload files**
3. Upload `index.html` and `schema.sql` (schema.sql is just for reference, doesn't need to be there, but fine to keep)
4. Commit directly to the `main` branch

## 4. Deploy on Vercel (from your phone)
1. Go to [vercel.com](https://vercel.com) → sign up with your GitHub account
2. **Add New → Project** → select your `goa-trip-2026` repo → **Import**
3. Leave all settings as default (it's a static site, no framework/build needed) → **Deploy**
4. In ~30 seconds you'll get a live URL like `goa-trip-2026.vercel.app` — share that link with your partner

## Using the app
- **Home** — trip title + live countdown (edit `TRIP_DATE` in the config to change it)
- **Notes** — cafes, songs, photo spots, day-trip ideas; filter by category with the chips
- **Packing** — pre-loaded with 20+ beach-trip essentials, grouped by category; check items off as you pack, add your own
- **Pinboard** — tap the **+** button to upload a photo with a caption, location, font style, and a sticker; it appears as a tilted polaroid on the corkboard

Both of you can open the same link — notes, checklist changes, and new pins show up live for each other (no refresh needed).

## Making it more "fancy" later
The current design uses CSS only (no image assets required), so it works out of the box. If you generate scrapbook assets with Gemini (background textures, stickers, washi tape, etc.), you can drop them into a `/assets` folder in the repo and reference them in the CSS — happy to wire that up once you have them.

## Troubleshooting
- **Red banner at the top of the site** → Supabase isn't connected yet; double check `SUPABASE_URL` and `SUPABASE_ANON_KEY` in `index.html`
- **Photo upload fails** → check the `pins` storage bucket exists, is public, and has the two policies from step 1
- **Notes/checklist not saving** → make sure `schema.sql` ran successfully with no errors in the SQL Editor
