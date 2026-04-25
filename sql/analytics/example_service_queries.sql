-- Example analyst queries supported by the warehouse.

-- Top request categories by monthly volume.
SELECT
    year,
    month,
    request_type,
    SUM(total_requests) AS requests
FROM marts.request_volume_monthly
GROUP BY year, month, request_type
ORDER BY year, month, requests DESC;

-- Boroughs with longest median response times.
SELECT
    borough,
    ROUND(AVG(median_resolution_hours), 2) AS avg_median_resolution_hours
FROM marts.response_time_distribution
GROUP BY borough
ORDER BY avg_median_resolution_hours DESC;

-- Priority request rate by borough and month.
SELECT
    year,
    month,
    borough,
    priority_rate_pct
FROM marts.priority_request_trends
ORDER BY year, month, priority_rate_pct DESC;

-- Current backlog by request type.
SELECT
    request_type,
    SUM(open_requests) AS backlog
FROM marts.open_request_backlog
GROUP BY request_type
ORDER BY backlog DESC;
