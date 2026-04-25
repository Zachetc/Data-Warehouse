-- Standalone staging layer for sample/demo builds.
-- The integrated build normally uses sql/integration/import_from_citypulse_etl.sql.

CREATE SCHEMA IF NOT EXISTS staging;

DROP TABLE IF EXISTS staging.service_requests;

CREATE TABLE staging.service_requests AS
SELECT
    request_id,
    created_at,
    closed_at,
    agency,
    request_type,
    descriptor,
    borough,
    status,
    resolution_hours,
    created_at::DATE AS created_date,
    EXTRACT(HOUR FROM created_at)::INT AS created_hour,
    (closed_at IS NOT NULL OR status = 'CLOSED') AS is_closed,
    priority_flag,
    resolution_bucket
FROM raw.service_requests_raw;

CREATE INDEX IF NOT EXISTS idx_staging_requests_id ON staging.service_requests(request_id);
CREATE INDEX IF NOT EXISTS idx_staging_requests_date ON staging.service_requests(created_date);
CREATE INDEX IF NOT EXISTS idx_staging_requests_borough ON staging.service_requests(borough);
CREATE INDEX IF NOT EXISTS idx_staging_requests_type ON staging.service_requests(request_type);
