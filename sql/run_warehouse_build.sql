-- CityPulse Analytics Warehouse build script
\i sql/raw/create_raw_tables.sql
\i sql/staging/create_staging_tables.sql
\i sql/warehouse/create_dimensions.sql
\i sql/warehouse/create_fact_service_requests.sql
\i sql/marts/create_reporting_views.sql
\i sql/quality/data_quality_checks.sql
