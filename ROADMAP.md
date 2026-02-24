# Client Hub — Development Roadmap

## Phase 1: Deploy & Persist (This Week)
**Goal:** Get the app live and saving data to a real database.

- [x] Build client-first unified inbox (React single-file app)
- [x] All core features: client CRUD, messages, templates, analytics, export
- [x] Supabase integration (auth + database)
- [x] Login/signup screen
- [x] Connected Accounts UI in Settings
- [ ] Push to GitHub
- [ ] Deploy to Vercel
- [ ] Create Supabase project & run schema
- [ ] Add credentials and go live
- [ ] Create your account and verify it works

**Time estimate:** 30–60 minutes of setup

---

## Phase 2: Gmail Sync (Weeks 2–3)
**Goal:** Pull real emails into the inbox automatically.

- [ ] Set up Google Cloud project + OAuth credentials
- [ ] Build Supabase Edge Function for OAuth token exchange
- [ ] Build Gmail sync worker (pulls emails every 15 min)
- [ ] Map emails to clients by sender address
- [ ] Store synced messages in Supabase
- [ ] Add "Send via Gmail" from the compose modal
- [ ] Handle Gmail push notifications (optional: real-time)

**Time estimate:** 8–12 hours of development

### Gmail Architecture
```
User clicks "Connect Gmail"
  → Redirect to Google OAuth
  → Google sends auth code to your callback URL
  → Supabase Edge Function exchanges code for tokens
  → Tokens stored in platform_connections table
  → Cron job (or Supabase scheduled function) fetches new emails
  → New emails inserted into messages table
  → App shows them in real-time
```

---

## Phase 3: More Platforms (Weeks 4–6)
**Goal:** Add Slack, Instagram, and Messenger syncing.

### Slack (Easiest after Gmail)
- [ ] Create Slack App at api.slack.com
- [ ] OAuth flow (similar to Gmail)
- [ ] Subscribe to message events via Webhooks
- [ ] Sync DMs and channel mentions

### Instagram DMs (Requires Business Account)
- [ ] Meta Business Suite setup
- [ ] Instagram Graph API access
- [ ] Webhook for new DMs
- [ ] Media attachment handling

### Facebook Messenger
- [ ] Meta App setup (can share with Instagram)
- [ ] Messenger Platform API
- [ ] Webhook subscription
- [ ] Rich message support (images, buttons)

### LinkedIn (Limited API)
- [ ] LinkedIn Developer App
- [ ] Messaging API (requires partner program for full access)
- [ ] May need manual sync or browser extension approach

### Zoom
- [ ] Zoom Marketplace App
- [ ] Meeting/chat webhook subscriptions
- [ ] Calendar integration for scheduled calls

**Time estimate:** 4–8 hours per platform

---

## Phase 4: Polish & Scale (Weeks 7–8)
**Goal:** Production hardening and quality-of-life improvements.

- [ ] Real-time updates via Supabase Realtime subscriptions
- [ ] Push notifications (browser + mobile via PWA)
- [ ] File/image attachment support
- [ ] Search across all messages (full-text search)
- [ ] Client activity timeline view
- [ ] Email signature support
- [ ] Custom domain for the app
- [ ] PWA manifest (installable on phone home screen)
- [ ] Rate limiting and error retry logic
- [ ] Automated daily backup to cloud storage

---

## Phase 5: Advanced Features (Month 3+)
**Goal:** Power features as the business grows.

- [ ] AI-powered reply suggestions
- [ ] Automated follow-up reminders
- [ ] Client onboarding checklist template
- [ ] Invoice/proposal tracking per client
- [ ] Team member support (if you hire)
- [ ] Zapier/Make integration for automation
- [ ] Mobile app (React Native or PWA)
- [ ] Custom reporting and white-label client portal

---

## Tech Stack Summary

| Layer | Technology | Cost |
|-------|-----------|------|
| Frontend | React 18 + Tailwind (single HTML) | Free |
| Hosting | Vercel | Free tier |
| Database | Supabase (Postgres) | Free tier (500MB) |
| Auth | Supabase Auth | Free tier |
| Email Sync | Gmail API + Supabase Edge Functions | Free tier |
| Domain | Custom domain (optional) | ~$12/year |

**Total cost to start: $0/month** (free tiers cover a solo operation easily)
