-- Incremental fact load pattern.
-- The fact table grain is one row per service request event.
-- Existing request IDs are skipped so repeated runs do not duplicate historical facts.
-- In the full build this script is mostly illustrative because create_fact_service_requests.sql
-- rebuilds the fact table from staging. In a production refresh, this would replace full rebuilds.

INSERT INTO warehouse.fact_service_requests (
    request_id,
    date_key,
    location_key,
    request_type_key,
    status_key,
    created_at,
    closed_at,
    created_hour,
    resolution_hours,
    resolution_bucket,
    is_closed,
    priority_flag,
    request_count
)
SELECT
    s.request_id,
    d.date_key,
    l.location_key,
    rt.request_type_key,
    st.status_key,
    s.created_at,
    s.closed_at,
    s.created_hour,
    s.resolution_hours,
    s.resolution_bucket,
    s.is_closed,
    s.priority_flag,
    1 AS request_count
FROM staging.service_requests s
JOIN warehouse.dim_date d
    ON s.created_date = d.date_value
JOIN warehouse.dim_location l
    ON COALESCE(s.borough, 'UNKNOWN') = l.borough
JOIN warehouse.dim_request_type rt
    ON COALESCE(s.request_type, 'UNKNOWN') = rt.request_type
JOIN warehouse.dim_status st
    ON COALESCE(s.status, 'UNKNOWN') = st.status
WHERE NOT EXISTS (
    SELECT 1
    FROM warehouse.fact_service_requests f
    WHERE f.request_id = s.request_id
);
