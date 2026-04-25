CREATE SCHEMA IF NOT EXISTS marts;

DROP MATERIALIZED VIEW IF EXISTS marts.request_volume_monthly;
CREATE MATERIALIZED VIEW marts.request_volume_monthly AS
SELECT
    d.year,
    d.month,
    rt.request_type,
    l.borough,
    COUNT(*) AS total_requests,
    SUM(CASE WHEN f.priority_flag THEN 1 ELSE 0 END) AS priority_requests
FROM warehouse.fact_service_requests f
JOIN warehouse.dim_date d ON f.date_key = d.date_key
JOIN warehouse.dim_request_type rt ON f.request_type_key = rt.request_type_key
JOIN warehouse.dim_location l ON f.location_key = l.location_key
GROUP BY d.year, d.month, rt.request_type, l.borough;

DROP MATERIALIZED VIEW IF EXISTS marts.response_time_distribution;
CREATE MATERIALIZED VIEW marts.response_time_distribution AS
SELECT
    rt.request_type,
    l.borough,
    COUNT(*) AS closed_requests,
    ROUND(AVG(f.resolution_hours), 2) AS avg_resolution_hours,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY f.resolution_hours)::numeric, 2) AS median_resolution_hours,
    ROUND(PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY f.resolution_hours)::numeric, 2) AS p90_resolution_hours
FROM warehouse.fact_service_requests f
JOIN warehouse.dim_request_type rt ON f.request_type_key = rt.request_type_key
JOIN warehouse.dim_location l ON f.location_key = l.location_key
WHERE f.resolution_hours IS NOT NULL
GROUP BY rt.request_type, l.borough;

DROP MATERIALIZED VIEW IF EXISTS marts.priority_request_trends;
CREATE MATERIALIZED VIEW marts.priority_request_trends AS
SELECT
    d.year,
    d.month,
    l.borough,
    COUNT(*) AS total_requests,
    SUM(CASE WHEN f.priority_flag THEN 1 ELSE 0 END) AS priority_requests,
    ROUND(100.0 * SUM(CASE WHEN f.priority_flag THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0), 2) AS priority_rate_pct
FROM warehouse.fact_service_requests f
JOIN warehouse.dim_date d ON f.date_key = d.date_key
JOIN warehouse.dim_location l ON f.location_key = l.location_key
GROUP BY d.year, d.month, l.borough;

DROP MATERIALIZED VIEW IF EXISTS marts.open_request_backlog;
CREATE MATERIALIZED VIEW marts.open_request_backlog AS
SELECT
    d.date_value,
    l.borough,
    rt.request_type,
    COUNT(*) AS open_requests
FROM warehouse.fact_service_requests f
JOIN warehouse.dim_date d ON f.date_key = d.date_key
JOIN warehouse.dim_location l ON f.location_key = l.location_key
JOIN warehouse.dim_request_type rt ON f.request_type_key = rt.request_type_key
JOIN warehouse.dim_status st ON f.status_key = st.status_key
WHERE LOWER(st.status) IN ('open', 'pending', 'in progress')
GROUP BY d.date_value, l.borough, rt.request_type;

CREATE INDEX IF NOT EXISTS idx_mart_volume_monthly ON marts.request_volume_monthly(year, month);
CREATE INDEX IF NOT EXISTS idx_mart_response_type ON marts.response_time_distribution(request_type);
CREATE INDEX IF NOT EXISTS idx_mart_priority_month ON marts.priority_request_trends(year, month);
