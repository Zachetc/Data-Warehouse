CREATE SCHEMA IF NOT EXISTS warehouse;

DROP TABLE IF EXISTS warehouse.dim_date CASCADE;
CREATE TABLE warehouse.dim_date AS
SELECT DISTINCT
    TO_CHAR(created_date, 'YYYYMMDD')::INT AS date_key,
    created_date AS date_value,
    EXTRACT(YEAR FROM created_date)::INT AS year,
    EXTRACT(MONTH FROM created_date)::INT AS month,
    EXTRACT(DAY FROM created_date)::INT AS day,
    TRIM(TO_CHAR(created_date, 'Day')) AS day_name,
    EXTRACT(DOW FROM created_date)::INT AS day_of_week,
    CASE WHEN EXTRACT(DOW FROM created_date) IN (0, 6) THEN TRUE ELSE FALSE END AS is_weekend
FROM staging.service_requests
WHERE created_date IS NOT NULL;

ALTER TABLE warehouse.dim_date ADD PRIMARY KEY (date_key);

DROP TABLE IF EXISTS warehouse.dim_location CASCADE;
CREATE TABLE warehouse.dim_location AS
SELECT
    ROW_NUMBER() OVER (ORDER BY borough) AS location_key,
    borough
FROM (
    SELECT DISTINCT COALESCE(borough, 'UNKNOWN') AS borough
    FROM staging.service_requests
) locations;

ALTER TABLE warehouse.dim_location ADD PRIMARY KEY (location_key);

DROP TABLE IF EXISTS warehouse.dim_request_type CASCADE;
CREATE TABLE warehouse.dim_request_type AS
SELECT
    ROW_NUMBER() OVER (ORDER BY request_type) AS request_type_key,
    request_type
FROM (
    SELECT DISTINCT COALESCE(request_type, 'UNKNOWN') AS request_type
    FROM staging.service_requests
) request_types;

ALTER TABLE warehouse.dim_request_type ADD PRIMARY KEY (request_type_key);

DROP TABLE IF EXISTS warehouse.dim_status CASCADE;
CREATE TABLE warehouse.dim_status AS
SELECT
    ROW_NUMBER() OVER (ORDER BY status) AS status_key,
    status
FROM (
    SELECT DISTINCT COALESCE(status, 'UNKNOWN') AS status
    FROM staging.service_requests
) statuses;

ALTER TABLE warehouse.dim_status ADD PRIMARY KEY (status_key);
