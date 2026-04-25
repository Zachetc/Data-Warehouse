-- CityPulse warehouse quality checks.
-- These are designed to catch problems at the staging, warehouse, and mart layers.

-- 1. Staging should not contain duplicate request IDs.
SELECT
    'duplicate_request_ids_in_staging' AS check_name,
    COUNT(*) AS failed_records
FROM (
    SELECT request_id
    FROM staging.service_requests
    GROUP BY request_id
    HAVING COUNT(*) > 1
) dupes;

-- 2. Required event timestamp should exist.
SELECT
    'missing_created_at_in_staging' AS check_name,
    COUNT(*) AS failed_records
FROM staging.service_requests
WHERE created_at IS NULL;

-- 3. Fact table should not contain orphaned dimension keys.
SELECT
    'orphaned_date_keys' AS check_name,
    COUNT(*) AS failed_records
FROM warehouse.fact_service_requests f
LEFT JOIN warehouse.dim_date d ON f.date_key = d.date_key
WHERE d.date_key IS NULL;

SELECT
    'orphaned_location_keys' AS check_name,
    COUNT(*) AS failed_records
FROM warehouse.fact_service_requests f
LEFT JOIN warehouse.dim_location l ON f.location_key = l.location_key
WHERE l.location_key IS NULL;

-- 4. Resolution hours should not be negative.
SELECT
    'negative_resolution_hours' AS check_name,
    COUNT(*) AS failed_records
FROM warehouse.fact_service_requests
WHERE resolution_hours < 0;

-- 5. Mart tables should contain rows after build.
SELECT
    'empty_request_volume_mart' AS check_name,
    CASE WHEN COUNT(*) = 0 THEN 1 ELSE 0 END AS failed_records
FROM marts.request_volume_monthly;
