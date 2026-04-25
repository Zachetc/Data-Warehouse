# Run this after the CityPulse ETL pipeline has loaded public.service_requests.
# Example:
#   .\scripts\run_integrated_build.ps1

$env:PGPASSWORD = $env:POSTGRES_PASSWORD
if (-not $env:PGPASSWORD) { $env:PGPASSWORD = "citypulse_pass" }

psql -h localhost -U citypulse_user -d citypulse_warehouse -f sql/run_citypulse_integrated_build.sql
psql -h localhost -U citypulse_user -d citypulse_warehouse -f sql/analytics/example_service_queries.sql
