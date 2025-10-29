# =========================================
# Produktifin Makefile — Database Migrations
# =========================================

# Default database URLs (override with .env)
include .env
export

# Migration directories
MIGRATIONS_DIR=infra/migrations

# Migrate command (use docker if CLI not installed locally)
MIGRATE ?= migrate

# ==============
# MIGRATION TASKS
# ==============

## Create a new migration for a service
## Usage: make migrate-new service=auth name=create_users_table
migrate-new:
	@if [ -z "$(service)" ] || [ -z "$(name)" ]; then \
		echo "Usage: make migrate-new service=<auth|pomodoro|history|calendar> name=<description>"; \
		exit 1; \
	fi
	@mkdir -p $(MIGRATIONS_DIR)/$(service)
	@$(MIGRATE) create -seq -ext sql -dir $(MIGRATIONS_DIR)/$(service) $(name)

## Run migrations up
## Usage: make migrate-up service=auth
migrate-up:
	@if [ -z "$(service)" ]; then \
		echo "Usage: make migrate-up service=<auth|pomodoro|history|calendar>"; \
		exit 1; \
	fi
	@echo "🚀 Running UP migrations for $(service)"
	@case $(service) in \
		auth) DB_URL=$(AUTH_DB_URL);; \
		pomodoro) DB_URL=$(POMODORO_DB_URL);; \
		history) DB_URL=$(HISTORY_DB_URL);; \
		calendar) DB_URL=$(CALENDAR_DB_URL);; \
	esac; \
	$(MIGRATE) -path $(MIGRATIONS_DIR)/$(service) -database $$DB_URL up

## Run migrations down (rollback)
## Usage: make migrate-down service=auth
migrate-down:
	@if [ -z "$(service)" ]; then \
		echo "Usage: make migrate-down service=<auth|pomodoro|history|calendar>"; \
		exit 1; \
	fi
	@echo "⚠️ Rolling BACK migrations for $(service)"
	@case $(service) in \
		auth) DB_URL=$(AUTH_DB_URL);; \
		pomodoro) DB_URL=$(POMODORO_DB_URL);; \
		history) DB_URL=$(HISTORY_DB_URL);; \
		calendar) DB_URL=$(CALENDAR_DB_URL);; \
	esac; \
	$(MIGRATE) -path $(MIGRATIONS_DIR)/$(service) -database $$DB_URL down

## Drop all tables for a service
## Usage: make migrate-drop service=auth
migrate-drop:
	@if [ -z "$(service)" ]; then \
		echo "Usage: make migrate-drop service=<auth|pomodoro|history|calendar>"; \
		exit 1; \
	fi
	@echo "💣 Dropping all tables for $(service)"
	@case $(service) in \
		auth) DB_URL=$(AUTH_DB_URL);; \
		pomodoro) DB_URL=$(POMODORO_DB_URL);; \
		history) DB_URL=$(HISTORY_DB_URL);; \
		calendar) DB_URL=$(CALENDAR_DB_URL);; \
	esac; \
	$(MIGRATE) -path $(MIGRATIONS_DIR)/$(service) -database $$DB_URL drop -f

## Check migration version
## Usage: make migrate-version service=auth
migrate-version:
	@if [ -z "$(service)" ]; then \
		echo "Usage: make migrate-version service=<auth|pomodoro|history|calendar>"; \
		exit 1; \
	fi
	@case $(service) in \
		auth) DB_URL=$(AUTH_DB_URL);; \
		pomodoro) DB_URL=$(POMODORO_DB_URL);; \
		history) DB_URL=$(HISTORY_DB_URL);; \
		calendar) DB_URL=$(CALENDAR_DB_URL);; \
	esac; \
	$(MIGRATE) -path $(MIGRATIONS_DIR)/$(service) -database $$DB_URL version
