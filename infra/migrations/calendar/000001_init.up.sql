CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    scheduled_start TIMESTAMPTZ NOT NULL,
    duration_minutes INT NOT NULL DEFAULT 25,
    repeat_type TEXT NOT NULL DEFAULT 'none',
    repeat_until TIMESTAMPTZ,
    status TEXT NOT NULL CHECK (status IN ('planned','cancelled','completed')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_events_user_date ON events(user_id, scheduled_start);
CREATE INDEX idx_events_status ON events(status);
