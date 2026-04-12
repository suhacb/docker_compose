# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is the central Docker Compose orchestration repository for a food/nutrition management platform. The actual application source code lives outside this repo in sibling directories (e.g., `/home/blaz/projects/src/[service_name]`). This repo only contains Docker configuration.

## Starting and Stopping Services

All services together (ordered):
```bash
./nutrients.sh up    # starts: keycloak → airflow → fooddata → auth_backend → nutrients_backend → auth_frontend → nutrients_frontend
./nutrients.sh down  # stops in reverse order
```

Individual service:
```bash
cd [service_name]
docker compose up -d
docker compose down
```

## Common Docker Commands per Service

PHP/Laravel services (auth_backend, nutrients_backend, fooddata):
```bash
docker compose run --rm artisan migrate
docker compose run --rm artisan migrate:fresh --seed
docker compose run --rm artisan tinker
docker compose run --rm php composer install
docker compose run --rm php composer require [package]
```

Angular services (auth_frontend, nutrients_frontend):
```bash
docker compose run --rm npm install
docker compose run --rm npm run [script]
```

## Architecture

### Services and Ports

| Service | URL | Stack |
|---|---|---|
| nutrients_frontend | http://localhost:9010 | Angular (Node 22 Alpine) |
| nutrients_backend | http://localhost:9015 | PHP 8.3-FPM + Nginx + MySQL 9.4 |
| nutrients_backend PHPMyAdmin | http://localhost:9016 | |
| nutrients_backend Zinc Search | http://localhost:9017 | |
| nutrients_backend Qdrant | http://localhost:9012 | vector DB |
| nutrients_backend RabbitMQ AMQP | localhost:9013 | |
| nutrients_backend RabbitMQ UI | http://localhost:9014 | |
| auth_frontend | http://localhost:9020 | Angular (Node 22 Alpine) |
| auth_backend | http://localhost:9025 | PHP 8.3-FPM + Nginx + MySQL 9.4 |
| auth_backend PHPMyAdmin | http://localhost:9026 | |
| Keycloak | http://localhost:7080 | Keycloak 26.4 + MySQL 9.4 |
| Keycloak PHPMyAdmin | http://localhost:9091 | |
| Airflow | http://localhost:9030 | Airflow 2.10.2 + PostgreSQL 15 |
| fooddata MongoDB | localhost:9045 | MongoDB 7 |
| fooddata Mongo Express | http://localhost:9046 | |

### Network Isolation

Each service group runs on its own Docker network (`auth`, `nutrients`, `keycloak`, `fooddata`, `airflow`). Services can only communicate within their network by default.

### PHP Container Pattern

All PHP-based services follow the same structure:
- `app` — Nginx reverse proxy (main entry port)
- `php` — PHP 8.3-FPM (runs Composer)
- `artisan` — Laravel CLI (runs Artisan commands)
- `db` — MySQL 9.4
- `phpmyadmin` — PHPMyAdmin 5.2

PHP containers use `PUID`/`PGID` env vars to run as the host user (`www-data`, UID 1000/GID 1000). This prevents file permission issues on Linux when source code is bind-mounted.

### Angular Container Pattern

Both frontends follow the same structure:
- `app` — `ng serve` on internal port 4200, exposed on the service port
- `npm` — one-off container for running npm commands

### Configuration Pattern

Each service directory contains a `.env` file (based on `.env.example`). Key variables follow a consistent pattern:
- `APP_PORT` — the externally exposed port for the main app
- `NETWORK` — the Docker network name
- Database credentials use `MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_ROOT_PASSWORD`

Port scheme: `9XXY` where `XX` is the project code and `Y` is the service offset (0=app, 1=phpmyadmin, 2=db, etc.).

### Xdebug

PHP services have Xdebug configured on port `9003` for step-through debugging. The `XDEBUG_MODE` and `XDEBUG_CONFIG` env vars control its behavior.
