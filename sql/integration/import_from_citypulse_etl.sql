-- Import cleaned CityPulse ETL output into the warehouse staging schema.
-- Expected upstream table from CityPulse ETL: public.service_requests

CREATE SCHEMA IF NOT EXISTS staging;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_schema = 'public'
          AND table_name = 'service_requests'
    ) THEN
        RAISE EXCEPTION 'Missing upstream table public.service_requests. Run the CityPulse ETL pipeline first.';
    END IF;
END $$;

DROP TABLE IF EXISTS staging.service_requests;

CREATE TABLE staging.service_requests AS
SELECT
    unique_key::TEXT AS request_id,
    created_date::TIMESTAMP AS created_at,
    closed_date::TIMESTAMP AS closed_at,
    agency::TEXT AS agency,
    complaint_type::TEXT AS request_type,
    COALESCE(descriptor::TEXT, 'UNKNOWN') AS descriptor,
    COALESCE(borough::TEXT, 'UNKNOWN') AS borough,
    COALESCE(status::TEXT, 'UNKNOWN') AS status,
    resolution_hours::DOUBLE PRECISION AS resolution_hours,
    created_day::DATE AS created_date,
    COALESCE(created_hour::INT, EXTRACT(HOUR FROM created_date::TIMESTAMP)::INT) AS created_hour,
    COALESCE(is_closed::BOOLEAN, status::TEXT = 'CLOSED') AS is_closed,
    COALESCE(priority_flag::BOOLEAN, FALSE) AS priority_flag,
    COALESCE(resolution_bucket::TEXT, 'open_or_unknown') AS resolution_bucket
FROM public.service_requests;

CREATE INDEX IF NOT EXISTS idx_staging_requests_id ON staging.service_requests(request_id);
CREATE INDEX IF NOT EXISTS idx_staging_requests_date ON staging.service_requests(created_date);
CREATE INDEX IF NOT EXISTS idx_staging_requests_borough ON staging.service_requests(borough);
CREATE INDEX IF NOT EXISTS idx_staging_requests_type ON staging.service_requests(request_type);
