-- Example business-style analysis queries for the CityPulse Analytics Warehouse.

-- Which request categories create the most workload?
SELECT *
FROM marts.category_workload
LIMIT 10;

-- Which boroughs have the highest request volume and longest average resolution time?
SELECT *
FROM marts.borough_performance
ORDER BY total_requests DESC;

-- What does monthly service volume look like?
SELECT *
FROM marts.monthly_service_volume;

-- What percentage of requests are high priority?
SELECT
    total_requests,
    priority_requests,
    ROUND((priority_requests::NUMERIC / NULLIF(total_requests, 0)) * 100, 2) AS priority_rate_pct
FROM marts.operational_kpi_summary;
