#!/usr/bin/env bash
set -euo pipefail

HOST_NAME=${HOST_NAME:-localhost}
DATABASE=${DATABASE:-citypulse}
USER_NAME=${USER_NAME:-citypulse}

echo "Running CityPulse full lineage warehouse build..."
psql -h "$HOST_NAME" -U "$USER_NAME" -d "$DATABASE" -f sql/run_citypulse_integrated_build.sql
