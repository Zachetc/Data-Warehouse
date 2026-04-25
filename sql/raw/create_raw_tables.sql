CREATE SCHEMA IF NOT EXISTS raw;
DROP TABLE IF EXISTS raw.service_requests CASCADE;
CREATE TABLE raw.service_requests (
    request_id TEXT,
    created_at TIMESTAMP,
    closed_at TIMESTAMP,
    agency TEXT,
    request_type TEXT,
    descriptor TEXT,
    status TEXT,
    borough TEXT,
    neighborhood TEXT,
    latitude NUMERIC(10, 6),
    longitude NUMERIC(10, 6),
    source_file TEXT,
    loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE raw.service_requests IS 'Landing table for cleaned CityPulse ETL service request records.';
