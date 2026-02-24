# Client Hub — Setup Guide

Complete guide to get your Unified Inbox live on the web.

---

## Step 1: Create a GitHub Repository

1. Go to [github.com/new](https://github.com/new)
2. Name it `client-hub` (or whatever you prefer)
3. Set it to **Private** (your client data will eventually live here)
4. **Don't** add a README (we already have files)
5. Click **Create repository**

Then push your files:

```bash
cd /path/to/your/files
git init
git add unified-inbox.html vercel.json .gitignore supabase-schema.sql SETUP.md ROADMAP.md
git commit -m "Initial commit — Client Hub"
git remote add origin https://github.com/YOUR_USERNAME/client-hub.git
git branch -M main
git push -u origin main
```

---

## Step 2: Deploy to Vercel

1. Go to [vercel.com](https://vercel.com) and sign in with GitHub
2. Click **"Add New Project"**
3. Import your `client-hub` repository
4. Framework Preset: **Other**
5. Click **Deploy**
6. Your app is now live at `https://client-hub-xxxx.vercel.app`

Optional: Add a custom domain in Vercel's project settings.

---

## Step 3: Set Up Supabase

### Create Your Project

1. Go to [supabase.com](https://supabase.com) and sign up (free)
2. Click **New Project**
3. Name: `client-hub`
4. Choose a **strong database password** (save it somewhere safe)
5. Region: Pick the closest to you
6. Click **Create new project** (takes ~2 minutes)

### Run the Database Schema

1. In your Supabase dashboard, go to **SQL Editor** (left sidebar)
2. Click **New Query**
3. Open `supabase-schema.sql` from your repo
4. Copy-paste the **entire file** into the SQL editor
5. Click **Run** — you should see "Success"

### Get Your Credentials

1. Go to **Settings → API** in Supabase
2. Copy **Project URL** — looks like `https://abcdef123.supabase.co`
3. Copy **anon public** key (the long string under "Project API keys")

### Add Credentials to Your App

Open `unified-inbox.html` and find these lines near the top:

```javascript
const SUPABASE_URL  = 'https://YOUR_PROJECT_ID.supabase.co';
const SUPABASE_KEY  = 'YOUR_ANON_PUBLIC_KEY';
```

Replace with your actual values:

```javascript
const SUPABASE_URL  = 'https://abcdef123.supabase.co';
const SUPABASE_KEY  = 'eyJhbGciOiJIUzI1NiIs...your-actual-key';
```

Commit and push — Vercel auto-deploys.

### Create Your Account

1. Visit your live site
2. Click **"Don't have an account? Sign up"**
3. Enter your email and password
4. Check your email for the confirmation link
5. Click it, then sign in — you're live!

---

## Step 4: Gmail Integration (Coming Soon)

Gmail requires a Google Cloud project and OAuth credentials. Here's the prep:

### Create a Google Cloud Project

1. Go to [console.cloud.google.com](https://console.cloud.google.com)
2. Create a new project called `client-hub`
3. Enable the **Gmail API** (APIs & Services → Library → search "Gmail")
4. Go to **APIs & Services → Credentials**
5. Click **Create Credentials → OAuth 2.0 Client ID**
6. Application type: **Web application**
7. Authorized redirect URI: `https://YOUR-SITE.vercel.app/auth/google/callback`
8. Save your **Client ID** and **Client Secret**

The actual OAuth flow and message syncing will be built as a Supabase Edge Function in Phase 3 of the roadmap.

---

## File Overview

| File | Purpose |
|------|---------|
| `unified-inbox.html` | The entire app (React + Tailwind, single file) |
| `vercel.json` | Tells Vercel how to serve the app |
| `.gitignore` | Keeps secrets out of git |
| `supabase-schema.sql` | Database tables, security policies, indexes |
| `SETUP.md` | This file |
| `ROADMAP.md` | Development timeline and phases |

---

## Troubleshooting

**"Demo Mode" banner still showing?**
→ Make sure your Supabase URL doesn't contain `YOUR_PROJECT`

**Can't sign up / "User already registered"?**
→ Check your email for the Supabase confirmation link

**Data not saving?**
→ Check browser console (F12) for errors. Verify your anon key is correct.

**Vercel not updating?**
→ Make sure you pushed to the `main` branch. Check Vercel dashboard for build status.
