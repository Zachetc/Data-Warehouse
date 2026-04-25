CREATE SCHEMA IF NOT EXISTS marts;

CREATE OR REPLACE VIEW marts.monthly_service_volume AS
SELECT
    d.year,
    d.month,
    SUM(f.request_count) AS total_requests,
    SUM(CASE WHEN f.is_closed THEN 1 ELSE 0 END) AS closed_requests,
    ROUND(AVG(f.resolution_hours)::NUMERIC, 2) AS avg_resolution_hours
FROM warehouse.fact_service_requests f
JOIN warehouse.dim_date d ON f.date_key = d.date_key
GROUP BY d.year, d.month
ORDER BY d.year, d.month;

CREATE OR REPLACE VIEW marts.category_workload AS
SELECT
    rt.request_type,
    SUM(f.request_count) AS total_requests,
    SUM(CASE WHEN f.priority_flag THEN 1 ELSE 0 END) AS priority_requests,
    ROUND(AVG(f.resolution_hours)::NUMERIC, 2) AS avg_resolution_hours
FROM warehouse.fact_service_requests f
JOIN warehouse.dim_request_type rt ON f.request_type_key = rt.request_type_key
GROUP BY rt.request_type
ORDER BY total_requests DESC;

CREATE OR REPLACE VIEW marts.borough_performance AS
SELECT
    l.borough,
    SUM(f.request_count) AS total_requests,
    SUM(CASE WHEN f.is_closed THEN 1 ELSE 0 END) AS closed_requests,
    ROUND((SUM(CASE WHEN f.is_closed THEN 1 ELSE 0 END)::NUMERIC / NULLIF(SUM(f.request_count), 0)) * 100, 2) AS closed_rate_pct,
    ROUND(AVG(f.resolution_hours)::NUMERIC, 2) AS avg_resolution_hours
FROM warehouse.fact_service_requests f
JOIN warehouse.dim_location l ON f.location_key = l.location_key
GROUP BY l.borough
ORDER BY total_requests DESC;

CREATE OR REPLACE VIEW marts.resolution_time_analysis AS
SELECT
    resolution_bucket,
    COUNT(*) AS request_count,
    ROUND(AVG(resolution_hours)::NUMERIC, 2) AS avg_resolution_hours
FROM warehouse.fact_service_requests
GROUP BY resolution_bucket
ORDER BY request_count DESC;

CREATE OR REPLACE VIEW marts.operational_kpi_summary AS
SELECT
    COUNT(*) AS total_requests,
    SUM(CASE WHEN is_closed THEN 1 ELSE 0 END) AS closed_requests,
    SUM(CASE WHEN priority_flag THEN 1 ELSE 0 END) AS priority_requests,
    ROUND((SUM(CASE WHEN is_closed THEN 1 ELSE 0 END)::NUMERIC / NULLIF(COUNT(*), 0)) * 100, 2) AS closed_rate_pct,
    ROUND(AVG(resolution_hours)::NUMERIC, 2) AS avg_resolution_hours
FROM warehouse.fact_service_requests;
