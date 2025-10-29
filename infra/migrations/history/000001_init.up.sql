CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE SCHEMA IF NOT EXISTS history;

CREATE TABLE history.sessions_archive (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    original_session_id UUID,
    user_id UUID NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('finished','paused','planned')),
    pomodoro_count INT NOT NULL DEFAULT 0,
    short_break_count INT NOT NULL DEFAULT 0,
    long_break_count INT NOT NULL DEFAULT 0,
    duration_pomodoro_minutes INT NOT NULL DEFAULT 25,
    duration_short_break_minutes INT NOT NULL DEFAULT 5,
    duration_long_break_minutes INT NOT NULL DEFAULT 15,
    total_focused_seconds INT NOT NULL DEFAULT 0,
    start_time TIMESTAMPTZ,
    end_time TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_history_user_date ON history.sessions_archive(user_id, created_at DESC);

CREATE TABLE history.session_tasks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    archived_session_id UUID NOT NULL REFERENCES history.sessions_archive(id) ON DELETE CASCADE,
    tasks JSONB NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE history.daily_user_aggregates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    date_date DATE NOT NULL,
    total_pomodoros INT NOT NULL DEFAULT 0,
    total_focused_seconds INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(user_id, date_date)
);
CREATE INDEX idx_aggregates_user_date ON history.daily_user_aggregates(user_id, date_date DESC);
