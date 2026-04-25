\echo 'Starting CityPulse integrated warehouse build...'

\i sql/staging/create_staging_tables.sql
\i sql/integration/import_from_citypulse_etl.sql
\i sql/warehouse/create_dimensions.sql
\i sql/warehouse/create_fact_service_requests.sql
\i sql/warehouse/add_constraints.sql
\i sql/incremental/load_fact_incremental.sql
\i sql/warehouse/scd2_dim_location.sql
\i sql/marts/create_reporting_views.sql
\i sql/quality/data_quality_checks.sql

\echo 'CityPulse integrated warehouse build complete.'
