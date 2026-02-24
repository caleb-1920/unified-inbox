-- ============================================================
--  Client Hub — Supabase Schema
--  Run this entire file in your Supabase SQL Editor
--  (Dashboard → SQL Editor → New Query → paste → Run)
-- ============================================================

-- Enable UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


-- ─────────────────────────────────────────────
--  TABLES
-- ─────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS clients (
  id               UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id          UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  name             TEXT NOT NULL,
  business_type    TEXT DEFAULT '',
  status           TEXT DEFAULT 'lead'
                     CHECK (status IN ('lead','active','waiting','completed')),
  platforms        TEXT[]   DEFAULT '{}',
  budget           INTEGER  DEFAULT 0,
  email            TEXT     DEFAULT '',
  phone            TEXT     DEFAULT '',
  notes            JSONB    DEFAULT '[]',
  tags             TEXT[]   DEFAULT '{}',
  favorite         BOOLEAN  DEFAULT FALSE,
  pinned           BOOLEAN  DEFAULT FALSE,
  archived         BOOLEAN  DEFAULT FALSE,
  last_contact     TIMESTAMPTZ DEFAULT NOW(),
  created_at       TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS messages (
  id                  UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id             UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  client_id           UUID REFERENCES clients(id) ON DELETE CASCADE NOT NULL,
  platform            TEXT NOT NULL,
  sender              TEXT NOT NULL DEFAULT 'you',
  text                TEXT NOT NULL,
  read                BOOLEAN DEFAULT FALSE,
  status              TEXT DEFAULT 'sent',
  platform_message_id TEXT,          -- for deduplication when syncing from APIs
  created_at          TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS templates (
  id         UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id    UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  title      TEXT NOT NULL,
  category   TEXT DEFAULT '',
  text       TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Stores OAuth tokens for Gmail, Slack, etc.
CREATE TABLE IF NOT EXISTS platform_connections (
  id               UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id          UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  platform         TEXT NOT NULL,          -- 'gmail', 'slack', 'instagram', etc.
  access_token     TEXT,
  refresh_token    TEXT,
  token_expires_at TIMESTAMPTZ,
  account_email    TEXT,
  account_name     TEXT,
  is_active        BOOLEAN DEFAULT TRUE,
  created_at       TIMESTAMPTZ DEFAULT NOW(),
  updated_at       TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, platform)
);


-- ─────────────────────────────────────────────
--  ROW LEVEL SECURITY  (keeps your data private)
-- ─────────────────────────────────────────────

ALTER TABLE clients             ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages            ENABLE ROW LEVEL SECURITY;
ALTER TABLE templates           ENABLE ROW LEVEL SECURITY;
ALTER TABLE platform_connections ENABLE ROW LEVEL SECURITY;

-- Each table: only the owner can read/write their rows
CREATE POLICY "owner_clients"      ON clients              FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "owner_messages"     ON messages             FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "owner_templates"    ON templates            FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "owner_connections"  ON platform_connections FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);


-- ─────────────────────────────────────────────
--  INDEXES  (keeps queries fast)
-- ─────────────────────────────────────────────

CREATE INDEX IF NOT EXISTS clients_user_id_idx       ON clients(user_id);
CREATE INDEX IF NOT EXISTS clients_archived_idx      ON clients(user_id, archived);
CREATE INDEX IF NOT EXISTS messages_client_id_idx    ON messages(client_id);
CREATE INDEX IF NOT EXISTS messages_user_id_idx      ON messages(user_id);
CREATE INDEX IF NOT EXISTS messages_created_at_idx   ON messages(created_at DESC);
CREATE INDEX IF NOT EXISTS templates_user_id_idx     ON templates(user_id);
CREATE INDEX IF NOT EXISTS connections_user_id_idx   ON platform_connections(user_id);


-- ─────────────────────────────────────────────
--  AUTO-UPDATE updated_at on platform_connections
-- ─────────────────────────────────────────────

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON platform_connections
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
