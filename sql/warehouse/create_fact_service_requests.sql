DROP TABLE IF EXISTS warehouse.fact_service_requests;

CREATE TABLE warehouse.fact_service_requests AS
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
  ON COALESCE(s.status, 'UNKNOWN') = st.status;

ALTER TABLE warehouse.fact_service_requests ADD PRIMARY KEY (request_id);

CREATE INDEX IF NOT EXISTS idx_fact_date ON warehouse.fact_service_requests(date_key);
CREATE INDEX IF NOT EXISTS idx_fact_location ON warehouse.fact_service_requests(location_key);
CREATE INDEX IF NOT EXISTS idx_fact_request_type ON warehouse.fact_service_requests(request_type_key);
CREATE INDEX IF NOT EXISTS idx_fact_status ON warehouse.fact_service_requests(status_key);
