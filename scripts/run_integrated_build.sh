#!/usr/bin/env bash
set -euo pipefail

export PGPASSWORD="${POSTGRES_PASSWORD:-citypulse_pass}"
psql -h localhost -U citypulse_user -d citypulse_warehouse -f sql/run_citypulse_integrated_build.sql
psql -h localhost -U citypulse_user -d citypulse_warehouse -f sql/analytics/example_service_queries.sql
