-- CityPulse Analytics Warehouse data quality checks
-- These checks are written as readable SQL so they can be explained during interviews.

-- 1. Confirm staging has records after importing from CityPulse ETL.
SELECT 'staging_row_count' AS check_name, COUNT(*) AS value
FROM staging.service_requests;

-- 2. Check for duplicate request IDs.
SELECT 'duplicate_request_ids' AS check_name, COUNT(*) AS value
FROM (
    SELECT request_id
    FROM staging.service_requests
    GROUP BY request_id
    HAVING COUNT(*) > 1
) duplicates;

-- 3. Check missing created timestamps.
SELECT 'missing_created_at' AS check_name, COUNT(*) AS value
FROM staging.service_requests
WHERE created_at IS NULL;

-- 4. Check fact table matches staging row count.
SELECT 'fact_vs_staging_difference' AS check_name,
       (SELECT COUNT(*) FROM staging.service_requests)
       -
       (SELECT COUNT(*) FROM warehouse.fact_service_requests) AS value;

-- 5. Check that every fact record joined to required dimensions.
SELECT 'fact_missing_dimension_keys' AS check_name, COUNT(*) AS value
FROM warehouse.fact_service_requests
WHERE date_key IS NULL
   OR location_key IS NULL
   OR request_type_key IS NULL
   OR status_key IS NULL;

-- 6. Identify impossible negative resolution times.
SELECT 'negative_resolution_hours' AS check_name, COUNT(*) AS value
FROM warehouse.fact_service_requests
WHERE resolution_hours < 0;
