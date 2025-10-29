CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE SCHEMA IF NOT EXISTS pomodoro;

CREATE TABLE sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NULL,
    status TEXT NOT NULL CHECK (status IN ('running','paused','finished','planned')),
    duration_pomodoro_minutes INT NOT NULL DEFAULT 25,
    duration_short_break_minutes INT NOT NULL DEFAULT 5,
    duration_long_break_minutes INT NOT NULL DEFAULT 15,
    long_break_interval INT NOT NULL DEFAULT 4,
    pomodoro_count INT NOT NULL DEFAULT 0,
    short_break_count INT NOT NULL DEFAULT 0,
    long_break_count INT NOT NULL DEFAULT 0,
    total_focused_seconds INT NOT NULL DEFAULT 0,
    progress_seconds INT NOT NULL DEFAULT 0,
    start_time TIMESTAMPTZ,
    end_time TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at TIMESTAMPTZ
);
CREATE INDEX idx_sessions_user_status ON sessions(user_id, status);
CREATE INDEX idx_sessions_start_time ON sessions(start_time);

CREATE TABLE tasks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id UUID NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    is_done BOOL NOT NULL DEFAULT false,
    position INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_tasks_session ON tasks(session_id);
