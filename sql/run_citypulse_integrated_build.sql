-- CityPulse Analytics Warehouse integrated build
-- Main path: run this after the CityPulse ETL pipeline loads public.service_requests.

\i sql/integration/import_from_citypulse_etl.sql
\i sql/warehouse/create_dimensions.sql
\i sql/warehouse/create_fact_service_requests.sql
\i sql/marts/create_reporting_views.sql
\i sql/quality/data_quality_checks.sql
