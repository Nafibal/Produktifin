-- Create databases
CREATE DATABASE auth_db;
CREATE DATABASE pomodoro_db;
CREATE DATABASE history_db;
CREATE DATABASE calendar_db;

-- Create users
CREATE USER auth_user WITH PASSWORD 'auth_pass';
CREATE USER pomodoro_user WITH PASSWORD 'pomodoro_pass';
CREATE USER history_user WITH PASSWORD 'history_pass';
CREATE USER calendar_user WITH PASSWORD 'calendar_pass';

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE auth_db TO auth_user;
GRANT ALL PRIVILEGES ON DATABASE pomodoro_db TO pomodoro_user;
GRANT ALL PRIVILEGES ON DATABASE history_db TO history_user;
GRANT ALL PRIVILEGES ON DATABASE calendar_db TO calendar_user;
